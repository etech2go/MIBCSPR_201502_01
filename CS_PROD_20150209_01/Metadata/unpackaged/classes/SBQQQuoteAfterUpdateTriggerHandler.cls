public with sharing class SBQQQuoteAfterUpdateTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		SBQQQuoteHelper.UpdateQuoteLines((List<SBQQ__Quote__c>)tp.newList);	
	}
}