global class batchReplacementProduct implements Database.Batchable<sObject>
{
    global final Id currentProduct;
    global final Id ReplaceProduct;
    global final Id ReplacePriceBook;
    global final string Query;
    
    global batchReplacementProduct(Id currProduct, Id RepProduct, Id RepPriceook) 
    {
        currentProduct = currProduct;
        ReplaceProduct = RepProduct;
        ReplacePriceBook = RepPriceook;
      }     
  	
	global Database.QueryLocator start(Database.BatchableContext BC)         
    {
    	Map<Id,Contract> contractMap = replaceProductHelper.processReplaceProduct(currentProduct,ReplaceProduct,ReplacePriceBook);
      	
      	return Database.getQueryLocator([Select OpportunityId, Product2Id, Last_Years_Quantity__c, Last_Years_Sales_Price__c, Quantity, UnitPrice from OpportunityLineItem WHERE OpportunityId 
                                                IN :contractMap.keyset() AND PricebookEntry.Product2Id = :currentProduct]);
     }
     
    global void execute(Database.BatchableContext bc, List<OpportunityLineItem> oliList)
	{
		List<PricebookEntry> pbe = [Select Id, Pricebook2.Id, Pricebook2.Name, Product2Id from PricebookEntry Where Product2Id = :ReplaceProduct And pricebook2Id =:ReplacePriceBook And isactive=true];
        List<OpportunityLineItem> insOliList = new List<OpportunityLineItem>();
       // List<OpportunityLineItem> oliCheck = new List<OpportunityLineItem>();
        
        system.debug('*** CurrentProduct ---:'+ currentProduct);
        system.debug('*** ReplaceProduct ---:'+ ReplaceProduct);
        system.debug('*** ReplacePriceBook ---:'+ ReplacePriceBook);
        system.debug('*** OLI List ----'+ oliList);
        system.debug('*** PBE list --- '+ pbe);
		Set<Id> oliOppIds = new Set<Id>();
		for(OpportunityLineItem oli : oliList){
			oliOppIds.add(oli.OpportunityId);
		}
		
		List<OpportunityLineItem> oliFindList = [Select OpportunityId From OpportunityLineItem Where OpportunityId in :oliOppIds And Product2Id = :ReplaceProduct];
		
		Map<Id,OpportunityLineItem> OLIMap = new Map<Id,OpportunityLineItem>();
        for(OpportunityLineItem oli : oliFindList){
			OLIMap.put(oli.OpportunityId,oli);
		}
           
        if (!pbe.isEmpty()){
            if (!oliList.isEmpty()){
		
		      for (OpportunityLineItem ol : oliList){
		      	  
		 		  OpportunityLineItem oliCheck = OLIMap.get(ol.OpportunityId);
				  
	        	  if (oliCheck == null){
		        	  OpportunityLineItem oli = new OpportunityLineItem();
			       	  oli.OpportunityId = ol.OpportunityId;
			       	  oli.Quantity = ol.Quantity;
			       	  oli.UnitPrice = ol.UnitPrice;
			       	  oli.Last_Years_Quantity__c = ol.Quantity;
			       	  oli.Last_Years_Sales_Price__c = ol.UnitPrice;
			       	  oli.PriceBookEntryId = pbe[0].id;
			       	  insOliList.add(oli);
	        	  }
		        }
            }
         }
	   
	    if (!insOliList.isEmpty()){
	   	  insert insOliList;
	   	  system.debug('**** insOliList' + insOliList);
	   	}
	   	else{
	   		 system.debug('**** NO OLI RECORDS TO INSERT');
	   	}
		
	 }
	
	global void finish(Database.BatchableContext bc) {} 

}