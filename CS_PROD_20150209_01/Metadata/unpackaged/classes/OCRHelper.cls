public with sharing class OCRHelper
{
	public static List<SObject> objectsToUpdate = new List<SObject>();
	
	public static void SetPrimaryContactForQuote(List<OpportunityContactRole> ocrList)
	{
		Set<Id> oppIds = new Set<Id>();
		for (OpportunityContactRole ocr : ocrList)
		{
			if (ocr.IsPrimary)
			{
				oppIds.add(ocr.OpportunityId);
			}
		}
		
		List<SBQQ__Quote__c> quoteList = [Select Id, SBQQ__PrimaryContact__c, SBQQ__Opportunity__c from SBQQ__Quote__c where SBQQ__Opportunity__c in :oppIds];
		Map<Id, List<SBQQ__Quote__c>> quoteMap = new Map<Id, List<SBQQ__Quote__c>>();
		for (SBQQ__Quote__c q : quoteList)
		{
			if (quoteMap.containsKey(q.SBQQ__Opportunity__c))
			{
				quoteMap.get(q.SBQQ__Opportunity__c).add(q);
			}
			else
			{
				List<SBQQ__Quote__c> tempList = new List<SBQQ__Quote__c>();
				tempList.add(q);
				quoteMap.put(q.SBQQ__Opportunity__c, tempList);
			}
		}
				
		for (OpportunityContactRole ocr : ocrList)
		{
			if (ocr.IsPrimary)
			{
				// Get all quotes linked to the Opp of this OCR
				List<SBQQ__Quote__c> qList = quoteMap.get(ocr.OpportunityId);
				
				if (qList != null)
				{
					for (SBQQ__Quote__c q : qList)
					{
						q.SBQQ__PrimaryContact__c = ocr.ContactId;
						objectsToUpdate.add(q);
					}
				}
			}
		}
	}
}