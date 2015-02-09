@isTest (seeAllData = true)
private class TestOpportunityPrintViewExtension
{
	static testMethod void TestPrintViewExtension()
	{
		List<Account> accounts = TestingUtils.createAccounts(1, true);
        
        Opportunity opp = TestingUtils.createOpportunity(accounts[0].Id);
        insert opp;
	    Prepaid_Clip_Package__c clipPackage = TestingUtils.createClipPackage(accounts[0].Id, TestingUtils.ADMIN_USER.Id, 'DVD Clip', true);
        Broadcast_Item__c broadcastItem = TestingUtils.createBroadcastItem(opp.Id,clipPackage.Id, true);
		
		PageReference pageRef = Page.OpportunityPrintView;
		pageRef.GetParameters().put('id', opp.Id);
		Test.setCurrentPage(pageRef); 
		ApexPages.StandardController controller = new ApexPages.StandardController(opp); 
        OpportunityPrintViewExtension extension = new OpportunityPrintViewExtension(controller);
	}
}