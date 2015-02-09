public with sharing class LeadAssignmentExtension
{
	public Lead l {Get;Set;}
	public Task t {Get;Set;}
	public Contact con {Get;Set;}
	public Boolean LeadViewMode {get; set;}
	public Boolean TaskViewMode {get; set;}
	public String AssignLead {get;set;}
	public String OwnerName {get; set;}
	private Id OldOwnerId;
	private String NewBizAuto = 'New Biz Auto';
	private String NewBizManual = 'New Biz Manual';		
	private String LeadPassSubject = 'Lead Pass from ';
	private String TaskPassSubject = 'The New Task Assigned To ';
	
	public LeadAssignmentExtension(ApexPages.StandardController controller) 
    {
		String leadId = ApexPages.currentPage().getParameters().get('lid');  
        String contactId = ApexPages.currentPage().getParameters().get('cid');  	
		String taskId = ApexPages.currentPage().getParameters().get('tid');  	
		
		LeadViewMode = false;
		TaskViewMode = false;
		
		if(leadId != null)
        {
            l =  UtilityClass.GetLead(leadId); 
			OldOwnerId = l.OwnerId;			
        } 
		else
		{
			l = null;	
		}
		
		if(taskId != null)
        {			
            t =  UtilityClass.GetTask(taskId);  
			con = UtilityClass.GetContact(contactId);  			
			OldOwnerId = t.OwnerId;
        }
		else
		{			
			con = new Contact();	
		}
	}
	
	public PageReference ShowHideOwner()
	{
		System.debug('######################## AssignLead = ' + AssignLead);	
		ToggleOwnerView(l, con);
			
		return null;
	}
	
	public void PassLead()
	{
		System.debug('######################## AssignLead = ' + AssignLead);
		System.debug('######################## Lead = ' + l);	
		System.debug('######################## Contact = ' + con);	
		System.debug('######################## Task = ' + t);	
		
		User userOwner = null;
		CampaignMember cm = null;
		String campaignName = '';
		String includedEmails = '';
		
		try
		{
			if(l != null && t == null)
			{
				l.Status = 'New';			
				l.Lead_Pass_Date__c = Date.today();
				userOwner = UtilityClass.GetUser(OldOwnerId);
				cm = GetLatestCampaign(l.Id, null);
			}
			else if(t != null)
			{
				t.Status = 'New';
				t.Lead_Pass_Date__c = Date.today();	
				t.IsReminderSet = true;
				t.ReminderDateTime = Date.today().addDays(1);
				userOwner = UtilityClass.GetUser(t.OwnerId);
				cm = GetLatestCampaign(null, con.Id);
			}
			
			if(cm == null)
			{					
				campaignName = 'No Campaign associated to Lead';
			} 
			else
			{
				campaignName = cm.Campaign.Name;
			}
			
			System.debug('######################## userOwner = ' + userOwner);
			
			if(AssignLead == NewBizAuto)
			{
				if(l != null && t == null)
				{
					l.Lead_Pass_Rep__c = userOwner.Id;
					update l;
					LeadHelper.ExecuteLeadGenNewBizRules(con.Id, l.Id, true, null, LeadPassSubject + l.Owner.Name, l.Rating, true);
				}
				else if(t != null)
				{
					l = new Lead();
					t.Lead_Pass_Rep__c = UtilityClass.GetUser(OldOwnerId).Name;		
					update t;
					LeadHelper.ExecuteLeadGenNewBizRules(con.Id, l.Id, true, t.Id, campaignName, t.Rating__c, true);								
				}
			}
			else if(AssignLead == NewBizManual)
			{			
				if(l != null && t == null)
				{				
					l.Lead_Pass_Rep__c = userOwner.Id;
					update l;
					if(userOwner.Manager.Email != null)
						includedEmails = userOwner.Manager.Email;
					CampaignMemberHelper.SendLeadEmail(LeadPassSubject + UtilityClass.GetUser(OldOwnerId).Name + ' - ' + campaignName, l, con, userOwner, includedEmails); 
				}
				else if(t != null)
				{						
					l = new Lead();
					t.Lead_Pass_Rep__c = UtilityClass.GetUser(OldOwnerId).Name;
					update t;
					if(userOwner.Manager.Email != null)
						includedEmails = userOwner.Manager.Email;
					CampaignMemberHelper.SendLeadEmail(LeadPassSubject + UtilityClass.GetUser(OldOwnerId).Name + ' - ' + campaignName, null, con, userOwner, includedEmails); 
				}
			}
			else if(AssignLead == Constants.GroupRenewals)
			{
				if(l != null && t == null)
				{
					l.Lead_Pass_Rep__c = userOwner.Id;
					update l;				
					if(userOwner.Manager.Email != null)
						includedEmails = userOwner.Manager.Email;
					CampaignMemberHelper.SendLeadEmail(LeadPassSubject + UtilityClass.GetUser(OldOwnerId).Name + ' - ' + campaignName, l, con, userOwner, includedEmails); 
				}
				else if(t != null)
				{
					t.Lead_Pass_Rep__c = UtilityClass.GetUser(OldOwnerId).Name;
					update t;
					if(userOwner.Manager.Email != null)
						includedEmails = userOwner.Manager.Email;
					CampaignMemberHelper.SendLeadEmail(LeadPassSubject + UtilityClass.GetUser(OldOwnerId).Name + ' - ' + campaignName, null, con, userOwner, includedEmails);
				}
			}
			else if(AssignLead == Constants.GroupBroadcast)
			{
				String broadcastMessage = ' Broadcast Lead';
				if(l != null && t == null)
				{
					l.Lead_Pass_Rep__c = userOwner.Id;
					l.Description = (l.Description != null ? l.Description + broadcastMessage : broadcastMessage);
					update l;
					LeadHelper.ExecuteLeadGenNewBizRules(con.Id, l.Id, true, null, LeadPassSubject + l.Owner.Name, l.Rating, true);	
				}
				else if(t != null)
				{
					l = new Lead(); 
					t.Lead_Pass_Rep__c = UtilityClass.GetUser(OldOwnerId).Name;
					con.Description = (con.Description != null ? con.Description + broadcastMessage : broadcastMessage);
					update con;
					LeadHelper.ExecuteLeadGenNewBizRules(con.Id, l.Id, true, t.Id, campaignName, t.Rating__c, true);	
				}
			}			
			
			ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, 'Lead assignment has been moved successfully')); 
		}
		catch(System.DmlException dmlError) 
		{
			System.debug('######################## Error Message = ' + dmlError);
			ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error, 'You do not have rights to re-assign this Task.  Please contact the Task owner or your administrator to reassign this Task'));						
		}
		catch(System.Exception e)
		{
			ApexPages.addMessages(e);
		}				
	}
	
	private void ToggleOwnerView(Lead l, Contact con)
	{
		System.debug('######################## = ' + l);	
		System.debug('######################## = ' + t);	
		System.debug('######################## = ' + con);	
		
		if(AssignLead == NewBizManual || AssignLead == Constants.GroupRenewals)
		{
			if(l != null && t == null)
			{
				l.OwnerId = null;
				LeadViewMode = true;
				TaskViewMode = false;
			}
			else if(t != null)
			{
				t.OwnerId = null;
				LeadViewMode = false;
				TaskViewMode = true;
			}		
		}
		else
		{
			LeadViewMode = false;
			TaskViewMode = false;
		}
	}
	
	private static CampaignMember GetLatestCampaign(Id leadId, Id contactId)
	{	
		List<CampaignMember> cmList = null;
		
		if(leadId != null)
			cmList = [Select C.CampaignId, C.Campaign.Name, C.LastModifiedDate, C.LeadId from CampaignMember C WHERE C.LeadId =: leadId ORDER BY C.LastModifiedDate DESC LIMIT 1];
		else if(contactId != null)
			cmList = [Select C.CampaignId, C.Campaign.Name, C.LastModifiedDate, C.LeadId from CampaignMember C WHERE C.ContactId =: contactId ORDER BY C.LastModifiedDate DESC LIMIT 1];
		
		if(cmList.size() > 0)
			return cmList.get(0);
		else
			return null;
	}		
}