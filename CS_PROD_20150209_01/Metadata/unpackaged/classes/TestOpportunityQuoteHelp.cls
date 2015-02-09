@isTest
private class TestOpportunityQuoteHelp 
{
	static testMethod void TestOpportunityQuoteHelpCredit() 
	{
		TestingUtils.InitAvaTax();
        List<Account> accounts = TestingUtils.createAccounts(1, true);      
        Account a = accounts.get(0);
		
        Opportunity opp = TestingUtils.createOpportunity(a.Id);
        insert opp;        	
				
		Case c = new Case();
        
		RecordType rt = [SELECT Id, Name from RecordType where Name= 'Training' LIMIT 1];
		
		Test.startTest();		
		
        PageReference pageRef = Page.OpportunityQuoteHelp;
        pageRef.GetParameters().put('aid', a.Id);
        pageRef.GetParameters().put('oid', opp.Id);
		pageRef.GetParameters().put('rtId', rt.Id);        
		
        Test.setCurrentPage(pageRef);                   
		
        ApexPages.StandardController controller = new ApexPages.StandardController(c); 
		
		OpportunityQuoteHelpExtension extension = new OpportunityQuoteHelpExtension();
        		
		extension.HelpOption = 'Credit';
        extension.RedirectToPage();	
		extension.credit.Opportunity__c = opp.Id;
		extension.credit.Start_Date_of_New_Contract__c = Date.today();
		extension.credit.Comments__c = 'Test Comments';
		extension.Save();
        Test.stopTest();
	}
	
	static testMethod void TestOpportunityQuoteHelpInternational() 
	{
		TestingUtils.InitAvaTax();
        List<Account> accounts = TestingUtils.createAccounts(1, true);      
        Account a = accounts.get(0);
		
        Opportunity opp = TestingUtils.createOpportunity(a.Id);
        insert opp;        
				
		Case c = new Case();
        
		RecordType rt = [SELECT Id, Name from RecordType where Name= 'Training' LIMIT 1];
		
		Test.startTest();		
		
        PageReference pageRef = Page.OpportunityQuoteHelp;
        pageRef.GetParameters().put('aid', a.Id);
        pageRef.GetParameters().put('oid', opp.Id);
		pageRef.GetParameters().put('rtId', rt.Id);        
		
        Test.setCurrentPage(pageRef);                   
		
        ApexPages.StandardController controller = new ApexPages.StandardController(c); 
		
		OpportunityQuoteHelpExtension extension = new OpportunityQuoteHelpExtension();
        		
		extension.HelpOption = 'International';
        extension.RedirectToPage();		
		extension.ipq.CisionPoint_ID__c = '1234';
		extension.ipq.Country_s__c = '1234';
		extension.ipq.Coverage_Start_Date__c = Date.today();
		extension.ipq.Coverage_End_Date__c = Date.today();
		extension.ipq.Volume_of_Subscriptions__c = '1234';
		extension.ipq.Keyword_Specs_per_Subscription__c = 'Test';
		extension.ipq.Media_Source__c = 'Test';
		extension.Save();
        Test.stopTest();
	}
	
	/*static testMethod void TestOpportunityQuoteHelpRedlineRequest() 
	{
		TestingUtils.InitAvaTax();
        List<Account> accounts = TestingUtils.createAccounts(1, true);      
        Account a = accounts.get(0);
		
        Opportunity opp = TestingUtils.createOpportunity(a.Id);
        insert opp;
				
		Case c = new Case();
        
		RecordType rt = [SELECT Id, Name from RecordType where Name= 'Training' LIMIT 1];
		
		Test.startTest();		
		
        PageReference pageRef = Page.OpportunityQuoteHelp;
        pageRef.GetParameters().put('aid', a.Id);
        pageRef.GetParameters().put('oid', opp.Id);
		pageRef.GetParameters().put('rtId', rt.Id);        
		
        Test.setCurrentPage(pageRef);                   
		
        ApexPages.StandardController controller = new ApexPages.StandardController(c); 		
		OpportunityQuoteHelpExtension extension = new OpportunityQuoteHelpExtension();
        		
		extension.HelpOption = 'Redline';
		extension.RedirectToPage();	
		extension.rr.General_4_Fees_Payments__c = '';
		extension.rr.Finance_Comments__c = 'Test finance comments';
		extension.Save();
        Test.stopTest();
	}*/
	
	static testMethod void TestOpportunityQuoteHelpSalesSupport() 
	{
		TestingUtils.InitAvaTax();
        List<Account> accounts = TestingUtils.createAccounts(1, true);      
        Account a = accounts.get(0);
		
        Opportunity opp = TestingUtils.createOpportunity(a.Id);
        insert opp;        	
				
		Case c = new Case();
        
		RecordType rt = [SELECT Id, Name from RecordType where Name= 'Training' LIMIT 1];
		
		Test.startTest();		
		
        PageReference pageRef = Page.OpportunityQuoteHelp;
        pageRef.GetParameters().put('aid', a.Id);
        pageRef.GetParameters().put('oid', opp.Id);
		pageRef.GetParameters().put('rtId', rt.Id);        
		
        Test.setCurrentPage(pageRef);                   
		
        ApexPages.StandardController controller = new ApexPages.StandardController(c); 
		
		OpportunityQuoteHelpExtension extension = new OpportunityQuoteHelpExtension();
        		
		extension.HelpOption = 'SalesSupport';
        extension.RedirectToPage();			
        Test.stopTest();
	}
}