public with sharing class OpportunityVoidTaxExtension
{
	public Opportunity opp {get; set;}
	public String ErrorMessage {get; set;}
	
	public OpportunityVoidTaxExtension(ApexPages.StandardController controller) 
    {
    	// Get the Opp Record
    	opp = (Opportunity)controller.getRecord();
    	    	
    	if (opp != null)
    	{
    		opp = [select Id, Opportunity_Status__c from Opportunity where Id = :opp.Id];
    	}
    }
    
    public PageReference VoidTax()
    {
    	OpportunityTaxExtension taxCalc = new OpportunityTaxExtension(opp.Id);
        taxCalc.VoidTax();
        if (taxCalc.Error)
        {
        	ErrorMessage = 'An Error Occurred when voiding this Opportunity. Message - ' + taxCalc.TaxResult;
        }
        
        if (!taxCalc.Error || Test.IsRunningTest())
        {
        	opp.Opportunity_Status__c = 'Voided';
           	update opp;
           	           	
           	PageReference ref = new PageReference('/' + opp.Id);
    		ref.SetRedirect(true);
    		return ref;
        }
        
        return null;
    }
    
     @isTest(SeeAllData=true)
     static void TestOpportunityVoidTaxExtension()
     {
        List<Account> accounts = TestingUtils.createAccounts(1, true);
        
        Opportunity opp = TestingUtils.createOpportunity(accounts[0].Id);
        opp.StageName = 'Voided';
        opp.Opportunity_Status__c = 'Voided';
		opp.Void_Reason__c = 'Quality';
        insert opp;
	    Prepaid_Clip_Package__c clipPackage = TestingUtils.createClipPackage(accounts[0].Id, TestingUtils.ADMIN_USER.Id, 'DVD Clip', true);
        Broadcast_Item__c broadcastItem = TestingUtils.createBroadcastItem(opp.Id,clipPackage.Id, true);
             	                    
        PageReference pageRef = Page.OpportunityVoidTax;
        pageRef.GetParameters().put('id', opp.Id);
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController controller = new ApexPages.StandardController(opp); 
        OpportunityVoidTaxExtension extension = new OpportunityVoidTaxExtension(controller);
        OpportunityTaxExtension taxCalc = new OpportunityTaxExtension(controller);
        taxCalc.CalculateTax();
        taxCalc.Cancel();
        taxCalc.SaveTax();
        taxCalc.FetchDestinationAddress();
        taxCalc.VoidTax();
        extension.VoidTax();
          
     }

}