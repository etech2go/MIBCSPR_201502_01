public with sharing class replaceProductHelper {
	
	public static Map<Id,Contract> contractMap = new Map<Id,Contract>();
	
	public static Map<Id,Contract> processReplaceProduct(Id currentProduct, Id replaceProductId, Id replacePricebookId){
		
		Set<Id> opIds = new Set<Id>();
		List<OpportunityLineItem> OLIresults = new List<OpportunityLineItem>();
	 	
	 	List<Opportunity> oppList = [Select Id From Opportunity Where isClosed= false AND Type = 'Renewal' AND pricebook2id = :replacePricebookId];
	 	
	 	if(!oppList.isEmpty()){
	 		for(Opportunity o : oppList){
	 			opIds.add(o.Id);
	 		}
	 	}
	 	
	 	List<Contract> contractList = [Select Id, SBQQ__Opportunity__c, SBQQ__RenewalOpportunity__c, SBQQ__RenewalPricebookId__c from Contract 
                                                  WHERE SBQQ__RenewalOpportunity__c IN :opIds];
        
        if(!contractList.isEmpty()){
        	for(Contract c : contractList){
        		contractMap.put(c.SBQQ__RenewalOpportunity__c,c);
        	}
        }
        
        return contractMap;
	}

}