public class OpportunityHelper
{
	public static boolean isQuoteSubmittedForApproval = false;
	public static List<SObject> objectsToInsert = new List<SObject>();
    public static List<SObject> objectsToUpdate = new List<SObject>();
	
	public static void SendGASorManagedServicesEmail(List<Opportunity> oppsList)
	{
		OpportunityCache.GenerateOpportunityLineItemMap(oppsList);
        OpportunityCache.GenerateAccountsMap(oppsList);
		OpportunityCache.GeneratePrimaryQuotes(oppsList);
		
		for (Opportunity opp : oppsList)
		{
			if (opp.StageName == 'Closed Won' && !opp.GAS_or_Managed_Service_Check__c)
			{
                Account acc = OpportunityCache.accountsMap.get(opp.AccountId);
				SBQQ__Quote__c primQuote = OpportunityCache.quotesMap.get(opp.Id);
				List<OpportunityLineItem> liList = OpportunityCache.lineItemsMap.get(opp.Id);
				Boolean GAS = false;
				Boolean managedServices = false;
				String msProductsList = '';
                String nonMSProductsList = '';
				String gasProductsList = '';
                 
				if (liList != null && primQuote != null && primQuote.SBQQ__StartDate__c != null)
				{
					for (OpportunityLineItem li : liList)
					{
						if (li.PriceBookEntry.Product2.Sub_Family__c == 'Global Analysts Services')
						{
							GAS = true;
							
							if (gasProductsList != '')
	                        {
	                            gasProductsList += '<tr><td>   </td>';  
	                        }
	                        
	                        gasProductsList += '<td>' + li.PriceBookEntry.Product2.Name + '</td></tr>';
						}
	                                        
						if (li.PriceBookEntry.Product2.Sub_Family__c == 'Managed Services')
						{
							managedServices = true;
	                        
	                        if (msProductsList != '')
	                        {
	                            msProductsList += '<tr><td>   </td>';  
	                        }
	                        
	                        msProductsList += '<td>' + li.PriceBookEntry.Product2.Name + ' - $' + li.UnitPrice + '</td></tr>';
						}
	                    else
	                    {
	                        if (nonMSProductsList != '')
	                        {
	                            nonMSProductsList += '<tr><td></td>';  
	                        }
	                        
	                        nonMSProductsList += '<td>' + li.PriceBookEntry.Product2.Name + '</td></tr>';
	                    }
					}
				}
				
                if (nonMSProductsList == '')
                {
                	nonMSProductsList = '<td></td></tr>';    
                }
				               
                String emailBody = '';
                String subject = '';
                
				if (GAS)
				{
					String projectLead = acc.Project_Lead__c;
					if (projectLead == null || projectLead == '')
					{
						projectLead = acc.CS_Tier__c;	
					}
					
					String productLines = '';
					if (acc.Plan_Customer__c)
					{
						productLines += 'Plan ';
					}
					if (acc.Connect_Customer__c)
					{
						productLines += 'Connect ';
					}
					if (acc.Monitoring_Customer__c)
					{
						productLines += 'Monitor ';
					}
					if (acc.Analysis_Customer__c)
					{
						productLines += 'Analyze ';
					}
					if (acc.Broadcast_Customer__c)
					{
						productLines += 'Broadcast ';
					}
					
					subject = 'An Order that contains Analysis products has just been processed in Salesforce - ' + acc.Name;
					emailBody = '<b><U>CGA Information</B></U><BR/><BR/>';
					emailBody += '<table><tr><td><B>Account Name:</B></td><td>' + acc.Name + '</td></tr>';
					emailBody += '<tr><td><B>Total Amount:</B></td><td>$' + opp.Amount + '</td></tr>';
					emailBody += '<tr><td><B>Project Lead:</B></td><td>' + projectLead + '</td></tr>';
					emailBody += '<tr><td><B>Contract Start Date:</B></td><td>' + primQuote.SBQQ__StartDate__c.Month() + '/' + primQuote.SBQQ__StartDate__c.Day() + '/' + primQuote.SBQQ__StartDate__c.Year() + '</td></tr>';
					emailBody += '<tr><td><B>Products:</B></td>' + gasProductsList;
					emailBody += '<tr><td><B>Product Lines:</B></td><td>' + productLines + '</td></tr></table><br/>';
				
					System.Debug('##########################################Email Body = ' + emailBody);
	                if (Constants.IsProduction())
	                {
	                	emailBody += '<a href="https://na14.salesforce.com/' + opp.Id + '">Click here to view the Opportunity in Salesforce</a>';
	                }   
	                else
	                {
	                    emailBody += '<a href="https://cs21.salesforce.com/' + opp.Id + '">Click here to view the Opportunity in Salesforce</a>';
	                }
					                
	                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	          		mail.setHtmlBody(emailBody);
	          		mail.setSubject(subject);
	    
	          		List<String> emailRecipients = new List<String>();
	    
					if (Constants.IsProduction())
					{
	                	emailRecipients.add('Craig.Mitchell@cision.com');
						emailRecipients.add('Joris.Nefs@cision.com');
 						emailRecipients.add('Linda.Mantegani@cision.com');
						emailRecipients.add('Mathilda.Joubert@cision.com');
 						emailRecipients.add('Troy.Gilbert@cision.com');
						emailRecipients.add('Wayne.Bullock@cision.com');
					}
					else
					{
						emailRecipients.add('mark.doggett@cision.com');
					}
					
					mail.setToAddresses(emailRecipients);
	          		mail.setSaveAsActivity(false);
	          		mail.setUseSignature(false);
	    
	          		if (!Test.isRunningTest())
	          		{
	            		System.debug('Sending Email');
	            		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	            		System.debug('Email Sent');
	          		}
				}
				
				if (managedServices)
				{
                    subject = 'Salesforce Order Processed - ' + acc.Name;
					emailBody = '<b><U>Managed Services Information</B></U><BR/><BR/>';
                    emailBody += '<table><tr><td><B>Account Name:</B></td><td>' + acc.Name + '</td></tr>';
                    emailBody += '<tr><td><B>Date Order was Submitted:</B></td><td>' + opp.CloseDate.Month() + '/' + opp.CloseDate.Day() + '/' + opp.CloseDate.Year() + '</td></tr>';
                    emailBody += '<tr><td><B>Managed Services Products:</B></td>' + msProductsList;
                    emailBody += '<tr><td><B>Other Products:</B></td>' + nonMSProductsList;
                    emailBody += '<tr><td><B>Salesperson:</B></td><td>' + opp.Owner.Name + '</td></tr>';
                    emailBody += '<tr><td><B>Opportunity Type:</B></td><td>' + opp.Type + '</td></tr>';
                    emailBody += '<tr><td><B>Renewal Salesperson:</B></td><td>' + acc.Renewal_Rep__r.Name + '</td></tr></table><br/>';
                   
					System.Debug('##########################################Email Body = ' + emailBody);
	                if (Constants.IsProduction())
	                {
	                	emailBody += '<a href="https://na14.salesforce.com/' + opp.Id + '">Click here to view the Opportunity in Salesforce</a>';
	                }   
	                else
	                {
	                    emailBody += '<a href="https://cs21.salesforce.com/' + opp.Id + '">Click here to view the Opportunity in Salesforce</a>';
	                }
					                
	                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	          		mail.setHtmlBody(emailBody);
	          		mail.setSubject(subject);
	    
	          		List<String> emailRecipients = new List<String>();
	    
					if (Constants.IsProduction())
					{
	                	emailRecipients.add('ManagedServices@cision.com');
					}
					else
					{
						emailRecipients.add('mark.doggett@cision.com');
					}
					
					mail.setToAddresses(emailRecipients);
	          		mail.setSaveAsActivity(false);
	          		mail.setUseSignature(false);
	    
	          		if (!Test.isRunningTest())
	          		{
	            		System.debug('Sending Email');
	            		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	            		System.debug('Email Sent');
	          		}
				}
				
				
        
				opp.GAS_or_Managed_Service_Check__c = true;
			}
		}
	}
	
	public static void UpdateInvoiceDetails(List<Opportunity> oppsList, Map<Id, Opportunity> oldOpps, Boolean isBefore)
	{
		Set<ID> accountIds = new Set<ID>();
		for (Opportunity opp: oppsList)
  		{
			if (opp.AccountId != null)
			{
				accountIds.add(opp.AccountId);
			}
  		}
  
  		Map<ID, Account> accountsMap = new Map<ID, Account>([select Id, Plan_Customer__c, Connect_Customer__c, Monitoring_Customer__c, Analysis_Customer__c, Broadcast_Customer__c, Project_Lead__c, CS_Tier__c, Name, Renewal_Rep__r.Name, Required_Invoice_Contact_Email__c, Required_Invoice_Contact_Name__c, BillingState from Account where Id IN :accountIds]);
			
		for (Opportunity opp : oppsList)
		{
			Account acc = accountsMap.get(opp.AccountId);
			
			Opportunity oldOpp = oldOpps.get(opp.Id);
				
			if (opp.Opportunity_Status__c != null)
			{
				// Update the Opp status if moving to Pending from another Status
			   	if ((oldOpp.Opportunity_Status__c == null || !oldOpp.Opportunity_Status__c.startsWith('Pending')) && opp.Opportunity_Status__c.startsWith('Pending'))
			   	{
			       	if (acc.Required_Invoice_Contact_Email__c != null && acc.Required_Invoice_Contact_Email__c != '')
			       	{
			       		opp.Invoice_Contact_Email__c = acc.Required_Invoice_Contact_Email__c;
			       	}
			        
			       	if (acc.Required_Invoice_Contact_Name__c != null && acc.Required_Invoice_Contact_Name__c != '')
			       	{
			       		opp.Invoice_Contact_Name__c = acc.Required_Invoice_Contact_Name__c;
			       	}
			   	}
			}
		}
	}
	
	
	
	public static void CompleteRenewal(List<Opportunity> oppsList)
	{
        Boolean containsRenewal = false;
        
        for (Opportunity opp : oppsList)
		{
            if (opp.Type == 'Renewal')
            {
                containsRenewal = true;
                break;
            }
        }
        
        if (containsRenewal)
        {
			OpportunityCache.GenerateRenewalContract(oppsList);
			OpportunityCache.GenerateOpportunityLineItemMap(oppsList);
        }
        
		for (Opportunity opp : oppsList)
		{
            if (opp.Type == 'Renewal' && !opp.Renewal_Completed__c)
            {
                Contract c = OpportunityCache.renewalContractMap.get(opp.Id);

               	List<OpportunityLineItem> liList = OpportunityCache.lineItemsMap.get(opp.Id);

               	if (liList != null)
               	{
               		// Calculate last year spend
                	Decimal netSpend = 0;

                    for (OpportunityLineItem li : liList)
                    {
                    	if (li.Product_Family__c != 'Broadcast Services')
                        {
                        	netSpend += li.TotalPrice;
                        }
                    }

                    opp.Last_Year_Spend__c = netSpend;
				}
				
				if (c != null)
                {
                   	if (c.SBQQ__Opportunity__r.Type == 'New')
                    {
                    	opp.New_Renewal_Customer__c = true;
                    }
						
					opp.Last_Year_Owner__c = c.SBQQ__Opportunity__r.OwnerId;
					opp.Previous_Year_s_Last_Year_Spend__c = c.SBQQ__Opportunity__r.Last_Year_Spend__c;
				}
                    
				opp.Renewal_Completed__c = true;
            }
		}
	}
	
	public static void AssignRetentionOwner(List<Opportunity> oppsList)
    {
        OpportunityCache.GenerateOpportunityLineItemMap(oppsList);
        OpportunityCache.GenerateAccountsMap(oppsList);
        		
		// Get all the previous years Onwers
		Set<Id> ownerIds = new Set<Id>();
		for (Opportunity opp : oppsList)
		{
			if (opp.Last_Year_Owner__c != null)
			{
				ownerIds.add(opp.Last_Year_Owner__c);
			}
		}
		Map<Id, User> ownersMap = new Map<Id, User>([Select Id, Profile.Name, Is_Client_Manager__c, Is_Major_Manager__c, Is_National_Manager__c  from User where Id in :ownerIds or Is_Client_Manager__c = true or Is_Major_Manager__c = true or Is_National_Manager__c = true]);
			
		Id ClientManagerId = null;
		Id MajorManagerId = null;
		Id NationalManagerId = null;
		
		for (User u : ownersMap.values())
		{
			if (u.Is_Client_Manager__c)
			{
				ClientManagerId = u.Id;
			}
			else if (u.Is_Major_Manager__c)
			{
				MajorManagerId = u.Id;
			}
			else if (u.Is_National_Manager__c)
			{
				NationalManagerId = u.Id;
			}
		}
		
		Map<string, Opp_Region__c> regionMap = new Map<string, Opp_Region__c>();
        List<Opp_Region__c> regionList = [Select Id, Name, State__c From Opp_Region__c];
        for(Opp_Region__c r: regionList)
		{
            regionMap.put(r.State__c, r);
        }
              
        System.debug('ASSIGNING RETENTION OWNER');
        string lastBucket ='';
        string currBucket = '';
        
        for (Opportunity opp : oppsList){
            List<OpportunityLineItem> liList = OpportunityCache.lineItemsMap.get(opp.Id);
            Account acc = OpportunityCache.accountsMap.get(opp.accountId);
                       
            if (acc != null){
            	if (opp.Renewal_Rep_Assigned__c == false && opp.Type == 'Renewal')// && opp.StageName == 'Closed Won') 
               	{
                	System.debug('Assignment 1' );
                  	if (opp.Last_Year_Spend__c != null && opp.Last_Year_Spend__c > 0){
                    	lastBucket = BucketType(opp.Last_Year_Spend__c, opp.Id, liList);
                   	}
                        
                  	if (opp.Bookings__c != null && opp.Bookings__c > 0){
                    	currBucket = BucketType(opp.Bookings__c, opp.Id, liList);
                   	}
                           
                    User lastYearsOwner = null;
					Boolean IsRenewalOrTransactionalBroadcast = false;
					Boolean IsTransactionalBroadcast = false;
					
					if (opp.Last_Year_Owner__c != null)
					{
						lastYearsOwner = ownersMap.get(opp.Last_Year_Owner__c);
						
						if (lastYearsOwner.Profile.Name == 'Broadcast Transaction Manager' || lastYearsOwner.Profile.Name == 'Broadcast Transaction User')
						{
							IsTransactionalBroadcast = true;
						}
						
						if (IsTransactionalBroadcast || lastYearsOwner.Profile.Name == 'Renewals Manager' || lastYearsOwner.Profile.Name == 'Renewals Sales User')
						{
							IsRenewalOrTransactionalBroadcast = true;
						}
					}
					
                  	if (	lastBucket == currBucket &&
							((!opp.New_Renewal_Customer__c && IsRenewalOrTransactionalBroadcast) || IsTransactionalBroadcast) ) {// **belongs to same Sales Team 
						// Assign this Opp to the Last OWner
                      	opp.OwnerId = opp.Last_Year_Owner__c;         
                   	}
                  	else {
                    	//Assign this opp to a Rep in currBucket
                      	string grp = '';
                       	
						// Is this a transaction broadcast Opp
						if (opp.Owners_Profile_When_Opportunity_Created__c == 'Broadcast Transaction Manager' || opp.Owners_Profile_When_Opportunity_Created__c == 'Broadcast Transaction User')
						{
							currBucket = 'BROADCAST';
							grp = 'All';	
						}
						else
						{
                      		if (currBucket != 'BASIC') {
								if (acc.BillingState != null && acc.BillingState != '')
        						{
            	            		Opp_Region__c r = regionMap.get(acc.BillingState);
        							if (r != null)
									{
										grp = r.Name;
									}
								}
                       		}
							else
							{
								grp = 'All';
							}
						}
                        
                      	if (grp != ''){
                        	// We now have enough info to do an assignment
                         	RoundRobinHelper rrHelper = new RoundRobinHelper('Opportunity', grp, currBucket);
                         	Id userId = rrHelper.GetNextUser(false, true, opp.Commissionable_Potential__c);
                        
                         	if (userId != null){
                            	opp.OwnerId = userId;
                            	opp.Renewal_Rep_Assigned__c = true;
                            	rrHelper.CreateStatisticRecord(opp.Name);
                            	rrHelper.UpdateRoundRobin();
                          	}
                       	}
						else
						{
							// The State entered in the State Code field was not found, this should just be assigned to the Manager
							if (currBucket == 'CLIENT')
							{
								opp.OwnerId = ClientManagerId;
							}
							else if (currBucket == 'MAJOR')
							{
								opp.OwnerId = MajorManagerId;
							}
							else if (currBucket == 'NATIONAL')
							{
								opp.OwnerId = NationalManagerId;
							}
							
							opp.Renewal_Rep_Assigned__c = true;
						}
                    }
                }
			}
        }
    }
	
	public static void AssignCARep(List<Opportunity> oppsList,  Map<Id, Opportunity> oldOpps)
	{
		Set<Id> userIds = new Set<Id>();
		for (Opportunity o : oppsList)
		{
			userIds.add(o.OwnerId);
		}
		
		Map<Id, User> usersMap = new Map<Id, User>([Select Id, CA_Rep__c from User where Id in :userIds and IsActive = true]);
				
		for (Opportunity o : oppsList)
		{
			Opportunity oldOpp = null;
			
			if (oldOpps != null)
			{
				oldOpp = oldOpps.get(o.Id);
			}
			
			if (oldOpp == null || (o.OwnerId != oldOpp.OwnerId))
			{
				User u = usersMap.get(o.OwnerId);
				o.CA_Rep__c = u.CA_Rep__c;
			}
		}
	}
	
	public static void CreateRenewalActivities(List<Opportunity> oppsList)
	{
		OpportunityCache.GenerateBDCList();
		OpportunityCache.GenerateOCR(oppsList);
		OpportunityCache.GenerateRecordTypeIds();
		
		System.debug('GENERATE ACCOUNTS MAP CALLING');
		OpportunityCache.GenerateAccountsMap(oppsList);
		
        List<Task> tasksToInsert = new List<Task>();
        
		for (Opportunity opp : oppsList)
		{
			if (opp.Type == 'Renewal' && opp.Renewal_Completed__c && !opp.Renewal_Tasks_Completed__c)
			{
				for (BDC_Activity_Type__c activityType : OpportunityCache.activityTypesList)
				{
					System.debug('ACTIVITY Type - ' + activityType);
					
					Boolean createActivity = true;
				
					if (activityType.New_Renewal_Customer__c == true && opp.New_Renewal_Customer__c == false)
					{
						createActivity = false;
					}
				
					if (createActivity && (activityType.From__c == 'Renewal Creation Date' || opp.Renewal_Due_Date__c != null))
					{
						Task newTask = new Task();
		
						newTask.RecordTypeId = OpportunityCache.TaskRenewalRecordType;
						newTask.OwnerId = opp.OwnerId;
						newTask.WhatId = opp.Id;
					
						if (activityType.Name != 'BDC New Biz Rep Call')
						{							
							OpportunityContactRole ocr = OpportunityCache.primaryOcrMap.get(opp.Id);
							if(ocr != null)
								newTask.WhoId = ocr.ContactId;
						}
					
						Account acc = OpportunityCache.accountsMap.get(opp.AccountId);
						newTask.Subject = acc.Name + ' - ' + activityType.Name;
						newTask.Renewal_BDC_Cycle__c = activityType.Name;
						newTask.Renewal_Phone_Call_Templates__c = activityType.Id;
						newTask.Status = 'Not Started';
						newTask.Priority = 'Normal';
					
						// Now work out the Due Date
						DateTime dueDate = null;
					
						if (activityType.Days_Months__c == 'Days')
						{
							if (activityType.From__c == 'Renewal Creation Date')
							{
								dueDate = opp.CreatedDate.AddDays((Integer)activityType.Number_of_Days_Months__c);
							}
							else
							{
								dueDate = opp.Renewal_Due_Date__c.AddDays((Integer)activityType.Number_of_Days_Months__c*-1);
							}
						}
						else
						{
							if (activityType.From__c == 'Renewal Creation Date')
							{
								dueDate = opp.CreatedDate.AddMonths((Integer)activityType.Number_of_Days_Months__c);
							}
							else
							{
								dueDate = opp.Renewal_Due_Date__c.AddMonths((Integer)activityType.Number_of_Days_Months__c*-1);
							}
						}
					
						newTask.ActivityDate = dueDate.date();
					
						tasksToInsert.add(newTask);
					}
				}
				
				opp.Renewal_Tasks_Completed__c = true;
			}
		}
		
		insert tasksToInsert;
		
	}
	
	public static void UpdateContactIfShippingDetailsChange(List<Opportunity> oppsList)
  	{
		Set<Id> accountIds = new Set<Id>();
		for (Opportunity o : oppsList)
		{
			if (o.AccountId != null)
			{
				accountIds.add(o.AccountId);
			}
		}
		
		List<Contact> contList = [Select Id, AccountId, FirstName, LastName, Email, Phone from Contact where AccountId in :accountIds];
		Map<String, Contact> contactsMap = new Map<String, Contact>();
		if (contList != null)
		{
			for (Contact c : contList)
			{
				String key = c.AccountId + '|' + c.LastName + '|' + c.Email;
				contactsMap.put(key, c);
			}
		}
    	
		List<OpportunityContactRole> ocrList = [Select Id, ContactId, OpportunityId, IsPrimary from OpportunityContactRole where OpportunityId IN :oppsList];
		Map<ID, List<OpportunityContactRole>> ocrMap = new Map<ID, List<OpportunityContactRole>>();
		Map<ID, OpportunityContactRole> primaryOcrMap = new Map<ID, OpportunityContactRole>();
			
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
		
		List<SBQQ__Quote__c> quoteList = [select Id, SBQQ__StartDate__c, SBQQ__Opportunity__c, SBQQ__PrimaryContact__c, Tax_Exempt__c, Change_Billing_Street__c, Change_Billing_City__c, Change_Billing_State__c, Change_Billing_Zip__c, Change_Billing_Country__c, Change_Invoice_Contact_Email__c, Change_Invoice_Contact_Name__c, Change_Invoice_Contact_Phone__c from SBQQ__Quote__c where SBQQ__Opportunity__c IN :oppsList and SBQQ__Primary__c = true];
			
		Map<Id, SBQQ__Quote__c> quotesMap = new Map<Id, SBQQ__Quote__c>();
			
		if (quoteList != null)
		{
			for (SBQQ__Quote__c q : quoteList)
			{
				quotesMap.put(q.SBQQ__Opportunity__c, q);
			}
		}
			
    	Map<Id, Contact> contactsToAdd = new Map<Id, Contact>();
		List<OpportunityContactRole> ocrToAdd = new List<OpportunityContactRole>();
		List<OpportunityContactRole> ocrToUpdate = new List<OpportunityContactRole>();
    	for (Opportunity o : oppsList)
    	{
     		if (o.Change_Shipping_Email__c != null && o.Change_Shipping_First_Name__c != null && o.Change_Shipping_Last_Name__c != null && o.Change_Shipping_Phone__c != null)
      		{
        		String matchKey = o.AccountId + '|' +  o.Change_Shipping_Last_Name__c + '|' + o.Change_Shipping_Email__c;
        	    Contact cont = contactsMap.get(matchKey);
        
                if (cont == null)
        		{
          	         // We need to create a new Contact
          			cont = new Contact(Email = o.Change_Shipping_Email__c, FirstName = o.Change_Shipping_First_Name__c, LastName = o.Change_Shipping_Last_Name__c, Phone = o.Change_Shipping_Phone__c, AccountId = o.AccountId);
          			contactsToAdd.put(o.Id, cont);
                }
				else
				{
					List<OpportunityContactRole> ocrOppList = ocrMap.get(o.Id);
					Boolean createNewRole = true;
				
					if (ocrOppList != null)
					{
						for (OpportunityContactRole ocr : ocrOppList)
						{
							if (ocr.ContactId == cont.Id)
							{
								createNewRole = false;
								if (!ocr.isPrimary)
								{
									ocr.isPrimary = true;
									ocrToUpdate.add(ocr);
								}
							}
							else if (ocr.ContactId != cont.Id && ocr.isPrimary)
							{
								ocr.isPrimary = false;
								ocrToUpdate.add(ocr);
							}
						}
					}
					
					if (createNewRole)
					{
						OpportunityContactRole newOcr = new OpportunityContactRole(ContactId = cont.Id, OpportunityId = o.Id, isPrimary = true, Role = 'Decision Maker');
						ocrToAdd.add(newOcr);
					}
				}
      		}
    	}
    
		insert contactsToAdd.Values();
		
		if (contactsToAdd != null && contactstoAdd.keyset().size() > 0)
		{
			for (Id i : contactsToAdd.keySet())
			{
				Contact c = contactsToAdd.get(i);
				OpportunityContactRole newOcr = new OpportunityContactRole(ContactId = c.Id, OpportunityId = i, isPrimary = true, Role = 'Decision Maker');
				ocrToAdd.add(newOcr);
			}
		}
		
		update ocrToUpdate;
    	insert ocrToAdd;
				
  	}
		
	public static void CreateTrainingCases(List<Opportunity> oppsList)
	{
		OpportunityCache.GenerateRecordTypeIds();
		OpportunityCache.GenerateAdminUserId();
		OpportunityCache.GenerateOpportunityLineItemMap(oppsList);
		
        List <Case> casesToInsert = new List<Case>();
        
		for (Opportunity opp : oppsList)
		{
			if (opp.At_Risk__c == 'Yes' && opp.RecordTypeId == OpportunityCache.OpportunityRenewalsRecordType && !opp.Training_At_Risk_Case_Created__c)
			{
				Case newAtRiskCase = new Case();
					
				newAtRiskCase.RecordTypeId = OpportunityCache.CaseTrainingRecordType;
         		newAtRiskCase.Subject = 'At Risk Training'; 
         		newAtRiskCase.Type = 'At Risk Request';
				newAtRiskCase.Reason__c = opp.Reason__c;
         		newAtRiskCase.Opportunity__c = opp.Id;
         		newAtRiskCase.Status = 'New';
         		newAtRiskCase.Priority = 'Medium';
         		newAtRiskCase.Opportunity_Type__c = opp.Type;
         		newAtRiskCase.Opportunity_Owner__c = Opp.OwnerId;
         		newAtRiskCase.State_Province__c = opp.Shipping_State__c;
				newAtRiskCase.AccountId = opp.AccountId;
				newAtRiskCase.Origin = 'Automated Training Case';
         		newAtRiskCase.OwnerId = OpportunityCache.salesforceAdminUser;
				opp.Training_At_Risk_Case_Created__c = true;
				casesToInsert.add(newAtRiskCase);
			}
			
			if (opp.StageName == 'Closed Won' && (opp.RecordTypeId == OpportunityCache.OpportunityRenewalsRecordType || opp.RecordTypeId == OpportunityCache.OpportunityNewBizRecordType) && !opp.Training_Order_Cases_Created__c)
			{
				Boolean consultCreated = false;
				Boolean onsiteCreated = false;
				
				List<OpportunityLineItem> itemList = OpportunityCache.lineItemsMap.get(opp.Id);
				
				if (itemList != null)
				{
					for (OpportunityLineItem li : itemList)
					{
						if ( (li.PricebookEntry.Product2.Family == 'Plan Services' || li.PricebookEntry.Product2.Family == 'Monitoring Services') 
							&& (li.PricebookEntry.Product2.Edition__c == 'Enterprise' || li.PricebookEntry.Product2.Edition__c == 'Professional' || li.PricebookEntry.Product2.Edition__c == 'Non-CisionPoint' || li.PricebookEntry.Product2.Sub_Family__c == 'Social Media Monitoring Dashboard')
							&& !consultCreated)
						{
							Case newConsultCase = new Case();
						
							newConsultCase.RecordTypeId = OpportunityCache.CaseTrainingRecordType;
	         				newConsultCase.Subject = 'Consult Training'; 
	         				newConsultCase.Type = 'Consult Request';
	         				newConsultCase.Opportunity__c = opp.Id;
	         				newConsultCase.Status = 'New';
	         				newConsultCase.Priority = 'Medium';
							newConsultCase.Origin = 'Automated Training Case';
	         				newConsultCase.Opportunity_Type__c = opp.Type;
	         				newConsultCase.Opportunity_Owner__c = Opp.OwnerId;
	         				newConsultCase.State_Province__c = opp.Shipping_State__c;
	         				newConsultCase.OwnerId = OpportunityCache.salesforceAdminUser;
							newConsultCase.AccountId = opp.AccountId;
							opp.Training_Order_Cases_Created__c = true;
							consultCreated = true;
							casesToInsert.add(newConsultCase);
						}
					
						if (li.PricebookEntry.Product2.ProductCode == 'RESTRAININGHALFDAY' && !onsiteCreated)
						{
							Case newOnSiteCase = new Case();
							
							newOnSiteCase.RecordTypeId = OpportunityCache.CaseTrainingRecordType;
	       		  			newOnSiteCase.Subject = 'On-Site Training'; 
	       		  			newOnSiteCase.Type = 'On-Site Request';
	        	 			newOnSiteCase.Opportunity__c = opp.Id;
	        	 			newOnSiteCase.Status = 'New';
	        	 			newOnSiteCase.Priority = 'Medium';
	        	 			newOnSiteCase.Opportunity_Type__c = opp.Type;
							newOnSiteCase.Origin = 'Automated Training Case';
	         				newOnSiteCase.Opportunity_Owner__c = Opp.OwnerId;
	         				newOnSiteCase.State_Province__c = opp.Shipping_State__c;
	         				newOnSiteCase.OwnerId = OpportunityCache.salesforceAdminUser;
							newOnSiteCase.AccountId = opp.AccountId;
							opp.Training_Order_Cases_Created__c = true;
							onsiteCreated = true;
							casesToInsert.add(newOnSiteCase);
						}
					}
				}
			}
		}
        
        insert casesToInsert;
	}
	
	public static void CreateClientServicesCases(List<Opportunity> oppsList)
	{
		OpportunityCache.GenerateRecordTypeIds();
		OpportunityCache.GenerateAdminUserId();
		OpportunityCache.GenerateOpportunityLineItemMap(oppsList);
		OpportunityCache.GenerateAccountsMap(oppsList);
		
        List<Case> casesToInsert = new List<Case>();
        
        System.Debug('Running CreateClientServicesActivities');
		for (Opportunity opp : oppsList)
		{ 
            System.Debug('In Opp. StageName = ' + opp.StageName + ' RecordTYpe = ' + opp.RecordTypeId + 'Tasks Created = ' + opp.Client_Services_Tasks_Created__c);
            
			if (opp.StageName == 'Closed Won' && (opp.RecordTypeId == OpportunityCache.OpportunityRenewalsRecordType || opp.RecordTypeId == OpportunityCache.OpportunityNewBizRecordType) && !opp.Client_Services_Tasks_Created__c)
			{
				System.Debug('Running CreateClientServicesActivities');
				Account acc = OpportunityCache.accountsMap.get(opp.AccountId);
			
				Boolean verificationCall = false;
				Boolean outreachCall = false;
				Boolean PitchEngineCall = false;
		
				List<OpportunityLineItem> itemList = OpportunityCache.lineItemsMap.get(opp.Id);
				
				if (itemList != null)
				{
                    System.Debug('Got Line Items');
					for (OpportunityLineItem li : itemList)
					{
                        System.Debug('Processing Line Item. Family = ' + li.PricebookEntry.Product2.Family + ' Name = ' + li.PricebookEntry.Product2.Name + ' Edition = ' + li.PricebookEntry.Product2.Edition__c + ' Sub Family = ' + li.PricebookEntry.Product2.Sub_Family__c);
						if ( (li.PricebookEntry.Product2.Family == 'Monitoring Services' || li.PricebookEntry.Product2.Name.contains('unfiltered')) && !verificationCall ) 
						{
                            System.Debug('Processing Monitoring');
							Case newVerificationCase = new Case();
												
							newVerificationCase.RecordTypeId = OpportunityCache.CaseClientServicesRecordType;
	         				newVerificationCase.Subject = 'Verification Call - '  + acc.Name;
	         				newVerificationCase.Type = 'Verification Call';
	         				newVerificationCase.Opportunity__c = opp.Id;
	         				newVerificationCase.Status = 'New';
	         				newVerificationCase.Priority = 'Medium';
							newVerificationCase.Origin = 'Automated Client Services Case';
	         				newVerificationCase.Opportunity_Type__c = opp.Type;
	         				newVerificationCase.Opportunity_Owner__c = Opp.OwnerId;
	         				newVerificationCase.State_Province__c = opp.Shipping_State__c;
	         				newVerificationCase.OwnerId = OpportunityCache.salesforceAdminUser;
							newVerificationCase.AccountId = opp.AccountId;
							Database.DMLOptions dmlOpts = new Database.DMLOptions();  
							dmlOpts.assignmentRuleHeader.useDefaultRule = true;
							newVerificationCase.SetOptions(dmlOpts);
																					
							opp.Client_Services_Tasks_Created__c = true;
						
							casesToInsert.add(newVerificationCase);
							verificationCall = true;
						}
					
						if ( (li.PricebookEntry.Product2.Edition__c == 'Small Business' || li.PricebookEntry.Product2.Edition__c == 'Basic') && !outreachCall ) 
						{
                            System.Debug('Processing Outreach');
							Case newOutreachCase = new Case();
													
							newOutreachCase.RecordTypeId = OpportunityCache.CaseClientServicesRecordType;
	         				newOutreachCase.Subject = 'New Small Business Outreach - '  + acc.Name; 
	         				newOutreachCase.Type = 'New Small Business Outreach';
	         				newOutreachCase.Opportunity__c = opp.Id;
	         				newOutreachCase.Status = 'New';
	         				newOutreachCase.Priority = 'Medium';
							newOutreachCase.Origin = 'Automated Client Services Case';
	         				newOutreachCase.Opportunity_Type__c = opp.Type;
	         				newOutreachCase.Opportunity_Owner__c = Opp.OwnerId;
	         				newOutreachCase.State_Province__c = opp.Shipping_State__c;
	         				newOutreachCase.OwnerId = OpportunityCache.salesforceAdminUser;
							newOutreachCase.AccountId = opp.AccountId;
							Database.DMLOptions dmlOpts = new Database.DMLOptions();  
							dmlOpts.assignmentRuleHeader.useDefaultRule = true;
							newOutreachCase.SetOptions(dmlOpts);
							
							opp.Client_Services_Tasks_Created__c = true;
						
							casesToInsert.add(newOutreachCase);
							outreachCall = true;
						}
					
						if ( li.PricebookEntry.Product2.Sub_Family__c == 'Social Newsroom' && !PitchEngineCall ) 
						{
                            System.Debug('Processing Pitch Engine');
							Case newPitchEngineCase = new Case();
																				
							newPitchEngineCase.RecordTypeId = OpportunityCache.CaseClientServicesRecordType;
	         				newPitchEngineCase.Subject = 'PitchEngine Setup - '  + acc.Name;
	         				newPitchEngineCase.Type = 'PitchEngine Setup';
	         				newPitchEngineCase.Opportunity__c = opp.Id;
	         				newPitchEngineCase.Status = 'New';
	         				newPitchEngineCase.Priority = 'Medium';
							newPitchEngineCase.Origin = 'Automated Client Services Case';
	         				newPitchEngineCase.Opportunity_Type__c = opp.Type;
	         				newPitchEngineCase.Opportunity_Owner__c = Opp.OwnerId;
	         				newPitchEngineCase.State_Province__c = opp.Shipping_State__c;
	         				newPitchEngineCase.OwnerId = OpportunityCache.salesforceAdminUser;
							newPitchEngineCase.AccountId = opp.AccountId;
							Database.DMLOptions dmlOpts = new Database.DMLOptions();  
							dmlOpts.assignmentRuleHeader.useDefaultRule = true;
							newPitchEngineCase.SetOptions(dmlOpts);
							
							opp.Client_Services_Tasks_Created__c = true;
						
							casesToInsert.add(newPitchEngineCase);
							PitchEngineCall = true;
						}
					}
				}
			}
		}
        insert casesToInsert;
	}
	
	public static void CreateCreditRiskAssessmentCase(List<Opportunity> oppsList)
	{
		OpportunityCache.GenerateRecordTypeIds();
		OpportunityCache.GenerateAdminUserId();
		OpportunityCache.GenerateAccountsMap(oppsList);
		
        List <Case> casesToInsert = new List<Case>();
        
		for (Opportunity opp : oppsList)
		{
            //System.Debug('Credit Risk Created = ' + opp.Credit_Risk_Case_Created__c + ' Products = ' + opp.Number_of_Products__c + ' GP ID = ' + opp.GP_Cust_ID__c);
			if (!opp.Credit_Risk_Case_Created__c && opp.Number_of_Products__c > 0  && opp.GP_Cust_ID__c == null)
			{
				Account acc = OpportunityCache.accountsMap.get(opp.AccountId);
				
				if (acc != null)
				{
					// Create the Case
					Case c = new Case();
					c.Subject = 'Credit Risk assessment for ' + acc.Name;
					c.AccountId = opp.AccountId;
					c.Sub_Account_Name__c = opp.Sub_Account__c;
					c.Follow_Up_Date__c = Date.today().addDays(1);
					c.Priority = 'Medium';
					c.Origin = 'Automated Contract Admin Case';
					c.Status = 'New';
					c.RecordTypeId = OpportunityCache.CaseContractAdminRecordType;
					c.Opportunity__c = opp.Id;
					
					if (opp.CA_Rep__c != null)
					{
						c.OwnerId = opp.CA_Rep__c;
					}
					else
					{
						c.OwnerId = OpportunityCache.defaultContractAdminUser;
					}
					
					casesToInsert.add(c);
				}
				
				opp.Credit_Risk_Case_Created__c = true;
			}
		}
        
        insert casesToInsert;
	}
	
	public static void AddCompetitor(List<Opportunity> oppsList, Map<Id, Opportunity> oldOpps)
	{
		List<Competitor__c> compsList = [Select Id, Opportunity__c, Competitor_Name__c, Opportunity_Close__c from Competitor__c where Opportunity__c IN :oppsList];
			
		Map<ID, List<Competitor__c>> competitorsMap = new Map<ID, List<Competitor__c>>();
			
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
			
		List<Competitor__c> competitorsToAdd = new List<Competitor__c>();
		for (Opportunity o : oppsList)
		{
			List<Competitor__c> compsForOpp = competitorsMap.get(o.Id);
			Boolean addComp = true;
			
			if (compsForOpp != null)
			{
				String matchString = 'Stolen From';
				// See if there is a competitor matching the name and Opportunity Close String
				if (o.StageName == 'Closed Lost')
				{
					matchString = 'Lost To';
				}
				
				for (Competitor__c c : compsForOpp)
				{
					if (c.Competitor_Name__c == o.Competitor_Name__c && c.Opportunity_Close__c == matchString)
					{
						addComp = false;
					}
				}
			}
			
			if (addComp)
			{
				Opportunity oldOpp = oldOpps.get(o.Id);
				
				if ((o.StageName == 'Closed Lost' || o.StageName == 'Closed Won') && oldOpp.StageName != 'Closed Lost' && oldOpp.StageName != 'Closed Won')
				{
					Competitor__c comp = new Competitor__c();
					comp.Account__c = o.AccountId;
					comp.Opportunity__c = o.Id;
					comp.Competitor_Name__c = o.Competitor_Name__c;
						
					if (o.StageName == 'Closed Lost')
					{
						comp.Opportunity_Close__c = 'Lost To';
						comp.Service_Expiration_Date__c = o.CloseDate.addMonths(12);
					}
					else
					{
						comp.Opportunity_Close__c = 'Stolen From';
					}
					
					competitorsToAdd.add(comp);
				}
			}
		}
		
		insert competitorsToAdd;
	}
		
	private static String BucketType(Decimal value, ID oppId, List<OpportunityLineItem> liList)
    {
        if (liList != null)
        {
            for (OpportunityLineItem li : liList)
            {
                if (li.PricebookEntry.Product2.Sub_Family__c == 'Basic Database')
                {
                    return 'BASIC';
                }
            }
        }
        
        if (value <= 10000)
        {
            return 'CLIENT';
        }
        else if (value <= 29999.99)
        {
            return 'MAJOR';
        }
        else
        {
            return 'NATIONAL';
        }
        
        return '';
    }
   
		
	public static void UpdatePassedToSoftraxFlag(List<Opportunity> oppsList)
    {
        List<Contract> contractsList = [Select Id, SBQQ__Opportunity__c, SBQQ__RenewalOpportunity__c, STX_Contract_Number__c from Contract where SBQQ__Opportunity__c IN :oppsList or SBQQ__RenewalOpportunity__c in :oppsList];		
		
		for (Opportunity o : oppsList)
		{
			if(o.Passed_to_Softrax__c == false)
			{
				for (Contract c : contractsList)
				{
					if(c.SBQQ__Opportunity__c == o.Id || c.SBQQ__RenewalOpportunity__c == o.Id)
					{
						if(c.STX_Contract_Number__c != null)
						{
							if(!String.IsBlank(c.STX_Contract_Number__c))
							{
								o.Passed_to_Softrax__c = true;
							}
						}
					}
				}							
			}
		}
    }
    
    //When opp stage is CA Rejected or Closed Won update primary quote record type
    public static void UpdateQuoteIfOppStageChanges(List<Opportunity> oppsList,Map<Id, Opportunity> oldMap){
    	OpportunityCache.GeneratePrimaryQuotes(oppsList);
    	OpportunityCache.GenerateRecordTypeIds();
    	for(Opportunity o : oppsList){
			if(!OpportunityCache.quotesMap.isEmpty()){
				if ((oldMap.get(o.Id).StageName != o.StageName) && o.StageName == Constants.OpportunityStageClosedWon && (o.RecordTypeId == OpportunityCache.OpportunityRenewalsRecordType || o.RecordTypeId == OpportunityCache.OpportunityLockedRenewalsRecordType || o.RecordTypeId == OpportunityCache.OpportunityNewBizRecordType || o.RecordTypeId == OpportunityCache.OpportunityLockedNewBizRecordType)){
    			//oppo cache create quote record type values and update here				
				OpportunityCache.quotesMap.get(o.Id).recordTypeId = OpportunityCache.QuoteClosedRecordType;
				OpportunityCache.quotesMap.get(o.Id).SBQQ__Status__c = Constants.QuoteStatusApproved;				
				objectsToUpdate.add((Sobject)OpportunityCache.quotesMap.get(o.Id));
				}
				if ((oldMap.get(o.Id).StageName != o.StageName) && o.StageName == Constants.OpportunityStageCaRejected && (o.RecordTypeId == OpportunityCache.OpportunityRenewalsRecordType || o.RecordTypeId == OpportunityCache.OpportunityLockedRenewalsRecordType || o.RecordTypeId == OpportunityCache.OpportunityNewBizRecordType || o.RecordTypeId == OpportunityCache.OpportunityLockedNewBizRecordType)){
    			OpportunityCache.quotesMap.get(o.Id).recordTypeId = OpportunityCache.QuoteBeforeApprovalsRecordType;
				OpportunityCache.quotesMap.get(o.Id).SBQQ__Status__c = Constants.QuoteStatusRejected;				
				objectsToUpdate.add((Sobject)OpportunityCache.quotesMap.get(o.Id));
				}
				if ((oldMap.get(o.Id).StageName != o.StageName) && (o.StageName == Constants.OpportunityStageClosedLost || o.StageName == Constants.OpportunityStageVoided) && (o.RecordTypeId == OpportunityCache.OpportunityRenewalsRecordType || o.RecordTypeId == OpportunityCache.OpportunityLockedRenewalsRecordType || o.RecordTypeId == OpportunityCache.OpportunityNewBizRecordType || o.RecordTypeId == OpportunityCache.OpportunityLockedNewBizRecordType)){
    			OpportunityCache.quotesMap.get(o.Id).recordTypeId = OpportunityCache.QuoteClosedRecordType;
				OpportunityCache.quotesMap.get(o.Id).SBQQ__Status__c = Constants.QuoteStatusRejected;				
				objectsToUpdate.add((Sobject)OpportunityCache.quotesMap.get(o.Id));
				}
			}
    	}		
    }
}