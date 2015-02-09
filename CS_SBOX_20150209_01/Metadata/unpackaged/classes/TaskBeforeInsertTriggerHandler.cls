public with sharing class TaskBeforeInsertTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		TaskHelper helper = new TaskHelper((List<Task>)tp.newList);
		List<Id> accountIds = new List<Id>();
		List<Id> oppIds = new List<Id>();
		Id accountId = null;
		helper.UpdateSalesPersonAndState();
		
		for (Task t : (List<Task>)tp.newList)
		{
			helper.AssignClientServicesTasks(t);
			System.debug('################# WhatId = ' + t.WhatId);
			System.debug('################# WhoId = ' + t.WhoId);
			System.debug('################# AccountId = ' + t.AccountId);
			//System.debug('################# t = ' + t);
			Id objId = t.WhatId;
			if(t.WhatId != null)
			{
				//Opportunity
				if(string.valueOf(objId).startsWith('006'))
				{
					oppIds.add(objId);					
				}//Quote
				else if(string.valueOf(objId).startsWith('a0q'))
				{
					SBQQ__Quote__c q = UtilityClass.GetQuote(objId);
					System.debug('################# = ' + q);
					oppIds.add(q.SBQQ__Opportunity__c);
				}
				
				//Also update the Account for the related objects
				accountId = AccountHelper.ReturnAccountIdFromId(objId);
				System.debug('################# WhatId = ' + accountId);
				if(accountId != null)
					accountIds.Add(accountId);								
			}
			else if(t.WhoId != null)
			{
				accountId = AccountHelper.ReturnAccountIdFromId(t.WhoId);
				System.debug('################# WhoId = ' + accountId);
				if(accountId != null)
					accountIds.Add(accountId);				
			}
		}
		
		helper.UpdateRoundRobin();
		
		System.debug('################# oppIds = ' + oppIds);
		System.debug('################# accountIds = ' + accountIds);
		AccountHelper.UpdateSalesLastTouchedDate(accountIds);	
		//OpportunityHelper.UpdateSalesLastTouchedDateFuture(oppIds);	
		
	}
}