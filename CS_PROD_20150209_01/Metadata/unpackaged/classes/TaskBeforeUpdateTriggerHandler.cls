public with sharing class TaskBeforeUpdateTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		TaskHelper helper = new TaskHelper((List<Task>)tp.newList);
		List<Id> accountIds = new List<Id>();
		List<Id> oppIds = new List<Id>();
		Id objId = null;
		helper.UpdateSalesPersonAndState();		
		
		for (Task t : (List<Task>)tp.newList)
		{			
			//Check for account
			System.debug('################# WhatId = ' + t.WhatId);
			System.debug('################# WhoId = ' + t.WhoId);
			System.debug('################# AccountId = ' + t.AccountId);
			objId = t.WhatId;
			
			if(t.AccountId != null)
			{				
				accountIds.Add(t.AccountId);			
			}	
			
			if(objId != null)
			{
				if(string.valueOf(objId).startsWith('006'))
				{
					oppIds.add(objId);					
				}
				else if(string.valueOf(objId).startsWith('a0q'))
				{
					SBQQ__Quote__c q = UtilityClass.GetQuote(objId);
					System.debug('################# = ' + q);
					oppIds.add(q.SBQQ__Opportunity__c);
				}
			}
		}
		
		AccountHelper.UpdateSalesLastTouchedDate(accountIds);
		//OpportunityHelper.UpdateSalesLastTouchedDate(oppIds);
	}
}