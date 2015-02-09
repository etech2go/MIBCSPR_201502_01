global class batchAccountProcessEmail implements Database.Batchable<sObject>
{
	global List<Account> accountsToProcess; 
	
	global batchAccountProcessEmail(){}
	private string query ='';
	global set<string> accName;
	
	global batchAccountProcessEmail(List<Account> accList)
	{
		accountsToProcess = accList;
     }
	
	global Database.QueryLocator start(Database.BatchableContext BC)     
  	{
		return Database.getQueryLocator([Select Id, Name from Account Limit 1]);	
	}
		
	global void execute(Database.BatchableContext bc, List<Account> scope)
	{	
		if (accountsToProcess.size() > 0){
			List<Account> accToUpdate = new List<Account>();
			List<Account> accToInsert = new List<Account>();
  		    //system.debug('*** List size '+ accountsToProcess.size());
			for (Account acc : accountsToProcess)
			{
				Account a = matchAccount(acc.Name.trim());
				if(a != null){
					
				  if ((a.CRM_Account_ID__c != '' && a.CRM_Account_ID__c != null)){
				  	   a.CRM_Account_ID__c = acc.CRM_Account_ID__c;
				  	   accToUpdate.add(a);
				  } 
				  else if ((a.Vocus_SFDC_Account_ID__c != '' && a.Vocus_SFDC_Account_ID__c != null) || (a.Vocus_Org_Id__c != '' && a.Vocus_Org_Id__c != null)){
			    	  a.Vocus_SFDC_Account_ID__c = acc.Vocus_SFDC_Account_ID__c;
			          a.Vocus_Org_Id__c = acc.Vocus_Org_Id__c;
			          accToUpdate.add(a);
				   }
				}
				else{
					system.debug('*** Account to INSERT**** '+ acc.Name);
					system.debug('*** Phone :'+ acc.Phone);
					system.debug('*** ShippingStreet :'+ acc.ShippingStreet);
					system.debug('*** ShippingCity :'+ acc.ShippingCity);
					system.debug('*** ShippingState :'+ acc.ShippingState);
					system.debug('***  ShippingPostalCode:'+ acc.ShippingPostalCode);
					system.debug('*** ShippingCountry :'+ acc.ShippingCountry);
					system.debug('***  Website:'+ acc.Website);
					system.debug('***  DUNS_Number__c:'+ acc.DUNS_Number__c);
					system.debug('***  Vocus_SFDC_Account_ID__c:'+ acc.Vocus_SFDC_Account_ID__c);
					system.debug('***  Vocus_Org_Id__c:'+ acc.Vocus_Org_Id__c);
					
					accToInsert.add(acc);
				}					
			}
			
			if(accToInsert.size() > 0){
				insert accToInsert;
			}
			
			if(accToUpdate.size() > 0){
				update accToUpdate;
			}
		}
	}
	
	global void finish(Database.BatchableContext bc)
	{
		 
	}
	
	
	private Account matchAccount(string accName){
		string aName = '%' + accName + '%';
		system.debug('***aName*** : '+ aName);
		if (accName != null && accName != ''){
		    List<Account> a = [Select Id, CRM_Account_ID__c, Vocus_SFDC_Account_ID__c, Vocus_Org_Id__c From Account Where Name like :aName Limit 1];
		    if (a.size() >0){
		        return a[0];
		    }
		    else{
		    	return null;
		    }
		}
		return null;
	}
	
}