global with sharing class batchCompetitorAlerts implements Database.Batchable<sObject>, Schedulable
{
	private String queryString = null;
	
	private Map<Id, User> usersMap = new Map<Id, User>([Select Id, Email, ManagerId, IsActive, Profile.Name from User]);
	private Id newBizTaskRecordTypeId = null;
	private Id renewalsTaskRecordTypeId = null;
	private Contact tempContact = null;
	private Id templateId = null;
	
	global batchCompetitorAlerts(String q)
	{
		queryString = q;
		
		tempContact = [select id, Email from Contact where email <> null limit 1];
		templateId = [select id from EmailTemplate where DeveloperName='CompetitorRenewalAlert'].id;
		
		List<RecordType> rtList = [select Id, Name, SObjectType from RecordType where SObjectType = 'Task' and (Name = 'Renewal Sales' or Name = 'New Biz Sales')];
		
		if (rtList != null && rtList.size() > 0)
		{
			for (RecordType r : rtList)
			{
				if (r.SObjectType == 'Task' && r.Name == 'New Biz Sales')
				{
					newBizTaskRecordTypeId = r.Id;
				}
				
				if (r.SObjectType == 'Task' && r.Name == 'Renewal Sales')
				{
					renewalsTaskRecordTypeId = r.Id;
				}
			}
		}

	}

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
      return Database.getQueryLocator(queryString);
    }
	
	global void execute(Database.BatchableContext BC, List<Competitor__c>scope)
	{
		List <Competitor__c> competitorsExpiring = new List<Competitor__c>();
		
   		for (Competitor__c c : scope)
		{
			// See if the expiry date of this Competitor is 3 months or greater and an alert has not already been sent
			if (c.Service_Expiration_Date__c <= Date.Today().addMonths(3) && !c.Service_Expiration_Alert_Sent__c 
				&& (c.Opportunity_Close__c == null || c.Opportunity_Close__c == '' || c.Opportunity_Close__c == 'Lost To'))
			{
				// This Competitor needs an alert sending
				competitorsExpiring.add(c);
			}
		}
		
		if (competitorsExpiring.size() > 0)
		{
			List<Task> alertTasks = new List<Task>();
			
			for (Competitor__c c : competitorsExpiring)
			{
				// Create the Task
				Task t = new Task();
				t.OwnerId = GetAlertOwnerId(c);
				t.WhatId = c.Account__c;
				t.Subject = c.Account__r.Name + '\'s Contract with ' + c.Competitor_Name__c + ' is up in 3 months';
				t.Description = c.Account__r.Name + '\'s Contract with ' + c.Competitor_Name__c + ' is up on ' + c.Service_Expiration_Date__c.format() + '. This is a good time to reach out to them.';  
				t.ActivityDate = Date.today().addDays(1);
				t.RecordTypeId = GetRecordTypeFromUser(t.OwnerId);
				
				alertTasks.add(t);
				
				// Send the Email
				Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
				msg.setTemplateId(templateId);
				msg.setWhatId(c.ID);
				msg.setTargetObjectId(tempContact.id);
		
				List<String> toAddresses = new List<String>();
				toAddresses.add(usersMap.get(t.OwnerId).Email);
				msg.setToAddresses(toAddresses);
		
				// Send the emails in a transaction, then roll it back
				Savepoint sp = Database.setSavepoint();
				List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
				messages.add(msg);
				
				if (!Test.isRunningTest())
				{
					Messaging.sendEmail(messages);
				}
				
				Database.rollback(sp);
		
				// Now Actually Send the Email to the Correct Address
				Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
				emailToSend.setToAddresses(msg.getToAddresses());
				emailToSend.setPlainTextBody(msg.getPlainTextBody());
				emailToSend.setHTMLBody(msg.getHTMLBody());
				emailToSend.setSubject(msg.getSubject());
				List<Messaging.SingleEmailMessage> messagesToSend = new List<Messaging.SingleEmailMessage>();
				messagesToSend.add(emailToSend);
				
				if (!Test.IsRunningTest())
				{
					Messaging.sendEmail(messagesToSend);
				}
				
				//Set the flag to say the alert has been sent
				c.Service_Expiration_Alert_Sent__c = true;
			}
			
			insert alertTasks;
			update competitorsExpiring;
		}
    }
	
	public Id GetAlertOwnerId(Competitor__c c)
	{
		if (c.Account__r.Renewal_Rep__c != null)
		{
			return c.Account__r.Renewal_Rep__c;
		}
		else
		{
			User u = usersMap.get(c.CreatedById);
			
			if (u.IsActive)
			{
				return u.Id;
			}
			else
			{
				if (u.ManagerId != null)
				{
					User m = usersMap.get(u.ManagerId);
					
					if (m.IsActive)
					{
						return m.Id;
					}
				}
			}
		}
		
		return c.Account__r.OwnerId;
	}
	
	public Id GetRecordTypeFromUser(Id userId)
	{
		User userToCheck = usersMap.get(userId);
		String profileName = userToCheck.Profile.Name;
		
		if (profileName.toLowerCase().Contains('renewal'))
		{
			return renewalsTaskRecordTypeId;
		}
		
		return newBizTaskRecordTypeId;
	}
	
	global void finish(Database.BatchableContext BC)
	{
    
    }
	
	global void execute(SchedulableContext SC) 
    {  
		string SOQL = 'Select Id, Name, Service_Expiration_Alert_Sent__c, Opportunity_Close__c, CreatedById, Account__c, Account__r.Name, Account__r.OwnerId, Account__r.Renewal_Rep__c, Brand_Campaign__c, Competitive_Spend__c, Competitor_Name__c, Competitor_Notes__c,  Service_Expiration_Date__c, Service_Provided__c from Competitor__c where (Competitor_Name__c != \'No Competitor\' and Competitor_Name__c != \'Client Won’t Say/Don’t Know\')';
    	Database.executeBatch(new batchCompetitorAlerts(SOQL),10); 
	}
}