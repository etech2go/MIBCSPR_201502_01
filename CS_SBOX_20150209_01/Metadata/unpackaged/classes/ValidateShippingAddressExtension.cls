public with sharing class ValidateShippingAddressExtension
{
	public Opportunity opp {get; set;}
	public NewAddress validatedAddress {get; set;}
	
	public class NewAddress
	{
		public String Line1 {get; set;}
		public String City {get; set;}
		public String Region {get; set;}
		public String PostalCode {get; set;}
		public String Country {get; set;}
	}
	
	public ValidateShippingAddressExtension(ApexPages.StandardController controller) 
    {
    	// Get the Opp Record
    	opp = (Opportunity)controller.getRecord();
    	   	
    	if (opp != null)
        {
        	opp = [select Id, Name, Shipping_City__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Shipping_Country__c from Opportunity where Id = :opp.Id];
        }
    	
    	validatedAddress = new NewAddress();         
    }
              
    public PageReference AddressValidate()
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
    		result.ResultCode = 'Success';
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
    	
    	if (result.ResultCode == 'success')
    	{
    		if (result.ValidAddresses != null)
    		{
    			validatedAddress.Line1 = result.ValidAddresses.ValidAddress[0].Line1;
    			validatedAddress.City = result.ValidAddresses.ValidAddress[0].City;
    			validatedAddress.Region = result.ValidAddresses.ValidAddress[0].Region;
    			validatedAddress.PostalCode = result.ValidAddresses.ValidAddress[0].PostalCode;
    			validatedAddress.Country = result.ValidAddresses.ValidAddress[0].Country;
    		}
    	}
    	
    	return null;
    	
    }
    
    public PageReference UpdateAddress()
    {
    	if (validatedAddress.Line1 != null && validatedAddress.Line1 != '')
    	{
    		opp.Shipping_Street__c = validatedAddress.Line1;
    		opp.Shipping_City__c = validatedAddress.City;
    		opp.Shipping_State__c = validatedAddress.Region;
    		opp.Shipping_Zip__c = validatedAddress.PostalCode;
    		opp.Shipping_Country__c = validatedAddress.Country;
    		
    		update opp;
    		
    		return Cancel();
      	}
      	
      	return null;
    }
       
    public PageReference Cancel()
    {
    	PageReference ref = new PageReference('/' + opp.Id);
    	ref.SetRedirect(true);
    	return ref;
    }
    
    @isTest(SeeAllData=true)
    static void TestOpportunityValidateShippingAddress()
    {
        List<Account> accounts = TestingUtils.createAccounts(1, true);
        
        Opportunity opp = TestingUtils.createOpportunity(accounts[0].Id);
        insert opp;
             
        PageReference pageRef = Page.ValidateShippingAddress;
        pageRef.GetParameters().put('id', opp.Id);
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController controller = new ApexPages.StandardController(opp); 
        ValidateShippingAddressExtension extension = new ValidateShippingAddressExtension(controller);
        extension.AddressValidate();
        extension.Cancel();
        extension.UpdateAddress();
        
    }
}