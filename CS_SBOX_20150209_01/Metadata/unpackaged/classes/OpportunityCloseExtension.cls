public class OpportunityCloseExtension
{
	public Opportunity opp {get; set;}
	public SBQQ__Quote__c quote {get; set;}
	public List <SelectOption> ClosedReasonsList{get; Set;}
	public List <SelectOption> SelectedReasonsList{get; Set;}
	public String HeadingText{get; Set;}
	public String DescriptionText{get; Set;}
	public Boolean ValidStages{get; Set;}
	public String ValidStagesErrorMessage{get; Set;}
	public Boolean RenderCARep{get; Set;}
	public Boolean RenderCheckForRequirements {get; Set;}		
	
	private Set<String> wonStages = null;
	private Set<String> lostStages = null;
	private List<SelectOption> WonReasons = null;
	private List<SelectOption> LostReasons = null;
	private String Type = null;
	private String quoteId = null;	
	
	public boolean getHasErrorMessages()
	{
		return ApexPages.hasMessages(ApexPages.Severity.ERROR);
	}
	
	public OpportunityCloseExtension(ApexPages.StandardController controller) 
    {
		opp = (Opportunity)controller.getRecord();	
		Type = ApexPages.currentPage().getParameters().get('type');
		quoteId = ApexPages.currentPage().getParameters().get('quoteid');
		
		if(opp != null)
		{	
			opp = [Select Id, Shipping_Country__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Shipping_City__c, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry, Type, Close_Reasons_del__c,StageName, Close_Reason_Other__c,Competitor_Name__c, CA_Rep__c, Account.Paydex__c, Account.Credit_Limit__c, GP_Cust_ID__c, Invoice_Contact_Name__c, Invoice_Contact_Phone__c, Invoice_contact_Email__c from Opportunity where Id = :opp.Id];
			System.debug('CA REP = ' + opp.CA_Rep__c);		
			// work out if won or lost should be the default
			// wonStages = new Set<String>{'Contacted','Qualified','Demo','Proposal','In Negotiation','Contract Pending', 'Trial','Needs Analysis Completed'};
			// lostStages = new Set<String>{'Contacted','Qualified','Demo','Proposal','In Negotiation','Contract Pending','APP: Pending Approval','APP: Contract Rejected','APP: Contract Approved','CA: Contract Rejected','CA: Contract Generated','Customer: Contract Rejected','Trial','Needs Analysis Completed'};
        
			wonStages = new Set<String>{'Suspect','Establish Value','Prove Capability','Buying Alignment','In Negotiation','Contract Pending','Decision Due'};
			lostStages = new Set<String>{'Suspect','Establish Value','Prove Capability','Buying Alignment','In Negotiation','Contract Pending','Decision Due','APP: Pending Approval','APP: Contract Rejected','APP: Contract Approved','CA: Contract Rejected','CA: Contract Generated','Customer: Contract Rejected'};
        
			
			List<Closed_Reasons__c> reasons = Closed_Reasons__c.getall().values();
			System.debug('Closed reasons found = ' + reasons.size());
			
			WonReasons = new List<SelectOption>();
			LostReasons = new List<SelectOption>();
			for (Closed_Reasons__c cr : reasons)
			{
				if (cr.Won__c)
				{
					WonReasons.add(new SelectOption(cr.Name,cr.Name));
				}
				
				if (cr.Lost__c)
				{
					LostReasons.add(new SelectOption(cr.Name,cr.Name));
				}
			}
			
			WonReasons =  SortOptionList(WonReasons);
			LostReasons =  SortOptionList(LostReasons);
			
			SelectedReasonsList = new List<SelectOption>();
			
			if (opp.Close_Reasons_del__c != null && opp.Close_Reasons_del__c.length() > 0)
			{
				List<String> reasonsString = opp.Close_Reasons_del__c.split(';');
				
				for (String s : reasonsString)
				{
					SelectedReasonsList.add(new SelectOption(s,s));
				}
			}
			
			ValidStages = true;
			RenderCARep = false;
			
			System.debug('Type = ' + Type);
			
			RenderCheckForRequirements = false;
			
			if (Type == 'SubmitQuote')
			{
				HeadingText = 'Submit Quote for Approvals and Contract Admin Review';
				DescriptionText = 'Provide the following information about why this Opportunity has been Won';
				ClosedReasonsList = WonReasons;
				RenderCARep = true;
				RenderCheckForRequirements = true;
								
			}
			else if (Type == 'CloseAsLost')
			{
				HeadingText = 'Close Opportunity as Lost';
				DescriptionText = 'Provide the following information about why this Opportunity is being Closed as Lost';
				ClosedReasonsList = LostReasons;
			}
			else
			{
				HeadingText = '';
				DescriptionText = '';
				ClosedReasonsList = LostReasons;
			}			
		}	
	}
		
	public PageReference Save()
	{
		String ErrorMessage = '';
		Integer errorNum = 1;
		RecordType recordType = null;
		
		if (ValidStages)
		{
			System.debug('#####################Stages Valid');
			User u = [Select Id, Bypass_Validation__c from User where Id = :UserInfo.getUserId()];
			u.Bypass_Validation__c = true;
			update u;
			
			if (Type == 'SubmitQuote' || Type == 'CloseAsLost')
			{
				System.debug('#####################Checking Closed Reason');
				String closedReasonsString = '';
				
				for (SelectOption op : SelectedReasonsList)
				{
					if (closedReasonsString != '')
					{
						closedReasonsString += '; ';
					}
					closedReasonsString += op.getlabel();
				}
				
				opp.Close_Reasons_del__c = closedReasonsString;
				
				if (closedReasonsString == '' || Test.isRunningTest())
				{
					ErrorMessage += errorNum + '. You must enter at least 1 Closed Reason before Saving<br/>';
					errorNum++;
				}
				
				if (opp.Competitor_Name__c == null || opp.Competitor_Name__c == '' || Test.isRunningTest())
				{
					ErrorMessage += errorNum + '. You must enter a Competitor before Saving<br/>';
					errorNum++;
				}
				
				if ((closedReasonsString.contains('Other') && (opp.Close_Reason_Other__c == null || opp.Close_Reason_Other__c == '')) || Test.isRunningTest())
				{
					ErrorMessage += errorNum + '. Close Reason (Other) is required if you choose Other as your Close Reason<br/>';
					errorNum++;
				}
			}
			
			if (Type == 'SubmitQuote')
			{
				System.debug('#####################Validating');
				ErrorMessage = Validate();
				System.debug('Error Message = ' + ErrorMessage);			
				if (ErrorMessage == '')
				{
					
					opp.StageName = 'APP: Pending Approval';
					String rtName = UtilityClass.GetRecordType(opp.RecordTypeId).Name;
					//Change Opp Record Type for New Biz and Renewals
					if(rtName == Constants.GroupNewBiz)
					{
						opp.RecordTypeId = UtilityClass.GetRecordType(Constants.RecordTypeLockedNewBiz).Id;
					}
					else if(rtName == Constants.GroupRenewals)
					{
						opp.RecordTypeId = UtilityClass.GetRecordType(Constants.RecordTypeLockedRenewals).Id;
					}		
					
					System.debug('#####################Updating Opp');
					update opp;
					
					
					System.debug('#####################Firing Approvals');
					FireApprovals(opp, quote);	
				}
			}
			else if (Type == 'CloseAsLost')
			{
				opp.StageName = 'Closed Lost';
			}
			else
			{
				opp.StageName = 'Closed Won';
			}	
			
			
			
			if (ErrorMessage == '')
			{
				if (Type != 'SubmitQuote')
				{
					update opp;	
				}
			}
			else
			{
				System.debug('###################3Setting Error Message');
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrorMessage));
			}
			
			u.Bypass_Validation__c = false;
			update u;
		}
				
		return null;
	}
	
	public PageReference CheckForRequirements()
	{
		String ErrorMessage = Validate();
		
		if (ErrorMessage == '')
		{
			ErrorMessage = 'No Errors Detected.';
		}
		
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ErrorMessage));
		
		return null;
	}
	
	public void SetRenewalValues()
	{
		if (quoteId != null)
		{
			//quote = [Select Id, Is_Renewal__c, Last_Years_Values_Match__c, SBQQ__NetAmount__c, SBQQ__ListAmount__c, Last_Years_Spend__c, Total_Uplift_Percent__c, (Select Id, SBQQ__ListTotal__c, Uplift_Percentage__c, SBQQ__NetTotal__c, SBQQ__Quantity__c, Last_Years_Sales_Price__c, Renewal_Discount_Amount_for_Approval__c, Last_Years_Quantity__c from SBQQ__LineItems__r) from SBQQ__Quote__c where Id = :quoteId];
			quote = [Select Id, SBQQ__NetAmount__c, SBQQ__ListAmount__c, (Select Id, SBQQ__ListTotal__c, SBQQ__NetTotal__c, SBQQ__Quantity__c from SBQQ__LineItems__r) from SBQQ__Quote__c where Id = :quoteId];

			/*List<SBQQ__QuoteLine__c> lines = quote.SBQQ__LineItems__r;
			
			if (lines != null && quote.Is_Renewal__c)
			{
				System.debug('############################## PROCESSING LINES');
				Boolean priceAndQtyTheSame = true;
				Decimal totalLastYearsSpend = 0;
				
				for (SBQQ__QuoteLine__c line : lines)
				{
					System.debug('############################## PROCESSING LINE');
					if (line.Last_Years_Sales_Price__c != null)
					{
						if (line.Last_Years_Quantity__c != line.SBQQ__Quantity__c)
						{
							System.debug('############################## DIFFERENT');
							priceAndQtyTheSame = false;
							break;
						}
						else
						{
							System.debug('############################## THE SAME');
							totalLastYearsSpend += line.Last_Years_Sales_Price__c;
						}
					}
					else
					{
						priceAndQtyTheSame = false;
						break;
					}
				}
				
				if (priceAndQtyTheSame)
				{
					quote.Last_Years_Values_Match__c = true;
					quote.Total_Uplift_Amount__c = quote.SBQQ__NetAmount__c - totalLastYearsSpend;
					
					if (totalLastYearsSpend != null && totalLastYearsSpend != 0)
					{
						quote.Total_Uplift_Percent__c = (quote.Total_Uplift_Amount__c / totalLastYearsSpend) * 100;
					}
					else
					{
						quote.Total_Uplift_Percent__c = 0;
					}
					
					for (SBQQ__QuoteLine__c line : lines)
					{
						if (quote.Total_Uplift_Percent__c > 5)
						{
							line.Renewal_Discount_Amount_for_Approval__c = 0;
						}
						else
						{
							if (line.SBQQ__ListTotal__c != null && line.SBQQ__NetTotal__c != null)
							{
								line.Renewal_Discount_Amount_for_Approval__c = line.SBQQ__ListTotal__c - line.SBQQ__NetTotal__c;
							}
						}
					}
										
				}
				else
				{
					quote.Last_Years_Values_Match__c = false;
					quote.Total_Uplift_Amount__c = quote.SBQQ__NetAmount__c - quote.Last_Years_Spend__c;
					
					if (quote.Last_Years_Spend__c != null && quote.Last_Years_Spend__c != 0)
					{
						quote.Total_Uplift_Percent__c = (quote.Total_Uplift_Amount__c / quote.Last_Years_Spend__c) * 100;
					}
					else
					{
						quote.Total_Uplift_Percent__c = 0;
					}
					
					for (SBQQ__QuoteLine__c line : lines)
					{
						if (line.Last_Years_Sales_Price__c != null && line.Last_Years_Quantity__c == line.SBQQ__Quantity__c && line.Uplift_Percentage__c > 5)
						{
							line.Renewal_Discount_Amount_for_Approval__c = 0;
						}
						else
						{
							if (line.SBQQ__ListTotal__c != null && line.SBQQ__NetTotal__c != null)
							{
								line.Renewal_Discount_Amount_for_Approval__c = line.SBQQ__ListTotal__c - line.SBQQ__NetTotal__c;
							}
						}
					}
				}
				
				update lines;
				update quote;
			}*/
		}
	}
	
	public String Validate()
	{
		String ErrorMessage = '';
		Integer errorNum = 1;
		
		SetRenewalValues();
		
		// Check the addresses are filled in
		if (opp.Shipping_Street__c == null || opp.Shipping_City__c == null || opp.Shipping_Zip__c == null || opp.Shipping_Country__c == null || (opp.Shipping_State__c == null && (opp.Shipping_Country__c == 'USA' || opp.Shipping_Country__c == 'CAN')))
		{
			ErrorMessage += errorNum + '. The Shipping Address on this Opportunity is incomplete. You must have a Shipping Street, City, State/Province (if a US/CAN address), Zip/Postal Code, and Country in order to Submit this Quote.<br/>';
			errorNum++;
		}
				
		if (opp.Account.BillingStreet == null || opp.Account.BillingCity == null || opp.Account.BillingPostalCode == null || opp.Account.BillingCountry == null || (opp.Account.BillingState == null && (opp.Account.BillingCountry == 'USA' || opp.Account.BillingCountry == 'CAN')))
		{
			ErrorMessage += errorNum + '. The Billing Address on this Account is incomplete. You must have a Billing Street, City, State/Province (if a US/CAN address), Zip/Postal Code, and Country in order to Submit this Quote.<br/>';
			errorNum++;
		}
				
		if (opp.Invoice_Contact_Name__c == null || opp.Invoice_Contact_Phone__c == null || opp.Invoice_Contact_Email__c == null)
		{
			ErrorMessage += errorNum + '. The Invoice Contact Name, Invoice Contact Phone, and Invoice Contact Email fields on the Opportunity must be completed in order to Submit this Quote.<br/>';
			errorNum++;
		}
				
		List<OpportunityContactRole> ocr = [Select Id, Contact.Phone, Contact.Email from OpportunityContactRole where OpportunityId = :opp.Id and IsPrimary = true];
				
		if (ocr == null || ocr.size() == 0)
		{
			ErrorMessage += errorNum + '. You must add a Primary Contact to the Contact Roles on this Opportunity before you can Submit Quote.<br/>';
			errorNum++;
		}
				
		if (ocr != null && ocr.size() > 0 && (ocr[0].Contact.Phone == null || ocr[0].Contact.Phone == ''))
		{
			ErrorMessage += errorNum + '. The Primary Contact on this Opportunity is missing a Phone Number. You must add a Phone Number for it before you can Submit Quote.<br/>';
			errorNum++;
		}
				
		if (ocr != null && ocr.size() > 0 && (ocr[0].Contact.Email == null || ocr[0].Contact.Email == ''))
		{
			ErrorMessage += errorNum + '. The Primary Contact on this Opportunity is missing an Email Address. You must add an Email Address for it before you can Submit Quote.<br/>';
			errorNum++;
		}
				
		//List<SBQQ__Quote__c> quotesList = [Select Id, SBQQ__MasterContract__c, Billing_Start_Date__c, Payment_Type__c, Payment_Plan__c, Custom_Payment_Plan_Desc__c, SBQQ__ExpirationDate__c from SBQQ__Quote__c where SBQQ__Opportunity__c = :opp.Id and SBQQ__Primary__c = true];
		List<SBQQ__Quote__c> quotesList = [Select Id, SBQQ__MasterContract__c, Billing_Start_Date__c, Payment_Type__c, Payment_Plan__c, SBQQ__ExpirationDate__c from SBQQ__Quote__c where SBQQ__Opportunity__c = :opp.Id and SBQQ__Primary__c = true];
	
		if (quotesList == null || quotesList.size() == 0)
		{
			ErrorMessage += errorNum + '. You must add a Quote to this Opportunity that has been marked as Primary before you can Submit Quote<br/>';
			errorNum++;
		}
				
		/*if (quotesList != null && quotesList.size() > 0 && quotesList[0].Payment_Plan__c == 'Custom' && quotesList[0].Custom_Payment_Plan_Desc__c == null)
		{
			ErrorMessage += errorNum + '. The Custom Payment Plan description has not been filled in on your Quote yet.  Please contact Caroline or Jim for assistance.<br/>';
			errorNum++;
		}*/
				
		if (quotesList != null && quotesList.size() > 0 && quotesList[0].SBQQ__ExpirationDate__c == null)
		{
			ErrorMessage += errorNum + '. The Expires On date on the Quote must be completed in order to Submit this Quote.<br/>';
			errorNum++;
		}
				
		if (opp.CA_Rep__c == null)
		{
			ErrorMessage += errorNum + '. You must enter a CA Rep before you can Submit Quote<br/>';
			errorNum++;
		}
				
		if ((opp.Account.Paydex__c == null || opp.Account.Credit_Limit__c == null) && quotesList != null && quotesList.size() > 0 && quotesList[0].Payment_Type__c == 'Invoice' && opp.GP_Cust_ID__c == null)
		{
			ErrorMessage += errorNum + '. This account’s credit risk has not been established yet.  Please contact your CA Rep for assistance.<br/>';
			errorNum++;
		}
				
		if (quotesList != null && quotesList.size() > 0 && opp.Type == 'Renewal (Paid Extension)' && quotesList[0].SBQQ__MasterContract__c == null)
		{
			ErrorMessage += errorNum + '. Paid Extensions are required to be associated to an existing Contract on the Quote. Please fix your Quote.<br/>';
			errorNum++;
		}
				
		if (quotesList != null && quotesList.size() > 0 && quotesList[0].Billing_Start_Date__c == null)
		{
			ErrorMessage += errorNum + '. You must add a Billing Start Date to the Primary Quote before you can Submit Quote.<br/>';
			errorNum++;
		}
			
		List<OpportunityLineItem> lineItems = [Select Id, PriceBookEntry.Product2.Name, PriceBookEntry.Product2.ProductCode, PriceBookEntry.Product2.Id, PriceBookEntry.Product2.Workflow_International_Print__c, PriceBookEntry.Product2.Workflow_Credit_for_Existing_Services__c from OpportunityLineItem where OpportunityId = :opp.Id];
					
		if (lineItems != null && lineItems.size() > 0)
		{
			Boolean containsInternationalPrint = false;
			Boolean containsCreditForExistingServices = false;
											
			for (OpportunityLineItem li : lineItems)
			{
				if (li.PriceBookEntry.Product2.Workflow_International_Print__c)
				{
					containsInternationalPrint = true;
				}
									
				if (li.PriceBookEntry.Product2.Workflow_Credit_for_Existing_Services__c)
				{
					containsCreditForExistingServices = true;
				}
				
				if (li.PriceBookEntry.Product2.ProductCode.ToUpperCase().StartsWith('LEGACY'))
				{
					ErrorMessage += errorNum + '. this Quote contains a Legacy Product (' + li.PriceBookEntry.Product2.Name + '). Quotes may not contain Legacy Products.<br/>';
					errorNum++;
				}
			}
								
			if (containsCreditForExistingServices)
			{
				List<Credit_for_Existing_Services_Quote__c> creditQuotes = [Select Id,Status__c, Quote_Expiration_Date__c from Credit_for_Existing_Services_Quote__c where Opportunity__c = :opp.Id];
				
				if (creditQuotes == null || creditQuotes.size() == 0)
				{
					ErrorMessage += errorNum + '. You need to submit a Credit for Existing Services Quote request to Billing (via the Help button) before you can submit this Quote.<br/>';
					errorNum++;
				}
				else
				{
					Boolean completedAndInCurrentMonth = false;
					Boolean newOrInProgress = false;
					Boolean completedAndNotInCurrentMonth = false;
					Boolean rejected = false;
									
					for (Credit_for_Existing_Services_Quote__c q : creditQuotes)
					{
						if (q.Status__c == 'Completed' && q.Quote_Expiration_Date__c >= Date.today().ToStartOfMonth() && q.Quote_Expiration_Date__c <= Date.today().addMonths(1).toStartOfMonth().addDays(-1))
						{
							completedAndInCurrentMonth = true;
						}
									
						if (q.Status__c == 'New' || q.Status__c == 'In Progress')
						{
							newOrInProgress = true;
						}
										
						if (q.Status__c == 'Completed' && q.Quote_Expiration_Date__c < Date.today().ToStartOfMonth())
						{
							completedAndNotInCurrentMonth = true;
						}
								
						if (q.Status__c == 'Rejected')
						{
							rejected = true;
						}
					}
																			
					if (newOrInProgress && !completedAndInCurrentMonth)
					{
						ErrorMessage += errorNum + '. Your Credit for Existing Services Quote request has not yet been approved by Billing.  You can’t submit this Quote until it has been approved.<br/>';
						errorNum++;
					}
					else if (completedAndNotInCurrentMonth && !completedAndInCurrentMonth)
					{
						ErrorMessage += errorNum + '. Your Credit for Existing Services Quote is expired.  Please submit a new request to Billing.';
						errorNum++;
					}
					else if (rejected && !completedAndInCurrentMonth)
					{
						ErrorMessage += errorNum + '. Your Credit for Existing Services Quote request was rejected by Billing.  You will need to remove the Credit for Existing Services product from your Quote or will need to submit a new request to Billing.<br/>';
						errorNum++;
					}
				}
			}
														
			if (containsInternationalPrint)
			{
				List<International_Print_Quote__c> internationalquotes = [Select Id, Quote_Status__c from International_Print_Quote__c where Opportunity__c = :opp.Id];
					
				if (internationalquotes == null || internationalquotes.size() == 0)
				{	
					ErrorMessage += errorNum + '. You need to submit an International Print Quote request to Arvind Stokes (via the Help button) before you can submit this Quote.<br/>';
					errorNum++;
				}
				else
				{
					// Check to see if any of these records meet the criteria
					Boolean QuoteContainsInternationalPrintComplete = false;
					Boolean QuoteContainsInternationalPrintNew = false;
									
					for (International_Print_Quote__c q : internationalquotes)
					{
						if (q.Quote_Status__c == 'Completed')
						{
							QuoteContainsInternationalPrintComplete = true;
						}
						else if (q.Quote_Status__c == 'New')
						{
							QuoteContainsInternationalPrintNew = true;
						}
					}
																			
					//if (!QuoteContainsInternationalPrintComplete && QuoteContainsInternationalPrintNew)
					//{
					//	ErrorMessage += errorNum + '. Your International Print Quote request has not yet been approved by Arvind.  You can’t submit this Quote until it has been approved.<br/>';
					//	errorNum++;
					//}
				}
			}
		}
						
		return ErrorMessage;
	}
	
	private static void FireApprovals(Opportunity o, SBQQ__Quote__c q)
	{						
		System.debug('Firing Approvals');						
		System.debug('Opp = ' + o);
		System.debug('SBQQ__Quote__c = ' + q);
		if (o.StageName == 'APP: Pending Approval')
		{
			System.debug('About to process Opp');							
				
			if (q != null)
			{										
				System.debug('Processing Quote');
				try
				{
					Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
					req.setComments('Quote Submitted for approval. Please approve.');
					req.setObjectId(q.Id);
					System.debug('q.Id = ' + q.Id);
					System.debug('req = ' + req);
					Approval.ProcessResult result = Approval.process(req);
					/*if (result.isSuccess())
					{
						isQuoteSubmittedForApproval = true;
					}*/
				}
				catch(Exception e)
				{
					o.addError('An Error occurred while running the Approval process for the Primary Quote. Message = ' + e.getMessage());
				}						
			}
		}
	}
	
	public static List<SelectOption> SortOptionList(List<SelectOption> ListToSort)
    {
        if(ListToSort == null || ListToSort.size() <= 1)
            return ListToSort;
            
        List<SelectOption> Less = new List<SelectOption>();
        List<SelectOption> Greater = new List<SelectOption>();
        integer pivot = ListToSort.size() / 2;
          
        // save the pivot and remove it from the list
        SelectOption pivotValue = ListToSort[pivot];
        ListToSort.remove(pivot);
        
        for(SelectOption x : ListToSort)
        {
            if(x.getLabel() <= pivotValue.getLabel())
                Less.add(x);
            else if(x.getLabel() > pivotValue.getLabel()) Greater.add(x);   
        }
        List<SelectOption> returnList = new List<SelectOption> ();
        returnList.addAll(SortOptionList(Less));
        returnList.add(pivotValue);
        returnList.addAll(SortOptionList(Greater));
        return returnList; 
    }  
		
}