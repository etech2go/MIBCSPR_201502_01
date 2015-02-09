global class batchCalculateOpenLeadsForRoundRobin implements Database.Batchable<sObject>, Schedulable
{
	global final String Query;	
	global batchCalculateOpenLeadsForRoundRobin(string q)     
  	{
  		Query = q;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC)         
    {
    	return Database.getQueryLocator(Query);
    }
	
	global void finish(Database.BatchableContext bc){} 
	
	global void execute(Database.BatchableContext bc, List<Round_Robin__c> scope)
	{
		//Date startDay = Date.today().ToStartOfMonth(); //Take today minus two days for leads.  This was a requirement of business
		Date startDay = Date.today() - 2; //Take today minus two days for leads.  This was a requirement of business to not include the last 2 days
		Date endOfMonth = Date.today().addMonths(1).ToStartOfMonth().addDays(-1);
		
		System.debug('startDay = ' + startDay);
		System.debug('endOfMonth = ' + endOfMonth);		
		Set<ID> userIds = new Set<ID>();		
		Map<ID, List<Lead>> userHotLeadsMap = new Map<ID, List<Lead>>();
		Map<ID, List<Lead>> userWarmLeadsMap = new Map<ID, List<Lead>>();
		Map<ID, List<Task>> userHotTasksMap = new Map<ID, List<Task>>();
		Map<ID, List<Task>> userWarmTasksMap = new Map<ID, List<Task>>();
				
		for (Round_Robin__c rr : scope)
		{			
			if(rr.Object_Type__c == 'Lead')
				userIds.add(rr.User__c);	
		}	
		
		List<Lead> rrLeadsList = [Select L.Id, L.OwnerId, L.Status, L.Rating from Lead L WHERE OwnerId IN :userIds and Status in ('In Progress', 'New', 'Contacted', 'Unable To Contact') and ((CreatedDate >= :startDay and CreatedDate <= :endOfMonth))];		
		List<Task> rrTasksList = [Select T.Id, T.OwnerId, T.Lead_Status__c, T.Rating__c from Task T WHERE OwnerId IN :userIds and Task_Type__c =: Constants.CampaignResponseTaskType and Lead_Status__c in ('In Progress', 'New', 'Contacted', 'Unable To Contact') and ((CreatedDate >= :startDay and CreatedDate <= :endOfMonth))];		
		System.debug('#############################################scope = ' + scope);
		System.debug('#############################################userIds = ' + userIds);
		System.debug('#############################################leads = ' + rrLeadsList);			
		System.debug('#############################################tasks = ' + rrTasksList);
		
		CheckLeadsListAndAssign(rrLeadsList, userHotLeadsMap, userWarmLeadsMap);
		CheckTasksListAndAssign(rrTasksList, userHotTasksMap, userWarmTasksMap);

		for (Round_Robin__c rr : scope)
		{
			// Get the Leads List for this User
			List<Lead> hotLeads = userHotLeadsMap.get(rr.User__c);
			List<Lead> warmLeads = userWarmLeadsMap.get(rr.User__c);	
			List<Task> hotTasks = userHotTasksMap.get(rr.User__c);
			List<Task> warmTasks = userWarmTasksMap.get(rr.User__c);
			if (hotLeads != null && hotTasks != null)			
			{				
				rr.Open_Hot_Leads_This_Month__c = hotLeads.size() + hotTasks.size();
			}
			else if(hotLeads != null && hotTasks == null)
			{
				rr.Open_Hot_Leads_This_Month__c = hotLeads.size();
			}	
			else if(hotLeads == null && hotTasks != null)
			{
				rr.Open_Hot_Leads_This_Month__c = hotTasks.size();
			}
			else
			{
				rr.Open_Hot_Leads_This_Month__c = 0;
			}
			
			if (warmLeads != null && warmTasks != null)			
			{											
				rr.Open_Warm_Leads_This_Month__c = warmLeads.size() + warmTasks.size();
			}
			else if (warmLeads != null && warmTasks == null)	
			{
				rr.Open_Warm_Leads_This_Month__c = warmLeads.size();
			}
			else if (warmLeads == null && warmTasks != null)	
			{
				rr.Open_Warm_Leads_This_Month__c = warmTasks.size();
			}
			else
			{
				rr.Open_Warm_Leads_This_Month__c = 0;
			}
		}
		
		update scope;
	}
	
	private void CheckLeadsListAndAssign(List<Lead> leadsList, Map<ID, List<Lead>> userHotLeadsMap, Map<ID, List<Lead>> userWarmLeadsMap)
	{
		for (Lead l : leadsList)
		{						
			if(l.Rating == Constants.HotRating)
			{
				if (userHotLeadsMap.containsKey(l.OwnerId))
				{
					userHotLeadsMap.get(l.OwnerId).add(l);
				}
				else
				{
					PutToLeadsMap(userHotLeadsMap, l);				
				}			
			}
			else if(l.Rating == Constants.WarmRating)
			{
				if (userWarmLeadsMap.containsKey(l.OwnerId))
				{
					userWarmLeadsMap.get(l.OwnerId).add(l);
				}
				else
				{
					PutToLeadsMap(userWarmLeadsMap, l);					
				}		
			}
		}			
	}
	
	private void CheckTasksListAndAssign(List<Task> tasksList, Map<ID, List<Task>> userHotTasksMap, Map<ID, List<Task>> userWarmTasksMap)
	{
		for (Task t : tasksList)
		{						
			if(t.Rating__c == Constants.HotRating)
			{
				if (userHotTasksMap.containsKey(t.OwnerId))
				{
					userHotTasksMap.get(t.OwnerId).add(t);
				}
				else
				{
					PutToTaskMap(userHotTasksMap, t);				
				}			
			}
			else if(t.Rating__c == Constants.WarmRating)
			{
				if (userWarmTasksMap.containsKey(t.OwnerId))
				{
					userWarmTasksMap.get(t.OwnerId).add(t);
				}
				else
				{
					PutToTaskMap(userWarmTasksMap, t);					
				}		
			}
		}			
	}
	
	private void PutToLeadsMap(Map<ID, List<Lead>> leadsMap, Lead l)
	{
		List<Lead> tempList = new List<Lead>();
		tempList.add(l);
		leadsMap.put(l.OwnerId, tempList);
	}
	
	private void PutToTaskMap(Map<ID, List<Task>> tasksMap, Task t)
	{
		List<Task> tempList = new List<Task>();
		tempList.add(t);
		tasksMap.put(t.OwnerId, tempList);
	}
	
	global void execute(SchedulableContext SC) 
    {  
		string SOQL = 'Select Id, User__c, Open_Warm_Leads_This_Month__c, Open_Hot_Leads_This_Month__c, Object_Type__c from Round_Robin__c Where Object_Type__c = \'' + 'Lead' + '\'';
    	Database.executeBatch(new batchCalculateOpenLeadsForRoundRobin(SOQL),20); 
    }	
}