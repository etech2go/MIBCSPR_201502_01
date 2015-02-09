public with sharing class OpportunityAlertExtension{
	public Boolean DisplayPopUp {get; set;}
	public Opportunity opp {get; set;}
	public Account acct {get; set;}
	public String AlertMessage {get;set;}
	public OpportunityAlertExtension(ApexPages.StandardController controller) 
    {
		 // Get the Account Record
		String oppId = ApexPages.currentPage().getParameters().get('oid');
		//System.debug('oppId=' + oppId);
		
		if(oppId != null)
		{
			opp = [select Id, Name, Type, AccountId, RecordType.Name from Opportunity where Id = :oppId];
		}
		else
		{
			opp = (Opportunity)controller.getRecord();							
			opp = [select Id, Name, Type, AccountId, RecordType.Name from Opportunity where Id = :opp.Id];
		}	
				
		System.debug('opp=' + opp);
		if(opp.RecordType.Name == 'Transactional Broadcast')
		{
			AlertMessage = 'You can not route any Opps for this Account until the credit hold issue has been resolved. Do NOT create a new Account to bypass the Credit Hold.';	
		}
		else
		{
			AlertMessage = 'If you submit a quote for this Opp prior to it being taken off credit hold, Accounting will have to approve the quote before you can send out the DocuSign contract to the client.  Do NOT create a new Account to bypass the Credit Hold.';
		}
		
		if(opp !=null)	
			acct =  [select Id, Name, Type, CisionPoint_ID__c, AR_Rep__c, Credit_Hold__c, GP_Cust_ID__c from Account where Id = :opp.AccountId]; 			            		
	}

}