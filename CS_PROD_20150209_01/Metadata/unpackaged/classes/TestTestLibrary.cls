@isTest
private class TestTestLibrary
{
	static testMethod void TestLibraryMethods()
	{
		TestLibrary.InitAvaTax();
		
		Id su = TestLibrary.STANDARD_USER_PROFILE;
		id sa = TestLibrary.SYSTEM_ADMIN_USER_PROFILE;
		Id bt = TestLibrary.BROADCAST_TRANSACTION_PROFILE;
		Id nb = TestLibrary.NEW_BIZ_PROFILE;
		Id m = TestLibrary.MARKETING_PROFILE;
	
		Id tcs = TestLibrary.TASK_CLIENT_SERVICES_RECORD_TYPE;	
		Id nbrt = TestLibrary.OPPORTUNITY_NEW_BIZ_RECORD_TYPE;
		Id rrt = TestLibrary.OPPORTUNITY_RENEWALS_RECORD_TYPE;
	
		Id sau = TestLibrary.SFDC_ADMIN_USER;
		
		List<User> usersList = TestLibrary.CreateUsers('Test', TestLibrary.STANDARD_USER_PROFILE,  1);
		insert usersList;
		
		List<Account> accList = TestLibrary.CreateAccounts('Test', usersList[0].Id, 1);
		insert accList;
		
		List<Contact> contList = TestLibrary.CreateContacts('Test', 'test@cisionca.com', usersList[0].Id, accList[0].Id, 1);
		insert contList;
					
		List<Opportunity> oppList = TestLibrary.CreateOpportunities('Test', usersList[0].Id, accList[0].Id, 1);
		insert oppList;
		
		List<OpportunityLineItem> liList = TestLibrary.CreateOpportunityLineItems('111', oppList[0].Id, 1);
		
		List<Campaign> campList = TestLibrary.CreateCampaigns('Test', usersList[0].Id, 1);
		
		List<Product2> prodList = TestLibrary.createProducts('Test', 'Test', 'Test', 1);
		insert prodList;
		
		List<OpportunityLineItem> liList2 = TestLibrary.CreateOpportunityLineItems(prodList[0].Id, oppList[0].Id, 1);
		
		System.Debug('Inserting Quote. Acc Id = ' + accList[0].Id + ' Opp Id = ' + oppList[0].Id);
		List<SBQQ__Quote__c> quoteList = TestLibrary.CreateQuotes(accList[0].Id, oppList[0].Id, 1);
		//insert quoteList;
		
		//List<SBQQ__QuoteLine__c> quoteLineList = TestLibrary.createQuoteLines(quoteList[0].Id, prodList[0].Id, 1);
		//insert quoteLineList;
		
		List<Case> caseList = TestLibrary.createCases('Test', accList[0].Id, 1);
				
		List<Task> taskList = TestLibrary.CreateTasks('Test', 'Test', 'Test', 1);
		
	}
}