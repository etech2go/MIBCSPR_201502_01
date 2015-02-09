public with sharing class UtilityClass 
{
	public static String getSObjectTypeName(SObject so) 
	{
		return so.getSObjectType().getDescribe().getName();
	}
	
	public static Boolean HasListChanged(List<SObject> oldList, List<SObject> newList)
	{
		if (oldList != null && newList != null && oldList.size() > 0 && newList.size() > 0)
		{
			// If the old list contains no Ids and the new list does or visa versa then we should return true
			if ( (oldList[0].Id == null && newList[0].Id != null) || (oldList[0].Id != null && newList[0].Id == null) )
			{
				return true;
			}
			else
			{
				if (oldList[0].Id == null && newList[0].Id == null)
				{
					return false;
				}
				else
				{
					Boolean oldListContainsNulls = false;
					Boolean newListContainsNulls = false;
					
					for (SObject soOld : oldList)
					{
						if (soOld.Id == null)
						{
							oldListContainsNulls = true;
							break;
						}
					}
					
					for (SObject soNew : newList)
					{
						if (soNew.Id == null)
						{
							newListContainsNulls = true;
							break;
						}
					}
					
					if (!oldListContainsNulls && !newListContainsNulls)
					{
						Set<Id> oldResultIds = (new Map<Id,SObject>(oldList)).keySet();
						Set<Id> newResultIds = (new Map<Id,SObject>(newList)).keySet();
						
						if (oldResultIds.containsAll(newResultIds))
						{
							return false;
						}
						else
						{
							return true;
						}
					}
					else
					{
						return true;
					}
				}
			}
		}
		else
		{
			return true;
		}
	}
	
	public static User GetUser(String userName)
	{
		List<User> uList = null;
		
		uList = [Select U.Id, U.Email, U.Manager.Email, U.Manager.Name, U.Username, U.Name, U.Ca_Rep__c from User U where Name =: userName LIMIT 1];		
		
		if(uList.size() > 0)
			return uList.get(0);
		else
			return null;
			
	}
	
	public static User GetUser(Id userId)
	{
		List<User> uList = null;
		
		uList = [Select U.Id, U.Email, U.Manager.Email, U.Manager.Name, U.Username, U.Name, U.Ca_Rep__c from User U where Id =: userId LIMIT 1];		
		
		if(uList.size() > 0)
			return uList.get(0);
		else
			return null;
	}
	
	public static RecordType GetRecordType(Id recordTypeId)
	{		
		RecordType caseSupportRecordType = [Select R.IsActive, R.Description, R.Name, R.Id, R.DeveloperName from RecordType R WHERE R.Id  =: recordTypeId];
		
		return caseSupportRecordType;
	}
	
	public static RecordType GetRecordType(String Name)
	{		
		RecordType caseSupportRecordType = [Select R.IsActive, R.Description, R.Name, R.Id, R.DeveloperName from RecordType R WHERE R.Name  =: Name];
		
		return caseSupportRecordType;
	}
	
	public static SBQQ__Quote__c GetQuote(Id quoteId)
	{
		SBQQ__Quote__c quote = [SELECT q.Id, q.SBQQ__Account__c, q.SBQQ__Opportunity__c, q.Name from SBQQ__Quote__c q where q.Id =: quoteId];
		
		return quote;
	}
	
	public static Contact GetContact(Id contactId)
	{
		Contact con = [Select C.OwnerId, C.AccountId, C.Account.Name, C.Name, C.Phone, C.MailingCity, C.MailingState, C.MailingCountry, C.Account.AnnualRevenue, C.Account.Type, C.Account.Plan_Customer__c, C.Description, C.Account.Total_Spend_Non_Broadcast__c, C.Account.Total_Spend_Broadcast__c, C.Account.Fortune_1000_Ranking__c, C.Account.NAICS_Code_1__c, C.Account.Website, C.Account.New_Biz_Rep__c, C.Account.Renewal_Rep__c, C.Id, C.CreatedDate, 
						C.Email, C.Account.BillingState, C.Account.BillingCountry, C.Web_Employees__c, C.Web_Revenue__c, C.Job_Role__c, C.Function_Department__c, C.PR_Department_Size__c, C.PR_Activities__c, C.Areas_of_Interest__c, C.Web_Lead_Comments__c from Contact C where Id =: contactId];
		
		return con;		
	}	
	
	public static Opportunity GetOpportunity(Id oppId)
	{
		Opportunity opp = [Select Id, Name, AccountId, OwnerId, CampaignId, IsClosed from Opportunity where Id =: oppId];
		
		return opp;
	}
	
	public static Task GetTask(Id taskId)
	{	
		Task t = [Select T.Id, T.AccountId, T.Account.Name, T.Who.Name, T.OwnerId, T.RecordTypeId, t.RecordType.Name, T.Task_Type__c, T.WhatId from Task T where Id =: taskId];
		System.debug('###########################' + t);
		
		return t;
	}
	
	public static Lead GetLead(Id leadId)
	{
		Lead l = [Select Id, Name, OwnerId, NumberOfEmployees, Status, Lead_Pass_Rep__c, Web_Revenue__c, Email, Owner.Name, Company, Phone, City, State, Country, Job_Role__c, Function_Department__c, PR_Department_Size__c, PR_Activities__c, Areas_of_Interest__c, 
				 Web_Employees__c, Description, Rating from Lead where Id =: leadId];	
		
		return l;
	}
	
	public static Campaign GetCampaign(Id campaignId)
	{
		Campaign camp = [Select Id, Team_Queue__c, Name, Campaign_Goal__c from Campaign where Id =: campaignId];
		
		return camp;		
	}	
	
	public static Account GetAccount(Id acctId)
	{
		Account acct = [Select Id, Name from Account where Id =: acctId];
		
		return acct;		
	}	
	
	public static List<Schema.FieldSetMember> ReturnFieldSet(String objectName, String fieldSetName)
	{
		if (fieldSetName == null)
		{
			fieldSetName = 'Client_Services';
		}
		else
		{
			fieldSetName = fieldSetName.replace(' ', '_').replace('-', '_').replace('/', '_').replace('(', '_').replace(')', ' ').trim();
		}
		system.debug('fieldSetName=' + fieldSetName);
		Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
    	Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objectName);
    	Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

       	Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
		
		if(fieldSetObj != null)
     		return fieldSetObj.getFields(); 
		else
			return new List<Schema.FieldSetMember>();
	}
}