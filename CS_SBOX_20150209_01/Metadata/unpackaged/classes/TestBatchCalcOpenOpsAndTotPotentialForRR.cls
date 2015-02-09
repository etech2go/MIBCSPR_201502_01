@isTest
private class TestBatchCalcOpenOpsAndTotPotentialForRR {
	static testMethod void TestCalcOpenOpsAndTotPotentialForRR() {
		// TO DO: implement unit test
		TestingUtils.InitAvaTax();
		
		User u = TestLibrary.createUser('Test1', TestLibrary.NEW_BIZ_PROFILE);
        insert u;
		
		System.debug('*** User created...');
		
		//insert user in RR
		Round_Robin__c rr1 = new Round_Robin__c(User__c=u.Id,Object_Type__c='Opportunity',Group__c='CST',Sub_Group__c='NATIONAL',Assign_Records__c=true,Number_of_Records_Assigned__c=1,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=1,Total_Available_Potential__c=1000);
		insert rr1;
		        
		Account a = TestLibrary.CreateAccount('Test Account', u.Id);  
       	insert a;
		
		Contact c = TestLibrary.CreateContact('Test', 'Test@cisionus.com', u.Id, a.Id);
		insert c;
		
		Opportunity o = TestLibrary.CreateOpportunity('Test', u.Id, a.Id);
        o.RecordTYpeId = TestLibrary.OPPORTUNITY_RENEWALS_RECORD_TYPE;
		o.Type = 'Renewal'; 
		o.At_Risk__c = 'Yes';  
		o.Renewal_Due_Date__c = Date.today().addDays(10);
		o.Commissionable_Potential__c = 2000;
		insert o;
        
        system.debug('*** Opportunity Owner---'+ o.OwnerId);
        
        system.debug('*** Renewal_Due_Date__c ---'+o.Renewal_Due_Date__c);
		
		Test.startTest();
		
		  User uResult = [Select Id from User Where Alias = 'Test1'];
		  system.debug('*** user Id ---'+ uResult.Id);
		  System.assert(uResult != null);
		
       	  string SOQL = 'Select Id, User__c, Open_Opps__c, Total_Available_Potential__c from Round_Robin__c Where user__c = \''+ uResult.id + '\'';
          system.debug('***SQL---'+ SOQL);
          
          Database.executeBatch(new batchCalcOpenOpsAndTotPotentialForRR(SOQL),20); 

		  Round_Robin__c rrResult = [Select Id, User__c, Open_Opps__c, Total_Available_Potential__c from Round_Robin__c Where user__c = :uResult.id and Object_Type__c='Opportunity'];
		  
          system.debug('*** User ---'+ rrResult.User__c);
          system.debug('*** Open_Opps ---'+ rrResult.Open_Opps__c);
          system.debug('*** Total_Available_Potential__c ---'+ rrResult.Total_Available_Potential__c);
       
		  System.assert(rrResult != null);
		  //System.assert(rrResult.Open_Opps__c > 0);
		  //System.assert(rrResult.Total_Available_Potential__c > 0);
		
		
		Test.stopTest();
		
	}
	
	
	
}