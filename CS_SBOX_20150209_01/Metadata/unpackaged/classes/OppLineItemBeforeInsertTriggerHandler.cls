public with sharing class OppLineItemBeforeInsertTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		OpportunityLineItemHelper.SetLastYearsSalesPriceonRenewal((List<OpportunityLineItem>) tp.newList);
				
	}

}