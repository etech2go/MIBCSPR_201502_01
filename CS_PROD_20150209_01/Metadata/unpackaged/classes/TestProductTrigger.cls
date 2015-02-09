@isTest
private class TestProductTrigger 
{
	static testMethod void TestDuplicateProduct() 
	{
		Product2 p = TestLibrary.CreateProduct('Test', 'Code', 'Family');
		
		Test.startTest();
		
		insert p;				
		update p;
		
		Product2 p2 = TestLibrary.CreateProduct('Test', 'Code', 'Family');
		
		try 
		{
			insert p2;
		} catch (DmlException e) { }
			
		Test.stopTest();
		
		List<Product2> prodList = [Select Id from Product2 where Name = 'Test'];
		System.Assert(prodList.size() == 1);
		
	}
	
	static testMethod void TestCommissionProduct() 
	{
		TestLibrary.InitAvaTax();
		
		Product2 p = TestLibrary.CreateProduct('Test', 'Code', 'Family');
		p.Commissionable_Product__c = true;
		insert p;
		
		User u = TestLibrary.createUser ('Testuser', TestLibrary.BROADCAST_TRANSACTION_PROFILE);
        insert u;
		Account acc = TestLibrary.CreateAccount('Test Account', u.Id); 
        insert acc;   
		Opportunity opp = TestLibrary.CreateOpportunity('TestOp', u.Id, acc.Id);
		insert opp;
		List<OpportunityLineItem> olList = TestLibrary.CreateOpportunityLineItems(p.Id, opp.Id, 1);
        insert olList;
		
		Test.startTest();
			update p;
		Test.stopTest();
		
		List<OpportunityLineItem> liList = [Select Id, Commissionable_Product__c, PricebookEntry.Product2Id from OpportunityLineItem];

		System.Assert(liList[0].Commissionable_Product__c == True);
	}
		
}