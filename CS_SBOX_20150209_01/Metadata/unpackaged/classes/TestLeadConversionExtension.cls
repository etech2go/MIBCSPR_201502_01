@isTest //(SeeAllData=true)
private class TestLeadConversionExtension
{
	static testMethod void ConvertLeadNewTest()
	{
		TestingUtils.InitAvaTax();
		Account a = TestingUtils.CreateAccount();           
		insert a;
		Opportunity opp = TestingUtils.createOpportunity(a.Id);
		opp.StageName = 'Open';
		opp.Shipping_Address__c = '123 Test';
		opp.Shipping_City__c = 'Chicago';
		opp.Shipping_Country__c = 'USA';
		opp.Shipping_Zip__c = '12345';
        insert opp;				
		List<Contact> contacts = TestingUtils.createContacts(1, a.Id, false);        
        Contact cont = contacts.get(0);
		insert cont;
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(opp.Id, cont.Id);
		List<Task> tasks = TestingUtils.createTasks(1, false);
		Task t = tasks.get(0);
		t.WhoId = cont.Id;
		t.WhatId = opp.Id;
		insert t;
		Test.startTest();
				
		PageReference pageRef = Page.LeadConversion;
		pageRef.GetParameters().put('tid', t.Id);        		
		Test.setCurrentPage(pageRef); 
		
		ApexPages.StandardController controller = new ApexPages.StandardController(t); 
        LeadConversionExtension extension = new LeadConversionExtension(controller);
		
		extension.LeadConversionType = 'New';
		extension.ConvertLead();
		
		Test.stopTest();	
	}
	
	static testMethod void ConvertLeadUpdateTest()
	{
		TestingUtils.InitAvaTax();
		Account a = TestingUtils.CreateAccount();           
		insert a;
		Opportunity opp = TestingUtils.createOpportunity(a.Id);
		opp.StageName = 'Open';
        insert opp;				
		List<Contact> contacts = TestingUtils.createContacts(1, a.Id, false);        
        Contact cont = contacts.get(0);
		insert cont;
		OpportunityContactRole ocr = TestingUtils.createOpportunityContactRole(opp.Id, cont.Id);
		List<Task> tasks = TestingUtils.createTasks(1, false);
		Task t = tasks.get(0);
		t.WhoId = cont.Id;
		t.WhatId = opp.Id;
		insert t;
		Test.startTest();
				
		PageReference pageRef = Page.LeadConversion;
		pageRef.GetParameters().put('tid', t.Id);        		
		Test.setCurrentPage(pageRef); 
		
		ApexPages.StandardController controller = new ApexPages.StandardController(t); 
        LeadConversionExtension extension = new LeadConversionExtension(controller);
		
		extension.LeadConversionType = opp.Id;
		extension.ConvertLead();
		
		Test.stopTest();	
	}
	
}