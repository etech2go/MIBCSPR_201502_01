@isTest
private class TestUserTrigger {
	static testMethod void TestCARepMove()
	{
		TestLibrary.InitAvaTax();
		
		User caUser = TestLibrary.createUser ('Test1', TestLibrary.STANDARD_USER_PROFILE);
        insert caUser;
		
		User newCaUser = TestLibrary.createUser ('Test2', TestLibrary.STANDARD_USER_PROFILE);
        insert newCaUser;
		
		User u = TestLibrary.createUser ('Test3', TestLibrary.STANDARD_USER_PROFILE);
        u.CA_Rep__c = caUser.Id;
		insert u;
		
		Account acc = TestLibrary.CreateAccount('Test Account', u.Id);  
		insert acc;
		
		Opportunity opp = TestLibrary.createOpportunity('Test', u.Id, acc.Id);
		opp.CA_Rep__c = caUser.Id;
		insert opp;
		
		Test.startTest();
			u.CA_Rep__c = newCaUser.Id;
			update u;
		Test.stopTest();
	
		opp = [Select Id, CA_Rep__C from Opportunity where Id = :opp.Id];
		System.Assert(opp.CA_Rep__c == newCaUser.Id);
	}
}