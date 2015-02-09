public class ProductAfterUpdateTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{	
		ProductHelper.SetCommissionableProduct(tp.newList);		
	}

}