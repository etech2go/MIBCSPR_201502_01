public with sharing class CompetitorHelper
{
	public Map<ID, Opportunity> oppsMap {get; Set;}
	public Map<ID, Account> accountsMap {get; Set;}
	private Map<ID, List<Competitor__c>> compOppsMap = new Map<ID, List<Competitor__c>>();
	private Map<ID, List<Competitor__c>> compAccountsMap = new Map<ID, List<Competitor__c>>();
	
	private Set<ID> accountIds = new Set<ID>();
	private Set<ID> opportunityIds = new Set<ID>();
	
	public CompetitorHelper(List<Competitor__c> comps)
	{
		for (Competitor__c comp : comps)
		{
			accountIds.add(comp.Account__c);
		
			if (comp.Opportunity__c != null)
			{
				opportunityIds.add(comp.Opportunity__c);
			}
		}
		
		// Get all the relevant Competitors, opps and Accounts from the database
		List<Competitor__c> competitorsList = [Select Id, Account__c, Opportunity__c, Competitive_Spend__c, Competitor_Name__c, Service_Expiration_Date__c, Service_Provided__c, CreatedDate from Competitor__c where Account__c IN :accountIds or Opportunity__c IN :opportunityIds];
		List<Opportunity> oppsList = [Select Id, Competitor_Info__c from Opportunity where Id IN :opportunityIds];
		List<Account> accountList = [Select Id, Competitor_Info__c from Account where Id IN :accountIds];
		oppsMap = new Map<ID, Opportunity>(oppsList);
		accountsMap = new Map<ID, Account>(accountList);
		
		if (competitorsList != null)
		{
			for (Competitor__c c : competitorsList)
			{
				if (compAccountsMap.containsKey(c.Account__c))
				{
					compAccountsMap.get(c.Account__c).add(c);
				}
				else
				{
					List<Competitor__c> newCompList = new List<Competitor__c>();
					newCompList.add(c);
					compAccountsMap.put(c.Account__c, newCompList);
				}
			
				if (c.Opportunity__c != null && compOppsMap.containsKey(c.Opportunity__c))
				{
					compOppsMap.get(c.Opportunity__c).add(c);
				}
				else
				{
					List<Competitor__c> newCompList = new List<Competitor__c>();
					newCompList.add(c);
					compOppsMap.put(c.Opportunity__c, newCompList);
				}
			}
		}
	}
	
	public void UpdateAccountCompetitorField(String accountId)
	{
		Account a = accountsMap.get(accountId);
		List<Competitor__c> compList = compAccountsMap.get(accountId);
		a.competitor_Info__c = BuildCompetitorName(compList);
	}
	
	public void UpdateOpportunityCompetitorField(String opportunityId)
	{
		if (opportunityId != null)
		{
			Opportunity o = oppsMap.get(opportunityId);
			List<Competitor__c> oppsCompList = compOppsMap.get(opportunityId);
			o.competitor_Info__c = BuildCompetitorName(oppsCompList);
		}
	}
	
	private String BuildCompetitorName(List<Competitor__c> compList)
	{
		if (compList != null)
		{
			String competitorText = '';
			
			for (Competitor__c c : compList)
			{
				if (c.Competitor_Name__c != null)
				{
					competitorText += c.Competitor_Name__c;
				}
				else
				{
					competitorText += 'No Competitor Name';
				}
				
				if (c.Service_Provided__c != null)
				{
					String[] tmpString = c.Service_Provided__c.split(';');
					
					Integer i = 1;
					competitorText += ', (';
					for (String s : tmpString)
					{
						if (i > 1)
						{
							competitorText += ', ';
						}
						
						competitorText += s;
						i++;
					}
					
					competitorText += ')';
				}
				else
				{
					competitorText += ', No Services Provided';
				}
				
				if (c.Service_Expiration_Date__c != null)
				{
					competitorText += ', ';
					DateTime dtConverted = Datetime.newInstance(c.Service_Expiration_Date__c.year(), c.Service_Expiration_Date__c.month(), c.Service_Expiration_Date__c.day(),0,0,0);
					competitorText += dtConverted.format('MM/dd/yyyy');
				}
				else
				{
					competitorText += ', No Expiration Date';
				}
				
				if (c.Competitive_Spend__c != null)
				{
					competitorText += ', $';
					competitorText += c.Competitive_Spend__c;
				}
				else
				{
					competitorText += ', No Competitive Spend';
				}
				
				competitorText += ', ';
				competitorText += c.CreatedDate.Format('MM/dd/yyyy');
				competitorText += '\r\n';
			}
			
			return competitorText;
		}
		
		return null;
	}

}