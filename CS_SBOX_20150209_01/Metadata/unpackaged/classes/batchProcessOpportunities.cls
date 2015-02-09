global class batchProcessOpportunities implements Database.Batchable<sObject>, Schedulable
{ 	
	String IdtoProcess = '';
	
	global batchProcessOpportunities()
	{
		
	}
	
	global batchProcessOpportunities(String Id)
	{
		IdtoProcess = Id;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC)         
    {
        List<RecordType> rtList = [select Id, Name, SObjectType from RecordType where SObjectType = 'Opportunity' and (Name = 'New Biz' or Name = 'Renewals' or Name = 'Locked New Biz' or Name = 'Locked Renewals')];
		Id OpportunityNewBizRecordType = null;
        Id OpportunityRenewalsRecordType = null;
		Id OpportunityLockedNewBizRecordType = null;
        Id OpportunityLockedRenewalsRecordType = null;
        
        if (rtList != null && rtList.size() > 0)
		{
            for (RecordType r : rtList)
			{
				if (r.Name == 'New Biz')
				{
					OpportunityNewBizRecordType = r.Id;
				}
				else if (r.Name == 'Renewals')
				{
					OpportunityRenewalsRecordType = r.Id;
				}
				else if (r.Name == 'Locked New Biz')
				{
					OpportunityLockedNewBizRecordType = r.Id;
				}
				else if (r.Name == 'Locked Renewals')
				{
					OpportunityLockedRenewalsRecordType = r.Id;
				}
			}
		}
        
		DateTime dt = Datetime.now().addMinutes(-5);  //DateTime dt = system.today().addMinutes(-55);  //
		System.debug('DateTime = ' + dt);
		
		String query = 'select Id, Owner.IsActive, Amount, CloseDate, Owner.Name, GAS_or_Managed_Service_Check__c, SBQQ__Contracted__c, Reason__c, CA_Rep__c, Sub_Account__c, GP_Cust_ID__c, Number_of_Products__c, Credit_Risk_Case_Created__c, Client_Services_Tasks_Created__c, Shipping_State__c, Training_At_Risk_Case_Created__c, Training_Order_Cases_Created__c, RecordTypeId, StageName, Opportunity.At_Risk__c, Renewal_Completed__c, AccountId, Opportunity_Status__c, Type, OwnerId, Renewal_Rep_Assigned__c, CreatedDate, Renewal_Due_Date__c, Renewal_Tasks_Completed__c, Last_Year_Spend__c, Sales_Last_Touched_Date__c, Last_Year_Owner__c, Previous_Year_s_Last_Year_Spend__c, New_Renewal_Customer__c, Passed_to_Softrax__c from Opportunity where ';
        if (IdtoProcess == '')
		{
			query += '((At_Risk__c = \'Yes\' and RecordTypeId = \'' + OpportunityRenewalsRecordType + '\' and Training_At_Risk_Case_Created__c = False) ';
        	query += 'or (StageName = \'Closed Won\' and Passed_to_Softrax__c = false and (RecordTypeId = \'' + OpportunityRenewalsRecordType + '\' or RecordTypeId = \'' + OpportunityNewBizRecordType + '\' or RecordTypeId = \'' + OpportunityLockedRenewalsRecordType + '\' or RecordTypeId = \'' + OpportunityLockedNewBizRecordType + '\') and (Training_Order_Cases_Created__c = False or Client_Services_Tasks_Created__c = False)) ';
        	query += 'or (Credit_Risk_Case_Created__c = False and Number_of_Products__c > 0 and GP_Cust_ID__c = null) or (StageName = \'Closed Won\' and GAS_or_Managed_Service_Check__c = false)) and Owner.IsActive = true';
			System.debug('query = ' + query);
		}
		else
		{
			query += 'Id = \'' + IdtoProcess + '\'';
		}
		
    	return Database.getQueryLocator(query);		
		//[select Id, AccountId, Opportunity_Status__c, Type, OwnerId, Renewal_Rep_Assigned__c, Renewal_Due_Date__c, Renewal_Tasks_Completed__c, Last_Year_Spend__c, Sales_Last_Touched_Date__c, Last_Year_Owner__c, Previous_Year_s_Last_Year_Spend__c, New_Renewal_Customer__c from Opportunity where Type = 'Renewal' and Renewal_Completed__c = false and Created_Date_Time__c < :dt]
    }

	global void execute(Database.batchableContext bc, List<SObject> scope)
	{		
		if(scope != null)
		{
			OpportunityHelper.CreateTrainingCases((List<Opportunity>)scope);
        	OpportunityHelper.CreateClientServicesCases((List<Opportunity>)scope);    
       		OpportunityHelper.CreateCreditRiskAssessmentCase((List<Opportunity>)scope);
			OpportunityHelper.UpdatePassedToSoftraxFlag((List<Opportunity>)scope);
			OpportunityHelper.SendGASorManagedServicesEmail((List<Opportunity>)scope);
						
			update scope;
		}
	}

	global void finish(Database.batchableContext info)
	{
	}
	
	global void execute(SchedulableContext ctx)
	{
        Database.executeBatch(new batchProcessOpportunities(), 50);
    }
}