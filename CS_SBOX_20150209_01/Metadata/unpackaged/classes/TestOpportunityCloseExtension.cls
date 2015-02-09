@isTest
private class TestOpportunityCloseExtension
{
	
    static testmethod void TestSubmitQuoteNoShippingAddress()
	{
		InsertClosedReasons();
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);      
		insert accounts;
				
        Opportunity oppNoShippingAddress = TestingUtils.createOpportunity(accounts[0].Id);
		oppNoShippingAddress.StageName = 'Establish Value';
		oppNoShippingAddress.Shipping_Street__c = null;
        insert oppNoShippingAddress;
		
		Test.startTest();
		
		RunSubmitQuoteTest(oppNoShippingAddress);
		
		Test.stopTest();
        
	}
      
    
	static testmethod void TestSubmitQuoteNoBillingAddress()
	{
		InsertClosedReasons();
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);      
        accounts[0].BillingStreet = null;
		insert accounts;
				
        Opportunity oppNoBillingAddress = TestingUtils.createOpportunity(accounts[0].Id);
		oppNoBillingAddress.StageName = 'Establish Value';
		insert oppNoBillingAddress;
		
		Test.startTest();
		
		RunSubmitQuoteTest(oppNoBillingAddress);
		
		Test.stopTest();
	}

	static testmethod void TestSubmitQuoteNoOCR()
	{
		InsertClosedReasons();
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);      
        insert accounts;
				
        Opportunity oppNoOCR = TestingUtils.createOpportunity(accounts[0].Id);
		oppNoOCR.StageName = 'Establish Value';
		insert oppNoOCR;
		
		Test.startTest();
		
		RunSubmitQuoteTest(oppNoOCR);
		
		Test.stopTest();
	}
	
	static testmethod void TestSubmitQuoteOCRNoPhone()
	{
		InsertClosedReasons();
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);      
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test', '111111', false);
		cont.Email = 'Test@Test.com';
		cont.Phone = null;
		insert cont;
		
        Opportunity oppOCRNoPhone = TestingUtils.createOpportunity(accounts[0].Id);
		oppOCRNoPhone.StageName = 'Establish Value';
		insert oppOCRNoPhone;
		
		OpportunityContactRole ocr1 = TestingUtils.createOpportunityContactRole(oppOCRNoPhone.Id, cont.Id);
		insert ocr1;
		
		Test.startTest();
		
		RunSubmitQuoteTest(oppOCRNoPhone);
		
		Test.stopTest();
	}
	
    
	static testmethod void TestSubmitQuoteNoQuote()
	{
		InsertClosedReasons();
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);      
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
        Opportunity oppNoQuote = TestingUtils.createOpportunity(accounts[0].Id);
		oppNoQuote.StageName = 'Establish Value';
		insert oppNoQuote;
		
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(oppNoQuote.Id, cont.Id);
		insert ocr;
		
		Test.startTest();
		
		RunSubmitQuoteTest(oppNoQuote);
		
		Test.stopTest();
	}
	
	static testmethod void TestSubmitQuoteCustomPaymentPlan()
	{
		InsertClosedReasons();
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);      
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
        Opportunity oppCustomPaymentPlan = TestingUtils.createOpportunity(accounts[0].Id);
		oppCustomPaymentPlan.StageName = 'Establish Value';
		insert oppCustomPaymentPlan;
		
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(oppCustomPaymentPlan.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', Payment_Plan__c = 'Custom', SBQQ__Opportunity__c = oppCustomPaymentPlan.Id, SBQQ__Type__c = 'Quote');
		insert quote;
		
		Test.startTest();
		
		RunSubmitQuoteTest(oppCustomPaymentPlan);
		
		Test.stopTest();
	}
	
	static testmethod void TestSubmitQuoteNoCARep()
	{
		InsertClosedReasons();
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);      
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
        Opportunity oppNoCARep = TestingUtils.createOpportunity(accounts[0].Id);
		oppNoCARep.StageName = 'Establish Value';
		oppNoCARep.CA_Rep__c = null;
		insert oppNoCARep;
		
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(oppNoCARep.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = oppNoCARep.Id, SBQQ__Type__c = 'Quote');
		insert quote;
		
		Test.startTest();
		
		RunSubmitQuoteTest(oppNoCARep);
		
		Test.stopTest();
	}
	
	static testmethod void TestSubmitQuoteNoGPId()
	{
		InsertClosedReasons();
		
		User u1 = TestingUtils.createUser ( 'catest', TestingUtils.TEST_PROFILE_ID);
		insert u1;
		User u2 = TestingUtils.createUser ( 'mtest', TestingUtils.TEST_PROFILE_ID);
		u2.CA_Rep__c = u1.Id;
		insert u2;
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);      
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
        Opportunity oppNoGPID = TestingUtils.createOpportunity(accounts[0].Id);
		oppNoGPID.StageName = 'Establish Value';
		oppNoGPID.CA_Rep__c = u1.Id;
		oppNoGPID.OwnerId = u2.Id;
		insert oppNoGPID;
		
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(oppNoGPID.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = oppNoGPID.Id, SBQQ__Type__c = 'Quote');
		insert quote;
		
		Test.startTest();
		
		RunSubmitQuoteTest(oppNoGPID);
		
		Test.stopTest();
	}
	
	static testmethod void TestSubmitQuoteRenewalPaidExtension()
	{
		InsertClosedReasons();
		
		User u1 = TestingUtils.createUser ( 'catest', TestingUtils.TEST_PROFILE_ID);
		insert u1;
		User u2 = TestingUtils.createUser ( 'mtest', TestingUtils.TEST_PROFILE_ID);
		u2.CA_Rep__c = u1.Id;
		insert u2;
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);
		accounts[0].GP_Cust_ID__c = '111111';
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
       Opportunity oppRenewalPaidExtension = TestingUtils.createOpportunity(accounts[0].Id);
		oppRenewalPaidExtension.StageName = 'Establish Value';
		oppRenewalPaidExtension.Type = 'Renewal (Paid Extension)';
		oppRenewalPaidExtension.CA_Rep__c = u1.Id;
		oppRenewalPaidExtension.OwnerId = u2.Id;
		insert oppRenewalPaidExtension;
		
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(oppRenewalPaidExtension.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = oppRenewalPaidExtension.Id, SBQQ__Type__c = 'Quote');
		insert quote;
		
		Test.startTest();
		
		RunSubmitQuoteTest(oppRenewalPaidExtension);
		
		Test.stopTest();
	}
	
	@istest (SeeAllData=true)
	static void TestSubmitQuoteNoBillingStartDate()
	{
		InsertClosedReasons();
		
		User u1 = TestingUtils.createUser ( 'catest', TestingUtils.TEST_PROFILE_ID);
		insert u1;
		User u2 = TestingUtils.createUser ( 'mtest', TestingUtils.TEST_PROFILE_ID);
		u2.CA_Rep__c = u1.Id;
		insert u2;
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);
		accounts[0].GP_Cust_ID__c = '111111';
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
       	Opportunity oppNoBillingStartDate = TestingUtils.createOpportunity(accounts[0].Id);
		oppNoBillingStartDate.StageName = 'Establish Value';
		oppNoBillingStartDate.CA_Rep__c = u1.Id;
		oppNoBillingStartDate.OwnerId = u2.Id;
		insert oppNoBillingStartDate;
				
		Test.startTest();
		
		createTestOpportunityLineItems(oppNoBillingStartDate.Id);
		
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(oppNoBillingStartDate.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = oppNoBillingStartDate.Id, Billing_Start_Date__c = null, SBQQ__Type__c = 'Quote');
		insert quote;
		
		RunSubmitQuoteTest(oppNoBillingStartDate);
		
		Test.stopTest();
	}
	
    
	@istest (SeeAllData=true)
	static void TestSubmitQuotePassedOpp()
	{
		InsertClosedReasons();
		
		User u1 = TestingUtils.createUser ( 'catest', TestingUtils.TEST_PROFILE_ID);
		insert u1;
		User u2 = TestingUtils.createUser ( 'mtest', TestingUtils.TEST_PROFILE_ID);
		u2.CA_Rep__c = u1.Id;
		insert u2;
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);
		accounts[0].GP_Cust_ID__c = '111111';
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
       	Opportunity passedOpp = TestingUtils.createOpportunity(accounts[0].Id);
		passedOpp.StageName = 'Establish Value';
		passedOpp.CA_Rep__c = u1.Id;
		passedOpp.OwnerId = u2.Id;
		insert passedOpp;
				
		Test.startTest();
		
		createTestOpportunityLineItems(passedOpp.Id);
		
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(passedOpp.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = passedOpp.Id, Billing_Start_Date__c = Date.today(), SBQQ__Type__c = 'Quote');
		insert quote;
		
		RunSubmitQuoteTest(passedOpp);
		
		Test.stopTest();
	}
	
	@istest (SeeAllData=true)
	static void TestSubmitQuoteCreditCompletedInCurrentMonth()
	{
		InsertClosedReasons();
		
		User u1 = TestingUtils.createUser ( 'catest', TestingUtils.TEST_PROFILE_ID);
		insert u1;
		User u2 = TestingUtils.createUser ( 'mtest', TestingUtils.TEST_PROFILE_ID);
		u2.CA_Rep__c = u1.Id;
		insert u2;
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);
		accounts[0].GP_Cust_ID__c = '111111';
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
       	Opportunity oppCreditCompletedInCurrentMonth = TestingUtils.createOpportunity(accounts[0].Id);
		oppCreditCompletedInCurrentMonth.StageName = 'Establish Value';
		oppCreditCompletedInCurrentMonth.CA_Rep__c = u1.Id;
		oppCreditCompletedInCurrentMonth.OwnerId = u2.Id;
		insert oppCreditCompletedInCurrentMonth;
			
		Test.startTest();
		
		createTestOpportunityLineItems(oppCreditCompletedInCurrentMonth.Id);
		
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(oppCreditCompletedInCurrentMonth.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = oppCreditCompletedInCurrentMonth.Id, Billing_Start_Date__c = Date.today(), SBQQ__Type__c = 'Quote');
		insert quote;
		
		Credit_for_Existing_Services_quote__c credit = new Credit_for_Existing_Services_quote__c(Status__c = 'Completed', Quote_Expiration_Date__c = Date.today(), Opportunity__c = oppCreditCompletedInCurrentMonth.Id, Start_Date_of_New_Contract__c = Date.today());
		insert credit;
		
		RunSubmitQuoteTest(oppCreditCompletedInCurrentMonth);
		
		Test.stopTest();
	}
	
	@istest (SeeAllData=true)
	static void TestSubmitQuoteCreditNewOrIsInProgress()
	{
		InsertClosedReasons();
		
		User u1 = TestingUtils.createUser ( 'catest', TestingUtils.TEST_PROFILE_ID);
		insert u1;
		User u2 = TestingUtils.createUser ( 'mtest', TestingUtils.TEST_PROFILE_ID);
		u2.CA_Rep__c = u1.Id;
		insert u2;
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);
		accounts[0].GP_Cust_ID__c = '111111';
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
       	Opportunity oppCreditNewOrInProgress = TestingUtils.createOpportunity(accounts[0].Id);
		oppCreditNewOrInProgress.StageName = 'Establish Value';
		oppCreditNewOrInProgress.CA_Rep__c = u1.Id;
		oppCreditNewOrInProgress.OwnerId = u2.Id;
		insert oppCreditNewOrInProgress;
				
		Test.startTest();
		
		createTestOpportunityLineItems(oppCreditNewOrInProgress.Id);
		
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(oppCreditNewOrInProgress.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = oppCreditNewOrInProgress.Id, Billing_Start_Date__c = Date.today(), SBQQ__Type__c = 'Quote');
		insert quote;
		
		Credit_for_Existing_Services_quote__c credit = new Credit_for_Existing_Services_quote__c(Status__c = 'New', Quote_Expiration_Date__c = Date.today(), Opportunity__c = oppCreditNewOrInProgress.Id, Start_Date_of_New_Contract__c = Date.today());
		insert credit;
		
		RunSubmitQuoteTest(oppCreditNewOrInProgress);
		
		Test.stopTest();
	}

	@istest (SeeAllData=true)
	static void TestSubmitQuoteCreditCompleteAndNotInCurrentMonth()
	{
		InsertClosedReasons();
		
		User u1 = TestingUtils.createUser ( 'catest', TestingUtils.TEST_PROFILE_ID);
		insert u1;
		User u2 = TestingUtils.createUser ( 'mtest', TestingUtils.TEST_PROFILE_ID);
		u2.CA_Rep__c = u1.Id;
		insert u2;
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);
		accounts[0].GP_Cust_ID__c = '111111';
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
       	Opportunity oppCreditCompletedandNotInCurrentMonth = TestingUtils.createOpportunity(accounts[0].Id);
		oppCreditCompletedandNotInCurrentMonth.StageName = 'Establish Value';
		oppCreditCompletedandNotInCurrentMonth.CA_Rep__c = u1.Id;
		oppCreditCompletedandNotInCurrentMonth.OwnerId = u2.Id;
		insert oppCreditCompletedandNotInCurrentMonth;
				
		Test.startTest();
		
		createTestOpportunityLineItems(oppCreditCompletedandNotInCurrentMonth.Id);
		
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(oppCreditCompletedandNotInCurrentMonth.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = oppCreditCompletedandNotInCurrentMonth.Id, Billing_Start_Date__c = Date.today(), SBQQ__Type__c = 'Quote');
		insert quote;
		
		Credit_for_Existing_Services_quote__c credit = new Credit_for_Existing_Services_quote__c(Status__c = 'Completed', Quote_Expiration_Date__c = Date.today().addMonths(2), Opportunity__c = oppCreditCompletedandNotInCurrentMonth.Id, Start_Date_of_New_Contract__c = Date.today());
		insert credit;
		
		International_Print_Quote__c print = new International_Print_Quote__c(Quote_Status__c = 'Completed',  Opportunity__c = oppCreditCompletedandNotInCurrentMonth.Id);
		insert print;
		
		RunSubmitQuoteTest(oppCreditCompletedandNotInCurrentMonth);
		
		Test.stopTest();
	}

	@istest (SeeAllData=true)
	static void TestSubmitQuoteCreditRejected()
	{
		InsertClosedReasons();
		
		User u1 = TestingUtils.createUser ( 'catest', TestingUtils.TEST_PROFILE_ID);
		insert u1;
		User u2 = TestingUtils.createUser ( 'mtest', TestingUtils.TEST_PROFILE_ID);
		u2.CA_Rep__c = u1.Id;
		insert u2;
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);
		accounts[0].GP_Cust_ID__c = '111111';
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		insert cont;
		
       	Opportunity oppCreditRejected = TestingUtils.createOpportunity(accounts[0].Id);
		oppCreditRejected.StageName = 'Establish Value';
		oppCreditRejected.CA_Rep__c = u1.Id;
		oppCreditRejected.OwnerId = u2.Id;
		insert oppCreditRejected;
				
		Test.startTest();
		
		createTestOpportunityLineItems(oppCreditRejected.Id);
		
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(oppCreditRejected.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = true, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = oppCreditRejected.Id, Billing_Start_Date__c = Date.today(), SBQQ__Type__c = 'Quote');
		insert quote;
		
		Credit_for_Existing_Services_quote__c credit = new Credit_for_Existing_Services_quote__c(Status__c = 'Rejected', Rejected_Reason__c = 'Test', Quote_Expiration_Date__c = Date.today(), Opportunity__c = oppCreditRejected.Id, Start_Date_of_New_Contract__c = Date.today());
		insert credit;
		
		International_Print_Quote__c print = new International_Print_Quote__c(Quote_Status__c = 'New',  Opportunity__c = oppCreditRejected.Id);
		insert print;
		
		RunSubmitQuoteTest(oppCreditRejected);
		
		Test.stopTest();
	}
    
    @istest (SeeAllData=true)
	static void TestSubmitQuoteValidateFailOpp()
	{
		InsertClosedReasons();
		
		User u1 = TestingUtils.createUser ( 'catest', TestingUtils.TEST_PROFILE_ID);
		insert u1;
		User u2 = TestingUtils.createUser ( 'mtest', TestingUtils.TEST_PROFILE_ID);
		// -- u2.CA_Rep__c = u1.Id;
		insert u2;
		
		List<Account> accounts = TestingUtils.createAccounts(1, false);
		accounts[0].GP_Cust_ID__c = '111111';
        accounts[0].BillingStreet = null;
        insert accounts;
		
		Contact cont = TestingUtils.createAgent(accounts[0].Id, 'Test2', '222222', false);
		// cont.Email = 'Test@Test.com';
        cont.Email = null;
		// cont.Phone = null;
        insert cont;
		
       	Opportunity failedOpp = TestingUtils.createOpportunity(accounts[0].Id);
		failedOpp.StageName = 'Establish Value';
		// failedOpp.CA_Rep__c = u1.Id;
		failedOpp.OwnerId = u2.Id;
        failedOpp.Shipping_Street__c = null;
		insert failedOpp;
				
		Test.startTest();
		
		createTestOpportunityLineItems(failedOpp.Id);
		
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(failedOpp.Id, cont.Id);
		insert ocr;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Primary__c = false, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = failedOpp.Id, Billing_Start_Date__c = Date.today(), SBQQ__Type__c = 'Quote');
		insert quote;
		
		RunSubmitQuoteTest(failedOpp);
		
		Test.stopTest();
	}
    
	static void RunSubmitQuoteTest(Opportunity opp)
	{
		PageReference pageRef = Page.opportunityClose;
		pageRef.GetParameters().put('id', opp.Id);
        pageRef.GetParameters().put('type','SubmitQuote');
		Test.setCurrentPage(pageRef); 
		
		ApexPages.StandardController controller = new ApexPages.StandardController(opp); 
        OpportunityCloseExtension extension = new OpportunityCloseExtension(controller);
		extension.Save();
	}
	
    
	static void createTestOpportunityLineItems(Id oppId)
    {
        List<Product2> products = new List<Product2>();
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();       
        
        Pricebook2 standardPriceBook = [select Id from Pricebook2 where isStandard=true];
        Pricebook2 testPricebook = new Pricebook2();
        testPricebook.Name = 'testPricebook';
        insert testPricebook;
        
        List<Opportunity> oppList = [select Id,Pricebook2Id from Opportunity where Id = :oppId];
        oppList[0].Pricebook2Id = standardPriceBook.Id;
		update oppList;
        
        Product2 intPrintprod = TestingUtils.createProduct(false);
		intPrintprod.Name = 'TestProd1';
		intPrintprod.ProductCode = 'TestProd1';
		intPrintprod.Workflow_International_Print__c = true;
		products.add(intPrintprod);
		
		Product2 creditExistingServicesProd = TestingUtils.createProduct(false);
		creditExistingServicesProd.Name = 'TestProd2';
		creditExistingServicesProd.ProductCode = 'TestProd2';
		creditExistingServicesProd.Workflow_Credit_for_Existing_Services__c = true;
		products.add(creditExistingServicesProd);
		
		insert products;
                        
        PricebookEntry testStandardPricebookEntry = new PricebookEntry();
        testStandardPricebookEntry.Product2Id = intPrintprod.Id;
        testStandardPricebookEntry.Pricebook2Id = standardPriceBook.Id; 
        testStandardPricebookEntry.IsActive = true;
        testStandardPricebookEntry.UnitPrice = 200;
        pricebookEntries.add(testStandardPricebookEntry);
					
		PricebookEntry testStandardPricebookEntry2 = new PricebookEntry();
        testStandardPricebookEntry2.Product2Id = creditExistingServicesProd.Id;
        testStandardPricebookEntry2.Pricebook2Id = standardPriceBook.Id; 
        testStandardPricebookEntry2.IsActive = true;
        testStandardPricebookEntry2.UnitPrice = 200;
		pricebookEntries.add(testStandardPricebookEntry2);
        
		insert pricebookEntries;         
                        
        OpportunityLineItem testLineItem = new OpportunityLineItem();
        testLineItem.OpportunityId = oppId;
        testLineItem.PricebookEntryId = testStandardPricebookEntry.Id;
        testLineItem.UnitPrice = 200;
        testLineItem.Quantity = 1;
        oppLineItems.add(testLineItem);  
		
		OpportunityLineItem testLineItem2 = new OpportunityLineItem();
        testLineItem2.OpportunityId = oppId;
        testLineItem2.PricebookEntryId = testStandardPricebookEntry2.Id;
        testLineItem2.UnitPrice = 200;
        testLineItem2.Quantity = 1;
        oppLineItems.add(testLineItem2); 
	       
		insert oppLineItems;
    }       
	
    
	static testMethod void TestCloseAsLost()
	{
		TestingUtils.InitAvaTax();
		
		List<Closed_Reasons__c> reasonsList = new List<Closed_Reasons__c>();
		Closed_Reasons__c reason1 = new Closed_Reasons__c(Name = 'Test1', Won__c = true, Lost__c = false);
		Closed_Reasons__c reason2 = new Closed_Reasons__c(Name = 'Test2', Won__C = false, Lost__c = true);
		Closed_Reasons__c reason3 = new Closed_Reasons__c(Name = 'DupeTest1', Won__c = true, Lost__c = false);
		Closed_Reasons__c reason4 = new Closed_Reasons__c(Name = 'DupeTest2', Won__C = false, Lost__c = true);
		reasonsList.add(reason1);
		reasonsList.add(reason2);
		reasonsList.add(reason3);
		reasonsList.add(reason4);
		insert reasonsList;
		
		List<Account> accounts = TestingUtils.createAccounts(1, true);      
        
        Opportunity opp = TestingUtils.createOpportunity(accounts[0].Id);
		opp.StageName = 'Establish Value';
        insert opp;
		
		Test.startTest();
		
		PageReference pageRef = Page.opportunityClose;
		pageRef.GetParameters().put('id', opp.Id);
        pageRef.GetParameters().put('type','CloseAsLost');
		Test.setCurrentPage(pageRef); 
		
		ApexPages.StandardController controller = new ApexPages.StandardController(opp); 
        OpportunityCloseExtension extension = new OpportunityCloseExtension(controller);
		
		extension.Save();
		
		Test.stopTest();
	}
	
	static testMethod void TestCloseAsWon()
	{
		TestingUtils.InitAvaTax();
		
		List<Closed_Reasons__c> reasonsList = new List<Closed_Reasons__c>();
		Closed_Reasons__c reason1 = new Closed_Reasons__c(Name = 'Test1', Won__c = true, Lost__c = false);
		Closed_Reasons__c reason2 = new Closed_Reasons__c(Name = 'Test2', Won__C = false, Lost__c = true);
		Closed_Reasons__c reason3 = new Closed_Reasons__c(Name = 'DupeTest1', Won__c = true, Lost__c = false);
		Closed_Reasons__c reason4 = new Closed_Reasons__c(Name = 'DupeTest2', Won__C = false, Lost__c = true);
		reasonsList.add(reason1);
		reasonsList.add(reason2);
		reasonsList.add(reason3);
		reasonsList.add(reason4);
		insert reasonsList;
		
		List<Account> accounts = TestingUtils.createAccounts(1, true);      
        
        Opportunity opp = TestingUtils.createOpportunity(accounts[0].Id);
		opp.StageName = 'Establish Value';
        insert opp;
		
		Test.startTest();
		
		PageReference pageRef = Page.opportunityClose;
		pageRef.GetParameters().put('id', opp.Id);
        pageRef.GetParameters().put('type','CloseAsWon');
		Test.setCurrentPage(pageRef); 
		
		ApexPages.StandardController controller = new ApexPages.StandardController(opp); 
        OpportunityCloseExtension extension = new OpportunityCloseExtension(controller);
		
		extension.Save();
		
		Test.stopTest();
	}
	


	static void InsertClosedReasons()
	{
		TestingUtils.InitAvaTax();
		
		List<Closed_Reasons__c> reasonsList = new List<Closed_Reasons__c>();
		Closed_Reasons__c reason1 = new Closed_Reasons__c(Name = 'Test1', Won__c = true, Lost__c = false);
		Closed_Reasons__c reason2 = new Closed_Reasons__c(Name = 'Test2', Won__C = false, Lost__c = true);
		Closed_Reasons__c reason3 = new Closed_Reasons__c(Name = 'DupeTest1', Won__c = true, Lost__c = false);
		Closed_Reasons__c reason4 = new Closed_Reasons__c(Name = 'DupeTest2', Won__C = false, Lost__c = true);
		reasonsList.add(reason1);
		reasonsList.add(reason2);
		reasonsList.add(reason3);
		reasonsList.add(reason4);
		insert reasonsList;
	}
}