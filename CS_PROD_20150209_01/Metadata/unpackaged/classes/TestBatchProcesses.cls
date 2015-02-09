@isTest
private class TestBatchProcesses
{
	static testMethod void TestBatchCalculateOpenLeadsForRoundRobin() 
    {
		//Setup the Data
		User user1 = TestingUtils.createUser('leadrr1', TestingUtils.TEST_PROFILE_ID);
		insert user1;
				
		Round_Robin__c rr1 = new Round_Robin__c(User__c=user1.Id,Object_Type__c='Lead',Group__c='West',Sub_Group__c='AM',Assign_Records__c=true,Number_of_Records_Assigned__c=null,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=0);
		insert rr1;
		
		List<Lead> leadList = TestingUtils.createLeads(4, false);
		leadList[0].OwnerId = user1.Id;
		leadList[0].Rating = 'Hot';
		leadList[1].OwnerId = user1.Id;
		leadList[1].Rating = 'Hot';
		leadList[2].OwnerId = user1.Id;
		leadList[2].Rating = 'Warm';
		leadList[3].OwnerId = user1.Id;
		leadList[3].Rating = 'Warm';
		insert leadList;
		
		List<Task> taskList = TestingUtils.createTasks(4, false);
		taskList[0].OwnerId = user1.Id;
		taskList[0].Task_Type__c = 'Campaign Response';
		taskList[0].Lead_Status__c = 'New';
		taskList[0].Rating__c = 'Hot';
		taskList[1].OwnerId = user1.Id;
		taskList[1].Task_Type__c = 'Campaign Response';
		taskList[1].Lead_Status__c = 'New';
		taskList[1].Rating__c = 'Hot';
		taskList[2].OwnerId = user1.Id;
		taskList[2].Task_Type__c = 'Campaign Response';
		taskList[2].Lead_Status__c = 'New';
		taskList[2].Rating__c = 'Warm';
		taskList[3].OwnerId = user1.Id;
		taskList[3].Task_Type__c = 'Campaign Response';
		taskList[3].Lead_Status__c = 'New';
		taskList[3].Rating__c = 'Warm';
		insert taskList;
		
		Test.startTest();
		
		string SOQL = 'Select Id, User__c, Object_Type__c, Open_Hot_Leads_This_Month__c, Open_Warm_Leads_This_Month__c from Round_Robin__c Where Id = \'' + rr1.Id + '\'';
		batchCalculateOpenLeadsForRoundRobin lead = new batchCalculateOpenLeadsForRoundRobin(SOQL);
		Database.executeBatch(lead, 1);			
		
		Test.stopTest();
	}
	
	static testMethod void TestBatchCalculateOpenOppsForRoundRobin() 
    {
		TestingUtils.InitAvaTax();

		//Setup the Data
		User user1 = TestingUtils.createUser('oppsrr', TestingUtils.TEST_PROFILE_ID);
		insert user1;
				
		Round_Robin__c rr1 = new Round_Robin__c(User__c=user1.Id,Object_Type__c='Opportunity',Group__c='West',Sub_Group__c='NATIONAL',Assign_Records__c=true,Number_of_Records_Assigned__c=null,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=0);
		insert rr1;
		
		Account a = TestingUtils.CreateAccount();  
		insert a;
		
		Opportunity opp = TestingUtils.createOpportunity(a.Id);
		opp.StageName = 'Contacted';
		opp.OwnerId = user1.Id;
		opp.Renewal_Due_Date__c = Date.today();
		insert opp;
		
		Test.startTest();
		
		string SOQL = 'Select Id, User__c, Open_Opps__c from Round_Robin__c where Id = \'' + rr1.Id + '\'';
    	Database.executeBatch(new batchCalculateOpenOppsForRoundRobin(SOQL),1); 
		
		Test.stopTest();
	}
	
	@isTest (SeeAllData=true)
	static void TestBatchProcessAccounts() 
	{
		TestingUtils.InitAvaTax();
		
		System.debug('Starting Process Accounts');
		Account a = TestingUtils.CreateAccount();  
		a.New_Biz_Last_Touched_Date__c = Date.today();
		a.Type = 'Customer';
		insert a;			
		System.debug('Account Created');
		
		Opportunity opp = TestingUtils.createOpportunity(a.Id);
    	opp.Invoice_Contact_Name__c = 'John';
    	opp.Invoice_Contact_Email__c = 'john@email.com';
		opp.Renewal_Due_Date__c = Date.today() + 7;
		opp.CloseDate = Date.today() - 7;
		opp.Type = 'Renewal';
    	insert opp;
		System.debug('Opp Created');
		
		Contract cont = TestingUtils.createContract(a.Id, opp.Id);
		insert cont;
		System.debug('Contract Created');
		
		Product2 prod = TestingUtils.createProduct(false);
		insert prod;
		
		SBQQ__Subscription__c sub = TestingUtils.createSubscription(a.Id, cont.Id, prod.Id);
		insert sub;
		System.debug('sub Created');
		
		List<SBQQ__Subscription__c> subsList = [Select Id from SBQQ__Subscription__c where SBQQ__Account__c = :a.Id];
		System.debug('Subs Count = ' + subsList.size());
		
		Asset ass = TestingUtils.createAsset(a.Id, prod.Id);
		insert ass;
		
		Test.startTest();	
		
		String SOQL = 'SELECT Id, Name, Type, Named_Account_Rep__c, New_Biz_Rep__c, New_Biz_Last_Touched_Date__c, New_Biz_Named_Account_Rep__c, Renewal_Rep__c, Renewal_Period__c, Plan_Customer__c, Connect_Customer__c, Monitoring_Customer__c, Analysis_Customer__c, Broadcast_Customer__c,' +
			' Directories__c, Plan_Additional_Users__c, Plan_Premium_Data_Add_Ons__c, International_Database__c, Web_Wire_Distribution__c, Content_Marketing__c, Social_Newsroom__c, Analyze_Tab__c, Broadcast_Monitoring__c,' +
			' Electronic_Monitoring__c, Managed_Services__c, Other_Monitoring_Services__c, Print_Monitoring__c, Social_Media_Monitoring_CP__c, Social_Media_Monitoring_Dashboard__c, Social_Media_Monitoring_Other__c,' + 
			' Advanced_Analytics__c, Global_Analysts__c, Canada__c, Distribution__c, Training__c, Broadcast_Rep__c, Broadcast_Last_Touched_Date__c, Credit_Limit__c, Paydex__c, Credit_Risk_Values_Date__c, Account_Ownership_History__c from Account where Id = \'' + a.Id + '\''; 

		
		batchProcessAccounts testBatch = new batchProcessAccounts(SOQL);
		Database.executeBatch(testBatch, 1);		
		Test.stopTest();
	}
	
	@isTest (SeeAllData=true)
	static void TestBatchCompetitorAlerts()
	{
		TestingUtils.InitAvaTax();
		
		List<Account> acc = TestingUtils.createAccounts(1, true);
			   	
	   	Opportunity opp = TestingUtils.createOpportunity(acc[0].Id);
    	opp.Invoice_Contact_Name__c = 'John';
    	opp.Invoice_Contact_Email__c = 'john@email.com';
    	insert opp;
		
		List<Competitor__c> compList = TestingUtils.createCompetitor(1, acc[0].Id, opp.Id);
		insert compList;
		
		List<Contact> conts = TestingUtils.createContacts(1, acc[0].Id, true);
						
		Test.startTest();
			string SOQL = 'Select Id, Name, Service_Expiration_Alert_Sent__c, Opportunity_Close__c, CreatedById, Account__c, Account__r.Name, Account__r.Renewal_Rep__c, Competitive_Spend__c, Competitor_Name__c, Competitor_Notes__c,  Service_Expiration_Date__c, Service_Provided__c from Competitor__c where Id = \'' + compList[0].Id + '\'';
    		Database.executeBatch(new batchCompetitorAlerts(SOQL),1); 
		Test.stopTest();
	}
	
	static testMethod void TestBatchSetPrimaryCampaignForOpp()
	{
		TestingUtils.InitAvaTax();
		
		Account acc = TestingUtils.CreateAccount();  
		insert acc;	   	
	   	
	   	Opportunity opp = TestingUtils.createOpportunity(acc.Id);
    	opp.Invoice_Contact_Name__c = 'John';
    	opp.Invoice_Contact_Email__c = 'john@email.com';
    	insert opp;
		
		List<Contact> contList = TestingUtils.createContacts(1, acc.Id, true);
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(opp.Id, contList[0].Id);
		insert ocr;
		Campaign camp = TestingUtils.createCampaign();
		camp.Type = 'Nurture';
		insert camp;
		CampaignMember campMember = TestingUtils.createCampaignMember(camp.Id, contList[0].Id);
		campMember.Status = 'Sent';
		insert campMember;
		
		Test.StartTest();
			String SOQL = 'SELECT Id, Name, CampaignId, CreatedDate FROM Opportunity WHERE Id = \'' + opp.Id + '\'';
			batchSetPrimaryCampaignForOpp batch = new batchSetPrimaryCampaignForOpp(SOQL);
			Database.executeBatch(batch,1); 
		Test.StopTest();
		
	}
	
	
	
	
}