@isTest (seeAllData = true) 
public with sharing class TestPrepaidClipPackageServices
{
	
    static testMethod void testUpdateBroadcastItems()
    {
    	Account acc = new Account();
    	acc.Name = 'Test';
	    acc.BillingStreet = '123 Main St';
		acc.BillingCity = 'Chicago';
		acc.BillingState = 'IL';
		acc.BillingPostalCode = '60603';
    	acc.BillingCountry = 'USA';
	   	insert acc;	   	
	   	
	   	Opportunity opp = TestingUtils.createOpportunity(acc.Id);
    	opp.Invoice_Contact_Name__c = 'John';
    	opp.Invoice_Contact_Email__c = 'john@email.com';
    	insert opp;
    	
    	Prepaid_Clip_Package__c cp = TestingUtils.createClipPackage(opp.AccountId, TestingUtils.ADMIN_USER.Id, 'DVD Clip', false );
    	cp.No_Clip_Package__c = false;
    	insert cp;
    	
        Broadcast_Item__c bItem = TestingUtils.createBroadcastItem(opp.Id, cp.Id, false);
        bItem.Update_From_Parent__c = false;
        insert bItem;
        
        //Update No_Clip_Package__c should update Update_From_Parent__c
    	cp.No_Clip_Package__c = true;
        Test.startTest();
        update cp;
        Test.stopTest();
        
        bItem = [Select Id, Update_From_Parent__c
        			From Broadcast_Item__c
        			Where Id = :bItem.Id];
       	
       	System.assertEquals(true, bItem.Update_From_Parent__c); 			
    }
}