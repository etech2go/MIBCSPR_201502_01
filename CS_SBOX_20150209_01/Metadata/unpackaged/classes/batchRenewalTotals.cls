global class batchRenewalTotals implements Database.Batchable<sObject>, Schedulable
{
	private Map<Id, Opportunity> renewalOppsMap = null;
	private Map<Id, List<SBQQ__Subscription__c>> subsMap = null;
	private Map<Id, List<Asset>> assetMap = null;
	
	global Database.QueryLocator start(Database.BatchableContext BC)         
    {
    	return Database.getQueryLocator([select Id, SBQQ__RenewalOpportunity__c, SBQQ__Quote__c from Contract where SBQQ__RenewalOpportunity__c != null]);
    }
 
    global void execute(Database.BatchableContext bc, List<SObject> scope)
	{
		SetupBatch((List<Contract>)scope);
		
		for (Contract c : (List<Contract>)scope)
		{
			// Get the Opp for this Contract
			Opportunity opp = renewalOppsMap.get(c.SBQQ__RenewalOpportunity__c);
			
			// Get the subs lines for this Contract
			List<SBQQ__Subscription__c> subsList = subsMap.get(c.Id);
			
			// Get the Assetts for the quote linked to this Contract
			List<Asset> assetList = assetMap.get(c.SBQQ__Quote__c);
		
			Decimal totalNetPrice = 0;
			
			if (subsList != null)
			{
				Decimal totalCommissionablePotentialAmount = 0;
				Decimal totalNonCommissionablePotentialAmount = 0;
				Decimal totalBroadcastCommissionableAmount = 0;
				Decimal totalBroadcastNonCommissionableAmount = 0;
						
				for (SBQQ__Subscription__c s : subsList)
				{
					if (s.Potential_Amount__c != null)
					{
						if (s.Product_Family__c != 'Broadcast Services' && s.Commissionable_Product__c && (s.Opp_Type__c == 'New' || s.Opp_Type__c == 'Renewal' || s.Opp_Type__c == 'Renewal (Paid Extension)'))
						{
							totalCommissionablePotentialAmount += s.Potential_Amount__c;
						}
						else if (s.Product_Family__c != 'Broadcast Services' && s.Product_Family__c != 'Connect Services' && s.Commissionable_Product__c && s.Opp_Type__c == 'Upsell')
						{
							totalCommissionablePotentialAmount += s.Potential_Amount__c;
						}
						else if (s.Product_Family__c != 'Broadcast Services' && !s.Commissionable_Product__c && (s.Opp_Type__c == 'New' || s.Opp_Type__c == 'Renewal' || s.Opp_Type__c == 'Renewal (Paid Extension)'))
						{
							totalNonCommissionablePotentialAmount += s.Potential_Amount__c;
						}
						else if (s.Product_Family__c == 'Connect Services' && s.Commissionable_Product__c && s.Opp_Type__c == 'Upsell')
						{
							totalNonCommissionablePotentialAmount += s.Potential_Amount__c;
						}
						else if (s.Product_Family__c == 'Broadcast Services' && s.Commissionable_Product__c)
						{
							totalBroadcastCommissionableAmount += s.Potential_Amount__c;
						}
						else if (s.Product_Family__c == 'Broadcast Services' && !s.Commissionable_Product__c)
						{
							totalBroadcastNonCommissionableAmount += s.Potential_Amount__c;
						}
					}
					
					if (s.SBQQ__NetPrice__c != null)
					{
						totalNetPrice += s.SBQQ__NetPrice__c;
					}
				}
				
				opp.Commissionable_Potential__c = totalCommissionablePotentialAmount;
				opp.Non_Commissionable_Potential__c = totalNonCommissionablePotentialAmount;
				opp.Broadcast_Commissionable_Potential__c = totalBroadcastCommissionableAmount;
				opp.Broadcast_Non_Commissionable_Potential__c = totalBroadcastNonCommissionableAmount;
			}
			
			if (assetList != null)
			{
				for (Asset a : assetList)
				{
					if (a.Price != null)
					{
						totalNetPrice += a.Price;
					}
				}
			}
			
			opp.Last_Year_Total_Spend__c = totalNetPrice;
		}
		
		update renewalOppsMap.values();
	}
 
    global void finish(Database.BatchableContext bc)
	{
	} 
	
	private void SetupBatch(List<Contract> scope)
	{
		Set<Id> renewalOppsIds = new Set<Id>();
		Set<Id> quoteIds = new Set<Id>();
		for (Contract c : scope)
		{
			renewalOppsIds.add(c.SBQQ__RenewalOpportunity__c);
			
			if (c.SBQQ__Quote__c != null)
			{
				quoteIds.add(c.SBQQ__Quote__c);
			}
		}
		
		renewalOppsMap = new Map<Id, Opportunity>([Select Id, AccountId, Commissionable_Potential__c, Non_Commissionable_Potential__c, Broadcast_Commissionable_Potential__c, Broadcast_Non_Commissionable_Potential__c from Opportunity where Id in :renewalOppsIds]);
		
		List<SBQQ__Subscription__c> subsList = [select Id, SBQQ__Contract__c, Potential_Amount__c, Product_Family__c, Commissionable_Product__c, Opp_Type__c, SBQQ__NetPrice__c from SBQQ__Subscription__c where SBQQ__Contract__c in :scope];
		subsMap = new Map<Id, List<SBQQ__Subscription__c>>();
		if (subsList != null)
		{
			for (SBQQ__Subscription__c s : subsList)
			{
				if (subsMap.containsKey(s.SBQQ__Contract__c))
				{
					subsMap.get(s.SBQQ__Contract__c).add(s);
				}
				else
				{
					List<SBQQ__Subscription__c> tempList = new List<SBQQ__Subscription__c>();
					tempList.add(s);
					subsMap.put(s.SBQQ__Contract__c, tempList);
				}
			}
		}
		
		List<Asset> assetList = [Select Id, SBQQ__QuoteLine__r.SBQQ__Quote__c, Price from Asset where SBQQ__QuoteLine__r.SBQQ__Quote__c in :quoteIds];
		assetMap = new Map<Id, List<Asset>>();
		if (assetList != null)
		{
			for (Asset a : assetList)
			{
				if (assetMap.containsKey(a.SBQQ__QuoteLine__r.SBQQ__Quote__c))
				{
					assetMap.get(a.SBQQ__QuoteLine__r.SBQQ__Quote__c).add(a);
				}
				else
				{
					List<Asset> tempList = new List<Asset>();
					tempList.add(a);
					assetMap.put(a.SBQQ__QuoteLine__r.SBQQ__Quote__c, tempList);
				}
			}
		}
	}
	
	global void execute(SchedulableContext ctx)
	{
        Database.executeBatch(new batchRenewalTotals(), 50);
    }

}