public with sharing class SBQQQuoteLineHelper
{	
		
	public static void AssignLastYearsSalesPriceToQuoteLine(List<SBQQ__QuoteLine__c> quoteLines)
	{
		Set<Id> oppIds = new Set<Id>();
		Set<Id> productIds = new Set<Id>();
		Set<Id> quoteIds = new Set<Id>();
		
		for (SBQQ__QuoteLine__c line : quoteLines)
		{
			if (line.SBQQ__Quote__c != null)
			{
				quoteIds.add(line.SBQQ__Quote__c);
			}
			
			if (line.SBQQ__Product__c != null)
			{
				productIds.add(line.SBQQ__Product__c);
			}
		}
			
		List<SBQQ__Quote__c> quoteList = [Select Id, SBQQ__Opportunity__c from SBQQ__Quote__c where Id in :quoteIds];
		for (SBQQ__Quote__c q : quoteList)
		{
			if (q.SBQQ__Opportunity__c != null)
			{
				oppIds.add(q.SBQQ__Opportunity__c);
			}
		}
		
		Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>([Select Id, (Select Id, ListPrice, ProductCode, Last_Years_Sales_Price__c, Last_Years_Quantity__c from OpportunityLineItems) from Opportunity where Id in :oppIds]);
		Map<Id, product2> productMap = new Map<Id, product2>([Select Id, ProductCode from Product2 where Id in :productIds]);
						
		for (SBQQ__QuoteLine__c line : quoteLines)
		{
			System.debug('########################IN Quote LINE');
			Opportunity opp = opportunityMap.get(line.Opportunity__c);
			Product2 p = productMap.get(line.SBQQ__Product__c);
			
			if (opp != null)
			{
				line.Opportunity__c = opp.Id;	
			}
			
			if (opp != null && p != null && opp.OpportunityLineItems != null)
			{
				System.debug('########################Got Opp');
				for (OpportunityLineItem oppLineItem : opp.OpportunityLineItems)
				{
					if (oppLineItem.ProductCode == p.ProductCode)
					{
						System.debug('########################Found Line Item');
						line.Last_Years_Sales_Price__c = oppLineItem.Last_Years_Sales_Price__c;
						line.Last_Years_Quantity__c = oppLineItem.Last_Years_Quantity__c;
						line.SBQQ__Quantity__c = oppLineItem.Quantity;
						System.debug('#####################################Last Years SP = ' + line.Last_Years_Sales_Price__c);
						System.debug('#####################################Last Years SP = ' + line.Last_Years_Quantity__c);
						System.debug('#####################################Uplift = ' + line.Price_With_Uplift__c);
						break;
					}
				}
			}
		}
	}
}