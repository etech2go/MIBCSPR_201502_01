public with sharing class ContactBeforeInsertTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		List<Id> accountIds = new List<Id>();
		
		for (Contact c : (List<Contact>)tp.newList)
		{			
			//Check for account associated to contact		
			if(c.AccountId != null)
			{				
				accountIds.Add(c.AccountId);			
			}
		}
		
		AccountHelper.UpdateSalesLastTouchedDate(accountIds);	
	}
}