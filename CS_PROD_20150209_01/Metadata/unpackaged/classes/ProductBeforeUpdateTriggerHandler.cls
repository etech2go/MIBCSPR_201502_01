public with sharing class ProductBeforeUpdateTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{	
		ProductHelper.CheckProductExistence(tp.newList);		
	}
}