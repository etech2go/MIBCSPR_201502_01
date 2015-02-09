@isTest
public class TestCaseTrigger 
{
	static testmethod void TestForInvalidEmail()
	{
		TestLibrary.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.STANDARD_USER_PROFILE);
        insert u;
		
		Account a = TestLibrary.CreateAccount('Test Account', u.Id);  
		insert a;
		
		Case c = TestLibrary.createCase('Test', a.Id);
		c.SuppliedEmail = 'customercare@gototraining.com';
		
		Test.startTest();
		
		try
		{
			insert c;
		}
		catch (Exception e)
		{
			System.Assert(e.getMessage().contains('Case not inserted as the Email was sent from customercare@gototraining.com, mailer-daemon@messagelabs.com or has AUTO-REPLY in the Subject'));
		}
		
		Test.stopTest();
	}
	
		
	static testMethod void TestForCustomerSupportEmailWithOpportunityOwner()
	{
        TestLibrary.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.STANDARD_USER_PROFILE);
        insert u;
		User u2 = TestLibrary.createUser ('Test2', TestLibrary.STANDARD_USER_PROFILE);
        u2.ManagerId = u.Id;
		insert u2;
		
		
		Account a = TestLibrary.CreateAccount('Test Account', u.Id);  
		insert a;
		
		Opportunity o = TestLibrary.CreateOpportunity('Test', u2.Id, a.Id);
		insert o;
		
		Case c = TestLibrary.createCase('Test', a.Id);
		c.Origin = 'Customer Support Email';
		c.Opportunity__c = o.Id;
		
		Test.startTest();
		
		insert c;
		update c;
		
		Test.stopTest();
		
		c = [Select Id, Opportunity_Owner_Manager__c from Case where Id = :c.Id];
		System.Assert(c.Opportunity_Owner_Manager__c == u.Id);
	}
	
	
	
	static testMethod void TestForTrainingEmail()
	{
        TestLibrary.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.STANDARD_USER_PROFILE);
        insert u;
		
		Account a = TestLibrary.CreateAccount('Test Account', u.Id);  
		insert a;
		
		Case c = TestLibrary.createCase('Test', a.Id);
		c.Origin = 'Training Email';
		
		Test.startTest();
		
		insert c;
		
		Test.stopTest();
		
		c = [Select Id, Case_Owner_Assigned__c from Case where Id = :c.Id];
		System.Assert(c.Case_Owner_Assigned__c);
	}
	
	static testMethod void TestForAtRiskRequest()
	{
        TestLibrary.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.STANDARD_USER_PROFILE);
        insert u;
		
		Account a = TestLibrary.CreateAccount('Test Account', u.Id);  
		insert a;
		
		Case c = TestLibrary.createCase('Test', a.Id);
		c.Type = 'At Risk Request';
		
		Test.startTest();
		
		insert c;
		
		Test.stopTest();
		
		c = [Select Id, Case_Owner_Assigned__c from Case where Id = :c.Id];
		System.Assert(c.Case_Owner_Assigned__c);
	}
	
	static testMethod void TestConsultRequestMichelle()
	{
        TestLibrary.InitAvaTax();
		
		List<User> usersList = TestLibrary.createUsers('Test', TestLibrary.STANDARD_USER_PROFILE, 4);
        usersList[1].FirstName = 'Michelle';
		usersList[1].LastName = 'Dziuban';
		usersList[2].FirstName = 'James';
		usersList[2].LastName = 'Hart';
		usersList[3].FirstName = 'Jennifer';
		usersList[3].LastName = 'Torrens';
		insert usersList;
		
		Account a = TestLibrary.CreateAccount('Test Account', usersList[0].Id);  
		insert a;
		
		Case c = TestLibrary.createCase('Test', a.Id);
		c.Type = 'Consult Request';
		c.State_Province__c = 'AL';
		
		Test.startTest();
		
		insert c;
		
		Test.stopTest();
		
		c = [Select Id, OwnerId, Owner.Name from Case where Id = :c.Id];
		System.debug('Case Owner = ' + c.OwnerId + ' Michelle Id = ' + usersList[1].Id);
		//System.Assert(c.Owner.Name == usersList[1].Name);
	}
	
	static testMethod void TestConsultRequestJames()
	{
        TestLibrary.InitAvaTax();
		
		List<User> usersList = TestLibrary.createUsers('Test', TestLibrary.STANDARD_USER_PROFILE, 4);
        usersList[1].FirstName = 'Kate';
		usersList[1].LastName = 'Woodward';
		usersList[2].FirstName = 'James';
		usersList[2].LastName = 'Hart';
		usersList[3].FirstName = 'Jennifer';
		usersList[3].LastName = 'Torrens';
		insert usersList;
		
		Account a = TestLibrary.CreateAccount('Test Account', usersList[0].Id);  
		insert a;
		
		Case c = TestLibrary.createCase('Test', a.Id);
		c.Type = 'Consult Request';
		c.State_Province__c = 'AL';
		
		Test.startTest();
		
		insert c;
		
		Test.stopTest();
		
		c = [Select Id, OwnerId, Owner.Name from Case where Id = :c.Id];
		System.Assert(c.Owner.Name == usersList[2].Name);
	}
	
	static testMethod void TestConsultRequestJennifer()
	{
        TestLibrary.InitAvaTax();
		
		List<User> usersList = TestLibrary.createUsers('Test', TestLibrary.STANDARD_USER_PROFILE, 4);
        usersList[1].FirstName = 'Kate';
		usersList[1].LastName = 'Woodward';
		usersList[2].FirstName = 'James';
		usersList[2].LastName = 'Hart';
		usersList[3].FirstName = 'Jennifer';
		usersList[3].LastName = 'Torrens';
		insert usersList;
		
		Account a = TestLibrary.CreateAccount('Test Account', usersList[0].Id);  
		insert a;
		
		Case c = TestLibrary.createCase('Test', a.Id);
		c.Type = 'Consult Request';
		c.State_Province__c = 'AK';
		
		Test.startTest();
		
		insert c;
		
		Test.stopTest();
		
		c = [Select Id, OwnerId, Owner.Name from Case where Id = :c.Id];
		//System.Assert(c.Owner.Name == usersList[3].Name);
	}
	
	static testMethod void TestConsultRequestRoundRobin()
	{
        TestLibrary.InitAvaTax();
		
		List<User> usersList = TestLibrary.createUsers('Test', TestLibrary.STANDARD_USER_PROFILE, 4);
        usersList[1].FirstName = 'Kate';
		usersList[1].LastName = 'Woodward';
		usersList[2].FirstName = 'James';
		usersList[2].LastName = 'Hart';
		usersList[3].FirstName = 'Jennifer';
		usersList[3].LastName = 'Torrens';
		insert usersList;
		
		Account a = TestLibrary.CreateAccount('Test Account', usersList[0].Id);  
		insert a;
		
		Case c = TestLibrary.createCase('Test', a.Id);
		c.Type = 'Consult Request';
		c.State_Province__c = 'AA';
		
		Test.startTest();
		
		insert c;
		
		Test.stopTest();
		
		c = [Select Id, Case_Owner_Assigned__c from Case where Id = :c.Id];
		System.Assert(c.Case_Owner_Assigned__c);
	}
}