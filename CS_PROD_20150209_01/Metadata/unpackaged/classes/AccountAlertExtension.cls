public with sharing class AccountAlertExtension{
	public Boolean DisplayPopUp {get; set;}
	public Account acct {get; set;}
	
	public AccountAlertExtension(ApexPages.StandardController controller) 
    {
		 //  Get the Account Record
		
		String accountid = ApexPages.currentPage().getParameters().get('aid');
		//System.debug(accountid);
		
		if(accountid != null)
		{
			acct =  [select Id, Name, Renewal_Info__c, Collections_Info__c, Renewal_Period__c, New_Biz_Info__c, Client_Services_Info__c, Extensions_Info__c, Credit_Hold__c, P_O_Required__c, 
			LexisNexis_Named_Account__c, QuickShare_Account__c, AR_Rep__c, New_Biz_Named_Account_Rep__r.Name, Renewals_Named_Account_Rep__r.Name, Do_Not_Sell__c from Account where Id = :accountid]; //accountid
		}
		else
		{
			acct = (Account)controller.getRecord();		
			acct =  [select Id, Name, Renewal_Info__c, Renewal_Period__c, Collections_Info__c, New_Biz_Info__c, Client_Services_Info__c, Extensions_Info__c, Credit_Hold__c, P_O_Required__c, 
			LexisNexis_Named_Account__c, QuickShare_Account__c, AR_Rep__c,  New_Biz_Named_Account_Rep__r.Name, Renewals_Named_Account_Rep__r.Name, Do_Not_Sell__c from Account where Id = :acct.Id]; //accountid
		}
		
		//System.debug(acct);		   	  	
	}

}