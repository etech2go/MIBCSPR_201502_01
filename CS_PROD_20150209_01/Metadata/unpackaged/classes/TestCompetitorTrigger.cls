@isTest
private class TestCompetitorTrigger
{
	static testMethod void CompetitorTriggerTest()
	{
		TestLibrary.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.STANDARD_USER_PROFILE);
        insert u;
		
		Account acc = TestLibrary.CreateAccount('Test Account', u.Id);  
		insert acc;
		
		Opportunity opp = TestLibrary.CreateOpportunity('Test', u.Id, acc.Id);   	
	   	opp.Invoice_Contact_Name__c = 'Mark';
    	opp.Invoice_Contact_Email__c = 'mark.doggett@cision.com';
    	opp.Redo_Item_s__c = false;
    	insert opp;
		
		Test.startTest();
		
		Competitor__c comp = new Competitor__c(Account__c = acc.Id, Opportunity__c = opp.Id, Competitive_Spend__c = 10000, Competitor_Name__c = 'Biz360');
		insert comp;
		delete comp;
		
		comp = new Competitor__c(Account__c = acc.Id, Opportunity__c = opp.Id, Competitive_Spend__c = 10000, Service_Provided__c = 'Plan;Connect');
		insert comp;
		
		Test.stopTest();
		
		List<Competitor__c> compList = [Select Id from Competitor__c];
		System.debug('Competitor Size == ' + compList.size());
		System.Assert(compList.size() == 1);
	}
}