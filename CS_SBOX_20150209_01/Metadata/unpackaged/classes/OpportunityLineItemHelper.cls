public class OpportunityLineItemHelper
{
	public static void SetLastYearsSalesPriceonRenewal(List<OpportunityLineItem> lineItemsList)
	{
		System.debug('############################SETTING LAST YEARS SALES PRICE');
		// Generate a map on current and Renewal Opportunities
		Set<Id> oppIds = new Set<Id>();
		Set<Id> productIds = new Set<Id>();
		for (OpportunityLineItem li : lineItemsList)
		{
			oppIds.add(li.OpportunityId);
			productIds.add(li.Product2Id);
		}
		
		List<Contract> contractsList = new List<Contract>([Select Id, SBQQ__Opportunity__c, SBQQ__RenewalOpportunity__c from Contract where SBQQ__RenewalOpportunity__c in :oppIds]);
		Map<Id, Id> oppsConversionMap = new Map<Id, Id>();
		
		Set<Id> origOppIds = new Set<Id>();
		for (Contract c : contractsList)
		{
			if (c.SBQQ__Opportunity__c != null)
			{
				origOppIds.add(c.SBQQ__Opportunity__c);
				
				if (c.SBQQ__RenewalOpportunity__c != null)
				{
					oppsConversionMap.put(c.SBQQ__RenewalOpportunity__c, c.SBQQ__Opportunity__c);
				}
			}
		}
		
		Map<Id, Product2> productMap = new Map<Id, Product2>([Select Id, ProductCode from Product2 where Id in :productIds]);
		Map<Id, Opportunity> oppsMap = new Map<Id, Opportunity>([Select Id, (Select Id, OpportunityId, UnitPrice, ProductCode, Quantity from OpportunityLineItems) from Opportunity where Id in :origOppIds]);
				
		for (OpportunityLineItem li : lineItemsList)
		{
			// Get the Conversion
			Id origOppId = oppsConversionMap.get(li.OpportunityId);
			System.debug('############################CONVERSION ORIG OPP Id = ' + origOppId);
			
			if (origOppId != null)
			{
				Opportunity origOpp = oppsMap.get(origOppId);
				System.debug('############################CONVERSION ORIG OPP RECORD = ' + origOpp);
				System.debug('############################CONVERSION ORIG OPP LINE ITEMS = ' + origOpp.OpportunityLineItems);
				
				if (origOpp != null && origOpp.OpportunityLineItems != null)
				{
					Product2 p = productMap.get(li.Product2Id);
					
					if (p != null)
					{
						for (OpportunityLineItem origLi : origOpp.OpportunityLineItems)
						{
							System.debug('############################ORIG CODE = ' + origLi.ProductCode);
							System.debug('############################RENEWAL CODE  = ' + p.ProductCode);
							// See if we have a match
							if (p.ProductCode == origLi.ProductCode)
							{
								System.debug('############################UPDATING LINE ITEM');
								li.Last_Years_Sales_Price__c = origLi.UnitPrice;
								li.Last_Years_Quantity__c = origLi.Quantity;
								li.Quantity = origLi.Quantity;
								break;
							}
						}
					}
				}
			}
		}
	}

}