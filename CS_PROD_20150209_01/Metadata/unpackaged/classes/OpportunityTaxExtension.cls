public with sharing class OpportunityTaxExtension extends AVA_SFCORE.GetTaxOpportunity
{
	public Opportunity opp {get; set;}
	public Account acc {get; set;}
	
	private List<Broadcast_Item__c> lineItemsList {get; set;}
	private Map<String, Broadcast_Item__c> lineItemsMap {get; set;}
	
	public List<LineItemWrapper> lineWrapperList {get; set;}
    public Map<String, LineItemWrapper> lineWrapperMap {get; set;}
    
    public Boolean PostTax {get; set;}
    
    public String TaxResult {get; set;}
    public Boolean Error {get; set;}
    //Shipping Address
    public String ShippingLine1 {get; set;}
    public String ShippingCity {get; set;}
    public String ShippingState {get; set;}
    public String ShippingPostalCode {get; set;}
    public String ShippingCountry {get; set;}
    
    public class LineItemWrapper
    {
    	public String Id {get; set;}
    	public String Name {get; set;}
    	public Decimal Quantity {get; set;}
    	public Decimal SalesPrice {get; set;}
    	public Decimal Tax {get; set;}
    	public String Rate {get; set;}
    	public Decimal TotalAfterTax {get; set;}
    	public String TaxDetails {get; set;}
    	public Integer No {get; set;}    	
    }       
       
    public OpportunityTaxExtension(Id oppId) 
    {
    	super(oppId);
    	System.Debug('#######################################OPP ID = ' + oppId);
    	if (oppId != null)
    	{
    		opp = [select Id, Name, opportunity_number__c, accountId, Is_Address_Valid__c, Shipping_City__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Shipping_Country__c, Do_Not_Validate_Address__c from Opportunity where Id = :oppId];
    		
    		SetUpTaxExtension();
    	}
    }
    
	public OpportunityTaxExtension(ApexPages.StandardController controller) 
    {
    	// Get the Opp Record
    	opp = (Opportunity)controller.getRecord();
    	if (opp != null)
    	{
    		opp = [select Id, Name, opportunity_number__c, accountId, Is_Address_Valid__c, Shipping_City__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Shipping_Country__c, Do_Not_Validate_Address__c from Opportunity where Id = :opp.Id];    		
    		SetUpTaxExtension();
    	}
    }
    
    public void SetUpTaxExtension()
    {
    	TaxResult = 'No Result';
    	PostTax = false;
    	Error = false;
    	    
        // Get the fields we need from the Opportunity
        if (opp != null)
        {
           	acc = [select Id, GP_Cust_ID__c, Tax_Exempt__c from Account where Id = :opp.accountId];
        	
        	// Now get the line items
        	lineItemsList = [select Id, Qty__c, Inventory_Item__c, Total_Sale__c, Tax__c, Rate__c, Tax_Details__c, Total_after_Tax__c from Broadcast_Item__c where Opportunity__c = :opp.Id];
			
			if (lineItemsList == null)
			{
				lineItemsList = new List<Broadcast_Item__c>();
			}
			
			lineItemsMap = new Map<String, Broadcast_Item__c>();
			for (Broadcast_Item__c item : lineItemsList)
			{
				lineItemsMap.put(item.Id, item);
			}
			
			lineWrapperList = new List<LineItemWrapper>();
			Integer Num = 0;
			for (Broadcast_Item__c i : lineItemsList)
			{
				LineItemWrapper wrapper = new LineItemWrapper();
				wrapper.Id = i.Id;
				wrapper.Name = i.Inventory_Item__c;
				
				if (i.Qty__c != null)
				{
					wrapper.Quantity = i.Qty__c;
				}
				else
				{
					wrapper.Quantity = 1;
				}
				wrapper.SalesPrice = i.Total_Sale__c;
				wrapper.Tax = i.Tax__c;
				wrapper.Rate = i.Rate__c;
				wrapper.TotalAfterTax = i.Total_after_Tax__c;
				wrapper.TaxDetails = i.Tax_Details__c;
				wrapper.No = Num;				
				
				Num++;
				lineWrapperList.add(wrapper);
			}
			
			lineWrapperMap = new Map<String, LineItemWrapper>();
			for (LineItemWrapper w : lineWrapperList)
			{
				lineWrapperMap.put(String.valueOf(w.No), w);
			}
        		
        }
    }
    
    public PageReference CalculateTax()
    {
   		AvaTax_Settings__c settings = AvaTax_Settings__c.getValues('Settings');
   		
    	AVA_SF_SDK.TaxSvc.TaxSvcSoap soapRequest = new AVA_SF_SDK.TaxSvc.TaxSvcSoap(settings.Service_URL__c);
    	    	
    	AVA_SF_SDK.TaxSvc.Profile p = new AVA_SF_SDK.TaxSvc.Profile();
    	p.Client = 'Salesforce,1.0,0,Cision Salesforce to AvaTax Connector,1.0,0';
    	soapRequest.Profile = p;
    	
    	AVA_SF_SDK.TaxSvc.Security s = new AVA_SF_SDK.TaxSvc.Security();
    	AVA_SF_SDK.TaxSvc.UsernameToken_element userNameToken = new AVA_SF_SDK.TaxSvc.UsernameToken_element();
    	userNameToken.Username = settings.User_Name__c;
    	userNameToken.Password = settings.Password__c;
    	
    	s.UsernameToken = userNameToken;
    	soapRequest.Security = s;
    	
    	AVA_SF_SDK.TaxSvc.GetTaxRequest rVal = super.FetchTaxData(PostTax);
    	rVal.DocCode = opp.Name;
    	rVal.DocType = 'SalesInvoice';
    	
    	// Overwrite the line items
    	AVA_SF_SDK.TaxSvc.ArrayOfLine lineArray = new AVA_SF_SDK.TaxSvc.ArrayOfLine();
    	lineArray.Line = new List<AVA_SF_SDK.TaxSvc.Line>();
    	
    	for (LineItemWrapper w : lineWrapperList)
    	{
    		AVA_SF_SDK.TaxSvc.Line lineItem = new AVA_SF_SDK.TaxSvc.Line();	
    		lineItem.No = String.valueOf(w.No);
    		lineItem.itemCode = w.Name;
    		lineItem.TaxCode = w.Name;
    		lineItem.Amount = w.SalesPrice;
    		lineItem.Qty = w.Quantity;                   
            lineArray.Line.add(lineItem);
    	}
    	
    	rVal.Lines = lineArray;
    	
    	rVal.CompanyCode = Settings.Company_Name__c;
    	
    	if(acc.Tax_Exempt__c)
        {
        	rVal.ExemptionNo = 'Exempt';
        }
    	else
        {
            rVal.ExemptionNo = '';
        }    	
    	
    	AVA_SF_SDK.TaxSvc.GetTaxResult res = null;
    	
    	if (!Test.IsRunningTest())
    	{
    		res = soapRequest.GetTax(rVal);
    	}
    	else
    	{
    		res = new AVA_SF_SDK.TaxSvc.GetTaxResult();
    		res.Messages = null;
    		res.ResultCode = 'Success';
    		res.TotalTax = 100.00;
    		res.Taxlines = new AVA_SF_SDK.TaxSvc.ArrayOfTaxLine();
    		res.TaxLines.TaxLine = new List<AVA_SF_SDK.TaxSvc.TaxLine>();
    		AVA_SF_SDK.TaxSvc.TaxLine line = new AVA_SF_SDK.TaxSvc.TaxLine();
    		line.Tax = 10.00;
    		line.Rate = 9.50;
    		res.TaxLines.TaxLine.add(line);
    	}
    	    	
    	if (res.Messages != null)
    	{
    		TaxResult = '';
    		for (AVA_SF_SDK.TaxSvc.Message m : res.Messages.Message)
    		{
    			TaxResult += m.Details;
    			TaxResult += '. ';
    			Error = true;
    		}
    	}
    	else
    	{
    		if (res.ResultCode == 'Success' || Test.IsRunningTest())
    		{
    			// Update the Tax Lines
    			TaxResult = 'Total Tax = ' + String.valueOf(res.TotalTax);	
    			
    			if (res.TaxLines != null && res.TaxLines.TaxLine != null)
    			{
    				for (AVA_SF_SDK.TaxSvc.TaxLine line : res.TaxLines.TaxLine)
    				{
    					LineItemWrapper w = lineWrapperMap.get(line.No);
    					    					
    					if (w != null)
    					{
    						w.Tax = line.Tax;
    						w.Rate = String.valueOf(line.Rate*100);
    						w.TotalAfterTax = w.SalesPrice + w.Tax;    						
                            
    						// Now get the details
    						if (line.TaxDetails != null && line.TaxDetails.TaxDetail != null)
    						{
    							w.TaxDetails = '';
    							for (AVA_SF_SDK.TaxSvc.TaxDetail detail : line.TaxDetails.TaxDetail)
    							{
    								if (w.TaxDetails != '')
    								{
    									w.TaxDetails += '\r\n';	
    								}
    								
    								w.TaxDetails += detail.TaxName + ' : ' + detail.Tax;
    							}
    						}
    												
       					}		
    				}
    				    				
    			}
    			
    		}
    		else
    		{
    			TaxResult = res.ResultCode;
    			Error = true;
    		}
    	}
    	
    	return null;
    }	
    
    public PageReference VoidTax()
    {
    	AvaTax_Settings__c settings = AvaTax_Settings__c.getValues('Settings');
   		
    	AVA_SF_SDK.TaxSvc.TaxSvcSoap soapRequest = new AVA_SF_SDK.TaxSvc.TaxSvcSoap(settings.Service_URL__c);
    	    	
    	AVA_SF_SDK.TaxSvc.Profile p = new AVA_SF_SDK.TaxSvc.Profile();
    	p.Client = 'Salesforce,1.0,0,Cision Salesforce to AvaTax Connector,1.0,0';
    	soapRequest.Profile = p;
    	
    	AVA_SF_SDK.TaxSvc.Security s = new AVA_SF_SDK.TaxSvc.Security();
    	AVA_SF_SDK.TaxSvc.UsernameToken_element userNameToken = new AVA_SF_SDK.TaxSvc.UsernameToken_element();
    	userNameToken.Username = settings.User_Name__c;
    	userNameToken.Password = settings.Password__c;
    	
    	s.UsernameToken = userNameToken;
    	soapRequest.Security = s;
    	
    	AVA_SF_SDK.TaxSvc.CancelTaxRequest cancelRequest = new AVA_SF_SDK.TaxSvc.CancelTaxRequest();
    	//if(voidDocument){
    	//	cancelRequest.CancelCode = 'DocVoided';
            //cancelRequest.CancelCode = 'Unspecified';
    	//} 
    	//else{
    		cancelRequest.CancelCode = 'DocVoided';
    	//}
    	
    	cancelRequest.CompanyCode = Settings.Company_Name__c;
    	cancelRequest.DocCode = opp.Name;
    	cancelRequest.DocType = 'SalesInvoice';
    	
    	AVA_SF_SDK.TaxSvc.CancelTaxResult res = null;
    	
    	if (Test.IsRunningTest())
    	{
    		res = new AVA_SF_SDK.TaxSvc.CancelTaxResult();
    		res.ResultCode = 'Error';
    		res.Messages = new AVA_SF_SDK.TaxSvc.ArrayOfMessage();
    		res.Messages.Message = new List<AVA_SF_SDK.TaxSvc.Message>(); 
    		AVA_SF_SDK.TaxSvc.Message mes = new AVA_SF_SDK.TaxSvc.Message();
    		mes.Details = 'Test';
    		res.Messages.Message.add(mes);
    	}
    	else
    	{
    		res = soapRequest.CancelTax(cancelRequest);
    	}
    	
    	if (res.ResultCode != 'Success')
    	{
    		if (res.Messages != null)
    		{
    			TaxResult = '';
    			for (AVA_SF_SDK.TaxSvc.Message m : res.Messages.Message)
    			{	
    				TaxResult += m.Details;
    				TaxResult += '. ';
    				Error = true;
    			}
    		}
    	}
    	    	
    	return null;
    }
    
    public override AVA_SF_SDK.TaxSvc.BaseAddress FetchDestinationAddress()
    {
    	AVA_SF_SDK.TaxSvc.BaseAddress DestAddress = new AVA_SF_SDK.TaxSvc.BaseAddress();
        DestAddress.AddressCode = 'D';
    	DestAddress.Line1 = opp.Shipping_Street__c;
    	DestAddress.City = opp.Shipping_City__c;
    	DestAddress.Region = opp.Shipping_State__c;
    	DestAddress.PostalCode = opp.Shipping_Zip__c;
    	DestAddress.Country = opp.Shipping_Country__c;
    	
    	return DestAddress;
    }
        
        
    public PageReference Cancel()
    {
    	PageReference ref = new PageReference('/' + opp.Id);
    	ref.SetRedirect(true);
    	return ref;
    }
    
    public PageReference SaveTax()
    {
    	List<Broadcast_Item__c> itemsToUpdate = new List<Broadcast_Item__c>();
    	    	
    	for (LineItemWrapper w : lineWrapperList)
    	{
    		Broadcast_Item__c item = lineItemsMap.get(w.Id);
    		
    		if (item != null)
    		{
    			item.Tax__c = w.Tax;
				item.Rate__c = w.Rate;
				item.Tax_Details__c = w.TaxDetails;	
				itemsToUpdate.add(item);
    		}
    			
    	}
    	
    	if (!Test.IsRunningTest())
    	{
    		update itemsToUpdate;
    	}
    	
    	PageReference ref = new PageReference('/' + opp.Id);
    	ref.SetRedirect(true);
    	return ref;
    }             
    
    public boolean ValidateOppShippingAddress(Opportunity opp)
    {
    	AvaTax_Settings__c settings = AvaTax_Settings__c.getValues('Settings');
    	 
    	AVA_SF_SDK.AddressSvc.ValidateRequest req = new AVA_SF_SDK.AddressSvc.ValidateRequest();
    	req.Address = new AVA_SF_SDK.AddressSvc.BaseAddress();
    	req.Address.Line1 = opp.Shipping_Street__c;
    	req.Address.City = opp.Shipping_City__c;
    	req.Address.Region = opp.Shipping_State__c;
    	req.Address.PostalCode = opp.Shipping_Zip__c;
    	req.Address.Country = opp.Shipping_Country__c;
    	
    	AVA_SF_SDK.AddressSvc.AddressSvcSoap soapRequest = new AVA_SF_SDK.AddressSvc.AddressSvcSoap(settings.Service_URL__c);
    	AVA_SF_SDK.AddressSvc.Profile p = new AVA_SF_SDK.AddressSvc.Profile();
    	p.Client = 'Salesforce,1.0,0,Cision Salesforce to AvaTax Address Lookup Connector,1.0,0';
    	soapRequest.Profile = p;
    	
    	AVA_SF_SDK.AddressSvc.Security s = new AVA_SF_SDK.AddressSvc.Security();
    	AVA_SF_SDK.AddressSvc.UsernameToken_element userNameToken = new AVA_SF_SDK.AddressSvc.UsernameToken_element();
    	userNameToken.Username = settings.User_Name__c;
    	userNameToken.Password = settings.Password__c;
    	
    	s.UsernameToken = userNameToken;
    	soapRequest.Security = s;
    	
    	AVA_SF_SDK.AddressSvc.ValidateResult result = null;
    	
    	if (!Test.IsRunningTest())
    	{
    		result = soapRequest.Validate(req);
    	}
    	else
    	{ 
    		result = new AVA_SF_SDK.AddressSvc.ValidateResult();
    		if(opp.Shipping_Street__c.Contains('Test')){
    			result.ResultCode = 'Error';
    		}
    		else
    		{
    			result.ResultCode = 'Success';
    		}
    		result.ValidAddresses = new AVA_SF_SDK.AddressSvc.ArrayOfValidAddress();
    		result.ValidAddresses.ValidAddress = new List<AVA_SF_SDK.AddressSvc.ValidAddress>();
    		AVA_SF_SDK.AddressSvc.ValidAddress a = new AVA_SF_SDK.AddressSvc.ValidAddress();
    		a.Line1 = 'Line1';
    		a.City = 'City';
    		a.Region = 'IL';
    		a.PostalCode = 'Zip';
    		a.Country = 'Country';    		
    		result.ValidAddresses.ValidAddress.add(a);
    	}
    	
    	System.Debug('#######################################ResultCode = ' + result.ResultCode);
    	System.Debug('#######################################opp.Shipping_Country__c = ' + opp.Shipping_Country__c);
    	//System.Debug('#######################################result.ValidAddresses = ' + result.ValidAddresses);   
    	System.Debug('#######################################opp.Do_Not_Validate_Address__c = ' + opp.Do_Not_Validate_Address__c);    	
    	if (result.ResultCode == 'success')
    	{
    		if (result.ValidAddresses != null)
    		{    			
    			ShippingLine1 = result.ValidAddresses.ValidAddress[0].Line1;
    			ShippingCity = result.ValidAddresses.ValidAddress[0].City;
    			ShippingState = result.ValidAddresses.ValidAddress[0].Region;
    			ShippingPostalCode = result.ValidAddresses.ValidAddress[0].PostalCode;
    			ShippingCountry = result.ValidAddresses.ValidAddress[0].Country;     							     		    	
                
    			return true;
    		}    		
    	}
    	else if(opp.Do_Not_Validate_Address__c == true)
    	{    		   	
    		ShippingLine1 = opp.Shipping_Street__c;
			ShippingCity = opp.Shipping_City__c;
			ShippingState = opp.Shipping_State__c;
			ShippingPostalCode = opp.Shipping_Zip__c;
			ShippingCountry = opp.Shipping_Country__c;
			System.Debug('#######################################ShippingCountry = ' + ShippingCountry);
			return true;
    	}    
    	else
    	{
    		return false;	    	
    	}
    	
    	return false;	    	
    }
    
    @isTest(SeeAllData=true)
    static void TestOpportunityTaxExtension()
    {
        List<Account> accounts = TestingUtils.createAccounts(1, true);
        
        Opportunity opp = TestingUtils.createOpportunity(accounts[0].Id);
        insert opp;
	    Prepaid_Clip_Package__c clipPackage = TestingUtils.createClipPackage(accounts[0].Id, TestingUtils.ADMIN_USER.Id, 'DVD Clip', true);
        Broadcast_Item__c broadcastItem = TestingUtils.createBroadcastItem(opp.Id,clipPackage.Id, true);
       	                    
        PageReference pageRef = Page.OpportunityTaxCalculation;
        pageRef.GetParameters().put('id', opp.Id);
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController controller = new ApexPages.StandardController(opp); 
        OpportunityTaxExtension extension = new OpportunityTaxExtension(controller);
        OpportunityTaxExtension extension2 = new OpportunityTaxExtension(opp.Id);
        boolean validAddress = extension2.ValidateOppShippingAddress(opp);
        opp.Shipping_Street__c = '123 Test Street';
    	opp.Shipping_City__c = 'Chicago';
    	opp.Shipping_State__c = 'IL';
    	opp.Shipping_Zip__c = '60642';
    	opp.Shipping_Country__c = 'US';
    	opp.Do_Not_Validate_Address__c = true;
    	//update opp;
        validAddress = extension2.ValidateOppShippingAddress(opp);
        extension.CalculateTax();
        extension.Cancel();
        extension.SaveTax();
        extension.FetchDestinationAddress();
        extension.VoidTax();
        
    }
        
}