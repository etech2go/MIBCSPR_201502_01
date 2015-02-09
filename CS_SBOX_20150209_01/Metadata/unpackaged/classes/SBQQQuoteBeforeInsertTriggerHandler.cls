public with sharing class SBQQQuoteBeforeInsertTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		SBQQQuoteHelper.AreAccountsDifferent((List<SBQQ__Quote__c>)tp.newList);
	}
}