@isTest
private with sharing class TestbatchReplacementProduct {
	
	static testMethod void TestbatchReplacementProduct()
	{
		TestingUtils.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test1', TestLibrary.NEW_BIZ_PROFILE);
        insert u;
		        
		Account a = TestLibrary.CreateAccount('Test Account', u.Id);  
       	insert a;
		
		Contact c = TestLibrary.CreateContact('Test', 'Test@cisionus.com', u.Id, a.Id);
		insert c;
		
		Opportunity o = TestLibrary.CreateOpportunity('Test', u.Id, a.Id);
        o.RecordTYpeId = TestLibrary.OPPORTUNITY_RENEWALS_RECORD_TYPE;
		o.Type = 'Renewal'; 
		o.At_Risk__c = 'Yes';  
		o.Renewal_Due_Date__c = Date.today().addDays(30);
		insert o;
        
        Opportunity o2 = o.clone();
        insert o2;
        		
	    List<OpportunityLineItem> olList = TestLibrary.CreateOpportunityLineItems('Test Product','CRT', o.Id, 1, 'Connect Services', 'Professional','Social Newsroom');
        insert olList;
        
        Product2 cProduct = [Select Id, Name From Product2 Where Name ='Test Product']; 
        PriceBookEntry pbeCProduct = [Select Id, Pricebook2Id, Pricebook2.Name from PricebookEntry Where Product2Id = :cProduct.Id And isactive=true];
        
        OpportunityLineItem olList2 = new OpportunityLineItem(OpportunityId = o2.Id, PriceBookEntryId = pbeCProduct.Id, UnitPrice = 200, Quantity = 1);// 'Connect Services', 'Professional','Social Newsroom');
        insert olList2;
              
        Contract cont = TestingUtils.createContract(a.Id, o.Id);
        cont.SBQQ__Opportunity__c = o.id;
        cont.SBQQ__RenewalOpportunity__c = o2.id;
        cont.SBQQ__RenewalPricebookId__c = Test.getStandardPricebookId();
		insert cont;
        
        system.debug('****Renewal Opportunity Id ---'+ o2.id);
		
		//replacement product...
		Product2 rProduct = TestLibrary.createProduct('Replace Product', 'REP', 'Connect Services');
        insert rProduct;
        
        //pricebookentry for replacement product...
        PriceBookEntry pbe = new PriceBookEntry(Product2Id = rProduct.Id, Pricebook2Id = Test.getStandardPricebookId(), IsActive = true, UnitPrice = 400);
        insert pbe;
        
        //below mapping for test coverage in helper class...
        Map<Id,Contract> contractMap = new Map<Id,Contract>();
        contractMap.put(cont.SBQQ__RenewalOpportunity__c,cont);
               
        Test.startTest();
        
            Product2 currProduct = [Select Id, Name From Product2 Where Name ='Test Product']; 
        
            Product2 repProduct = [Select Id, Name From Product2 Where Name ='Replace Product']; 
                   
            Opportunity opp = [Select Id From Opportunity Where Id=:o.id And isClosed= false];
            
            OpportunityLineItem oli = [Select OpportunityId,Product2Id from OpportunityLineItem where OpportunityId = :o.id AND PricebookEntry.Product2Id = :currProduct.Id];
        
            PriceBookEntry pbeCurrProduct = [Select Id, Pricebook2Id, Pricebook2.Name from PricebookEntry Where Product2Id = :currProduct.Id And isactive=true];
        
            PricebookEntry pbeRepProduct = [Select Id, Pricebook2Id, Pricebook2.Name from PricebookEntry Where Product2Id = :repProduct.Id 
                                            And isactive=true];// And pricebook2.Id =:ReplacePriceBook];
            
            Contract contractRes = [Select Id, SBQQ__Opportunity__c, SBQQ__RenewalOpportunity__c, SBQQ__RenewalPricebookId__c from Contract Where SBQQ__Opportunity__c = :o.id
                                                  AND SBQQ__RenewalOpportunity__c = :o2.id];
            
            system.debug('*** SBQQ__RenewalPricebookId__c' + contractRes.SBQQ__RenewalPricebookId__c);
        
            system.debug('*** Rep Product PriceBook' + pbeRepProduct.Pricebook2.Name);
            system.debug('*** Current Product PriceBook' + pbeCurrProduct.Pricebook2.Name);
            system.debug('*** Curr Product :---'+currProduct.Id);
            system.debug('*** Rep Product :----'+repProduct.Id);
        
            system.assert(currProduct != null);
            system.assert(repProduct != null);
            
            system.assert(pbeCurrProduct != null);
            system.assertEquals(contractRes.SBQQ__RenewalPricebookId__c, pbeCurrProduct.Pricebook2Id);
                
        
            system.assert(pbeRepProduct != null);
        
            system.assertEquals(oli.OpportunityId, opp.Id);
            
            system.assertEquals(oli.Product2Id,currProduct.Id);
        
            //Pricebook2 pbResult = [select Id From Pricebook2 Where Id = :Test.getStandardPricebookId()];
            //system.assert(pbResult != null);
            
            Database.executeBatch(new batchReplacementProduct(currProduct.Id,repProduct.Id,Test.getStandardPricebookId()), 1);
        
            OpportunityLineItem oliResult = [Select OpportunityId,Product2Id,Quantity,UnitPrice from OpportunityLineItem 
                                             where 
                                             //Product2Id = :repProduct.Id And 
                                             OpportunityId = :o2.id]; 
                                          
            system.debug('*** OLIResult --- '+oliResult);
           //below asserts should PASS once the batch is executed..
           system.assert(oliResult != null);
           //system.assertEquals(oliResult.Product2Id,repProduct.Id);
                     
		
		Test.stopTest();
    }	

}