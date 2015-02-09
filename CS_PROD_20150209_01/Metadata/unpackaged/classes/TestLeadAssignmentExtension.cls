@isTest //(SeeAllData=true)
private class TestLeadAssignmentExtension 
{
	static testMethod void AssignLeadNewBizAutoTest()
	{
		TestingUtils.InitAvaTax();
		TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
		Account a = TestingUtils.CreateAccount();           
		insert a;
		
		List<Lead> leads = TestingUtils.createLeads(1,false);        
        Lead l = leads.get(0);
        l.Rating = 'Hot';
		insert l;
		
		List<Contact> contacts = TestingUtils.createContacts(1, a.Id, false);        
        Contact cont = contacts.get(0);
		insert cont;
								
		List<Task> tasks = TestingUtils.createTasks(1, false);
		Task t = tasks.get(0);
		t.WhoId = cont.Id;
		System.debug(a);
		System.debug(l);
		System.debug(cont);
		System.debug(t);
		
		insert t;
        
		Test.startTest();
				
		PageReference pageRef = GetLeadAssignPageRef(null, cont, l);         
		Test.setCurrentPage(pageRef);
		ApexPages.StandardController controller = new ApexPages.StandardController(t); 
        LeadAssignmentExtension extension = new LeadAssignmentExtension(controller);
        extension.ShowHideOwner();
		RunPassLead(extension);		               
        
		Test.stopTest();	
	}
    
    static testMethod void AssignTaskNewBizAutoTest()
	{
		TestingUtils.InitAvaTax();
		TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
    	Account a = TestingUtils.CreateAccount();           
		insert a;			
		
		List<Contact> contacts = TestingUtils.createContacts(1, a.Id, false);        
        Contact cont = contacts.get(0);
		insert cont;
								
		List<Task> tasks = TestingUtils.createTasks(1, false);
		Task t = tasks.get(0);
		t.WhoId = cont.Id;
		
		insert t;   
        
        Test.startTest();
				
		PageReference pageRef = GetLeadAssignPageRef(t, cont, null);         
		Test.setCurrentPage(pageRef);
		ApexPages.StandardController controller = new ApexPages.StandardController(t); 
        LeadAssignmentExtension extension = new LeadAssignmentExtension(controller);
        extension.ShowHideOwner();  
        extension.AssignLead = 'New Biz Auto';
		extension.PassLead();			               
        
		Test.stopTest();	
    }
    
    static testMethod void AssignTaskNewBizManualTest()
	{
		TestingUtils.InitAvaTax();
		TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
    	Account a = TestingUtils.CreateAccount();           
		insert a;			
		
		List<Contact> contacts = TestingUtils.createContacts(1, a.Id, false);        
        Contact cont = contacts.get(0);
		insert cont;
								
		List<Task> tasks = TestingUtils.createTasks(1, false);
		Task t = tasks.get(0);
		t.WhoId = cont.Id;
		
		insert t;   
        
        Test.startTest();
				
		PageReference pageRef = GetLeadAssignPageRef(t, cont, null);         
		Test.setCurrentPage(pageRef);
		ApexPages.StandardController controller = new ApexPages.StandardController(t); 
        LeadAssignmentExtension extension = new LeadAssignmentExtension(controller);
        extension.ShowHideOwner();  
        extension.AssignLead = 'New Biz Manual';
		extension.PassLead();	               
        
		Test.stopTest();	
    }
    
    static testMethod void AssignTaskBroadcastTest()
	{
		TestingUtils.InitAvaTax();
		TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
    	Account a = TestingUtils.CreateAccount();           
		insert a;			
		
		List<Contact> contacts = TestingUtils.createContacts(1, a.Id, false);        
        Contact cont = contacts.get(0);
		insert cont;
								
		List<Task> tasks = TestingUtils.createTasks(1, false);
		Task t = tasks.get(0);
		t.WhoId = cont.Id;
		
		insert t;   
        
        Test.startTest();
				
		PageReference pageRef = GetLeadAssignPageRef(t, cont, null);         
		Test.setCurrentPage(pageRef);
		ApexPages.StandardController controller = new ApexPages.StandardController(t); 
        LeadAssignmentExtension extension = new LeadAssignmentExtension(controller);
        extension.ShowHideOwner();  
        extension.AssignLead = 'Broadcast';
		extension.PassLead();	               
        
		Test.stopTest();	
    }
    
    static testMethod void AssignTaskRenewalsTest()
	{
		TestingUtils.InitAvaTax();
		TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
    	Account a = TestingUtils.CreateAccount();           
		insert a;			
		
		List<Contact> contacts = TestingUtils.createContacts(1, a.Id, false);        
        Contact cont = contacts.get(0);
		insert cont;
								
		List<Task> tasks = TestingUtils.createTasks(1, false);
		Task t = tasks.get(0);
		t.WhoId = cont.Id;
		
		insert t;   
        
        Test.startTest();
				
		PageReference pageRef = GetLeadAssignPageRef(t, cont, null);         
		Test.setCurrentPage(pageRef);
		ApexPages.StandardController controller = new ApexPages.StandardController(t); 
        LeadAssignmentExtension extension = new LeadAssignmentExtension(controller);
        extension.ShowHideOwner();  
        extension.AssignLead = 'Renewals';
		extension.PassLead();	               
        
		Test.stopTest();	
    }        
    
    private static void RunPassLead(LeadAssignmentExtension extension)
    {   
        extension.AssignLead = 'New Biz Auto';
		extension.PassLead();
        
        extension.AssignLead = 'New Biz Manual';
		extension.PassLead();
        
        extension.AssignLead = 'Renewals';
		extension.PassLead();	  
        
        extension.AssignLead = 'Broadcast';
		extension.PassLead();
    }
    private static PageReference GetLeadAssignPageRef(Task t, Contact c, Lead l)
    {
        PageReference pageRef = Page.LeadAssignment;
        if(t != null)
			pageRef.GetParameters().put('tid', t.Id);
        if(c != null)
			pageRef.GetParameters().put('cid', c.Id);
        if(l != null)
			pageRef.GetParameters().put('lid', l.Id);		
        
        return pageRef;
    }
}