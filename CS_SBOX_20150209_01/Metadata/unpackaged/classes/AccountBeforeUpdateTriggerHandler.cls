public class AccountBeforeUpdateTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{					
		for (Account a : (List<Account>)tp.newList)
		{			
			AccountHelper.AssignAccountOwner(a);			
		}			
	}
}