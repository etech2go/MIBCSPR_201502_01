@isTest
private class TestContractTrigger
{
	static testMethod void TestContractNumberAddedToOpp()
	{
		TestLibrary.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.STANDARD_USER_PROFILE);
        insert u;
		
		Account a = TestLibrary.CreateAccount('Test Account', u.Id);  
		a.Renewal_Rep__c = null;
		insert a;
		
		Opportunity opp = TestLibrary.CreateOpportunity('Test', u.Id, a.Id);  
		insert opp;
		
		Test.startTest();
			Contract c = new Contract(Status='Draft', StartDate = Date.today(), ContractTerm = 12, AccountId = a.Id, SBQQ__Opportunity__c = opp.Id);
			insert c;
			update c;
		Test.stopTest();
	
		opp = [Select Id, Contract_Number__c from Opportunity where Id = :opp.Id];
		c = [Select Id, ContractNumber from Contract where Id = :c.Id];
		System.Assert(opp.Contract_Number__c == c.ContractNumber);
	}
}