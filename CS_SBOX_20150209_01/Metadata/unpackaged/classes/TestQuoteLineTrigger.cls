@isTest
private class TestQuoteLineTrigger
{
	static testmethod void TestAssignOriginalQuote()
	{
		TestLibrary.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.STANDARD_USER_PROFILE);
        insert u;
		
		Account acc = TestLibrary.CreateAccount('Test Account', u.Id);  
		insert acc;
		
		Opportunity opp = TestLibrary.createOpportunity('Test', u.Id, acc.Id);
		insert opp;
				
		SBQQ__Quote__c origQuote = TestLibrary.CreateQuote(acc.Id, opp.Id);
		insert origQuote;
		
		Contract c = new Contract(Status='Draft', StartDate = Date.today(), ContractTerm = 12, AccountId = acc.Id, SBQQ__Opportunity__c = opp.Id, SBQQ__Quote__c = origQuote.Id);
		insert c;
		
		SBQQ__Quote__c quote = TestLibrary.CreateQuote(acc.Id, opp.Id);
		quote.SBQQ__MasterContract__c = c.Id;
		insert quote;
						
		Test.startTest();
		
		System.Debug('Creating quote Line for quote - ' + quote.Id);
		Product2 p = TestLibrary.CreateProduct('Test', 'Test', 'Test');
		insert p;
		SBQQ__QuoteLine__c quoteLine = TestLibrary.createQuoteLine(quote.Id, p.Id);

		insert quoteLine;
		
		System.debug('PERFORMING UPDATE');
		update quoteLine;
				
		Test.stopTest();
		
		quoteLine = [Select Id,Original_Quote__c from SBQQ__QuoteLine__c where Id = :quoteLine.Id ];
		System.debug('quoteLine Orig quote = ' + quoteLine.Original_Quote__c + ' Orin quote = ' + origQuote.Id);
		//System.Assert(quoteLine.Original_Quote__c == origQuote.Id);
		
	}

}