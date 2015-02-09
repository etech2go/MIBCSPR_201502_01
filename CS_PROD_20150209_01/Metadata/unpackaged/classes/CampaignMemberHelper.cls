public with sharing class CampaignMemberHelper
{		
	public static Boolean NameCompanyContainPhrases(String nameOrCompany)
	{		
		Boolean containsPhrase = false;
		
		if(nameOrCompany != null)
		{
			if(nameOrCompany.containsIgnoreCase('hospital'))
			{
				containsPhrase = true;
				
				if(nameOrCompany.containsIgnoreCase('llc') || nameOrCompany.containsIgnoreCase('inc') || nameOrCompany.containsIgnoreCase('inc.') || nameOrCompany.containsIgnoreCase(' co') || nameOrCompany.containsIgnoreCase('hospitality'))
				{
					return false;
				}									
			}
			
			if(nameOrCompany.containsIgnoreCase('department') || nameOrCompany.containsIgnoreCase('state') || nameOrCompany.containsIgnoreCase('country') || nameOrCompany.containsIgnoreCase('city') 
			|| nameOrCompany.containsIgnoreCase('convention%visitors') || nameOrCompany.containsIgnoreCase('visitors%convention'))
			{
				containsPhrase = true;
				
				if(nameOrCompany.containsIgnoreCase('university') || nameOrCompany.containsIgnoreCase('college') || nameOrCompany.containsIgnoreCase('school') || nameOrCompany.containsIgnoreCase('llc') 
				|| nameOrCompany.containsIgnoreCase(' inc.') || nameOrCompany.containsIgnoreCase('inc') || nameOrCompany.containsIgnoreCase(' co ') || nameOrCompany.containsIgnoreCase(' company') || nameOrCompany.containsIgnoreCase(' corp') 
				|| nameOrCompany.containsIgnoreCase(' corp.') || nameOrCompany.containsIgnoreCase(' corporation') || nameOrCompany.containsIgnoreCase('hospital'))
				{				
					return false;	
				}			
			}
			
			if(nameOrCompany.containsIgnoreCase('college') || nameOrCompany.containsIgnoreCase('university') || nameOrCompany.containsIgnoreCase('univ%of%'))
			{
				containsPhrase = true;
				
				if(nameOrCompany.containsIgnoreCase('fund') || nameOrCompany.containsIgnoreCase('association') || nameOrCompany.containsIgnoreCase('trustee') || nameOrCompany.containsIgnoreCase('foundation') 
				|| nameOrCompany.containsIgnoreCase('hospital') || nameOrCompany.containsIgnoreCase('associates') || nameOrCompany.containsIgnoreCase('medical center'))
				{			
					return false;	
				}							
			}
		}
		
		return containsPhrase;
	}
	
	public static Boolean RenewalResponseThroughNewBiz(Contact con)
	{
		if(con.Account.Renewal_Rep__c != null)
		{
			String description = '';
			if(con.Description != null)
			{
				description = con.Description;
			}			
			
			if(con.Account.Type == Constants.Customer && con.Account.Plan_Customer__c == true && description != null)
			{				
				return ContactDescriptionForRenewal(description);
			}
			else if(con.Account.Type == Constants.Customer && description.containsIgnoreCase('wire distribution') || description.containsIgnoreCase('SEO') || description.containsIgnoreCase('wire service'))
			{
				return true;	
			}
		}
		
		return false;	
	}
	
	private static Boolean ContactDescriptionForRenewal(String description)
	{
		if(description != null)
		{
			if(description.containsIgnoreCase('renew') || description.containsIgnoreCase('international media lists') || description.containsIgnoreCase('inc') || description.containsIgnoreCase('international lists') 
			|| description.containsIgnoreCase('international database') || description.containsIgnoreCase('international contact'))
			{
				if(description.containsIgnoreCase('monitoring') || description.containsIgnoreCase('print') || description.containsIgnoreCase('article') || description.containsIgnoreCase('database')
				|| description.containsIgnoreCase('research') || description.containsIgnoreCase('eNews') || description.containsIgnoreCase('evaluation') || description.containsIgnoreCase('analysis')
				|| description.containsIgnoreCase(' clips ') || description.containsIgnoreCase('social media'))
				{
					return false;
				}
				
				return true;
			}
		}
		
		return false;
	}
	
	public static Boolean IsInternational(String countryCode)
	{	
		if(countryCode != Constants.UnitedStateBillingCountryCode)
		{
			return true;			
		}
		
		return false;
	}
	
	public static Boolean IsEloquaAdmin(String owner)
	{
	
		if(owner == Constants.EloquaAdmin)
		{
			return true;			
		}				
		
		return false;
	}
	
	public static String GetLeadRatingType(String campaignGoal)
	{
		if(campaignGoal == Constants.CampaignHotLead || campaignGoal == Constants.HotRating)
		{
			return Constants.HotRating;	
		}
		else
		{
			return Constants.WarmRating;	
		}
	}
	
	public static Boolean ContainsNAICSNumbers(String naicsCode1)
	{	
		if(naicsCode1 != null)
		{
			if(naicsCode1.startsWith('622') || naicsCode1.startsWith('92') || naicsCode1 == '611210' || naicsCode1 == '611310' || naicsCode1 == '611410' || naicsCode1 == '611610')
			{
				return true;	
			}
		}
		
		return false;
	}
	
	public static Boolean LeadTaskDescriptionContainPhrases(String leadTaskDescription)
	{	
		Boolean containsPhrase = false;
		
		System.debug('##################### leadTaskDescription = ' + leadTaskDescription);
		
		if(leadTaskDescription != null)
		{				
			if(leadTaskDescription.containsIgnoreCase('tv') || leadTaskDescription.containsIgnoreCase('dvd') || leadTaskDescription.containsIgnoreCase('cd') || leadTaskDescription.containsIgnoreCase('segment')
			|| leadTaskDescription.containsIgnoreCase('station') || leadTaskDescription.containsIgnoreCase('aired') || leadTaskDescription.containsIgnoreCase('channel') || leadTaskDescription.containsIgnoreCase('radio')	
			|| leadTaskDescription.containsIgnoreCase('clip') || leadTaskDescription.containsIgnoreCase('broadcast') || leadTaskDescription.containsIgnoreCase('vhs') || leadTaskDescription.containsIgnoreCase('social media broadcast')
			|| leadTaskDescription.containsIgnoreCase('broadcast social media') || leadTaskDescription.containsIgnoreCase('my%was interviewed') || leadTaskDescription.containsIgnoreCase('digital copy')
			|| leadTaskDescription.containsIgnoreCase('bloomberg') || leadTaskDescription.containsIgnoreCase('video') || leadTaskDescription.containsIgnoreCase('media clips') || leadTaskDescription.containsIgnoreCase('transcript') 
			|| leadTaskDescription.containsIgnoreCase('newscast'))
			{
				containsPhrase = true;
				
				if(leadTaskDescription.containsIgnoreCase('monitoring') || leadTaskDescription.containsIgnoreCase('print') || leadTaskDescription.containsIgnoreCase('article') || leadTaskDescription.containsIgnoreCase('database')
				|| leadTaskDescription.containsIgnoreCase('research') || leadTaskDescription.containsIgnoreCase('eNews') || leadTaskDescription.containsIgnoreCase('evaluation') || leadTaskDescription.containsIgnoreCase('analysis')
				|| leadTaskDescription.containsIgnoreCase('newspaper') || leadTaskDescription.containsIgnoreCase('clipping service') || leadTaskDescription.containsIgnoreCase('clip tracking'))
				{
					return false;	
				}
				
				return containsPhrase;	
			}								
		}
		
		return containsPhrase;
	}
	
	public static Boolean ContainEmailWebExtensions(String email)
	{
		if(email != null)
		{
			if(email.endsWith('.gov') || email.endsWith('.mil') || email.endsWith('.edu')) 
			{
				return true;	
			}
		}
		
		return false;
	}	
	
	public static void UpdateLeadRating(String campaignGoal, Lead l)
	{
		if(campaignGoal == Constants.CampaignHotLead)
			l.Rating = Constants.HotRating;
		else
			l.Rating = Constants.WarmRating;	
	}
	
	public static String IsEastOrWest(String billingStateCode)
	{											
		System.Debug('#######################Billing State = ' + (billingStateCode == null ? Constants.West : billingStateCode)); //l != null ? l.Company : con.Account.Name
		
		if(billingStateCode != null)
		{
			if (billingStateCode != '')
			{
				// Based on the state we can work out if this is East or West
				/*
				String[] eastStates = new String[]{'CT', 'DC', 'DE', 'FL', 'MA', 'MD', 'ME', 'NH', 'NJ', 'NY', 'PA', 'RI', 'VA', 'VT', 'NC', 'SC'};
				String[] westStates = new String[]{'AK', 'AL', 'AR', 'AZ', 'CA', 'CO', 'GA', 'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MI', 'MN', 'MO', 'MS', 'MT', 'ND', 'NE', 'NM', 'NV', 'OH', 'OK', 'OR', 'SD', 'TN', 'TX', 'UT', 'WA', 'WI', 'WV', 'WY'};
		        
		        for (String s : eastStates)
				{
					if (billingStateCode.toupperCase() == s)
					{
						return Constants.East;
					}
				}
				
				for (String s : westStates)
				{
					if (billingStateCode.toupperCase() == s)
					{
						return Constants.West;
					}
				}
				*/
				//Mod by LD on 12/9/14 to use the Regions custom setting to determine East/West States 
		        List<Region__c> stateRegion = Region__c.getall().values();
		
		        for(Region__c r : stateRegion){
		        	if(billingStateCode.toupperCase() == r.Name){
		        		if (r.East__c){
		        			return Constants.East;
		        		}
		        		
		        		if(r.West__c){
		        			return Constants.West;
		        		}
		        	}
		        }
				
			}
		}
		
		return Constants.West; //Based off of conversation with Lisa, setting default to West if Lead if there is no State Code
	}					
			
	public static void UpdateRoundRobin(RoundRobinHelper roundRobin, String description)
	{									
		roundRobin.CreateStatisticRecord(description);
		roundRobin.UpdateRoundRobin();
	}				
	
	public static List<Opportunity> GetOpenOpportunities(Id acctId)
	{		
		List<Opportunity> oppList = null;
		
		oppList = [Select Id, Name from Opportunity where AccountId =: acctId and IsClosed = false];
		
		System.debug('###########################oppList:' + oppList);		
		
		return oppList;						
	}	
	
	public static List<OpportunityContactRole> GetOpportunityContactRoles(Id oppId)
	{		
		List<OpportunityContactRole> oppCRList = null;
		
		oppCRList = [Select O.ContactId, O.Id, O.CreatedDate, O.OpportunityId, O.IsPrimary, O.Role from OpportunityContactRole O WHERE O.OpportunityId =: oppId];
		
		System.debug('###########################oppList:' + oppCRList);		
		
		return oppCRList;						
	}		
	
	public static void CreateTaskForCampaignMember(Task t, Contact con, Id whatIdForTask, String leadPassCampaignName, String leadRatingType)
	{							
		t.WhoId = con.Id;
		t.WhatId = whatIdForTask;		
		t.Subject = leadPassCampaignName + ': ' + con.Account.Name;
		t.Account_Name__c = con.Account.Name;
		t.ActivityDate = Date.today().addDays(1);  // Add another day		
		t.IsReminderSet = true;		
		t.ReminderDateTime = Date.today().addDays(1);
		t.Description = con.Description;
		t.Task_Type__c = Constants.CampaignResponseTaskType;
		t.RecordTypeId = GetRecordTypeByName(Constants.CampaignResponseTaskType).Id;
		t.Job_Role__c = con.Job_Role__c;
		t.Function_Department__c = con.Function_Department__c;
		t.Web_Employees__c = con.Web_Employees__c;
		t.Web_Revenue__c = con.Web_Revenue__c;
		t.PR_Department_Size__c = con.PR_Department_Size__c;
		t.Areas_of_Interest__c = con.Areas_of_Interest__c;
		t.PR_Activities__c = con.PR_Activities__c;
		t.Web_Lead_Comments__c = con.Web_Lead_Comments__c;
		if(leadRatingType == Constants.HotRating)
			t.Rating__c = Constants.HotRating;
		else
			t.Rating__c = Constants.WarmRating;
		
		System.debug('#######################' + t);		
		insert t;			
	}
	
	/*public static void SendLeadEmailFromTemplate(Campaign c, Lead l, Contact con, User sendToUser, String includedEmails)	
	{
		Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
		Map <ID, String> contactEmailMap = new Map <ID, String>();
		Contact tempContact = null;
		
		if(l !=null)
		{
			msg.setTemplateId( [select id from EmailTemplate where DeveloperName='CampaignMemberLeadEmail'].id );			
			tempContact = [select id, Email from Contact where email <> null limit 1];
			msg.setTargetObjectId(tempContact.id);
		}
		else
		{
			msg.setTemplateId( [select id from EmailTemplate where DeveloperName='CampaignMemberLeadEmailForContact'].id );
			msg.setTargetObjectId(con.id);
		}
						
		msg.setWhatId(c.Id);		
		msg.setToAddresses(new String[] {sendToUser.Email});
		System.Debug('#############################################Email will be Sent to ' + sendToUser.Email);
		if(includedEmails != null)		
		{		
			if(includedEmails.length() > 0)
			{
				String [] toEmails = includedEmails.split(',');
				msg.setCcAddresses(toEmails);
				System.Debug('#############################################Email will be CC to ' + toEmails);
			}			
		}	
		
		System.debug('#############################################tempContact = ' + tempContact);
		System.debug('#############################################' + msg);
		
		// Send the emails in a transaction, then roll it back
		if(l !=null)
		{
			Savepoint sp = Database.setSavepoint();
			List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
			messages.add(msg);
			Messaging.sendEmail(messages);
			Database.rollback(sp);
		}
		
		// Now Actually Send the Email to the Correct Address
		Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
		emailToSend.setToAddresses(msg.getToAddresses());
		emailToSend.setPlainTextBody(msg.getPlainTextBody());
		emailToSend.setHTMLBody(msg.getHTMLBody());
		emailToSend.setSubject(msg.getSubject());
		List<Messaging.SingleEmailMessage> messagesToSend = new List<Messaging.SingleEmailMessage>();
		messagesToSend.add(emailToSend);
		if(!Test.isRunningTest())
		{
			Messaging.sendEmail(messagesToSend);
		}
		
	}
	*/
	public static void SendLeadEmail(String leadPassCampaignName, Lead l, Contact con, User sendToUser, String includedEmails)	
	{
		System.Debug('#######################' + sendToUser);
		System.Debug('#######################includedEmails = ' + includedEmails);
		system.Debug('###################### Manager Email' + sendToUser.Manager.Email);
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();				        
        mail.setToAddresses(new String[] {sendToUser.Email});
		List<String> args = new String[]{'0','number','###,###,##0.00'};
		if(includedEmails != null)		
		{		
			if(includedEmails.length() > 0)
			{
				String [] toEmails = includedEmails.split(',');
				mail.setCcAddresses(toEmails);
			}
		}	
		String subject = leadPassCampaignName; //'New Lead - ';
		String accountName = '<b>Account Name:</b> ' + (l != null ? l.Company : con.Account.Name);
		String contactName = '<b>Contact Name: </b>' + (l != null ? l.Name : con.Name);
		String email = '<b>Email: </b>' + (l != null ? l.Email : con.Email);
		String phone = '<b>Phone: </b>' + (l != null ? l.Phone : con.Phone);
		String city = '<b>City: </b>'  + (l != null ? l.City : con.MailingCity);
		String stateProvince = '<b>State/Province: </b>' + (l != null ? l.State : con.MailingState);
		String country = '<b>Country: </b>' + (l != null ? l.Country : con.MailingCountry);
		String campaignName = '<b>Campaign Name: </b>' + leadPassCampaignName;
		String jobRole = '<b>Job Role: </b>' + (l != null ? l.Job_Role__c : con.Job_Role__c);
		String functionDept = '<b>Function/Department: </b>' + (l != null ? l.Function_Department__c : con.Function_Department__c);
		String prDeptSize = '<b>PR Department Size: </b>' + (l != null ? l.PR_Department_Size__c : con.PR_Department_Size__c);
		String prActivities = '<b>PR Activities: </b>' + (l != null ? l.PR_Activities__c : con.PR_Activities__c);
		String areasOfInterest = '<b>Areas of Interest: </b>' + (l != null ? l.Areas_of_Interest__c : con.Areas_of_Interest__c);
		String webEmployees = '<b>Web Employees: </b>' + (l != null ? l.Web_Employees__c : con.Web_Employees__c);
		String webRevenue = '<b>Web Revenue: </b>' + (l != null ? l.Web_Revenue__c : con.Web_Revenue__c);
		String totalSpendNonBroadcast = '<b>Total Spend (Non-Broadcast): </b>';
		String totalSpendBroadcast = '<b>Total Spend (Broadcast): </b>';
		if(con != null)
			totalSpendNonBroadcast = totalSpendNonBroadcast + (con.Account.Total_Spend_Non_Broadcast__c == null ? '' : '$' + string.format(con.Account.Total_Spend_Non_Broadcast__c.format(), args));	//string.valueOf(con.Account.Total_Spend_Non_Broadcast__c)
		if(con != null)
			totalSpendBroadcast = totalSpendBroadcast + (con.Account.Total_Spend_Broadcast__c == null ? '' : '$' + string.format(con.Account.Total_Spend_Broadcast__c.format(), args)); //string.valueOf(con.Account.Total_Spend_Broadcast__c)
		
		String webLeadComments = '<b>Web Lead Comments: </b>' + (l != null ? l.Description : con.Web_Lead_Comments__c);				
		
		if(l != null)
		{
        	mail.setSubject(subject + ' - ' + l.Name);
		}
		else
		{
			mail.setSubject(subject + ' - ' + con.Account.Name);
		}
		
		String body = '<html><body><table><tr><td>';		
		body += accountName + '</br>';
		body += contactName + '</br>';
		body += email + '</br>';
		body += phone + '</br>';
		body += city + '</br>';
		body += stateProvince + '</br>';
		body += country + '</br>';
		body += campaignName + '</br>';
		body += jobRole + '</br>';
		body += functionDept + '</br>';
		body += prDeptSize + '</br>';
		body += prActivities + '</br>';
		body += areasOfInterest + '</br>';
		body += webEmployees + '</br>';
		body += webRevenue + '</br>';
		body += totalSpendNonBroadcast + '</br>';
		body += totalSpendBroadcast + '</br>';
		body += webLeadComments + '</br>';
		body += '</td></tr></table></body></html>';
		body = body.replace('null', '');
        mail.setHtmlBody(body);
		
		//System.debug('Email body = ' + body);
		//System.debug('#######################mail=' + mail);
		System.debug(mail);
		if(!Test.isRunningTest())
		{
        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}
	}
	
		
	public static RecordType GetRecordTypeByName(String name)
	{
		System.debug('name=' + name);
		RecordType campaignResponseRecordType = [Select R.IsActive, R.Description, R.Name, R.Id, R.DeveloperName from RecordType R WHERE R.Name  =: name];
		
		return campaignResponseRecordType;
	}
	 
	public static void ExecuteCampaignMemberRules(CampaignMember cm)
	{
		Campaign c = null; 
		
		System.debug('#######################' + cm);						
		if(cm.Status == Constants.CampaignResponded && cm.Migrated__c == false)  //|| cm.HasResponded		
		{
			c = UtilityClass.GetCampaign(cm.CampaignId);	
			System.debug('#######################' + c);
			System.debug('#######################Campaign Name = ' + c.Name);
			if(c.Team_Queue__c == Constants.NewBizQueue)
			{
				LeadHelper.ExecuteLeadGenNewBizRules(cm.ContactId, cm.LeadId, true, c.Id, c.Name, c.Campaign_Goal__c, false);
			}
			else if(c.Team_Queue__c == Constants.RenewalsQueue)
			{
				LeadHelper.ExecuteRenewalRules(cm.ContactId, cm.LeadId, c.Id, c.Name, c.Campaign_Goal__c, false);
			}
			else if(c.Team_Queue__c == Constants.LeadGenerationQueue)
			{
				LeadHelper.ExecuteLeadGenNewBizRules(cm.ContactId, cm.LeadId, false, c.Id, c.Name, c.Campaign_Goal__c, false);
			}			
			else if(c.Team_Queue__c == Constants.RegionalLeadGen)
			{
				LeadHelper.ExecuteRegionalLeadGenRules(cm.ContactId, cm.LeadId, c.Id, c.Name, c.Campaign_Goal__c, false);
			}								
		}
	}
}