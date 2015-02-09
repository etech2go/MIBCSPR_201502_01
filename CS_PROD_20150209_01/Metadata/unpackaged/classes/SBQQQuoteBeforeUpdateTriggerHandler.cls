public with sharing class SBQQQuoteBeforeUpdateTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		SBQQQuoteHelper.AreAccountsDifferent((List<SBQQ__Quote__c>)tp.newList);
	}
}