@isTest
private class TestAccountTrigger
{
    static testMethod void TestRenewalRep()
    {
		TestLibrary.InitAvaTax();
		
        User u = TestLibrary.createUser ('Test', TestLibrary.BROADCAST_TRANSACTION_PROFILE);
        insert u;
        
		System.runAs(u)
		{
        	Account a = TestLibrary.CreateAccount('Test Account', u.Id);  
        	a.Renewal_Rep__c = u.Id;       
			
			
       	 	Test.startTest();
        	insert a;
			update a;
        	Test.stopTest();
			       				
			// Check that the Last Touch Date was updated
			a = [Select Id, OwnerId, Renewal_Rep__c, Broadcast_Last_Touched_Date__c, Broadcast_Rep__c from Account where Id = :a.Id];
			//System.assert(a.OwnerId == a.Renewal_Rep__c);
			//System.assert(a.Broadcast_Last_Touched_Date__c == Date.today());
			//System.assert(a.Broadcast_Rep__c == u.Id);
		}
    }
	
	static testMethod void TestNewBizRep()
    {
		TestLibrary.InitAvaTax();
		
        User u = TestLibrary.createUser ('Test', TestLibrary.NEW_BIZ_PROFILE);
        insert u;
        
		System.runAs(u)
		{
        	Account a = TestLibrary.CreateAccount('Test Account', u.Id);  
        	a.New_Biz_Rep__c = u.Id;       
        
		
			Test.startTest();
        	insert a;
        	Test.stopTest();
		      
			a = [Select Id, OwnerId, New_Biz_Rep__c, New_Biz_Last_Touched_Date__c from Account where Id = :a.Id];
        	//System.assert(a.OwnerId == a.New_Biz_Rep__c);
			//System.assert(a.New_Biz_Last_Touched_Date__c == Date.today());
			//System.assert(a.New_Biz_Rep__c == u.Id);
    	}
	}
	
	static testMethod void TestExternalLastTouchedDate()
    {
		TestLibrary.InitAvaTax();
		
        User u1 = TestLibrary.createUser ('Test1', TestLibrary.NEW_BIZ_PROFILE);
        insert u1;
		User u2 = TestLibrary.createUser ('Test2', TestLibrary.BROADCAST_TRANSACTION_PROFILE);
        insert u2;
        
		Account a1 = TestLibrary.CreateAccount('Test Account 1', u1.Id);  
       	a1.New_Biz_Rep__c = u1.Id;     
		Account a2 = TestLibrary.CreateAccount('Test Account 2', u2.Id);  
       	a2.Renewal_Rep__c = u2.Id;     

		Test.startTest();
		
			insert a1;
			insert a2;
		
			List<Id> accIds = new List<Id>();
			accIds.add(a1.Id);
			accIds.add(a2.Id);
		
			System.runAs(u1)
			{
				AccountHelper.UpdateSalesLastTouchedDate(accIds);
			}
			
			System.runAs(u2)
			{
				AccountHelper.UpdateSalesLastTouchedDate(accIds);
			}
		
		Test.stopTest();
		
		a1 = [Select Id, OwnerId, New_Biz_Rep__c, New_Biz_Last_Touched_Date__c, Renewal_Rep__c, Broadcast_Last_Touched_Date__c, Broadcast_Rep__c from Account where Id = :a1.Id];
        //System.assert(a1.OwnerId == a1.New_Biz_Rep__c);
		//System.assert(a1.New_Biz_Last_Touched_Date__c == Date.today());
		//System.assert(a1.New_Biz_Rep__c == u1.Id);
			
		a2 = [Select Id, OwnerId, New_Biz_Rep__c, New_Biz_Last_Touched_Date__c, Renewal_Rep__c, Broadcast_Last_Touched_Date__c, Broadcast_Rep__c from Account where Id = :a2.Id];
       // System.assert(a2.OwnerId == a2.Renewal_Rep__c);
		//System.assert(a2.Broadcast_Last_Touched_Date__c == Date.today());
		//System.assert(a2.Broadcast_Rep__c == u2.Id);
    }
   
	static testMethod void TestReturnAccountIdFromId()
	{
		TestLibrary.InitAvaTax();
		
        User u = TestLibrary.createUser ('Test1', TestLibrary.NEW_BIZ_PROFILE);
        insert u;
		        
		Account a = TestLibrary.CreateAccount('Test Account', u.Id);  
       	insert a;
		
		Contact c = TestLibrary.CreateContact('Test', 'Test@cisionus.com', u.Id, a.Id);
		insert c;
		
		Opportunity o = TestLibrary.CreateOpportunity('Test', u.Id, a.Id);
		insert o;
		
		SBQQ__Quote__c q = TestLibrary.CreateQuote(a.Id, o.Id);
		insert q;
		
		Test.startTest();
			
			Id userAccountId = AccountHelper.ReturnAccountIdFromId(u.Id);
			Id accountId = AccountHelper.ReturnAccountIdFromId(a.Id);
			Id contactAccountId = AccountHelper.ReturnAccountIdFromId(c.Id);
			Id OppAccountId = AccountHelper.ReturnAccountIdFromId(o.Id);
			Id quoteAccountId = AccountHelper.ReturnAccountIdFromId(q.Id);
		
		Test.stopTest();
		
		/*System.assert(userAccountId == null);
		System.assert(accountId == a.Id);
		System.assert(contactAccountId == c.AccountId);
		System.assert(OppAccountId == o.AccountId);
		System.assert(quoteAccountId == q.SBQQ__Account__c);*/
	}
}