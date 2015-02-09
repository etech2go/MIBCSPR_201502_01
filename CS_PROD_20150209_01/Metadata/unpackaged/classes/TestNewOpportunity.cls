@isTest
private class TestNewOpportunity
{
	static testMethod void TestNewOpportunity() 
    {
		TestLibrary.InitAvaTax();
    
      	User u = TestLibrary.createUser ('Testuser', TestLibrary.BROADCAST_TRANSACTION_PROFILE);
        insert u;
        
    	Account acc = TestLibrary.CreateAccount('Test Account', u.Id);  
        acc.Required_Invoice_Contact_Name__c = 'Jitter Bit';
        acc.Required_Invoice_Contact_Email__c = 'jbit@email.com';
    	insert acc;
		     		
        Opportunity newOpp = TestLibrary.CreateOpportunity('TestOp', u.Id, acc.Id);
        newOpp.RecordTYpeId = TestLibrary.OPPORTUNITY_NEW_BIZ_RECORD_TYPE;
	    insert newOpp;
        
		Test.startTest();   
      		ApexPages.StandardController stdController = new ApexPages.StandardController(newOpp);
      		NewOpportunityController tst = new NewOpportunityController(stdController);
      		tst.getNewOppPage();  
      	Test.stopTest();
    }
}