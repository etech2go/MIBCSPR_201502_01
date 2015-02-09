@isTest
private class TestContactTrigger 
{
	static testMethod void ContactTriggerTest() 
	{
		TestLibrary.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.STANDARD_USER_PROFILE);
        insert u;
		
		Account a = TestLibrary.CreateAccount('Test Account', u.Id);  
		a.Renewal_Rep__c = null;
		insert a;
		
		User u2 = TestLibrary.createUser ('Test2', TestLibrary.BROADCAST_TRANSACTION_PROFILE);
		insert u2;
		
      	System.runAs(u2)
		{
			// The following code runs as user u2. 
			System.debug('Current User: ' + UserInfo.getUserName());
			System.debug('Current Profile: ' + UserInfo.getProfileId()); 
				 
		    Contact cont = TestLibrary.CreateContact('Test', 'Test@cisionus.com', u2.Id, a.Id);        
            cont.Description = cont.Description + ' ' + 'hospital renew';            
            			
			Test.startTest();
			
			insert cont;
			
            cont.Email = 'Test2@Test.com';
            
			update cont;
			
			System.debug(a.Sales_Last_Touched_Date__c);
			
			Test.stopTest();
			
			List<Contact> contList = [Select Id from Contact];
			System.Assert(contList.size() == 1);
		 }
		
		
	}
}