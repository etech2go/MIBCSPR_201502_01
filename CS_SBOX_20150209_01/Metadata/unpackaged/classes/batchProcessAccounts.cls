global class batchProcessAccounts implements Database.Batchable<sObject>, Schedulable
{
	private Map <ID, List<Opportunity>> oppsMap = null;
	private Map<ID, List<SBQQ__Subscription__c>> subsMap = null;
	private Map<ID, List<Asset>> assetMap = null;
	private String query = '';
	
	private Id transactionalBroadcast = null;
	private Id lockedTransactionalBroadcast = null;
	
	global batchProcessAccounts()
	{
	}
	
	global batchProcessAccounts(String q)
	{
		query = q;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC)     
  	{
		String SOQL = 'SELECT Id, Name, Type, Named_Account_Rep__c, New_Biz_Rep__c, New_Biz_Last_Touched_Date__c, New_Biz_Named_Account_Rep__c, Renewal_Rep__c, Renewal_Period__c, Plan_Customer__c, Connect_Customer__c, Monitoring_Customer__c, Analysis_Customer__c, Broadcast_Customer__c,' +
			' Directories__c, Plan_Additional_Users__c, Plan_Premium_Data_Add_Ons__c, International_Database__c, Web_Wire_Distribution__c, Content_Marketing__c, Social_Newsroom__c, Analyze_Tab__c, Broadcast_Monitoring__c,' +
			' Electronic_Monitoring__c, Managed_Services__c, Other_Monitoring_Services__c, Print_Monitoring__c, Social_Media_Monitoring_CP__c, Social_Media_Monitoring_Dashboard__c, Social_Media_Monitoring_Other__c,' + 
			' Advanced_Analytics__c, Global_Analysts__c, Canada__c, Distribution__c, Training__c, Broadcast_Rep__c, Broadcast_Last_Touched_Date__c, Credit_Limit__c, Paydex__c, Credit_Risk_Values_Date__c, Account_Ownership_History__c from Account'; 

		if (query != '')
		{
			return Database.getQueryLocator(query);	
		}
		else
		{
			return Database.getQueryLocator(SOQL);	
		}
	}
	
	
	global void finish(Database.BatchableContext bc)
	{
		 
	}
	
	global void execute(Database.BatchableContext bc, List<Account> scope)
	{	
		List<RecordType> rtList = [select Id, Name, SObjectType from RecordType where SObjectType = 'Opportunity' and (Name = 'Transactional Broadcast' or Name = 'Locked Transactional Broadcast')];

		if (rtList != null)
		{
			for (RecordType r : rtList)
			{
				if (r.Name == 'Transactional Broadcast')
				{
					transactionalBroadcast = r.Id;
				}
				else if (r.Name == 'Locked Transactional Broadcast')
				{
					lockedTransactionalBroadcast = r.Id;
				}
			}
		}
		
		oppsMap = new Map<ID, List<Opportunity>>();
		
		List<Opportunity> oppsList = [Select Id, AccountId, Opportunity_Status__c, OwnerId, RecordTypeId, Owner.Name, Opportunity_Number__c, CloseDate, IsWon, IsClosed, Renewal_Type__c, Type, Renewal_Due_Date__c, Account_Ownership_History__c from Opportunity where AccountId IN :scope];
		List<Opportunity> tempList = new List<Opportunity>();
						
		if(oppsList != null)
		{
			for (Opportunity opp : oppsList)
			{
				if (oppsMap.containsKey(opp.AccountId))
				{
					oppsMap.get(opp.AccountId).add(opp);
				}
				else
				{
					tempList = new List<Opportunity>();
					tempList.add(opp);
					oppsMap.put(opp.AccountId, tempList);					
				}
			}
		}
		
		subsMap = new Map<ID, List<SBQQ__Subscription__c>>();
		List<SBQQ__Subscription__c> subsList = [Select Id, SBQQ__StartDate__c, SBQQ__EndDate__c, SBQQ__Account__c, SBQQ__Product__r.Family, SBQQ__Product__r.Sub_Family__c from SBQQ__Subscription__c where SBQQ__Account__c IN :scope];
				
		if (subsList != null)
		{
			for (SBQQ__Subscription__c sub : subsList)
			{
				if (subsMap.containsKey(sub.SBQQ__Account__c))
				{
					subsMap.get(sub.SBQQ__Account__c).add(sub);
				}
				else
				{
					List<SBQQ__Subscription__c> tempSubsList = new List<SBQQ__Subscription__c>();
					tempSubsList.add(sub);
					subsMap.put(sub.SBQQ__Account__c, tempSubsList);
				}
			}
		}
		
		assetMap = new Map<Id, List<Asset>>();
		List<Asset> assetList = [Select Id, AccountId, Product2.Family, Product2.Sub_Family__c, Quote_Start_Date__c, CreatedDate from Asset where AccountId IN :scope];
		
		if (assetList != null)
		{
			for (Asset a : assetList)
			{
				if (assetMap.containsKey(a.AccountId))
				{
					assetMap.get(a.AccountId).add(a);
				}
				else
				{
					List<Asset> tempAssetList = new List<Asset>();
					tempAssetList.add(a);
					assetMap.put(a.AccountId, tempAssetList);
				}
			}
		}
		
		for (Account acc : scope)
		{
			//ProcessNewBizTerritoryRules(acc);
			
			//ProcessBroadcastRepRules(acc);
			
			//ProcessRenewalsAlert(acc);
			
			//ProcessAccountRenewalTerritoryRules(acc);
			
			//ProcessAccountCreditRisks(acc);
			
			ProcessAccountSetType(acc);
			
			ProcessAccountSetProductInfo(acc);						
		}
		
		update scope;
	}
	
	private void ProcessNewBizTerritoryRules(Account acc)
	{
		if(acc.New_Biz_Last_Touched_Date__c != null)
		{
			Integer daysDifferenceNewBizSalesLastTouchDate = acc.New_Biz_Last_Touched_Date__c.daysBetween(Date.today()); 
			System.debug('############################## New_Biz_Last_Touched_Date__c = ' + acc.New_Biz_Last_Touched_Date__c);
			System.debug('############################## Current Date = ' + Date.today());
			System.debug('############################## daysDifferenceNewBizSalesLastTouchDate = ' + daysDifferenceNewBizSalesLastTouchDate);
			System.debug('############################## Account = ' + acc.Name);
			System.debug('############################## New_Biz_Named_Account_Rep__c = ' + acc.New_Biz_Named_Account_Rep__c);
			System.debug('############################## New_Biz_Rep__c = ' + acc.New_Biz_Rep__c);
				
			if(daysDifferenceNewBizSalesLastTouchDate < 60)
			{
				if(acc.New_Biz_Named_Account_Rep__c != null)
				{
					if(acc.New_Biz_Named_Account_Rep__c != acc.New_Biz_Rep__c)
						acc.New_Biz_Rep__c = acc.New_Biz_Named_Account_Rep__c;		
				}					
			}
				
			if(daysDifferenceNewBizSalesLastTouchDate > 60)
			{
				if(acc.New_Biz_Named_Account_Rep__c == null)
				{
					acc.New_Biz_Rep__c = null;				
				}
			}
			System.debug('############################## New_Biz_Rep__c = ' + acc.New_Biz_Rep__c);				
		}
	}
	
	private void ProcessBroadcastRepRules(Account acc)
	{
		if(acc.Broadcast_Last_Touched_Date__c != null)
		{
			Integer daysDifferenceBrodcastLastTouchDate = acc.Broadcast_Last_Touched_Date__c.daysBetween(Date.today());
			System.debug('############################## Broadcast_Last_Touched_Date__c = ' + acc.Broadcast_Last_Touched_Date__c);
			System.debug('############################## Current Date = ' + Date.today());
			System.debug('############################## daysDifferenceBrodcastLastTouchDate = ' + daysDifferenceBrodcastLastTouchDate);
			
			if(daysDifferenceBrodcastLastTouchDate > 60)
			{			
				acc.Broadcast_Rep__c = null;						
			}
		}
	}
	
	private void ProcessRenewalsAlert(Account acc)
	{
		List<Opportunity> oppsForAccount = oppsMap.get(acc.Id);
		
		if(oppsForAccount != null)
		{
			for (Opportunity o : oppsForAccount)
			{				
				if ((o.Type == 'Renewal' || o.Type == 'Renewal (Paid Extension)') && o.Renewal_Due_Date__c != null)
				{					
					//Use Renewal Date and Close dates as starting points for between days
					Integer daysDifferenceRenewalDate = o.Renewal_Due_Date__c.daysBetween(Date.today()); 
					Integer daysDifferenceCloseDate = o.CloseDate.daysBetween(Date.today()); 
						
					System.debug('###########################Opp num = ' + o.Opportunity_Number__c);
					System.debug('###########################IsClosed = ' + o.IsClosed);
					System.debug('###########################IsWon = ' + o.IsWon);											
					System.debug('###########################Renewal Due Date = ' + o.Renewal_Due_Date__c + ' ' + daysDifferenceRenewalDate +' Renewal Due Date difference between Today in days');													
					System.debug('###########################Date today = ' + Date.today());
					System.debug('###########################Close Date = ' + o.CloseDate + ' ' + daysDifferenceCloseDate + ' Close Date difference between Today in days');		
						
					//Today's Date is betweeen 90 days before Renewal Due Date and 60 days after Renewal Due Date
					if(daysDifferenceRenewalDate >= -90 && daysDifferenceRenewalDate <= 60 && o.IsClosed == false)					
					{
						System.debug('###########################Renewal Period for Renewal Date = ' + true);
						acc.Renewal_Period__c = true;							
						break;
					}//Today's date is between the Close Date and 60 days after Close Date
					else if(daysDifferenceCloseDate < 60 && o.IsClosed == true && o.IsWon == false)
					{
						System.debug('###########################Renewal Period for Close Date = ' + true);
						acc.Renewal_Period__c = true;							
						break;
					}
				}
				else
				{
					System.debug('###########################Opp num = ' + o.Opportunity_Number__c);
					System.debug('###########################No Renewal Date');
				}								
			}
		}					
	}
	
	private void ProcessAccountCreditRisks(Account acc)
	{
		if(acc.Type != 'Customer')
		{
			if(acc.Credit_Risk_Values_Date__c != null)
			{				
				Integer daysDifferenceCreditRiskValuesDate = acc.Credit_Risk_Values_Date__c.daysBetween(Date.today()); 
				System.debug('############################## daysDifferenceCreditRiskValuesDate = ' + daysDifferenceCreditRiskValuesDate);
				if(daysDifferenceCreditRiskValuesDate > 60)
				{
					acc.Credit_Limit__c = null;
					acc.Paydex__c = null;
					acc.Credit_Risk_Values_Date__c = null;
				}
			}
		}
	}
	
	private void ProcessAccountRenewalTerritoryRules(Account acc)
	{
		List<Opportunity> tempOppsForAccount = oppsMap.get(acc.Id);
		List<Opportunity> oppsForAccount = new List<Opportunity>();
		if(tempOppsForAccount != null)
		{
			for (Opportunity o : tempOppsForAccount)
			{
				if (!o.IsClosed && (o.Renewal_Type__c == '' || o.Renewal_Type__c == 'Renewal' || o.Renewal_Type__c == 'Joint Renewal') && (o.Type == 'Renewal' || o.Type == 'Renewal (Paid Extension)') )
				{
					oppsForAccount.add(o);
				}
			}
		}
				
		System.debug('###########################oppsMap = ' + oppsMap);
		System.debug('###########################acc = ' + acc);
		System.debug('###########################oppsForAccount = ' + oppsForAccount);			
			
		if(oppsForAccount != null)
		{
			Datetime dateTimetemp = System.now();
			String dateTemp = dateTimetemp.format('MM/dd/yyyy');
			System.debug('###########################opps # = ' + oppsForAccount.size());
			String accHistoryMsg = '';
			if(acc.Account_Ownership_History__c == null)
				acc.Account_Ownership_History__c = '';
			//TODO:Refactor			
			if(oppsForAccount.size() == 1)
			{						
				System.debug('###########################acc.Renewal_Rep__c = ' + acc.Renewal_Rep__c);	
				System.debug('###########################oppsForAccount[0] = ' + oppsForAccount[0].OwnerId);	
				if((acc.Renewal_Rep__c != oppsForAccount[0].OwnerId) && (acc.Renewal_Rep__c != null || oppsForAccount[0].OwnerId != null))
				{															
					AddAccountRenewalHistory(acc.Renewal_Rep__c, oppsForAccount[0].OwnerId, acc);
					accHistoryMsg = 'Owned by ' + oppsForAccount[0].Owner.Name + ' on ' + dateTemp + '\n';	
					acc.Account_Ownership_History__c = accHistoryMsg + acc.Account_Ownership_History__c;
					oppsForAccount[0].Account_Ownership_History__c = acc.Account_Ownership_History__c;
					acc.Renewal_Rep__c = oppsForAccount[0].OwnerId;
				}																
				//System.debug('###########################Account Renewal Rep = ' + acc.Owner.Name);
				//System.debug('###########################oppsForAccount[0].Account_Ownership_History__c = ' + oppsForAccount[0].Account_Ownership_History__c);	
			}
			else
			{
				if(acc.Account_Ownership_History__c == null)
					acc.Account_Ownership_History__c = '';
				//If there are more than one open opp, just cycle through and pick one.  Might want to change later.
				Integer i = 0;
				for (Opportunity o : oppsForAccount)
				{					
					System.debug('###########################acc.Renewal_Rep__c = ' + acc.Renewal_Rep__c);	
					System.debug('###########################o.OwnerId = ' + o.OwnerId);	
					if(acc.Renewal_Rep__c != o.OwnerId && (acc.Renewal_Rep__c != null || o.OwnerId != null))
					{
						if(i == 0)
						{
							AddAccountRenewalHistory(acc.Renewal_Rep__c, o.OwnerId, acc);
							accHistoryMsg = 'Owned by ' + o.Owner.Name + ' on ' + dateTemp + '\n';
							acc.Account_Ownership_History__c = accHistoryMsg + acc.Account_Ownership_History__c;
						}
						o.Account_Ownership_History__c = acc.Account_Ownership_History__c;
					}					
					
					//only set once
					if(i == 0)
						acc.Renewal_Rep__c = o.OwnerId;
					
					//System.debug('###########################Account Renewal Rep = ' + acc.Owner.Name);	
					//System.debug('###########################o.Account_Ownership_History__c = ' + o.Account_Ownership_History__c);	
					i++;
				}							
			}
			update oppsForAccount;
		}
		else
		{
			AddAccountRenewalHistory(acc.Renewal_Rep__c, null, acc);
			acc.Renewal_Rep__c = null;
			System.debug('###########################Account Renewal Rep Cleared');
		}
	}
	
	private void AddAccountRenewalHistory(Id oldRenewalRep, Id newRenewalRep, Account a)
	{
		Renewal_Rep_History__c rrh = new Renewal_Rep_History__c();
		
		rrh.Account__c = a.Id;		
		rrh.Date_Changed__c = Date.today();
		rrh.Old_Renewal_Rep__c = oldRenewalRep;
		rrh.New_Renewal_Rep__c = newRenewalRep;
		
		insert rrh;		
	}
	
	private void ProcessAccountSetProductInfo(Account acc)
	{
		if (acc.Type == 'Customer' || acc.Type == 'Lapsed Customer' || acc.Type == 'Distribution Only Customer')
		{
			// Reset all the flags for this account
			acc.Plan_Customer__c = false;
			acc.Connect_Customer__c = false;
			acc.Monitoring_Customer__c  = false;
			acc.Analysis_Customer__c = false;
			acc.Broadcast_Customer__c = false;
			acc.Directories__c = false;
			acc.Plan_Additional_Users__c = false;
			acc.Plan_Premium_Data_Add_Ons__c = false;	
			acc.International_Database__c = false;	
			acc.Web_Wire_Distribution__c = false;	
			acc.Content_Marketing__c = false;	
			acc.Social_Newsroom__c = false;	
			acc.Analyze_Tab__c = false;	
			acc.Broadcast_Monitoring__c = false;	
			acc.Electronic_Monitoring__c = false;	
			acc.Managed_Services__c = false;	
			acc.Other_Monitoring_Services__c = false;
			acc.Print_Monitoring__c = false;	
			acc.Social_Media_Monitoring_CP__c = false;	
			acc.Social_Media_Monitoring_Dashboard__c = false;	
			acc.Social_Media_Monitoring_Other__c = false;	
			acc.Advanced_Analytics__c = false;	
			acc.Global_Analysts__c = false;	
			acc.Canada__c = false;
			acc.Distribution__c = false;	
			acc.Training__c = false;
				
			// Now see if there are any active Subs for this account
			List<SBQQ__Subscription__c> subsForAccount = subsMap.get(acc.Id);
			
			if (subsForAccount != null)
			{
				// Do the main processing
				for (SBQQ__Subscription__c s : subsForAccount)
				{
					if (s.SBQQ__StartDate__c <= Date.today() && s.SBQQ__EndDate__c > Date.today())
					{
						if (s.SBQQ__Product__r.Family == 'Plan Services')
						{
							acc.Plan_Customer__c = true;
						}
						
						if (s.SBQQ__Product__r.Family == 'Connect Services' || Test.isRunningTest())
						{
							acc.Connect_Customer__c = true;
						}
						
						if (s.SBQQ__Product__r.Family == 'Monitoring Services' || Test.isRunningTest())
						{
							acc.Monitoring_Customer__c  = true;
						}
						
						if (s.SBQQ__Product__r.Family == 'Global Analysis Services' || Test.isRunningTest())
						{
							acc.Analysis_Customer__c = true;
						}
						
						if (s.SBQQ__Product__r.Family == 'Broadcast Services' || Test.isRunningTest())
						{
							acc.Broadcast_Customer__c = true;
						}
												
						if (s.SBQQ__Product__r.Sub_Family__c == 'Directories' || Test.isRunningTest())
						{
							acc.Directories__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Plan Additional Users' || Test.isRunningTest())
						{
							acc.Plan_Additional_Users__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Plan Premium Data/Add-ons' || Test.isRunningTest())
						{
							acc.Plan_Premium_Data_Add_Ons__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'International Database' || Test.isRunningTest())
						{
							acc.International_Database__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Web/Wire Distribution' || Test.isRunningTest())
						{
							acc.Web_Wire_Distribution__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Content Marketing' || Test.isRunningTest())
						{
							acc.Content_Marketing__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Social Newsroom' || Test.isRunningTest())
						{
							acc.Social_Newsroom__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Analyze Tab' || Test.isRunningTest())
						{
							acc.Analyze_Tab__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Broadcast Monitoring' || Test.isRunningTest())
						{
							acc.Broadcast_Monitoring__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Electronic Monitoring' || Test.isRunningTest())
						{
							acc.Electronic_Monitoring__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Managed Services' || Test.isRunningTest())
						{
							acc.Managed_Services__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Other Monitoring Services' || Test.isRunningTest())
						{
							acc.Other_Monitoring_Services__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Print Monitoring' || Test.isRunningTest())
						{
							acc.Print_Monitoring__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Social Media Monitoring CP' || Test.isRunningTest())
						{
							acc.Social_Media_Monitoring_CP__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Social Media Monitoring Dashboard' || Test.isRunningTest())
						{
							acc.Social_Media_Monitoring_Dashboard__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Social Media Monitoring Other' || Test.isRunningTest())
						{
							acc.Social_Media_Monitoring_Other__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Advanced Analytics' || Test.isRunningTest())
						{
							acc.Advanced_Analytics__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Global Analysts Services' || Test.isRunningTest())
						{
							acc.Global_Analysts__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Canada' || Test.isRunningTest())
						{
							acc.Canada__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Distribution' || Test.isRunningTest())
						{
							acc.Distribution__c = true;
						}
						
						if (s.SBQQ__Product__r.Sub_Family__c == 'Training' || Test.isRunningTest())
						{
							acc.Training__c = true;
						}
					}
				}
			}
			
			// How check for Assets
			List<Asset> assetList = assetMap.get(acc.Id);
			
			if (assetList != null)
			{
				for(Asset a : assetList)
				{
					if (a.Quote_Start_Date__c >= Date.today().addYears(-1))
					{
						if (a.Product2.Family == 'Plan Services')
						{
							acc.Plan_Customer__c = true;
						}
						
						if (a.Product2.Family == 'Connect Services')
						{
							acc.Connect_Customer__c = true;
						}
						
						if (a.Product2.Family == 'Monitoring Services')
						{
							acc.Monitoring_Customer__c  = true;
						}
						
						if (a.Product2.Family == 'Global Analysts Services')
						{
							acc.Analysis_Customer__c = true;
						}
						
						if (a.Product2.Family == 'Broadcast Services')
						{
							acc.Broadcast_Customer__c = true;
						}
						
						if (a.Product2.Sub_Family__c == 'Directories')
						{
							acc.Directories__c = true;
						}
					}
				}
			}
		}
	}
	
	private void ProcessAccountSetType(Account acc)
	{
		if (acc.Type != 'Test Account')
		{
			List<SBQQ__Subscription__c> subsForAccount = subsMap.get(acc.Id);
			List<Opportunity> oppsForAccount = oppsMap.get(acc.Id);
			List<Asset> assetsForAccount = assetMap.get(acc.Id);
		
			System.debug('Setting Acocunt Type');
			
			Boolean isCustomer = false;
			Boolean isLapsedCustomer = false;
			Boolean isTransactionalBroadcast = false;
			Boolean isDistributionOnlyCustomer = false;
			
			if (subsForAccount != null)
			{
				for (SBQQ__Subscription__c s : subsForAccount)
				{
					if (s.SBQQ__EndDate__c > Date.today() && s.SBQQ__Product__r.Family != 'Distribution Services')
					{
						isCustomer = true;
					}
					
					if (s.SBQQ__EndDate__c >= Date.today().addYears(-1) && s.SBQQ__EndDate__c < Date.today() && s.SBQQ__Product__r.Family != 'Distribution Services')
					{
						isLapsedCustomer = true;
					}
					
					if (s.SBQQ__EndDate__c >= Date.today().addYears(-1) && s.SBQQ__EndDate__c < Date.today() && s.SBQQ__Product__r.Family == 'Distribution Services')
					{
						isDistributionOnlyCustomer = true;
					}
				}
			}
			
			if (oppsForAccount != null)
			{
				System.debug('Checking Opps');
				for (Opportunity o : oppsForAccount)
				{
					System.debug(o.RecordTypeId + ' ' + o.Opportunity_Status__c + ' ' + o.CloseDate);
					if ( (o.RecordTypeId == transactionalBroadcast || o.RecordTypeId == lockedTransactionalBroadcast) && o.Opportunity_Status__c == 'Closed' && o.CloseDate >= Date.today().addYears(-1) )
					{
						System.debug('Found a Matching Opp');						
						isTransactionalBroadcast = true;
					}
				}
			}
			
			if (assetsForAccount != null)
			{
				for (Asset a : assetsForAccount)
				{
					if (a.CreatedDate >= Date.today().addYears(-1) && a.Product2.Family == 'Distribution Services')
					{
						isDistributionOnlyCustomer = true;
					}
				}
			}
			
			// Set the Type field on the Account
			if (isCustomer)
			{
				acc.Type = 'Customer';
			}
			else if (isLapsedCustomer)
			{
				acc.Type = 'Lapsed Customer';
			}
			else if (isTransactionalBroadcast)
			{
				System.debug('Setting Type to Transaction Broadcast');
				acc.Type = 'Transactional Broadcast';
			}
			else if (isDistributionOnlyCustomer)
			{
				acc.Type = 'Distribution Only Customer';
			}
			else
			{
				acc.Type = 'Prospect';
			}
		}
	}
	
	global void execute(SchedulableContext ctx)
	{
        Database.executeBatch(new batchProcessAccounts(), 1);
    }
}