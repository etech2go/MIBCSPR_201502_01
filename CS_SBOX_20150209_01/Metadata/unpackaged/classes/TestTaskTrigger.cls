@isTest
private class TestTaskTrigger
{
	static testMethod void TestTask()
	{
		TestLibrary.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.SYSTEM_ADMIN_USER_PROFILE);
        insert u;
		
		Account acc = TestLibrary.CreateAccount('Test Account', u.Id);  
		insert acc;
		
		Opportunity opp = TestLibrary.createOpportunity('Test', u.Id, acc.Id);
		insert opp;
						
		List<Task> taskList = TestLibrary.CreateTasks('Call', 'Completed', 'Call', 5);
		
		taskList[0].RecordTypeId = TestLibrary.TASK_CLIENT_SERVICES_RECORD_TYPE;
		taskList[0].Task_Type__c = 'Verification Call';
		taskList[0].OwnerId = TestLibrary.SFDC_ADMIN_USER;
		taskList[0].WhatId = opp.Id;
		taskList[0].Call_Result__c = 'Contact Answered / Renewal BDC Cycle Milestone Completed';
		taskList[0].Subject = 'BDC New Biz Rep Call';
		taskList[0].Renewal_BDC_Cycle__c = 'BDC New Biz Rep Call';
		taskList[0].Renewal_Call_Grade__c = 'A';
		
		taskList[1].RecordTypeId = TestLibrary.TASK_CLIENT_SERVICES_RECORD_TYPE;
		taskList[1].Task_Type__c = 'New Small Business Outreach';
		taskList[1].OwnerId = TestLibrary.SFDC_ADMIN_USER;
		taskList[1].WhatId = opp.Id;
		taskList[1].Call_Result__c = 'Contact Answered / Renewal BDC Cycle Milestone Completed';
		taskList[1].Subject = 'BDC Introduction Call';
		taskList[1].Renewal_BDC_Cycle__c = 'BDC Introduction Call';
		taskList[1].Renewal_Call_Grade__c = 'A';
		
		taskList[2].RecordTypeId = TestLibrary.TASK_CLIENT_SERVICES_RECORD_TYPE;
		taskList[2].Task_Type__c = 'PitchEngine Setup';
		taskList[2].OwnerId = TestLibrary.SFDC_ADMIN_USER;
		taskList[2].WhatId = opp.Id;
		taskList[2].Call_Result__c = 'Contact Answered / Renewal BDC Cycle Milestone Completed';
		taskList[2].Subject = 'BDC 3 Month Call';
		taskList[2].Renewal_BDC_Cycle__c = 'BDC 3 Month Call';
		taskList[2].Renewal_Call_Grade__c = 'A';
		
		taskList[3].RecordTypeId = TestLibrary.TASK_CLIENT_SERVICES_RECORD_TYPE;
		taskList[3].Task_Type__c = 'PitchEngine Setup';
		taskList[3].OwnerId = TestLibrary.SFDC_ADMIN_USER;
		taskList[3].WhatId = opp.Id;
		taskList[3].Call_Result__c = 'Contact Answered / Renewal BDC Cycle Milestone Completed';
		taskList[3].Subject = 'BDC 6 Month Call';
		taskList[3].Renewal_BDC_Cycle__c = 'BDC 6 Month Call';
		taskList[3].Renewal_Call_Grade__c = 'A';
		
		taskList[4].RecordTypeId = TestLibrary.TASK_CLIENT_SERVICES_RECORD_TYPE;
		taskList[4].Task_Type__c = 'PitchEngine Setup';
		taskList[4].OwnerId = TestLibrary.SFDC_ADMIN_USER;
		taskList[4].WhatId = opp.Id;
		taskList[4].Call_Result__c = 'Contact Answered / Renewal BDC Cycle Milestone Completed';
		taskList[4].Subject = 'BDC 9 Month Call';
		taskList[4].Renewal_BDC_Cycle__c = 'BDC 9 Month Call';
		taskList[4].Renewal_Call_Grade__c = 'A';
		
		Test.startTest();
		
		insert taskList;
		
		update taskList;
		
		Test.stopTest();
	}
}