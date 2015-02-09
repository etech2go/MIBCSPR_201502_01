@isTest //(SeeAllData=true)
private class TestOpportunityAlertExtension 
{
	static testMethod void OpportunityAlertTest() 
    {
        TestingUtils.InitAvaTax();
        Account a = TestingUtils.CreateAccount();           
        insert a;           
        
		Opportunity opp = TestingUtils.createOpportunity(a.Id);
		opp.StageName = 'Open';
        insert opp;
		
        Test.startTest();
                
        PageReference pageRef = Page.OpportunityAlert;        
        //pageRef.GetParameters().put('aid', a.Id); 
		pageRef.GetParameters().put('oid', opp.Id); 
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(opp); 
        OpportunityAlertExtension extension = new OpportunityAlertExtension(controller);                               
        
        Test.stopTest();    
    }
	
	static testMethod void OpportunityAlertTest2() 
    {
        TestingUtils.InitAvaTax();
        Account a = TestingUtils.CreateAccount();           
        insert a;           
        
		Opportunity opp = TestingUtils.createOpportunity(a.Id);
		opp.StageName = 'Open';
        insert opp;
		
        Test.startTest();
                
        PageReference pageRef = Page.OpportunityAlert;        
		pageRef.GetParameters().put('oid', null); 
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(opp); 
        OpportunityAlertExtension extension = new OpportunityAlertExtension(controller);                               
        
        Test.stopTest();    
    }
}