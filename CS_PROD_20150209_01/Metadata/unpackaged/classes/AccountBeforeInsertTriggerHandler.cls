public class AccountBeforeInsertTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{				
		for (Account a : (List<Account>)tp.newList)
		{
			AccountHelper.AssignAccountOwner(a);	
		}			
		
		AccountHelper.UpdateSalesLastTouchedDate((List<Account>)tp.newList);
	}
}