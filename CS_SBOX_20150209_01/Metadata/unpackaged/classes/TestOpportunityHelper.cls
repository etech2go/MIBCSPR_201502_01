@isTest
private class TestOpportunityHelper {
     
	static testMethod void TestUpdateInvoiceDetails()
	{
		TestLibrary.InitAvaTax();
    
		User u = TestLibrary.createUser('Testuser', TestLibrary.BROADCAST_TRANSACTION_PROFILE);
		insert u;
        
		Account acc = TestLibrary.CreateAccount('Test Account', u.Id);  
    
		insert acc;       
      
		Opportunity newOpp = TestLibrary.CreateOpportunity('TestOp', u.Id, acc.Id);
		newOpp.RecordTYpeId = TestLibrary.OPPORTUNITY_NEW_BIZ_RECORD_TYPE;
		newOpp.Opportunity_Status__c = '';
    
		Opportunity op2 = TestLibrary.CreateOpportunity('TestOp2', u.Id, acc.Id);
		op2.RecordTYpeId = TestLibrary.OPPORTUNITY_NEW_BIZ_RECORD_TYPE;
    
      
		List<Opportunity> opList = new List<Opportunity>();
		opList.add(newOpp);
		opList.add(op2);
      
		insert opList;
      
		Test.startTest();
    
		newOpp.Opportunity_Status__c = 'Pending Fulfillment'; 
		update newOpp;
            
		op2.Invoice_Contact_Email__c = 'jill@email.com';
		op2.Invoice_Contact_Name__c = 'Jill';
            
		try{
			update op2;
			//System.assert(false);
		}
		catch(exception e){
			//
		}
            
		Test.stopTest();
            
		Opportunity result = [Select Id,Opportunity_Status__c,Account.Required_Invoice_Contact_Name__c, Account.Required_Invoice_Contact_Email__c,Invoice_Contact_Email__c,Invoice_Contact_Name__c From Opportunity Where id=:newOpp.Id];      
                   
		//       system.assert(result.Opportunity_Status__c == 'Pending Fulfillment');
		System.debug('Opp Contact Email = ' + result.Invoice_Contact_Email__c + ' acc Contact Email = ' + result.Account.Required_Invoice_Contact_Email__c);
		//       system.assertEquals(result.Invoice_Contact_Email__c, result.Account.Required_Invoice_Contact_Email__c);
		//       system.assertEquals(result.Invoice_Contact_Name__c,result.Account.Required_Invoice_Contact_Name__c);         
      
	}
    
 
	static testMethod void TestCompleteRenewal(){
		TestLibrary.InitAvaTax();
          
		User u = TestLibrary.createUser('Testuser', TestLibrary.BROADCAST_TRANSACTION_PROFILE);
		insert u;
        
		System.runAs(u)
		{
		Account acc = TestLibrary.CreateAccount('Test Account', u.Id); 
          
		insert acc;      
                 
		Opportunity op = TestLibrary.CreateOpportunity('TestOp', u.Id, acc.Id);
		op.RecordTYpeId = TestLibrary.OPPORTUNITY_RENEWALS_RECORD_TYPE;
		op.Type = 'Renewal'; 
		op.At_Risk__c = 'Yes';  
		op.Renewal_Due_Date__c = Date.today().addDays(30);
		insert op;
            
		Contract c = TestingUtils.createContract(acc.Id, op.Id);
		insert c;
            
		List<OpportunityLineItem> olList = TestLibrary.CreateOpportunityLineItems('Test Product', 'CRT', op.Id, 1, 'Monitoring Services', 'Professional', 'Social Newsroom');
		insert olList;
          
		Test.startTest();
		op.Renewal_Completed__c = false;  
            
		List<Opportunity> opList = new List<Opportunity>();
		opList.add(op);
		opportunityHelper.CompleteRenewal(opList);
		update opList;
            
		Test.stopTest();
            
		op = [Select Id, Renewal_Completed__c,New_Renewal_Customer__c,Last_Year_Spend__c from Opportunity where Id = :op.Id];
		//  system.assertEquals(op.New_Renewal_Customer__c,false);   
		//  system.assertEquals(op.Renewal_Completed__c,true);   
            
	}    
		}
  
	static testMethod void TestAssignRetentionOwner(){
		TestLibrary.InitAvaTax();
          
		User u = TestLibrary.createUser('Testuser', TestLibrary.BROADCAST_TRANSACTION_PROFILE);
		insert u;
        
		System.runAs(u)
		{
		Account acc = TestLibrary.CreateAccount('Test Account', u.Id); 
          
		insert acc;      
                 
		Opportunity op = TestLibrary.CreateOpportunity('TestOp', u.Id, acc.Id);
		insert op;
            
		Contract c = TestingUtils.createContract(acc.Id, op.Id);
		insert c;
            
		Product2 p = TestLibrary.createProduct('Ld Test Product', 'ld01', 'Distribution Services');
            
		List<OpportunityLineItem> olList = TestLibrary.CreateOpportunityLineItems(p.ProductCode, op.Id, 1);
		insert olList;
          
		List<Opportunity> opList = new List<Opportunity>();
		opList.add(op);
          
		Test.startTest();
		OpportunityHelper.AssignRetentionOwner(opList);
		Test.stopTest();
            
		// op = [Select Id, Renewal_Rep_Assigned__c from Opportunity where Id = :op.Id];
		// system.assert(op.Renewal_Rep_Assigned__c == false);
            
	}  
		}
  
	static testMethod void TestCreateRenewalActivities()
	{
		TestLibrary.InitAvaTax();
         
		// Create all the BDC Records
		List<BDC_Activity_Type__c> atList = new List<BDC_Activity_Type__C>();
		atList.add(new BDC_Activity_Type__c(Name = 'BDC 6 Month Call', Call_Template__c = 'Test', Days_Months__c = 'Months', From__c = 'Renewal Due Date', New_Renewal_Customer__c = false, Number_of_Days_Months__c = 1));
		insert atList;
	  
		User u = TestLibrary.createUser('Testuser', TestLibrary.BROADCAST_TRANSACTION_PROFILE);
		insert u;
        
		System.runAs(u)
		{
		Account acc = TestLibrary.CreateAccount('Test Account', u.Id); 
         
		insert acc;      
                 
		Opportunity op = TestLibrary.CreateOpportunity('TestOp', u.Id, acc.Id);
		op.Type = 'Renewal';
		op.Renewal_Completed__c = true;
		op.Renewal_Due_Date__c = Date.today().addDays(30);
		op.New_Renewal_Customer__c = false;
		op.Renewal_Tasks_Completed__c = false;
		insert op;
            
		Contract c = TestingUtils.createContract(acc.Id, op.Id);
		insert c;
            
		Product2 p = TestLibrary.createProduct('Ld Test Product', 'ld01', 'Distribution Services');
            
		List<OpportunityLineItem> olList = TestLibrary.CreateOpportunityLineItems(p.ProductCode, op.Id, 1);
		insert olList;
          
		List<Opportunity> opList = new List<Opportunity>();
		opList.add(op);
          
		Test.startTest();
		OpportunityHelper.CreateRenewalActivities(opList);
		//  update opList;
		Test.stopTest();
            
		//Task t = [Select Id,Status,Priority,WhatId From Task Where WhatId = :op.Id limit 1];
		//op = [Select Id, Renewal_Tasks_Completed__c from Opportunity where Id = :op.Id];
		//system.assertEquals(t.WhatId,op.id);
		//system.assert(op.Renewal_Tasks_Completed__c == false);
            
	}  
		}
 
    
	static testMethod void TestUpdateContactIfShippingDetailsChange(){
		TestLibrary.InitAvaTax();
          
		User u = TestLibrary.createUser('Testuser', TestLibrary.BROADCAST_TRANSACTION_PROFILE);
		insert u;
        
		System.runAs(u)
		{
		Account acc = TestLibrary.CreateAccount('Test Account', u.Id); 
          
		insert acc;      
                 
		Opportunity op = TestLibrary.CreateOpportunity('TestOp', u.Id, acc.Id);
		insert op;
            
		op.Change_Shipping_Email__c = 'jackjill@email.com';
		op.Change_Shipping_First_Name__c = 'Jack';
		op.Change_Shipping_Last_Name__c = 'Jill';
		op.Change_Shipping_Phone__c = '1231231234';
           
		Test.startTest();
		update op;
		Test.stopTest();
            
		Contact c = [Select Firstname,Lastname From Contact Where Firstname = 'Jack' And Lastname = 'Jill' Limit 1];
		system.assert(c != null);
            
	}
		}
    
	static testMethod void TestCreateTrainingCases(){
      
		TestLibrary.InitAvaTax();
          
		User u = TestLibrary.createUser('Testuser', TestLibrary.SYSTEM_ADMIN_USER_PROFILE);
		insert u;
        
		System.runAs(u)
		{
		Account acc = TestLibrary.CreateAccount('Test Account', u.Id); 
          
		insert acc;      
                 
		Opportunity op = TestLibrary.CreateOpportunity('TestOp', u.Id, acc.Id);
		op.RecordTYpeId = TestLibrary.OPPORTUNITY_RENEWALS_RECORD_TYPE;
		op.At_Risk__c = 'Yes';  
		op.Type = 'Renewal'; 
		op.Renewal_Due_Date__c = Date.today().addDays(30);
		insert op;
            
		Opportunity op2 = TestLibrary.CreateOpportunity('TestOp2', u.Id, acc.Id);
		op2.RecordTYpeId = TestLibrary.OPPORTUNITY_NEW_BIZ_RECORD_TYPE;
		insert op2;
            
		List<OpportunityLineItem> olList = TestLibrary.CreateOpportunityLineItems('Test Product ld02', 'ld002', op2.Id, 1, 'Plan Services', 'Enterprise', '');
		insert olList;
            
		Opportunity op3 = TestLibrary.CreateOpportunity('TestOp3', u.Id, acc.Id);
		op3.RecordTYpeId = TestLibrary.OPPORTUNITY_NEW_BIZ_RECORD_TYPE;
		insert op3;
            
		List<OpportunityLineItem> olList2 = TestLibrary.CreateOpportunityLineItems('Test Product ld03', 'RESTRAININGHALFDAY', op3.Id, 1, 'Packages', 'Basic', '');
		insert olList2;
              
                                             
		Test.startTest();
              
		op.Training_At_Risk_Case_Created__c = false;
		update op; 
            
		op2.Training_At_Risk_Case_Created__c = false;
		op2.StageName = 'Closed Won';
		op2.Close_Reasons_del__c = 'Price';
		op2.Competitor_Name__c = 'Vocus';
		op2.Up_Against__c = 'GoogleNews';
		update op2;
            
		op3.Training_At_Risk_Case_Created__c = false;
		op3.StageName = 'Closed Won';
		op3.Close_Reasons_del__c = 'Price';
		op3.Competitor_Name__c = 'Vocus';
		op3.Up_Against__c = 'GoogleNews';
		update op3;
            
		List<Opportunity> opList = new List<Opportunity>();
		opList.add(op);
		opList.add(op2);
		opList.add(op3);
		OpportunityHelper.CreateTrainingCases(opList);
		update opList;
		Test.stopTest();
            
		Case c = [Select Opportunity_Type__c, Opportunity_Owner__c, State_Province__c, AccountId From Case Where Subject = 'At Risk Training' And Type = 'At Risk Request' limit 1];
		op = [Select Id, type, OwnerId, Shipping_State__c, AccountId,Training_At_Risk_Case_Created__c From Opportunity Where id = :op.Id];
		system.assertEquals(c.Opportunity_Type__c, op.Type);
		system.assertEquals(c.Opportunity_Owner__c, op.OwnerId);
		system.assertEquals(c.State_Province__c, op.Shipping_State__c);
		system.assertEquals(c.AccountId, op.AccountId);
            
            /*Case c2 = [Select Opportunity_Type__c, Opportunity_Owner__c, State_Province__c, AccountId From Case Where Subject = 'Consult Training' And Type='Consult Request' limit 1];
            op2 = [Select Id, type, OwnerId, Shipping_State__c, AccountId,Training_At_Risk_Case_Created__c From Opportunity Where id = :op2.Id];
            system.assertEquals(c2.Opportunity_Type__c, op2.Type);
            system.assertEquals(c2.Opportunity_Owner__c, op2.OwnerId);
            system.assertEquals(c2.State_Province__c, op2.Shipping_State__c);
            system.assertEquals(c2.AccountId, op2.AccountId);
            
            Case c3 = [Select Opportunity_Type__c, Opportunity_Owner__c, State_Province__c, AccountId From Case Where Subject = 'On-Site Training' And Type='On-Site Request' limit 1];
            op3 = [Select Id, type, OwnerId, Shipping_State__c, AccountId,Training_At_Risk_Case_Created__c From Opportunity Where id = :op3.Id];
            system.assertEquals(c3.Opportunity_Type__c, op3.Type);
            system.assertEquals(c3.Opportunity_Owner__c, op3.OwnerId);
            system.assertEquals(c3.State_Province__c, op3.Shipping_State__c);
            system.assertEquals(c3.AccountId, op3.AccountId);*/

	} 
        
		}
        
	static testMethod void TestCreateClientServicesCases(){
		TestLibrary.InitAvaTax();
          
		User u = TestLibrary.createUser('Testuser', TestLibrary.SYSTEM_ADMIN_USER_PROFILE);
		insert u;
        
		System.runAs(u)
		{
		Account acc = TestLibrary.CreateAccount('Test Account', u.Id); 
          
		insert acc;      
                      
		Opportunity op = TestLibrary.CreateOpportunity('TestOp1', u.Id, acc.Id);
		op.RecordTYpeId = TestLibrary.OPPORTUNITY_NEW_BIZ_RECORD_TYPE;
		insert op;
            
		List<OpportunityLineItem> olList = TestLibrary.CreateOpportunityLineItems('Test Product CCSA', 'CCSA', op.Id, 1, 'Monitoring Services', 'Basic', '');
		insert olList;
            
		Opportunity op2 = TestLibrary.CreateOpportunity('TestOp2', u.Id, acc.Id);
		op2.RecordTYpeId = TestLibrary.OPPORTUNITY_RENEWALS_RECORD_TYPE;
		op2.At_Risk__c = 'Yes';  
		op2.Type = 'Renewal'; 
		op2.Renewal_Due_Date__c = Date.today().addDays(30);
		//insert op2;
            
		List<OpportunityLineItem> olList2 = TestLibrary.CreateOpportunityLineItems('Test Product CCSA2 unfiltered', 'CCSA2', op2.Id, 1, 'Monitoring Services', 'Basic', '');
		//insert olList2;
            
		Opportunity op3 = TestLibrary.CreateOpportunity('TestOp3', u.Id, acc.Id);
		op3.RecordTYpeId = TestLibrary.OPPORTUNITY_RENEWALS_RECORD_TYPE;
		op3.At_Risk__c = 'Yes';  
		op3.Type = 'Renewal'; 
		op3.Renewal_Due_Date__c = Date.today().addDays(30);
		//insert op3;
            
		List<OpportunityLineItem> olList3 = TestLibrary.CreateOpportunityLineItems('Test Product CCSA3', 'CCSA3', op3.Id, 1, 'Broadcast Services', 'Professional', 'Social Newsroom');
		//insert olList3;
                                                
		Test.startTest();
		op.Client_Services_Tasks_Created__c = false;
		op.StageName = 'Closed Won';
		op.Close_Reasons_del__c = 'Price';
		op.Competitor_Name__c = 'Vocus';
		op.Up_Against__c = 'GoogleNews';
		update op;
            
		op2.Client_Services_Tasks_Created__c = false;
		op2.StageName = 'Closed Won';
		op2.Close_Reasons_del__c = 'Price';
		op2.Competitor_Name__c = 'Vocus';
		op2.Up_Against__c = 'Universal';
		//update op2;
              
		op3.Client_Services_Tasks_Created__c = false;
		op3.StageName = 'Closed Won';
		op3.Close_Reasons_del__c = 'Price';
		op3.Competitor_Name__c = 'Vocus';
		op3.Up_Against__c = 'Meltwater';
		//update op3;
            
		List<Opportunity> oppList = new List<Opportunity>();
		oppList.add(op);
		//oppList.add(op2);
		//oppList.add(op3);
		OpportunityHelper.CreateClientServicesCases(oppList);
		update oppList;
		Test.stopTest();
            
            /*Case c = [Select Id From Case Where Subject  like 'New Small Business Outreach%'];
            op = [Select Id, Client_Services_Tasks_Created__c From Opportunity Where id = :op.Id];
            system.assertEquals(t.Status, 'Not Started');
            system.assertEquals(t.Priority, 'Normal');
            system.assertEquals(t.WhatId,op.id);
            system.assert(op.Client_Services_Tasks_Created__c == true);
            
            Task t2 = [Select Id,Status,Priority,WhatId From Task Where Subject  like 'Verification Call%' and whatId = :op2.Id limit 1];
            op2 = [Select Id, Client_Services_Tasks_Created__c From Opportunity Where id = :op2.Id];
            system.assertEquals(t2.Status, 'Not Started');
            system.assertEquals(t2.Priority, 'Normal');
            system.assertEquals(t2.WhatId,op2.id);
        
            Task t3 = [Select Id,Status,Priority,WhatId From Task Where Subject  like 'PitchEngine Setup%' and whatId = :op3.Id limit 1];
            op3 = [Select Id, Client_Services_Tasks_Created__c From Opportunity Where id = :op3.Id];
            system.assertEquals(t3.Status, 'Not Started');
            system.assertEquals(t3.Priority, 'Normal');
            system.assertEquals(t3.WhatId,op3.id);*/
	}
		}
   
	static testMethod void TestCreateCreditRiskAssessmentCase(){
		TestLibrary.InitAvaTax();
          
		User u = TestLibrary.createUser('Testuser', TestLibrary.BROADCAST_TRANSACTION_PROFILE);
		insert u;
        
		System.runAs(u)
		{
		Account acc = TestLibrary.CreateAccount('Test Account', u.Id); 
		insert acc;      
                 
		Opportunity op = TestLibrary.CreateOpportunity('TestOp1', u.Id, acc.Id);
		op.RecordTYpeId = TestLibrary.OPPORTUNITY_NEW_BIZ_RECORD_TYPE;
		insert op;
            
		List<OpportunityLineItem> olList = TestLibrary.CreateOpportunityLineItems('Test Product CCSA', 'CCSA', op.Id, 1, 'Monitoring Services', 'Basic', '');
		insert olList;
                        
		Test.startTest();
              
		op = [Select Id, Credit_Risk_Case_Created__c, Number_of_Products__c, CA_Rep__c, GP_Cust_ID__c, AccountId, Sub_Account__c from Opportunity where Id = :op.Id];
		List<Opportunity> oppList = new List<Opportunity>();
		oppList.add(op);
		OpportunityHelper.CreateCreditRiskAssessmentCase(oppList);
		update op;
		Test.stopTest();
    
		///Case c = [Select Opportunity__c, AccountId From Case Where Opportunity__c =:op.Id limit 1];
		//op = [Select Id, AccountId, Credit_Risk_Case_Created__c from Opportunity where id=:op.id];
		//system.assertEquals(c.Opportunity__c, op.id);
		//system.assertEquals(c.AccountId, op.AccountId);
		//system.assert(op.Credit_Risk_Case_Created__c == true);
	}
		}
  
	static testMethod void TestProcessOpportunities()
	{
		TestingUtils.InitAvaTax();
		
		Account acc = TestingUtils.CreateAccount();  
		insert acc;	   	
	   	
		Opportunity newOpp = TestingUtils.createOpportunity(acc.Id);
		newOpp.Type = 'New';
		insert newOpp;
		
		List<OpportunityLineItem> olList = TestLibrary.CreateOpportunityLineItems('Test Product CCSA', 'CCSA', newOpp.Id, 1, 'Monitoring Services', 'Basic', '');
		insert olList;
		
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = newOpp.Id, SBQQ__Type__c = 'Quote');
		insert quote;
		
		SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quote.Id);
		insert quoteLine;
		
		Contract cont = TestingUtils.createContract(acc.Id, newOpp.Id);
		cont.SBQQ__RenewalOpportunity__c = newOpp.Id;
		cont.SBQQ__Quote__c = quote.Id;
		insert cont;
		
		Product2 connectProd = TestingUtils.createProduct(false);
		connectProd.Family = 'Connect Services';
		connectProd.ProductCode = 'Connect1';
		connectProd.Commissionable_Product__c = true;
		insert connectProd;
		Product2 broadcastProd = TestingUtils.createProduct(false);
		broadcastProd.Family = 'Broadcast Services';
		broadcastProd.ProductCode = 'Broadcast1';
		insert broadcastProd;
		
		SBQQ__Subscription__c sub = TestingUtils.createSubscription(acc.Id, cont.Id, connectProd.Id);
		sub.SBQQ__QuoteLine__c = quoteLine.Id;
		//		insert sub;
		//		System.debug('Product = ' + sub.SBQQ__Product__c + ' Product Family = ' + sub.Product_Family__c + ' Com Product = ' + sub.Commissionable_Product__c + ' Opp Type = ' + sub.Opp_Type__c);
		
		Asset ass1 = TestingUtils.createAsset(acc.Id, connectProd.Id);
		ass1.SBQQ__QuoteLine__c = quoteLine.Id;
		insert ass1;
		Asset ass2 = TestingUtils.createAsset(acc.Id, connectProd.Id);
		ass2.SBQQ__QuoteLine__c = quoteLine.Id;
		insert ass2;
		
		Test.startTest();
		
		Database.executeBatch(new batchProcessOpportunities(), 1);
		
		Test.stopTest();
	}
	
	static testMethod void TestProcessRenewalOpps()
	{
		TestingUtils.InitAvaTax();
		Account acc = TestingUtils.CreateAccount();  
		insert acc;	   	
		   	
		Opportunity newOpp = TestingUtils.createOpportunity(acc.Id);
		newOpp.Type = 'Renewal';
		insert newOpp;
			
		List<OpportunityLineItem> olList = TestLibrary.CreateOpportunityLineItems('Test Product CCSA', 'CCSA', newOpp.Id, 1, 'Plan Services', 'Basic', 'Basic Database');
		insert olList;
			
		SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
			SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', SBQQ__Opportunity__c = newOpp.Id, SBQQ__Type__c = 'Quote');
		insert quote;
			
		SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quote.Id);
		insert quoteLine;
			
		Contract cont = TestingUtils.createContract(acc.Id, newOpp.Id);
		cont.SBQQ__RenewalOpportunity__c = newOpp.Id;
		cont.SBQQ__Quote__c = quote.Id;
		insert cont;
			
		Product2 connectProd = TestingUtils.createProduct(false);
		connectProd.Family = 'Connect Services';
		connectProd.ProductCode = 'Connect1';
		connectProd.Commissionable_Product__c = true;
		insert connectProd;
		Product2 broadcastProd = TestingUtils.createProduct(false);
		broadcastProd.Family = 'Broadcast Services';
		broadcastProd.ProductCode = 'Broadcast1';
		insert broadcastProd;
			
		SBQQ__Subscription__c sub = TestingUtils.createSubscription(acc.Id, cont.Id, connectProd.Id);
		sub.SBQQ__QuoteLine__c = quoteLine.Id;
		//		insert sub;
		//		System.debug('Product = ' + sub.SBQQ__Product__c + ' Product Family = ' + sub.Product_Family__c + ' Com Product = ' + sub.Commissionable_Product__c + ' Opp Type = ' + sub.Opp_Type__c);
			
		Asset ass1 = TestingUtils.createAsset(acc.Id, connectProd.Id);
		ass1.SBQQ__QuoteLine__c = quoteLine.Id;
		insert ass1;
		Asset ass2 = TestingUtils.createAsset(acc.Id, connectProd.Id);
		ass2.SBQQ__QuoteLine__c = quoteLine.Id;
		insert ass2;
			
		Test.startTest();
			
		Database.executeBatch(new batchProcessRenewalOpps(), 1);
			
		Test.stopTest();
		
	}
}