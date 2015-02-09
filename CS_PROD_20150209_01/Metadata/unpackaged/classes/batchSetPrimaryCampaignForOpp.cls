global class batchSetPrimaryCampaignForOpp implements Database.Batchable<sObject>, Schedulable
{
	global final String Query;
	
	private Map<ID, List<CampaignMember>> campMemberMap = new Map <ID, List<CampaignMember>>();
	private List<Opportunity> oppsToUpdate = new List<Opportunity>();
	
	global batchSetPrimaryCampaignForOpp(string q)     
  	{
  		Query = q;
  	}
	
	global Database.QueryLocator start(Database.BatchableContext BC)         
    {
    	return Database.getQueryLocator(Query);
    }
     
    global void finish(Database.BatchableContext bc)
	{
	}  
	 
	global void execute(Database.BatchableContext bc, List<Opportunity> scope)
	{
		List<OpportunityContactRole> ocrList = [SELECT  OpportunityId, ContactId FROM OpportunityContactRole WHERE OpportunityId IN :scope];
		
		// Create a Map linking OppIds to a list of CampaignMembers
		List<CampaignMember> campMemberList = [SELECT  Id, ContactId, CampaignId, Campaign.StartDate FROM CampaignMember WHERE Status = 'Responded' AND ContactId IN (SELECT  ContactId FROM OpportunityContactRole WHERE OpportunityId IN :scope) ORDER BY Campaign.StartDate];
		
		if (campMemberList != null && ocrList != null)
		{
			for (CampaignMember c : campMemberList)
			{
				for (OpportunityContactRole ocr : ocrList)
				{
					if (c.ContactId == ocr.ContactId)
					{
						if (campMemberMap.containsKey(ocr.OpportunityId))
						{
							campMemberMap.get(ocr.OpportunityId).add(c);
						}
						else
						{
							List<CampaignMember> newCampList = new List<CampaignMember>();
							newCampList.add(c);
							campMemberMap.put(ocr.OpportunityId, newCampList);
						}
					}
				}
			}
		
			for (Opportunity opp:scope)
			{
				SetPrimaryCampaign(opp);
			}
			
			if (oppsToUpdate.size() > 0)
			{
				update oppsToUpdate;
				oppsToUpdate.clear();
			}
		}
	}

	private void SetPrimaryCampaign(Opportunity opp)
	{
		// Get the list of Campaign Members linked to this Opp
		List<CampaignMember> campList = campMemberMap.get(opp.Id);
		
		if (campList != null)
		{
			Date oneYearAgo = Date.today().addMonths(-12);
			if (opp.CreatedDate < oneYearAgo)
			{
				// This opp is over 1 year old. Therefore we should only assign the oldest Campaign in the last 1 year
				for (CampaignMember cm : campList)
				{
					// If this is over 1 year old then we are not interested
					if (cm.Campaign.StartDate != null && cm.Campaign.StartDate <= oneYearAgo)
					{
						// This is the first Campaign member belonging to a Campaign that is less than 1 year old
						opp.CampaignId = cm.CampaignId;
						oppsToUpdate.add(opp);
						break;
					}
				}
				
			}
			else
			{
				// We should assign the oldest Campaign Id in the list to this Opp
				opp.CampaignId = campList[0].CampaignId;
				oppsToUpdate.add(opp);
			}
		}
	}
	
	global void execute(SchedulableContext SC) 
    {  
		String SOQL = 'SELECT Id, Name, CampaignId, CreatedDate FROM Opportunity WHERE Id IN (SELECT OpportunityId FROM OpportunityContactRole)';
		Database.executeBatch(new batchSetPrimaryCampaignForOpp(SOQL),10); 
    }
}