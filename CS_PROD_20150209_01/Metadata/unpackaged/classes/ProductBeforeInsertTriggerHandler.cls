public with sharing class ProductBeforeInsertTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{		
		ProductHelper.CheckProductExistence(tp.newList);		
	}
}