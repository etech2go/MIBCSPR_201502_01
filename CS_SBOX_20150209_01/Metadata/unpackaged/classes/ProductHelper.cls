public with sharing class ProductHelper
{
	public static void CheckProductExistence(List<Product2> products)
	{
		Set<String> productCodes = new Set<String>();
		for (Product2 p: products)
		{
			productCodes.add(p.ProductCode);
		}
		
		List<Product2> pList = [Select Id, ProductCode from Product2 where ProductCode IN :productCodes and Id not in :products];
		Map<String, Product2> pMap = new Map<String, Product2>();
		if (pList != null)
		{
			for (Product2 p : pList)
			{
				pMap.put(p.ProductCode, p);
			}
		}
		
		for (Product2 p : products)
		{
			Product2 dupeProd = pMap.get(p.ProductCode);
			
			if(dupeProd != null)
			{				
				p.ProductCode.addError('Product Code already exists');
				break;
			}
		}
	}
	
	public static void SetCommissionableProduct(List<Product2> products)
	{
		// Get all Opp Line items that are linked to any of these products
		List<OpportunityLineItem> liList = [Select Id, Commissionable_Product__c, PricebookEntry.Product2Id from OpportunityLineItem where PricebookEntry.Product2Id in :products];
		Map<Id, List<OpportunityLineItem>> liMap = new Map<Id, List<OpportunityLineItem>>();
		for (OpportunityLineItem li : liList)
		{
			if (liMap.containsKey(li.PricebookEntry.Product2Id))
			{
				liMap.get(li.PricebookEntry.Product2Id).add(li);
			}
			else
			{
				List<OpportunityLineItem> tempList = new List<OpportunityLineItem>();
				tempList.add(li);
				liMap.put(li.PricebookEntry.Product2Id, tempList);
			}
		}
		
		List<OpportunityLineItem> lineItemsToUpdate = new List<OpportunityLineItem>();
		
		for (Product2 p : products)
		{
			List<OpportunityLineItem> lineItems = liMap.get(p.Id);
						
			if (lineItems != null)
			{
				for (OpportunityLineItem li : lineItems)
				{
					if (li.Commissionable_Product__c != p.Commissionable_Product__c)
					{
						li.Commissionable_Product__c = p.Commissionable_Product__c;
					
						if (lineItemsToUpdate.size() < 1000)
						{
							lineItemsToUpdate.add(li);
						}
						else
						{
							update lineItemsToUpdate;
							lineItemsToUpdate.clear();
						}
					}
				}
				
				if (lineItemsToUpdate.size() > 0)
				{
					update lineItemsToUpdate;
				}
			}
		}
		
		update liList;
	}
}