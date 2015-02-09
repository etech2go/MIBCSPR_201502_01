@isTest
private class TestCampaignMemberTrigger 
{						
	static testMethod void CampaignMemberLeadWithoutRepsNewBizTest() 
	{		
		TestingUtils.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.MARKETING_PROFILE);
        insert u;
        
		//System.runAs(u)
		//{
			TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
			//Set Up Data		
			Account a = GetAccount();					
			Lead l = GetLead();       		
			Campaign c = GetCampaign();       	
			CampaignMember cm = GetCampaignMember(c.Id, null, l.Id);     
			update cm;
			
			Test.startTest();
			a.Type = Constants.Customer;
	        a.Renewal_Rep__c = null;        
	        a.New_Biz_Rep__c = null;       
	        update a;
	        l.Description = 'Broadcast Renew';
	        l.Company = 'Test llc';
	        update l; 
	        
	        ExecuteCmRules(cm, c, Constants.NewBizQueue);           
	        
	        Test.stopTest();    
		//}
	}
	
	static testMethod void CampaignMemberLeadWithoutRepsLeadGenTest() 
	{		
		TestingUtils.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.MARKETING_PROFILE);
        insert u;
        
		//System.runAs(u)
		//{
			TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
			//Set Up Data		
			Account a = GetAccount();					
			Lead l = GetLead();       		
			Campaign c = GetCampaign();       	
			CampaignMember cm = GetCampaignMember(c.Id, null, l.Id);       
			
			Test.startTest();
			a.Type = Constants.Customer;
	        a.Renewal_Rep__c = null;        
	        a.New_Biz_Rep__c = null;       
	        update a;
	        l.Description = 'Broadcast Renew';
	        l.Company = 'hospital';
	        update l; 
	                
	        ExecuteCmRules(cm, c, Constants.LeadGenerationQueue);        
	        
	        Test.stopTest();        		
		//}
	}
	
	      	
	
    static testMethod void CampaignMemberContactWithRepsNewBizTest()
    {
		TestingUtils.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.MARKETING_PROFILE);
        insert u;
		
		User admin = TestLibrary.createUser ('Test2', TestLibrary.SYSTEM_ADMIN_USER_PROFILE);
        insert admin;
        
		System.runAs(u)
		{
			TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
			//Set Up Data
			Account a = GetAccount();	
			a.Name = 'Test hospital';
			System.runAs(admin)
			{
				update a;
			}
			
			Contact cont = GetContact(a.Id);		        
			Campaign c = GetCampaign();       
			CampaignMember cm = GetCampaignMember(c.Id, cont.Id, null); 
	        
	        Test.startTest();
			cont.Description = 'international database monitoring';        
	        update cont;      
	        a.Renewal_Rep__c = TestingUtils.BT_MANAGER.Id;
	        a.New_Biz_Rep__c = TestingUtils.BT_MANAGER.Id;
			
			System.runAs(admin)
			{
	        	update a;
			}
	        
	      	ExecuteCmRules(cm, c, Constants.NewBizQueue);          
	        
	        Test.stopTest();  
		}
    }
	
	static testMethod void CampaignMemberContactWithRepsLeadGenTest()
    {
		TestingUtils.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.MARKETING_PROFILE);
        insert u;
        
		System.runAs(u)
		{
			TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
			//Set Up Data
			Account a = GetAccount();			
			Contact cont = GetContact(a.Id);		        
			Campaign c = GetCampaign();       
			CampaignMember cm = GetCampaignMember(c.Id, cont.Id, null); 
	        
	        Test.startTest();
			cont.Description = 'Broadcast Renew';        
	        update cont;      
	        a.Renewal_Rep__c = TestingUtils.BT_MANAGER.Id;
	        a.New_Biz_Rep__c = TestingUtils.BT_MANAGER.Id;
	        update a;
	        
	        ExecuteCmRules(cm, c, Constants.LeadGenerationQueue);  
	        
	        Test.stopTest();  
		}
    }	
    
	static testMethod void CampaignMemberContactWithoutRepsNewBizTest() 
	{
		TestingUtils.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.MARKETING_PROFILE);
        insert u;
        
		System.runAs(u)
		{
			TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
			//Set Up Data
			Account a = GetAccount();			
			Contact cont = GetContact(a.Id);		        
			Campaign c = GetCampaign();       
			CampaignMember cm = GetCampaignMember(c.Id, cont.Id, null);      
			
			Test.startTest();
			
	        cont.Description = 'Broadcast Renew';        
	        update cont; 
	        
	        a.Renewal_Rep__c = null;        
	        a.New_Biz_Rep__c = null;       
	        update a;
	        
	        ExecuteCmRules(cm, c, Constants.NewBizQueue);         
	        
	        Test.stopTest();        
		}
	}   
	
	static testMethod void CampaignMemberContactWithoutRepsLeadGenTest() 
	{
		TestingUtils.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.MARKETING_PROFILE);
        insert u;
        
		System.runAs(u)
		{
			TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
			//Set Up Data
			Account a = GetAccount();			
			Contact cont = GetContact(a.Id);		        
			Campaign c = GetCampaign();       
			CampaignMember cm = GetCampaignMember(c.Id, cont.Id, null);      
			
			Test.startTest();
			
	        cont.Description = 'Broadcast Renew';        
	        update cont; 
	        
	        a.Renewal_Rep__c = null;        
	        a.New_Biz_Rep__c = null;       
	        update a;
	        
	        ExecuteCmRules(cm, c, Constants.LeadGenerationQueue);  
	        
	        Test.stopTest();     
		}
	}   

	static testMethod void CampaignMemberLeadWithoutRepsRenewalsRegionalLeadGenTest() 
	{		
		TestingUtils.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.MARKETING_PROFILE);
        insert u;
        
		//System.runAs(u)
		//{
			TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
			//Set Up Data		
			Account a = GetAccount();					
			Lead l = GetLead();       		
			Campaign c = GetCampaign();       	
			CampaignMember cm = GetCampaignMember(c.Id, null, l.Id);       
			
			Test.startTest();
			
	        a.Renewal_Rep__c = null;        
	        a.New_Biz_Rep__c = null;       
	        update a;
	        l.Description = 'Broadcast Renew';
	        l.Company = 'hospital';
	        update l; 
	        
	        ExecuteCmRules(cm, c, Constants.RenewalsQueue);   
	        ExecuteCmRules(cm, c, Constants.RegionalLeadGen);        
	        
	        Test.stopTest();        
		//}
	}    
    
    static testMethod void CampaignMemberLeadWithRepsRenewalsRegionalLeadGenTest() 
	{		
		TestingUtils.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.MARKETING_PROFILE);
        insert u;
        
		///System.runAs(u)
		//{
			TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
			//Set Up Data		
			Account a = GetAccount();					
			Lead l = GetLead();       		
			Campaign c = GetCampaign();       	
			CampaignMember cm = GetCampaignMember(c.Id, null, l.Id);       
			
			Test.startTest();
			
	        a.Renewal_Rep__c = TestingUtils.BT_MANAGER.Id;
	        a.New_Biz_Rep__c = TestingUtils.BT_MANAGER.Id;   
	        update a;
	        l.Description = 'Renew tv';
	        l.Company = 'hospital';
	        update l; 
	        
	        ExecuteCmRules(cm, c, Constants.RenewalsQueue);   
	        ExecuteCmRules(cm, c, Constants.RegionalLeadGen);        
	        
	        Test.stopTest();        
		//}
	}    
	
    static testMethod void CampaignMemberContactWithoutRepsRenewalsRegionalLeadGenGenTest() 
	{
		TestingUtils.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.MARKETING_PROFILE);
        insert u;
        
		System.runAs(u)
		{
			TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
			//Set Up Data
			Account a = GetAccount();			
			Contact cont = GetContact(a.Id);		        
			Campaign c = GetCampaign();       
			CampaignMember cm = GetCampaignMember(c.Id, cont.Id, null);      
			
			Test.startTest();
			
	        cont.Description = 'Monitoring';        
	        update cont; 
	        
	        a.Renewal_Rep__c = null;        
	        a.New_Biz_Rep__c = null;       
	        update a;
	        
	        ExecuteCmRules(cm, c, Constants.RenewalsQueue);   
	        ExecuteCmRules(cm, c, Constants.RegionalLeadGen);  
	        
	        Test.stopTest();      
		}
	}   
    
    static testMethod void CampaignMemberContactWithoutRepsRenewalsRegionalLeadGenTest() 
	{
		TestingUtils.InitAvaTax();
		
		User u = TestLibrary.createUser ('Test', TestLibrary.MARKETING_PROFILE);
        insert u;
        
		System.runAs(u)
		{
			TestingUtils.AddRoundRobinGroupsForMarketingCampaigns();
			//Set Up Data
			Account a = GetAccount();			
			Contact cont = GetContact(a.Id);		        
			Campaign c = GetCampaign();       
			CampaignMember cm = GetCampaignMember(c.Id, cont.Id, null);      
			
			Test.startTest();
			
	        cont.Description = 'Broadcast Renew';        
	        update cont; 
	        
	        a.Renewal_Rep__c = null;        
	        a.New_Biz_Rep__c = null;       
	        update a;
	        
	        ExecuteCmRules(cm, c, Constants.RenewalsQueue);   
	        ExecuteCmRules(cm, c, Constants.RegionalLeadGen);  
	        
	        Test.stopTest();        
		}
	}   
	private static Account GetAccount()
	{		
		Account a = TestingUtils.CreateAccount();   
        a.Renewal_Rep__c = TestingUtils.BT_MANAGER.Id;
        a.New_Biz_Rep__c = null;
		a.BillingState = 'IL';
		insert a;
		System.assert(a.Id != null);
		
		return a;
	}
	    
	private static Contact GetContact(Id accountId)
	{		
		List<Contact> contacts = TestingUtils.createContacts(1, accountId, false);        
        Contact cont = contacts.get(0);
        cont.Description = 'hospital';
		
        insert cont;
		System.assert(cont != null);
		
		return cont;
	}
	
	private static Lead GetLead()
	{
		List<Lead> leads = TestingUtils.createLeads(1, false);
        Lead l = leads.get(0);
        //User u = [SELECT Id, Name from User where Name = 'Eloqua Admin'];\
		Profile p = [select id from profile where name='Marketing'];

		User u = new User(FirstName='Eloqua', LastName='Admin', UserName='EloquaAdmin@cisionus.com', Email='test11@cisionus.com', Alias='alias',
                                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname='nickname',
                                ProfileId=p.Id, TimeZoneSidKey='America/New_York', isActive = true, Hire_Date__c = Date.today() );
		insert u;
        l.OwnerId = u.Id;     
        l.PR_Department_Size__c = Constants.MoreThan1000;
		insert l;
        System.assert(l.Id != null);
		
		return l;
	}
	
	private static Campaign GetCampaign()
	{
		List<Campaign> campaigns = TestingUtils.createCampaigns(1, false);
        Campaign c = campaigns.get(0);		 
		//c.Type = 'Sales Lead (1)';
		c.Type = 'Email';
		c.Ad_Type__c = '3rd Party';
		insert c;
		System.assert(c.Id != null);
		
		return c;
	}
	
	private static CampaignMember GetCampaignMember(Id campaignId, Id contactId, Id leadId)
	{
		CampaignMember cm = TestingUtils.createCampaignMember(campaignId, contactId);
        cm.Status = Constants.CampaignResponded;
        cm.CampaignId = campaignId;        
        cm.ContactId = contactId;
        cm.LeadId = leadId;		
		insert cm;
		System.assert(cm.Id != null);
		
		return cm;
	}
    
	
    private static void ExecuteCmRules(CampaignMember cm, Campaign c, String teamQueue)
    {
        if(teamQueue == Constants.NewBizQueue)
        {
          	//New Biz with Contact                
            c.Team_Queue__c = Constants.NewBizQueue;
            update c;        
            CampaignMemberHelper.ExecuteCampaignMemberRules(cm);               
        }
        else if(teamQueue == Constants.RenewalsQueue)
        {
             //Renewals
            c.Team_Queue__c = Constants.RenewalsQueue;
            update c;
            CampaignMemberHelper.ExecuteCampaignMemberRules(cm);
        }
		else if(teamQueue == Constants.LeadGenerationQueue)
        {
        	//Lead Generation
        	c.Team_Queue__c = Constants.LeadGenerationQueue;
			update c;
			CampaignMemberHelper.ExecuteCampaignMemberRules(cm);
        }       
        else if(teamQueue == Constants.RegionalLeadGen)
        {
            //Regional Lead Gen
            c.Team_Queue__c = Constants.RegionalLeadGen;
            update c;
            CampaignMemberHelper.ExecuteCampaignMemberRules(cm);  
        }
    }
}