public with sharing class OpportunityToInvoiceController {
	
	 private string oppId;
	 private Opportunity o;
	 
	 public OpportunityToInvoiceController(ApexPages.StandardController controller) {        
        o = (Opportunity)controller.getRecord();
        oppId = o.Id;
    }
    
    public PageReference createInvoice() {
    	OpportunityToInvoice opp2inv = new OpportunityToInvoice(oppId);
    	fw1__Invoice__c invoice = opp2inv.createInvoice();
    	if (invoice != null){
	    	PageReference invPage = new ApexPages.StandardController(invoice).view();
	      invPage.setRedirect(true);
	      return invPage;
    	} else {
    		PageReference oppPage = new ApexPages.StandardController(o).view();
        oppPage.setRedirect(true);
        return oppPage;
    	}
    }

}