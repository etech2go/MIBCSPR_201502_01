@isTest //(SeeAllData=true)
private class TestAccountAlertExtension 
{
    static testMethod void AccountAlertTest() 
    {
        TestingUtils.InitAvaTax();
        Account a = TestingUtils.CreateAccount();           
        insert a;           
        
        Test.startTest();
                
        PageReference pageRef = Page.AccountAlert;        
        pageRef.GetParameters().put('aid', a.Id);        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(a); 
        AccountAlertExtension extension = new AccountAlertExtension(controller);                               
        
        Test.stopTest();    
    }
	
	static testMethod void AccountAlertTest2() 
    {
        TestingUtils.InitAvaTax();
        Account a = TestingUtils.CreateAccount();           
        insert a;           
        
        Test.startTest();
                
        PageReference pageRef = Page.AccountAlert;        
        pageRef.GetParameters().put('aid', null);        
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(a); 
        AccountAlertExtension extension = new AccountAlertExtension(controller);                               
        
        Test.stopTest();    
    }
}