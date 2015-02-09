public with sharing class OpportunityUpdateExtension
{
	public Opportunity opp;
	
	public OpportunityUpdateExtension( ApexPages.StandardController stdController )
	{
	    opp = ( Opportunity )stdController.getRecord();       
    }

	public void SetPrimaryContactForQuote()
	{
		OpportunityUpdateExtension.SetPrimaryContactForQuoteFuture(opp.Id);
	}

	@future
	public static void SetPrimaryContactForQuoteFuture( Id oppId )
	{
		// Get the Primary OCR record for this Opportunity
		System.debug('############# oppId = ' + oppId);
		
		OpportunityContactRole[] ocr = [Select Id, contactId from OpportunityContactRole where OpportunityId = :oppId and IsPrimary = true];
		
		System.debug('############# ocr = ' + ocr);
		
		if (ocr.size() > 0)
		{
			// Get a list of Quotes that belong to this Opp
			List<SBQQ__Quote__c> quoteList = [Select Id, SBQQ__PrimaryContact__c from SBQQ__Quote__c where SBQQ__Opportunity__c = :oppId];
		
            if (quoteList != null)
            {
				for (SBQQ__Quote__c q : quoteList)
				{
					q.SBQQ__PrimaryContact__c = ocr[0].ContactId;
				}
            }
			
			update quoteList;
		}
	}
}