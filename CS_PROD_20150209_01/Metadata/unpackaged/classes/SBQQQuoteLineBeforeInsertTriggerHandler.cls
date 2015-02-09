public with sharing class SBQQQuoteLineBeforeInsertTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		System.debug('##############################before Quote LINE INSERT');
		SBQQQuoteLineHelper.AssignLastYearsSalesPriceToQuoteLine((List<SBQQ__QuoteLine__c>)tp.newList);
	}

}