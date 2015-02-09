public class OpportunityCache
{
	public static Map<Id, Account> accountsMap = null;
	public static Map<String, Contact> contactsMap = null;
	public static Map<ID, List<OpportunityLineItem>> lineItemsMap = null;
	public static Map<Id, SBQQ__Quote__c> quotesMap = null;
	public static Map<ID, OpportunityContactRole> primaryOcrMap = null;
	public static Map<ID, List<OpportunityContactRole>> ocrMap = null;
	public static Map<Id, User> usersMap = null;
	public static List<BDC_Activity_Type__c> activityTypesList = null;
	public static Map<ID, List<Competitor__c>> competitorsMap = null;
	public static Map<ID, List<Contract>> contractsMap = null;
	//public static Map<ID, Contract> contractMap = null;
	public static Map<Id, Contract> renewalContractMap = null;
		
	public static Id TaskRenewalRecordType = null;
	public static Id CaseTrainingRecordType = null;
	public static Id CaseClientServicesRecordType = null;
	public static Id CaseContractAdminRecordType = null;
	public static Id OpportunityNewBizRecordType = null;
	public static Id OpportunityRenewalsRecordType = null;
	public static Id OpportunityLockedNewBizRecordType = null;
	public static Id OpportunityLockedRenewalsRecordType = null;
	public static Id TaskClientServicesRecordType = null;
	public static Id salesforceAdminUser = null;
	public static Id defaultContractAdminUser = null;
	
	public static Id QuoteAdminRecordType = null;
	public static Id QuoteNewQuoteRecordType = null;
	public static Id QuoteBeforeApprovalsRecordType = null;
	public static Id QuoteAfterApprovalsRecordType = null;
	public static Id QuotePostSignatureRecordType = null;
	public static Id QuoteClosedRecordType = null;
	
	public static Id profileId = userinfo.getProfileId();	
	public static Id currentUserId = UserInfo.getUserId();
	public static String profileName = null;
	
	private static List<Opportunity> GenerateAccountsMapOppsList = new List<Opportunity>();
	private static List<Opportunity> GenerateContactMapOppsList = new List<Opportunity>();
	private static List<Opportunity> GenerateOpportunityLineItemMapList = new List<Opportunity>();
	private static List<Opportunity> GeneratePrimaryQuotesList = new List<Opportunity>();
	private static List<Opportunity> GenerateOCRList = new List<Opportunity>();
	private static List<Opportunity> GenerateCompetitorsList = new List<Opportunity>();
	private static List<Opportunity> GenerateRenewalContractList = new List<Opportunity>();
	private static List<Opportunity> GenerateContractsList = new List<Opportunity>();
		
	public static void GenerateAccountsMap(List<Opportunity> oppsList)
	{
		if (accountsMap == null || UtilityClass.HasListChanged(GenerateAccountsMapOppsList, oppsList))
		{
			Set<ID> accountIds = new Set<ID>();
			for (Opportunity opp: oppsList)
  			{
				System.Debug('ADDING Account Id ' + opp.AccountId);
    			accountIds.add(opp.AccountId);
  			}
  
  			accountsMap = new Map<ID, Account>([select Id, Plan_Customer__c, Connect_Customer__c, Monitoring_Customer__c, Analysis_Customer__c, Broadcast_Customer__c, Project_Lead__c, CS_Tier__c, Name, Renewal_Rep__r.Name, Required_Invoice_Contact_Email__c, Required_Invoice_Contact_Name__c, BillingState from Account where Id IN :accountIds]);
		
			System.debug('Accounts Map size = ' + accountsMap.size());
			GenerateAccountsMapOppsList.clear();
			GenerateAccountsMapOppsList.addAll(oppsList);
		}
	}

	public static void GenerateContactMap(List<Opportunity> oppsList)
	{
		if (contactsMap == null || UtilityClass.HasListChanged(GenerateContactMapOppsList, oppsList))
		{
			// Get all the Account Ids for the Opps
			Set<Id> accountIds = new Set<Id>();
			for (Opportunity o : oppsList)
			{
				if (o.AccountId != null)
				{
					accountIds.add(o.AccountId);
				}
			}
			
			// Get all Contacts for each of these accounts
			List<Contact> contList = [Select Id, AccountId, FirstName, LastName, Email, Phone from Contact where AccountId in :accountIds];
			contactsMap = new Map<String, Contact>();
			if (contList != null)
			{
				for (Contact c : contList)
				{
					String key = c.AccountId + '|' + c.LastName + '|' + c.Email;
					contactsMap.put(key, c);
				}
			}
			
			GenerateContactMapOppsList.clear();
			GenerateContactMapOppsList.addAll(oppsList);
		}
	}
	
	public static void GenerateOpportunityLineItemMap(List<Opportunity> oppsList)
	{
		if (lineItemsMap == null || UtilityClass.HasListChanged(GenerateOpportunityLineItemMapList, oppsList))
		{
			List<OpportunityLineItem> liList = [select Id, UnitPrice, OpportunityId, Product_Family__c, PriceBookEntry.Product2.ProductCode, TotalPrice, PriceBookEntry.Product2.Family, PricebookEntry.Product2.Name, PriceBookEntry.Product2.Edition__C, PriceBookEntry.Product2.Sub_Family__c from OpportunityLineItem where OpportunityId IN :oppsList];
			
			lineItemsMap = new Map<ID, List<OpportunityLineItem>>();
			
			if (liList != null)
			{
				for (OpportunityLineItem li : liList)
				{
					if (lineItemsMap.containsKey(li.OpportunityId))
					{
						lineItemsMap.get(li.OpportunityId).add(li);
					}
					else
					{
						List<OpportunityLineItem> tempLi = new List<OpportunityLineItem>();
						tempLi.add(li);
						lineItemsMap.put(li.OpportunityId, tempLi);
					}
				}
			}
			
			GenerateOpportunityLineItemMapList.clear();
			GenerateOpportunityLineItemMapList.addAll(oppsList);
		}
		
	}
	
	public static void GeneratePrimaryQuotes(List<Opportunity> oppsList)
	{
		if (quotesMap == null || UtilityClass.HasListChanged(GeneratePrimaryQuotesList, oppsList))
		{
			List<SBQQ__Quote__c> quoteList = [select Id, SBQQ__StartDate__c, SBQQ__Opportunity__c, SBQQ__PrimaryContact__c, Tax_Exempt__c, Change_Billing_Street__c, Change_Billing_City__c, Change_Billing_State__c, Change_Billing_Zip__c, Change_Billing_Country__c, Change_Invoice_Contact_Email__c, Change_Invoice_Contact_Name__c, Change_Invoice_Contact_Phone__c from SBQQ__Quote__c where SBQQ__Opportunity__c IN :oppsList and SBQQ__Primary__c = true];
			
			quotesMap = new Map<Id, SBQQ__Quote__c>();
			
			if (quoteList != null)
			{
				for (SBQQ__Quote__c q : quoteList)
				{
					quotesMap.put(q.SBQQ__Opportunity__c, q);
				}
			}
			
			GeneratePrimaryQuotesList.clear();
			GeneratePrimaryQuotesList.addAll(oppsList);
		}
	}
	
	public static void GenerateOCR(List<Opportunity> oppsList)
	{
		if (ocrMap == null || UtilityClass.HasListChanged(GenerateOCRList, oppsList))
		{
			List<OpportunityContactRole> ocrList = [Select Id, ContactId, OpportunityId, IsPrimary from OpportunityContactRole where OpportunityId IN :oppsList];
			ocrMap = new Map<ID, List<OpportunityContactRole>>();
			primaryOcrMap = new Map<ID, OpportunityContactRole>();
			
			if (ocrList != null)
			{						
				for (OpportunityContactRole ocr : ocrList)
				{
					if (ocrMap.containsKey(ocr.OpportunityId))
					{
						ocrMap.get(ocr.OpportunityId).add(ocr);	
					}
					else
					{
						List<OpportunityContactRole> tempList = new List<OpportunityContactRole>();
						tempList.add(ocr);
						ocrMap.put(ocr.OpportunityId, tempList);
					}
					
					if (ocr.IsPrimary)
					{
						primaryOcrMap.put(ocr.OpportunityId, ocr);
					}
				}
			}
			
			GenerateOCRList.clear();
			GenerateOCRList.addAll(oppsList);
		}
	}
	
	public static void GenerateRenewalContract(List<Opportunity> oppsList)
	{
		if (renewalContractMap == null || (renewalContractMap != null && renewalContractMap.values().size() == 0) || UtilityClass.HasListChanged(GenerateRenewalContractList, oppsList))
		{
			List<Contract> contList = [Select Id, SBQQ__RenewalOpportunity__c, SBQQ__Opportunity__r.OwnerId, SBQQ__Opportunity__r.Type, SBQQ__Opportunity__r.Last_Year_Spend__c from Contract where SBQQ__RenewalOpportunity__c in :oppsList];
			renewalContractMap = new Map<ID, Contract>();
			
			if (contList != null)
			{						
				for (Contract c : contList)
				{
					renewalContractMap.put(c.SBQQ__RenewalOpportunity__c, c);
				}
			}
			
			GenerateRenewalContractList.clear();
			GenerateRenewalContractList.addAll(oppsList);
		}
	}
	
	public static void GenerateUsersMap()
	{
		if (usersMap == null)
		{
			usersMap = new Map<Id, User>([Select Id, CA_Rep__c from User where IsActive = true]);
			profileName = [Select Id,Name from Profile where Id=:profileId].Name;
		}
	}
	
	public static void GenerateBDCList()
	{
		if (activityTypesList == null)
		{
			activityTypesList = [select Id, Name, Days_Months__c, From__c, New_Renewal_Customer__c, Number_of_Days_Months__c from BDC_Activity_Type__c];
		}
	}
	
	public static void GenerateRecordTypeIds()
	{
		if (TaskRenewalRecordType == null)
		{
			Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName();
			if(rtMapByName.containsKey(Constants.RecordTypeAdmin))
				QuoteAdminRecordType = rtMapByName.get(Constants.RecordTypeAdmin).getRecordTypeId();
			if(rtMapByName.containsKey(Constants.RecordTypeNewQuote))
				QuoteNewQuoteRecordType = rtMapByName.get(Constants.RecordTypeNewQuote).getRecordTypeId();
			if(rtMapByName.containsKey(Constants.RecordTypeBeforeApprovals))
				QuoteBeforeApprovalsRecordType = rtMapByName.get(Constants.RecordTypeBeforeApprovals).getRecordTypeId();
			if(rtMapByName.containsKey(Constants.RecordTypeAfterApprovals))
				QuoteAfterApprovalsRecordType = rtMapByName.get(Constants.RecordTypeAfterApprovals).getRecordTypeId();
			if(rtMapByName.containsKey(Constants.RecordTypePostSignature))
				QuotePostSignatureRecordType = rtMapByName.get(Constants.RecordTypePostSignature).getRecordTypeId();
			if(rtMapByName.containsKey(Constants.RecordTypeClosed))
				QuoteClosedRecordType = rtMapByName.get(Constants.RecordTypeClosed).getRecordTypeId();
			
			List<RecordType> rtList = [select Id, Name, SObjectType from RecordType where (SObjectType = 'Task' and (Name = 'Renewal Sales' or Name = 'Client Services')) or (SObjectType = 'Opportunity' and (Name = 'New Biz' or Name = 'Renewals' or Name = 'Locked New Biz' or Name = 'Locked Renewals')) or (SObjectType = 'Case' and (Name = 'Training' or Name = 'Contract Admin' or Name = 'Client Services'))];

			if (rtList != null && rtList.size() > 0)
			{
				for (RecordType r : rtList)
				{
					if (r.SObjectType == 'Task' && r.Name == 'Renewal Sales')
					{
						TaskRenewalRecordType = r.Id;
					}
					else if (r.SObjectType == 'Case' && r.Name == 'Training')
					{
						CaseTrainingRecordType = r.Id;
					}
					else if (r.SObjectType == 'Case' && r.Name == 'Client Services')
					{
						CaseClientServicesRecordType = r.Id;
					}
					else if (r.SObjectType == 'Task' && r.Name == 'Client Services')
					{
						TaskClientServicesRecordType = r.Id;
					}
					else if (r.SObjectType == 'Opportunity' && r.Name == 'New Biz')
					{
						OpportunityNewBizRecordType = r.Id;
					}
					else if (r.SObjectType == 'Opportunity' && r.Name == 'Renewals')
					{
						OpportunityRenewalsRecordType = r.Id;
					}
					else if (r.SObjectType == 'Opportunity' && r.Name == 'Locked New Biz')
					{
						OpportunityLockedNewBizRecordType = r.Id;
					}
					else if (r.SObjectType == 'Opportunity' && r.Name == 'Locked Renewals')
					{
						OpportunityLockedRenewalsRecordType = r.Id;
					}
					else if (r.SObjectType == 'Case' && r.Name == 'Contract Admin')
					{
						CaseContractAdminRecordType = r.Id;
					}
				}
			}
		}
	}
	
	public static void GenerateAdminUserId()
	{
		if (salesforceAdminUser == null)
		{
			List<User> adminUser = [Select Id, Name from User where Name = 'SFDC Admin' or Name = 'Meghan Manetti'];
			
			if (adminUser != null)
			{
				for (User u : adminUser)
				{
					if (u.Name == 'SFDC Admin')
					{
						salesforceAdminUser = u.Id;
					}
					else
					{
						defaultContractAdminUser = u.Id;
					}
				}
			}
		}
	}
	
	public static void GenerateCompetitors(List<Opportunity> oppsList)
	{
		if (competitorsMap == null || UtilityClass.HasListChanged(GenerateCompetitorsList, oppsList))
		{
			List<Competitor__c> compsList = [Select Id, Opportunity__c, Competitor_Name__c, Opportunity_Close__c from Competitor__c where Opportunity__c IN :oppsList];
			
			competitorsMap = new Map<ID, List<Competitor__c>>();
			
			if (compsList != null)
			{
				for (Competitor__c c : compsList)
				{
					if (competitorsMap.containsKey(c.Opportunity__c))
					{
						competitorsMap.get(c.Opportunity__c).add(c);
					}
					else
					{
						List<Competitor__c> tempCompList = new List<Competitor__c>();
						tempCompList.add(c);
						competitorsMap.put(c.Opportunity__c, tempCompList);
					}
				}
			}
			
			GenerateCompetitorsList.clear();
			GenerateCompetitorsList.addAll(oppsList);
		}
	}	
}