@isTest 
private class TestCaseSupportExtension 
{
    static testMethod void TestDCSCaseSupport() 
    {
		TestLibrary.InitAvaTax();
        List<Account> accounts = TestingUtils.createAccounts(1, true);      
        Account a = accounts.get(0);
		
        Opportunity opp = TestingUtils.createOpportunity(a.Id);
        insert opp;
        
		String caseCType = 'Broadcast Issues';
		
		List<Case> cases = TestingUtils.createCase(1, a.Id, opp.Id, caseCType);        
        Case c = cases.get(0);
		insert c;		        
        
		//RecordType rt = [SELECT Id, Name from RecordType where Name= 'DCS Broadcast Issues'];
		RecordType rt = UtilityClass.GetRecordType('DCS Broadcast Issues');
		
		Test.startTest();		
		
        PageReference pageRef = Page.CaseSupport;
        pageRef.GetParameters().put('aid', a.Id);
        pageRef.GetParameters().put('oid', opp.Id);
		pageRef.GetParameters().put('rtId', rt.Id);
        pageRef.GetParameters().put('cid', c.Id);
		
        Test.setCurrentPage(pageRef);                   
		
        ApexPages.StandardController controller = new ApexPages.StandardController(c); 
        CaseSupportExtension extension = new CaseSupportExtension(controller);      
       	extension.cs = (Case)controller.getRecord(); 
		SaveCaseInfo(extension.cs);
        extension.Save();   
		
        Test.stopTest();
    }
    
    static testMethod void TestSalesSupportCaseSupport() 
    {
		TestingUtils.InitAvaTax();
        List<Account> accounts = TestingUtils.createAccounts(1, true);      
        Account a = accounts.get(0);
		
        Opportunity opp = TestingUtils.createOpportunity(a.Id);
        insert opp;
        
		String caseCType = 'Broadcast Quote';
				
		Case c = new Case();
        
		//RecordType rt = [SELECT Id, Name from RecordType where Name= 'Sales Support Broadcast Quote'];
		RecordType rt = UtilityClass.GetRecordType('Sales Support Broadcast Quote');
		
		Test.startTest();		
		
        PageReference pageRef = Page.CaseSupport;
        pageRef.GetParameters().put('aid', a.Id);
        pageRef.GetParameters().put('oid', opp.Id);
		pageRef.GetParameters().put('rtId', rt.Id);        
		
        Test.setCurrentPage(pageRef);                   
		
        ApexPages.StandardController controller = new ApexPages.StandardController(c); 
        CaseSupportExtension extension = new CaseSupportExtension(controller);              
		extension.cs.Type = caseCType;
		extension.cs = (Case)controller.getRecord();        
        extension.GetCaseFieldSet();	
		extension.cs.Type = 'Pub Check';
		extension.cs = (Case)controller.getRecord();        
        extension.GetCaseFieldSet();
		extension.cs.Type = 'RFP';
		extension.cs = (Case)controller.getRecord();        
        extension.GetCaseFieldSet();
		extension.cs.Type = 'Extension Request';
		extension.cs = (Case)controller.getRecord();        
        extension.GetCaseFieldSet();
		extension.cs.Type = 'Trials';
		extension.cs = (Case)controller.getRecord();        
        extension.GetCaseFieldSet();
		SaveCaseInfo(extension.cs);
		extension.caseAttachment = null;
        extension.Save();   
		
        Test.stopTest();
    }
	
	static testMethod void TestTraining() 
    {
		TestingUtils.InitAvaTax();
        List<Account> accounts = TestingUtils.createAccounts(1, true);      
        Account a = accounts.get(0);
		
        Opportunity opp = TestingUtils.createOpportunity(a.Id);
        insert opp;
        
		String caseCType = 'Internal Training Request';
				
		List<Case> cases = TestingUtils.createCase(1, a.Id, opp.Id, caseCType);        
        Case c = cases.get(0);
		insert c;		
        
		Id rtId = TestingUtils.getRecordTypeId('Case', 'Training');		
		
		Test.startTest();		
		
        PageReference pageRef = Page.CaseSupport;
        pageRef.GetParameters().put('aid', a.Id);
        pageRef.GetParameters().put('oid', opp.Id);
		pageRef.GetParameters().put('rtId', rtId);
        pageRef.GetParameters().put('cid', c.Id);
		
        Test.setCurrentPage(pageRef);                   
		
        ApexPages.StandardController controller = new ApexPages.StandardController(c); 
        CaseSupportExtension extension = new CaseSupportExtension(controller);              
		extension.cs.Type = caseCType;
		extension.cs = (Case)controller.getRecord();        
        extension.GetCaseFieldSet();	
		extension.cs.Type = 'Training';
		extension.cs = (Case)controller.getRecord();        
        extension.GetCaseFieldSet();
		SaveCaseInfo(extension.cs);
		extension.caseAttachment = null; 		
        extension.Save();   
		
        Test.stopTest();
    }
	
	static testMethod void TestContractAdmin() 
    {
		TestingUtils.InitAvaTax();				
		User user1 = TestingUtils.createUser('CaUser1', TestingUtils.TEST_PROFILE_ID);
		user1.Email = 'Test@Cisionus.com';
		insert user1;		
		
		Round_Robin__c rr1 = new Round_Robin__c(User__c=user1.Id,Object_Type__c='Case',Group__c='Contract Admin',Sub_Group__c='',Assign_Records__c=true,Number_of_Records_Assigned__c=0,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=0);
		insert rr1;
		
        List<Account> accounts = TestingUtils.createAccounts(1, true);      
        Account a = accounts.get(0);
		
        Opportunity opp = TestingUtils.createOpportunity(a.Id);
        insert opp;
        
		String caseCType = 'Contract Admin';
				
		List<Case> cases = TestingUtils.createCase(1, a.Id, opp.Id, caseCType);        
        Case c = cases.get(0);
		insert c;		
        
		//Id rtId = TestingUtils.getRecordTypeId('Case', 'Contract_Admin_Request');
		RecordType rt = UtilityClass.GetRecordType('Contract Admin');
		
		Test.startTest();		
		
        PageReference pageRef = Page.CaseSupport;
        pageRef.GetParameters().put('aid', a.Id);
        pageRef.GetParameters().put('oid', opp.Id);
		pageRef.GetParameters().put('rtId', rt.Id);
        pageRef.GetParameters().put('cid', c.Id);
		
        Test.setCurrentPage(pageRef);                   
		
        ApexPages.StandardController controller = new ApexPages.StandardController(c); 
        CaseSupportExtension extension = new CaseSupportExtension(controller);              
		extension.cs.Type = caseCType;
		extension.cs = (Case)controller.getRecord();        
        extension.GetCaseFieldSet();			
		SaveCaseInfo(extension.cs);
		extension.caseAttachment = null;
        extension.Save();   
		
        Test.stopTest();
	}
	
	static void SaveCaseInfo(Case cs)
	{
		cs.Search_Terms__c = 'Test Terms';
		cs.Description = 'Test Description';
		cs.Subject = 'Test Subject';
		//extension.cs.ContactPhone = '1234567890';
		cs.Service_Desk_Ticket_Number__c = '1234';
		cs.Affected_CP_ID__c = '12345';
		cs.CisionPoint_Username__c = 'TestUser';
		cs.Number_of_Users_Affected__c = 1;
		cs.BAC__c = 'Test BAC';
		cs.Steps_to_Reproduce__c = 'Test Steps to Reproduce';
		cs.Expected__c = 'Test Expected';
		cs.Actual__c = 'Test Actual';
		cs.Jira_Number__c = 'Test Jira #';
		cs.Upset_Client_Notes__c = 'Test Upset Client Notes';
	}
}