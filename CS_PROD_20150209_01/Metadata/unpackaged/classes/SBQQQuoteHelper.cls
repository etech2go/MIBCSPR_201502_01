public with sharing class SBQQQuoteHelper
{
	public static void UpdateQuoteLines(List<SBQQ__Quote__c> quotesList)
	{
		List<SBQQ__QuoteLine__c> quoteLinesList = [Select Id, SBQQ__Quote__c, Original_Quote__c, Opportunity__c, SBQQ__Quote__r.SBQQ__MasterContract__r.SBQQ__Quote__c from SBQQ__QuoteLine__c where SBQQ__Quote__c in :quotesList];
		Map<Id, List<SBQQ__QuoteLine__c>> quoteLinesMap = new Map<Id, List<SBQQ__QuoteLine__c>>();
		for (SBQQ__QuoteLine__c ql : quoteLinesList)
		{
			if (quoteLinesMap.containsKey(ql.SBQQ__Quote__c))
			{
				quoteLinesMap.get(ql.SBQQ__Quote__c).add(ql);
			}
			else
			{
				List<SBQQ__QuoteLine__c> tempList = new List<SBQQ__QuoteLine__c>();
				tempList.add(ql);
				quoteLinesMap.put(ql.SBQQ__Quote__c, tempList);
			}
		}
		
		for (SBQQ__Quote__c q : quotesList)
		{
			// Get the associated Quote Lines
			List<SBQQ__QuoteLine__c> qlList = quoteLinesMap.get(q.Id);
			
			if (qlList != null)
			{
				List<SBQQ__QuoteLine__c> linesToUpdate = new List<SBQQ__QuoteLine__c>();
				Boolean needsUpdate = false;
				
				for (SBQQ__QuoteLine__c ql : qlList)
				{
					if (ql.Opportunity__c != q.SBQQ__Opportunity__c)
					{
						ql.Opportunity__c = q.SBQQ__Opportunity__c;
						needsUpdate = true;
					}
					
					if (ql.SBQQ__Quote__c != null && ql.SBQQ__Quote__r.SBQQ__MasterContract__c != null && ql.Original_Quote__c != ql.SBQQ__Quote__r.SBQQ__MasterContract__r.SBQQ__Quote__c)
					{
						ql.Original_Quote__c = ql.SBQQ__Quote__r.SBQQ__MasterContract__r.SBQQ__Quote__c;
						needsUpdate = true;
					}
					
					if (needsUpdate)
					{
						linesToUpdate.add(ql);
					}
				}
				
				update linesToUpdate;
			}
		}
	}
	
	public static void AreAccountsDifferent(List<SBQQ__Quote__c> quotesList)
	{
		// Check if the Account against the Master Contract and the Acocunt Directly related to the Quote are different
		Set<Id> contractIds = new Set<Id>();
		for (SBQQ__Quote__c q : quotesList)
		{
			if (q.SBQQ__MasterContract__c != null)
			{
				contractIds.add(q.SBQQ__MasterContract__c);
			}
		}
			
		Map<Id, Contract> masterContractMap = new Map<Id, Contract>([Select Id, AccountId from Contract where Id in :contractIds]);
		
		for (SBQQ__Quote__c q : quotesList)
		{
			if (q.SBQQ__MasterContract__c != null)
			{
				Contract c = masterContractMap.get(q.SBQQ__MasterContract__c);
			
				if (c != null)
				{
					if (c.AccountId != q.SBQQ__Account__c)
					{
						q.addError('The Master Contract on this Quote does not belong to the Account on this Quote.  Please choose a different Master Contract.');
					}
				}
			}
		}
	}
	
	
	
}