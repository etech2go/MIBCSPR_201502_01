public with sharing class AccountHelper
{
	public static void AssignAccountOwner(Account a)
	{		
		if (a.Renewal_Rep__c != null)  
        {
            a.OwnerId = a.Renewal_Rep__c; 
        }
		else if(a.Renewal_Rep__c == null && a.New_Biz_Rep__c != null)
		{
			a.OwnerId = a.New_Biz_Rep__c; 
		}			
	}	
	
	public static void UpdateSalesLastTouchedDate(List<Id> accountIds)
	{
		Id profileId=userinfo.getProfileId();
		String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
		Id currentUserId = UserInfo.getUserId();
		System.debug('########################## Current User Id = ' + currentUserId); 
		if(accountIds != null)
		{
			System.debug('##################### accountIds = ' + accountIds);
			List<Account> accounts = [Select Id, Name, Sales_Last_Touched_Date__c from Account Where Id in :accountIds];
			//system.debug('ProfileName'+profileName);
						
			for(Account a :  accounts)
			{
				UpdateSalesLastTouchedDate(a, profileName, currentUserId);
			}
			
			update accounts;
		}
	}
	
	public static void UpdateSalesLastTouchedDate(List<Account> accList)
	{
		Id profileId=userinfo.getProfileId();
		String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
		Id currentUserId = UserInfo.getUserId();
		
		for (Account a : accList)
		{
			UpdateSalesLastTouchedDate(a, profileName, currentUserId);
		}
	}
	
	/*public static void UpdateSalesLastTouchedDate(Account a)
	{
		Id profileId=userinfo.getProfileId();
		String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
		Id currentUserId = UserInfo.getUserId();
		system.debug('currentUserId = '+currentUserId);
		
		UpdateSalesLastTouchedDate(a, profileName, currentUserId);							
	}*/	
	
	private static void UpdateSalesLastTouchedDate(Account a, String profileName, Id currentUserId)
	{	
		System.debug('Setting Last Touched Date');
		
		if(profileName == Constants.BroadcastTransactionManager || profileName == Constants.BroadcastTransactionSalesUser || profileName == Constants.NewBizManager ||
		profileName == Constants.NewBizSalesUser || profileName == Constants.RenewalsManager || profileName == Constants.RenewalsSalesUser)
		{
			System.debug('Broadcast Profile');
			a.Sales_Last_Touched_Date__c = Date.today();
			if(profileName == Constants.NewBizManager || profileName == Constants.NewBizSalesUser)
			{
				a.New_Biz_Last_Touched_Date__c = Date.today();
				a.New_Biz_Rep__c = currentUserId;
			}
			else if(profileName == Constants.BroadcastTransactionManager || profileName == Constants.BroadcastTransactionSalesUser)
			{
				a.Broadcast_Last_Touched_Date__c = Date.today();
				a.Broadcast_Rep__c = currentUserId;
				System.debug('Broadcast Last Touched Date = ' + a.Broadcast_Last_Touched_Date__c );
			}						
		}					
	}
					
	public static ID ReturnAccountIdFromId(Id objectId)
	{
		if(string.valueOf(objectId).startsWith('001'))
		{
			return objectId;
		}//Check for account associated to contact
		else if(string.valueOf(objectId).startsWith('003'))
		{
			Contact c = UtilityClass.GetContact(objectId);
			
			return c.AccountId;
			//accountIds.Add(t.WhatId);					
		}//Check for account associated to opp
		else if(string.valueOf(objectId).startsWith('006'))
		{
			Opportunity o = UtilityClass.GetOpportunity(objectId);
			
			return o.AccountId;
		}//Check for account associated to quote
		else if(string.valueOf(objectId).startsWith('a0q'))
		{
			SBQQ__Quote__c q = UtilityClass.GetQuote(objectId);
			
			return q.SBQQ__Account__c;
		}
		
		return null;
	}		
}