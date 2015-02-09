public with sharing class LeadConversionExtension
{
	public String ConvertLead {get; set;}
	public String LeadConversionType {get; set;}
	public Task t {Get;Set;}
	public Contact con {Get;Set;}
	public Opportunity opp {Get;Set;}		
	public List<SelectOption> options {Get;Set;}
	private String AttachToExistingMsg = 'Attach To Opportunity: ';	
	
	public LeadConversionExtension(ApexPages.StandardController controller) 
    {				
		String taskId = ApexPages.currentPage().getParameters().get('tid');  	
		
		if(taskId != null)
        {			
            t = UtilityClass.GetTask(taskId);  
			LoadOpportunityList(t.AccountId);						
        }		
	}

	public void ConvertLead()
	{
		System.debug('LeadConversionType = ' + LeadConversionType);
		if(LeadConversionType == 'New')
		{
			CreateOpportunity();
			ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, 'Lead ' + t.Who.Name + ' has been converted and Opportunity has been created')); 
		}
		else
		{
			UpdateOpportunityAndTask(LeadConversionType);
			ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, 'Lead ' + t.Who.Name + ' has been converted successfully and Opportunity has been updated')); 
		}				
	}
	
	public void LoadOpportunityList(Id acctId)
	{
		List<Opportunity> oppList = CampaignMemberHelper.GetOpenOpportunities(acctId);
		options = new List<SelectOption>();
		options.add(new SelectOption('New', 'Create New Opportunity: ' + t.Account.Name + ' - Lead'));  //+ t.Who.Name
		if(oppList != null)
		{
			for(Opportunity o : oppList)
			{			
				System.debug('o = ' + o);
				options.add(new SelectOption(o.Id, AttachToExistingMsg + o.Name));        	
			}		
		}
	}	
	
	private void UpdateOpportunityAndTask(String oppId)
	{							
		Opportunity o = UtilityClass.GetOpportunity(oppId);
		System.debug('########################### t = ' + t);
		System.debug('########################### o = ' + o);
		if(o != null)
		{						
			/*if(o.CampaignId == null)
			{
				if(t.WhatId != null)
					o.CampaignId = t.WhatId;
			}*/
								
			SetOpportunityContactRole(oppId);
								
			update o;
		}
		
		UpdateTaskToCompleted();
	}
	
	private void CreateOpportunity()
	{
		Opportunity o = new Opportunity();
		o.Name = t.Account.Name + ' - Lead';  
		o.AccountId = t.AccountId;
		o.CloseDate = Date.today().addDays(60);
		o.OwnerId = t.OwnerId;
		o.StageName = Constants.OppSalesStageContacted;
		o.Probability = 10;			
		o.Invoice_Contact_Email__c = '';
		o.Invoice_Contact_Name__c = '';
		
		if(t.RecordType.Name == Constants.GroupNewBiz)
		{
			o.Type = Constants.OppTypeNew;
			o.New_Biz_Source__c = Constants.OppNewBizSourceInbound;
		}
		else if(t.RecordType.Name == Constants.GroupRenewals)
		{
			o.Type = Constants.OppTypeUpsell;
		}		
		
		Id profileId=userinfo.getProfileId();
		String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
		
		System.debug('profileName = ' + profileName);
		if(profileName != null)
		{
			if(profileName.contains(Constants.GroupRenewals))
			{
				o.RecordTypeId = CampaignMemberHelper.GetRecordTypeByName(Constants.GroupRenewals).Id;
			}
			else
			{
				o.RecordTypeId = CampaignMemberHelper.GetRecordTypeByName(Constants.GroupNewBiz).Id;
			}
		}
		
		System.debug(o);
		insert o;		
		SetOpportunityContactRole(o.Id);
		UpdateTaskToCompleted();
	}
	
	private void SetOpportunityContactRole(Id oppId)
	{
		OpportunityContactRole updatedOppContactRole = null;
		Boolean contactInList = false;
		Boolean isPrimaryContact = false;
		
		List<OpportunityContactRole> oppCRList = CampaignMemberHelper.GetOpportunityContactRoles(oppId);
		
		System.debug('########################### oppCRList = ' + oppCRList);
		
		if(oppCRList != null)
		{
			for(OpportunityContactRole ocr : oppCRList)
			{			
				if(ocr.ContactId == t.WhoId)
				{
					contactInList = true;
					updatedOppContactRole = ocr;
				}
				/*if(ocr.IsPrimary)
				{
					isPrimaryContact = true;
				}*/
			}
		}
		
		System.debug('########################### contactInList = ' + contactInList);
		System.debug('########################### oppId = ' + oppId);
		
		if(!contactInList)
		{
			OpportunityContactRole newOppContactRole = new OpportunityContactRole();
			newOppContactRole.ContactId = t.WhoId;
			/*if(!isPrimaryContact)
			{
				//newOppContactRole.IsPrimary = true;		 //Might bring this back		
			}*/
			newOppContactRole.OpportunityId = oppId;			
			
			insert newOppContactRole;
		}
		/*else
		{
			if(!isPrimaryContact)
			{
				//updatedOppContactRole.IsPrimary = true;			//Might bring this back	
			}
			
			update updatedOppContactRole;
		}*/
	}
	
	private void UpdateTaskToCompleted()
	{
		t.Status = Constants.LeadStatusCompleted;
		t.Lead_Status__c = Constants.LeadQualified;	
		
		update t;
	}
}