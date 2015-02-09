@isTest
private class TestUnlockQuoteExtension
{
	/*static void TestRecallApproval()
	{
		TestingUtils.InitAvaTax();
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);      
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
        Opportunity opp = TestingUtils.createOpportunity(accounts[0].Id);
		opp.StageName = 'Qualified';
		insert opp;
		
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(opp.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = opp.Id, SBQQ__Type__c = 'Quote');
		insert quote;
		
        Product2 p = TestLibrary.createProduct('test', 'test', 'test');
        insert p;
        
        SBQQ__QuoteLine__c ql = TestLibrary.createQuoteLine(quote.Id, p.Id);
        ql.SBQQ__ListPrice__c = 4000;
        ql.SBQQ__Quantity__c = 1;
        ql.SBQQ__AdditionalDiscountAmount__c = 30;
        insert ql;
 
        System.Debug('############################Discount Amount for Approval = ' + quote.Discount_Amount_for_Approval__c);
        System.Debug('############################Discount Percent for Approval = ' + quote.Discount_Percent_for_Approval__c );
		Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
		req.setComments('Quote Submitted for approval. Please approve.');
		req.setObjectId(quote.Id);
		Approval.process(req);
		
		Test.startTest();
			PageReference pageRef = Page.UnlockQuote;
			pageRef.GetParameters().put('id', quote.Id);
        	Test.setCurrentPage(pageRef); 
		
			ApexPages.StandardController controller = new ApexPages.StandardController(quote); 
        	UnlockQuoteExtension extension = new UnlockQuoteExtension(controller);
			extension.UnlockQuote();		
		
		Test.stopTest();
	}*/
    
    static testmethod void TestUnlockContractRejected()
	{
		TestingUtils.InitAvaTax();
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);      
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
        Opportunity opp = TestingUtils.createOpportunity(accounts[0].Id);
		opp.StageName = 'Cust: Contract Rejected';
		insert opp;
		
        OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(opp.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = opp.Id, SBQQ__Type__c = 'Quote');
		insert quote;
        
		Test.startTest();
			PageReference pageRef = Page.UnlockQuote;
			pageRef.GetParameters().put('id', quote.Id);
        	Test.setCurrentPage(pageRef); 
		
			ApexPages.StandardController controller = new ApexPages.StandardController(quote); 
        	UnlockQuoteExtension extension = new UnlockQuoteExtension(controller);
			extension.UnlockQuote();		
		
		Test.stopTest();
	}
    
    static testmethod void TestUnlockAPPRejected()
	{
		TestingUtils.InitAvaTax();
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);      
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
        Opportunity opp = TestingUtils.createOpportunity(accounts[0].Id);
		opp.StageName = 'APP: Rejected';
		insert opp;
		 
        OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(opp.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = opp.Id, SBQQ__Type__c = 'Quote');
		insert quote;
        
		Test.startTest();
			PageReference pageRef = Page.UnlockQuote;
			pageRef.GetParameters().put('id', quote.Id);
        	Test.setCurrentPage(pageRef); 
		
			ApexPages.StandardController controller = new ApexPages.StandardController(quote); 
        	UnlockQuoteExtension extension = new UnlockQuoteExtension(controller);
			extension.UnlockQuote();		
		
		Test.stopTest();
	}
}