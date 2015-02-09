public with sharing class batchJobTestHarnessController
{
	public List<JobsWrapper> jobs {get; Set;}
		
	public batchJobTestHarnessController()
	{
		jobs = new List<JobsWrapper>();
		jobs.add(new JobsWrapper(1, 'CalculateOpenLeadsForRoundRobin'));
		jobs.add(new JobsWrapper(2, 'CalculateOpenOppsForRoundRobin'));
		jobs.add(new JobsWrapper(3, 'SendCompetitorAlerts'));
		jobs.add(new JobsWrapper(4, 'SetPrimaryCampaignForOpp'));
		jobs.add(new JobsWrapper(5, 'ProcessAccounts'));
		jobs.add(new JobsWrapper(6, 'RenewalTotals'));
		jobs.add(new JobsWrapper(7, 'ProcessOpportunities'));
	}
	
	public PageReference RunJobs()
	{
		// Get the Row Id of the job we need to run
		string RowId = ApexPages.currentPage().getParameters().get('RowId');

		JobsWrapper currentJob = jobs[Integer.valueOf(RowId)-1];
		
		if (RowId == '1')
		{
			string SOQL = 'Select Id, User__c, Open_Warm_Leads_This_Month__c, Open_Hot_Leads_This_Month__c, Object_Type__c from Round_Robin__c Where Object_Type__c = \'' + 'Lead' + '\'';
    		currentJob.JobId = Database.executeBatch(new batchCalculateOpenLeadsForRoundRobin(SOQL),20); 
 		}
		else if (RowId == '2')
		{
			string SOQL = 'Select Id, User__c, Open_Opps__c from Round_Robin__c';
    		currentJob.JobId = Database.executeBatch(new batchCalculateOpenOppsForRoundRobin(SOQL),20); 
		}
		else if (RowId == '3')
		{
			string SOQL = 'Select Id, Name, Service_Expiration_Alert_Sent__c, Opportunity_Close__c, CreatedById, Account__c, Account__r.Name, Account__r.Renewal_Rep__c, Account__r.OwnerId, Competitive_Spend__c, Competitor_Name__c, Competitor_Notes__c,  Service_Expiration_Date__c, Service_Provided__c from Competitor__c where (Competitor_Name__c != \'No Competitor\' and Competitor_Name__c != \'Client Won’t Say/Don’t Know\')';
    		currentJob.JobId = Database.executeBatch(new batchCompetitorAlerts(SOQL),10);
		}
		else if (RowId == '4')
		{
			String SOQL = 'SELECT Id, Name, CampaignId, CreatedDate FROM Opportunity WHERE Id IN (SELECT OpportunityId FROM OpportunityContactRole)';
			currentJob.JobId = Database.executeBatch(new batchSetPrimaryCampaignForOpp(SOQL),10); 
		}
		else if (RowId == '5')
		{
			currentJob.JobId = Database.executeBatch(new batchProcessAccounts(),1); 
		}
		else if (RowId == '6')
		{
			 currentJob.JobId = Database.executeBatch(new batchRenewalTotals(), 50);
		}
		else if (RowId == '7')
		{
			 currentJob.JobId = Database.executeBatch(new batchProcessOpportunities(), 50);
		}
		
		currentJob.Status = 'Started';
		
		return null;
	}
	
	public PageReference UpdateStatuses()
	{
		// Only run this if any of the Jobs have a status of processing
		Set<ID> jobIds = new Set<ID>();
		for (JobsWrapper j : jobs)
		{
			if (j.Status == 'Processing' || j.Status == 'Started' || j.Status == 'Batch Queued')
			{
				jobIds.add(j.JobId);
			}
		}
		
		if (jobIds.size() > 0)
		{
			List<AsyncApexJob> aList = [select Id, TotalJobItems, Status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, CreatedDate, CreatedById, CompletedDate, ApexClassId, ApexClass.Name From AsyncApexJob where Id IN :jobIds];
			
			if (aList != null)
			{
				Map<ID, AsyncApexJob> aMap = new Map<ID, AsyncApexJob>(aList);
				
				for (JobsWrapper j : jobs)
				{
					AsyncApexJob aJob = aMap.get(j.JobId);
					if (aJob != null)
					{
						j.Status = aJob.Status;
											
						Double itemsProcessed = aJob.JobItemsProcessed;
            			Double totalItems = aJob.TotalJobItems;
 
            	       	//Determine the pecent complete based on the number of batches complete
            			if(totalItems == 0)
						{
                			j.percentComplete = 0;
            			}
						else
						{
                			j.percentComplete = ((itemsProcessed  / totalItems) * 100.0).intValue();
            			}
					}
				}
			}
		}
		
		return null;
	}
	
	public class JobsWrapper
	{
		public Integer RowId {get; Set;}
		public String FunctionName {get; Set;}
		public String Status {get; Set;}
		public String JobId {get; Set;}
		public Integer percentComplete {get; set;}
		
		public JobsWrapper(Integer RowId, String FunctionName)
		{
			this.RowId = RowId;
			this.FunctionName = FunctionName;
			Status = 'Not Started';
			percentComplete = 0;
		}
	}

}