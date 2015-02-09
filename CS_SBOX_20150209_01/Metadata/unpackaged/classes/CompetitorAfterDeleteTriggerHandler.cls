public with sharing class CompetitorAfterDeleteTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		CompetitorHelper helper = new CompetitorHelper((List<Competitor__c>)tp.oldList);
	
		for(Competitor__c comp : (List<Competitor__c>)tp.oldList)
		{
			helper.UpdateAccountCompetitorField(comp.Account__c);
			helper.UpdateOpportunityCompetitorField(comp.Opportunity__c);
        }
		
		if (helper.oppsMap != null)
		{
			sObjectsToUpdate.putAll((Map<ID, Sobject>)helper.oppsMap);
		}
		
		if (helper.accountsMap != null)
		{
			sObjectsToUpdate.putAll((Map<ID, Sobject>)helper.accountsMap);
		}
	}
}