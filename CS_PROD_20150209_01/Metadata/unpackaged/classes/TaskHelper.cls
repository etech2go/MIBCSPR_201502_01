public with sharing class TaskHelper
{
	private Map<Id,Task> mapTasks = null;
	private Set<Id> tIds = new Set<Id>();
	private ID trainingRecordTypeId = null;
	private Id clientServicesRecordTypeId = null;
	private ID SFAdminId = null;
		
	private List<Opportunity> oList = null;
	public Map<ID, Opportunity> oMap {get; Set;}
	
	private RoundRobinHelper verifyHelper = null;
	private RoundRobinHelper outreachHelper = null;
	private RoundRobinHelper pitchEngineHelper = null;
	
	public TaskHelper(List<Task> newList)
	{
		mapTasks = new Map<Id, Task>();
    	tIds = new Set<Id>();
		
		System.debug('tasks=' + newList);
		for (Task t : newList)
		{
			System.debug('t.WhatId=' + t.WhatId);
			if (t.WhatId != null)
			{	       
	            //Opportunity Id start with '006
	            if(string.valueOf(t.WhatId).startsWith('006'))
				{	           
	                //Add the task to the Map and Set
	                mapTasks.put(t.WhatId, t);
	                tIds.add(t.WhatId);
            	}
        	}
		}			
		
		oList = [Select Type, Owner.Name, Shipping_State__c, Reason__c From Opportunity Where Id IN : tIds];
		oMap = new Map<ID, Opportunity>(oList);
		//System.debug('tIds=' + tIds);	
		
		// Get the training record type
		List<RecordType> rtList = [select Id, Name from RecordType where SObjectType = 'Task' and (Name = 'Training' or Name = 'Client Services')];
		
		if (rtList != null && rtList.size() > 0)
		{
			for (RecordType rt : rtList)
			{
				if (rt.Name == 'Training')
				{
					trainingRecordTypeId = rt.Id;
				}
				else if (rt.Name == 'Client Services')
				{
					clientServicesRecordTypeId = rt.Id;
				}
			}
		}
		
		List<User> uList = [select Id, Name from User where Name = 'SFDC Admin'];
		if (uList != null && uList.size() > 0)
		{
			for (User u : uList)
			{
				if (u.Name == 'SFDC Admin')
				{
					SFAdminId = u.Id;
				}
			}
		}
			
		verifyHelper = new RoundRobinHelper('Task', 'Client Services', 'Verification Call');
		outreachHelper = new RoundRobinHelper('Task', 'Client Services', 'New Small Business Outreach');
		pitchEngineHelper = new RoundRobinHelper('Task', 'Client Services', 'PitchEngine Setup');
	}
	
	public void UpdateSalesPersonAndState()
	{		
		//Update the field of task and get its value from opp
		for(Opportunity o : oList)
		{
			Task t = mapTasks.get(o.Id);
		    t.Opportunity_Type_del__c = o.Type;
			t.SalesPerson__c = o.Owner.Name;
			t.State_Province__c = o.Shipping_State__c;
			
			//This will be removed from this trigger, but might be used somewhere else.
			/*if(t.Subject != null)
			{
				if(t.Subject.contains('At Risk Training'))
				{
					t.RecordTypeId = trainingRecordTypeId;
					t.Reason__c = o.Reason__c;
					t.Task_Type__c = 'At Risk';
				}
			}*/
		}
	}	
	
	public void AssignClientServicesTasks(Task t)
	{
		if (clientServicesRecordTypeId != null && SFAdminId != null)
		{
			if (t.Task_Type__c == 'Verification Call' && t.RecordTypeId == clientServicesRecordTypeId && t.OwnerId == SFAdminId)
			{
				ID userId = verifyHelper.GetNextUser(false, false);
				t.OwnerId = userId;
				verifyHelper.CreateStatisticRecord('Task - ' + t.Subject);
			}
			else if (t.Task_Type__c == 'New Small Business Outreach' && t.RecordTypeId == clientServicesRecordTypeId && t.OwnerId == SFAdminId)
			{
				ID userId = outreachHelper.GetNextUser(false, false);
				t.OwnerId = userId;
				outreachHelper.CreateStatisticRecord('Task - ' + t.Subject);
			}
			else if (t.Task_Type__c == 'PitchEngine Setup' && t.RecordTypeId == clientServicesRecordTypeId && t.OwnerId == SFAdminId)
			{
				ID userId = pitchEngineHelper.GetNextUser(false, false);
				t.OwnerId = userId;
				pitchEngineHelper.CreateStatisticRecord('Task - ' + t.Subject);
			}
		}
	}
	
	public void SetOppRenewalFlags(Task t)
	{
		if (t.Status=='Completed' && t.Call_Result__c == 'Contact Answered / Renewal BDC Cycle Milestone Completed')
		{
			// Get the related Opp
			Opportunity opp = oMap.get(t.WhatId);
			
			if (opp != null)
			{
				if (t.Renewal_BDC_Cycle__c == 'BDC New Biz Rep Call')
				{
					opp.BDC_New_Biz_Rep_Call_Completed__c = true;
					opp.BDC_New_Biz_Rep_Call_Grade__c = t.Renewal_Call_Grade__c;
				}
				else if (t.Renewal_BDC_Cycle__c == 'BDC Introduction Call')
				{
					opp.BDC_Introduction_Call_Completed__c = true;
					opp.BDC_Introduction_Call_Grade__c = t.Renewal_Call_Grade__c;
				}
				else if (t.Renewal_BDC_Cycle__c == 'BDC 3 Month Call')
				{
					opp.BDC_3_Month_Call_Completed__c = true;
					opp.BDC_3_Month_Call_Grade__c = t.Renewal_Call_Grade__c;
				}
				else if (t.Renewal_BDC_Cycle__c == 'BDC 6 Month Call')
				{
					opp.BDC_6_Month_Call_Completed__c = true;
					opp.BDC_6_Month_Call_Grade__c = t.Renewal_Call_Grade__c;
				}
				else if (t.Renewal_BDC_Cycle__c == 'BDC 9 Month Call')
				{
					opp.BDC_9_Month_Call_Completed__c = true;
					opp.BDC_9_Month_Call_Grade__c = t.Renewal_Call_Grade__c;
				}
			}
		}
	}
	
	public void UpdateRoundRobin()
	{
		verifyHelper.UpdateRoundRobin();
		outreachHelper.UpdateRoundRobin();
		pitchEngineHelper.UpdateRoundRobin();
	}

}