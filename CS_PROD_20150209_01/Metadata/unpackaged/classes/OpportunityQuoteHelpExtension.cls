public with sharing class OpportunityQuoteHelpExtension
{
	public Opportunity opp {get; set;}  
	public Credit_for_Existing_Services_Quote__c credit {get; set;}  
	public International_Print_Quote__c ipq {get; set;} 
	public Redlining_Request__c rr {get; set;} 
	public SObject obj {get; set;}
	public String HelpOption {get;set;}
	public String HeaderTitle {get; set;}  
	public Boolean showQuoteSection {get; set;} 
	public Boolean showInternationalPrintSection {get; set;}
	public Boolean showRedliningRequest {get; set;}
	public List<Schema.FieldSetMember> CustomFieldSetList {get;set;}
	
	private String oppId {get; set;} 
	private String recordTypeId {get; set;} 
	private String accountId {get; set;} 	
	
	public OpportunityQuoteHelpExtension() //ApexPages.StandardController controller
    {
		oppId = ApexPages.currentPage().getParameters().get('oid');  		
		recordTypeId = ApexPages.currentPage().getParameters().get('rtid');
		accountId = ApexPages.currentPage().getParameters().get('aid');
		System.debug(recordTypeId);
		showInternationalPrintSection = false;
		showQuoteSection = false;
		if(oppId != null)
        {
            opp =  [select Id, Name, OwnerId, AccountId from Opportunity where Id = :oppId];            
        }   
	}	
	
	public PageReference RedirectToPage()
	{
		String supportUrl = '';
		PageReference redirecturl;
		
		if(HelpOption == 'SalesSupport')
		{
			supportUrl = '/apex/CaseSupport' + '?aid=' + accountId + '&oid=' + oppId + '&rtid=' + recordTypeId; 
			redirecturl = new PageReference(supportUrl);						
		}
		else if(HelpOption == 'Credit')
		{
			showQuoteSection = true;
			showInternationalPrintSection = false;
			showRedliningRequest = false;
			HeaderTitle = 'Credit for Existing Services Quote';		
			if(credit == null)		
				credit = new Credit_for_Existing_Services_Quote__c();		
			
			//credit.Opportunity__c = oppId;
		}
		else if(HelpOption == 'International')
		{
			showInternationalPrintSection = true;
			showQuoteSection = false;
			showRedliningRequest = false;
			HeaderTitle = 'International Print Quote';
			if(ipq == null)
				ipq = new International_Print_Quote__c();			
		}	
		/*
		else if(HelpOption == 'Redline')
		{
			showInternationalPrintSection = false;
			showQuoteSection = false;
			showRedliningRequest = true;
			if(rr == null)
				rr = new Redlining_Request__c();			
		}*/
		
		System.debug('showQuoteSection = ' + showQuoteSection);
		System.debug('showInternationalPrintSection = ' + showInternationalPrintSection);
		System.debug('HelpOption = ' + HelpOption);
		
		return redirecturl;
	}
	
	public PageReference Save() 
    { 
		try{
		
			if(HelpOption == 'Credit')
			{
				SaveQuoteInfo();
			}
			else if(HelpOption == 'International')
			{
				SaveInternationalPrintQuote();
			}
			/*else if(HelpOption == 'Redline')
			{
				SaveRedliningRequest();
			}*/
		}
		catch(Exception e)
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage())); 
		}				
		
		return null;
		
	}
	
	private void SaveQuoteInfo()
	{						
		try
		{						
			credit.Opportunity__c = oppId;
			credit.OwnerId = UtilityClass.GetUser('Billing').Id;						
			credit.Status__c = 'New';
			
			System.debug('credit = ' + credit);
			insert credit;		
		}
		catch(DmlException ex)
		{
			ApexPages.addMessages(ex);
		}
		
		if(credit.Id != null)
		{
			Credit_for_Existing_Services_Quote__c cr = [SELECT Id, Name FROM Credit_for_Existing_Services_Quote__c WHERE Id = :credit.Id];
			ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, 'Credit for Existing Services Quote ' + cr.Name + ' has been saved successfully')); 
		}
	}
	
	private void SaveInternationalPrintQuote()
	{
		try
		{
			ipq.Opportunity__c = oppId;
			ipq.Quote_Status__c = 'New';
			RoundRobinHelper rrMHelper = new RoundRobinHelper('Case', 'Monitoring');
			ipq.OwnerId = rrMHelper.GetNextUser(false, false);
			
			insert ipq;
		}
		catch(DmlException ex)
		{
			ApexPages.addMessages(ex);
		}
		
		if(ipq.Id != null)
		{
			International_Print_Quote__c i = [SELECT Id, Name FROM International_Print_Quote__c WHERE Id = :ipq.Id];
			ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, 'International Print Quote ' + i.Name + ' has been saved successfully')); 
		}
	}
	
	/*private void SaveRedliningRequest()
	{			
		try
		{
			rr.Opportunity__c = oppId;
			insert rr;		
			
			if(rr.Id != null)
			{
				Redlining_Request__c redline = [SELECT Id, Name FROM Redlining_Request__c WHERE Id = :rr.Id];
				
				Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
				req.setComments('Redlining Request Submitted for approval. Please approve.');
				req.setObjectId(redline.Id);
				System.debug('Running Approval on OBject Id = ' + redline.Id);
				Approval.ProcessResult result = Approval.process(req);
				System.debug('Submitted for approval successfully: ' + result.isSuccess());	
				
				ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, 'Redlining Request ' + redline.Name + ' has been saved successfully')); 
			}
		}
		catch(DmlException ex)
		{
			ApexPages.addMessages(ex);
		}				
	}		*/
}