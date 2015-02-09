@isTest
private with sharing class TestBatchRenewalTotals
{
	static testMethod void TestBatchRenewalTotals()
	{
		TestingUtils.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test1', TestLibrary.NEW_BIZ_PROFILE);
        insert u;
		        
		Account a = TestLibrary.CreateAccount('Test Account', u.Id);  
       	insert a;
		
		Contact c = TestLibrary.CreateContact('Test', 'Test@cisionus.com', u.Id, a.Id);
		insert c;
		
		Opportunity o = TestLibrary.CreateOpportunity('Test', u.Id, a.Id);
		insert o;
		
	  	List<OpportunityLineItem> olList = TestLibrary.CreateOpportunityLineItems('Test Product','CRT', o.Id, 1, 'Connect Services', 'Professional','Social Newsroom');
        insert olList;
		
		Product2 p = [Select Id from Product2 where Name = 'Test Product'];
		
		/*SBQQ__Quote__c q = TestLibrary.CreateQuote(a.Id, o.Id);
		insert q;
				
		SBQQ__QuoteLine__c quoteLine = TestLibrary.createQuoteLine(q.Id, p.Id);
		insert quoteLine;
				
		Contract cont = TestingUtils.createContract(a.Id, o.Id);
		cont.SBQQ__RenewalOpportunity__c = o.Id;
		cont.SBQQ__Quote__c = q.Id;
		insert cont;
					
		SBQQ__Subscription__c sub = TestingUtils.createSubscription(a.Id, cont.Id, p.Id);
		sub.SBQQ__QuoteLine__c = quoteLine.Id;
		insert sub;
		//System.debug('Product = ' + sub.SBQQ__Product__c + ' Product Family = ' + sub.Product_Family__c + ' Com Product = ' + sub.Commissionable_Product__c + ' Opp Type = ' + sub.Opp_Type__c);
		
		Asset ass1 = TestingUtils.createAsset(a.Id, p.Id);
		ass1.SBQQ__QuoteLine__c = quoteLine.Id;
		insert ass1;*/
				
		Test.startTest();
		
		Database.executeBatch(new batchRenewalTotals(), 1);
		
		Test.stopTest();
		
	}
	
	
	

	
}