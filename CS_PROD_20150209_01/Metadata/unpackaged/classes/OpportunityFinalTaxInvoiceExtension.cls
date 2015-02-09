public with sharing class OpportunityFinalTaxInvoiceExtension
{	
	public OpportunityTaxExtension taxCalc {get; set;}
	public Opportunity opp {get; set;}
	public Account acc {get; set;}
	public User owner {get; set;}
	public Profile ownerProfile {get; set;}
	public String ErrorMessage {get; set;}
	private string PENDING_INVOICING = 'Pending Invoicing';
	private string ON_HOLD = 'On Hold';
	private string INVOICED = 'Invoiced';
	private string CISION_HERO = 'Cision Hero';
	private string OPP_OWNER_VALIDATION = 'Opportunity Owner Validation';
	
	public OpportunityFinalTaxInvoiceExtension(ApexPages.StandardController controller) 
    {
    	// Get the Opp Record
    	opp = (Opportunity)controller.getRecord();
    	    	
    	if (opp != null)
    	{
    		opp = [select Id, Name, OwnerId, Amount, AccountId, Opportunity_Status__c, Subtotal__c, Shipping_Cost__c, Sales_Tax__c, Total__c, Shipping_City__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Shipping_Country__c, Do_Not_Validate_Address__c from Opportunity where Id = :opp.Id];
    		acc = [select Id, Name, Verified__c from Account where Id = :opp.AccountId];
    		owner = [select UserRoleId,ProfileId from User where Id = :opp.OwnerId ];
    		ownerProfile =  [select Name from Profile where Id = :owner.ProfileId ];
    	}
    }
    
    public PageReference GenerateTaxAndInvoice()
    {
    	if (opp.Opportunity_Status__c != INVOICED)    	
    	{    		    	
    		System.Debug('#######################################ownerProfile.Name = ' + ownerProfile.Name);    		
    		if(ownerProfile.Name == 'Broadcast Transaction Manager' || ownerProfile.Name == 'Broadcast Transaction Sales User')
    		{
    			if(acc.Verified__c == true)
	    		{    			
		    		if (opp.Total__c != null && opp.Total__c > 0)
		    		{	    				    			
		    			//Validate Address	  
		    			//System.Debug('#######################################opp.Id = ' + opp.Id);
		    			
		    			taxCalc = new OpportunityTaxExtension(opp.Id);  	
		    			System.Debug('#######################################ShippingLine1 = ' + taxCalc.ShippingLine1);	    			
		    			if(taxCalc.ValidateOppShippingAddress(opp) == true)
		    			{	    			    			
		    				CalculateTaxAndInvoice();    
		    				UpdateOppAttributes(taxCalc, true);                                                   
		    			}
		    			else
		    			{
		    				opp.Opportunity_Status__c = PENDING_INVOICING;
		    				opp.Route_To__c = ON_HOLD;
	    					opp.On_Hold_Reason__c = 'Research Shipping Address';
	    					update opp; 
		    			}
		    		}
		    		else if(opp.Total__c < 0)
		    		{
		    			opp.Opportunity_Status__c = PENDING_INVOICING;
		    			opp.Route_To__c = ON_HOLD;
		    			opp.On_Hold_Reason__c = 'Negative Total';
	    				update opp; 
		    		}   
		    		else if(opp.Total__c == 0)
		    		{	    	
		    			//Skip Address Validation	
		    			taxCalc = new OpportunityTaxExtension(opp.Id);
		    			CalculateTaxAndInvoice();
		    			UpdateOppAttributes(taxCalc, false);	    			
		    		}     
	              	  
	                return RedirectToOpp();
	    		}
	    		else
	    		{
	    			opp.Opportunity_Status__c = PENDING_INVOICING;
	    			opp.Route_To__c = CISION_HERO;
	    			update opp;
	    			return RedirectToOpp();
	    		}
    		}
    		else
    		{
	    		opp.Opportunity_Status__c = PENDING_INVOICING;
				opp.Route_To__c = ON_HOLD;
				opp.On_Hold_Reason__c = OPP_OWNER_VALIDATION;
				update opp; 
				return RedirectToOpp();      		    		  
	    	}	    	
    	}
    	else
    	{
    		ErrorMessage = 'Opportunity ' + opp.Name + ' has already been Invoiced and cannot be Invoiced again';
    	}
        
        return null;
    }       
    
    private PageReference RedirectToOpp()
    {
    	 PageReference ref = new PageReference('/' + opp.Id);
         ref.SetRedirect(true);
         return ref;
    }       
    
    private void CalculateTaxAndInvoice()
    {    	
    	OpportunityTaxExtension taxCalc = new OpportunityTaxExtension(opp.Id);  
		taxCalc.PostTax = true;
		taxCalc.CalculateTax();
		if (taxCalc.Error)
		{
			ErrorMessage = 'An Error Occurred when Calculating the Sales Tax. Message - ' + taxCalc.TaxResult;
		}
		else
		{
			taxCalc.SaveTax(); 
		}                                               
        
        //Locking is done in the Invoice Trigger when an invoice is created
        if (!Test.IsRunningTest())
    	{
        	OpportunityToInvoice oppToInv = new OpportunityToInvoice(opp.Id);
        	oppToInv.process();
    	}                       
    }
    
    private void UpdateOppAttributes(OpportunityTaxExtension ote, boolean addressUpdate)
    {    	    	
    	Opportunity opportunity = [select Opportunity_Number__c, Shipping_City__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Shipping_Country__c, Locked__c from Opportunity where Id = :opp.Id];
    	if(addressUpdate)
    	{    		    		
	    	opportunity.Is_Address_Valid__c = true;                        
	        opportunity.Shipping_Street__c = ote.ShippingLine1;
	        opportunity.Shipping_City__c = ote.ShippingCity;
	        opportunity.Shipping_State__c = ote.ShippingState;
	        opportunity.Shipping_Zip__c = ote.ShippingPostalCode;
	        opportunity.Shipping_Country__c = ote.ShippingCountry;	     	
            System.Debug('#######################################ote.ShippingLine1= ' + ote.ShippingLine1);
            System.Debug('#######################################opportunity.Shipping_Street__c= ' + opportunity.Shipping_Street__c);
            System.Debug('#######################################ote.ShippingCity= ' + ote.ShippingCity);
            System.Debug('#######################################ote.ShippingState= ' + ote.ShippingState);
            System.Debug('#######################################ote.ShippingPostalCode= ' + ote.ShippingPostalCode);
            System.Debug('#######################################opportunity.Shipping_Country__c= ' + opportunity.Shipping_Country__c);
            System.Debug('#######################################ote.ShippingCountry= ' + ote.ShippingCountry);
    	}	             
        
    	System.Debug('#######################################opp.Locked__c UpdateOppAttributes= ' + opportunity.Locked__c);		        	      	   
    	if(opportunity.Locked__c != true)
        {
        	LockUnlockOppBroadcastItems(opportunity.Opportunity_Number__c, true);
        	opportunity.Locked__c = true;
        }   
        
        if (!Test.isRunningTest())
        {
        	update opportunity;
        }
    }       
    
    private void LockUnlockOppBroadcastItems(string oppNumber, boolean lockItem)
    {
    	List<Broadcast_Item__c> lineItemsList = [select Id, Locked__c from Broadcast_Item__c where Opportunity_Number__c = :oppNumber];
    	System.Debug('#######################################oppNumber = ' + oppNumber);
    	if(lineItemsList != null)
    	{
    		for (Broadcast_Item__c i : lineItemsList)
			{
				i.Locked__c = lockItem;
			}
			
			if (!Test.isRunningTest())
			{
				update lineItemsList;
			}
    	}    	
    }
    
    @isTest(SeeAllData=true)
    static void TestOpportunityFinalTaxInvoiceExtensionPositive()
    {
        List<Account> accounts = TestingUtils.createAccounts(1, true);
        
        Opportunity opp = TestingUtils.createOpportunity(accounts[0].Id);        
        insert opp;
                
	    Prepaid_Clip_Package__c clipPackage = TestingUtils.createClipPackage(accounts[0].Id, TestingUtils.ADMIN_USER.Id, 'DVD Clip', true);
        Broadcast_Item__c broadcastItem = TestingUtils.createBroadcastItem(opp.Id,clipPackage.Id, true);
       	
       	opp = [select Id, Name, Opportunity_Number__c, Amount, AccountId, Opportunity_Status__c, Subtotal__c, Shipping_Cost__c, Sales_Tax__c, Total__c, Shipping_City__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Shipping_Country__c, Do_Not_Validate_Address__c from Opportunity where Id = :opp.Id];
       	       	       	               	         
        PageReference pageRef = Page.OpportunityFinalTaxInvoice;
        pageRef.GetParameters().put('id', opp.Id);
        Test.setCurrentPage(pageRef); 
        
        Test.startTest();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(opp); 
        OpportunityFinalTaxInvoiceExtension extension = new OpportunityFinalTaxInvoiceExtension(controller);
        OpportunityTaxExtension taxCalc = new OpportunityTaxExtension(opp.Id);                                                          
        extension.opp = opp;                       
        //boolean validAddress = taxCalc.ValidateOppShippingAddress(extension.opp);                                          
        extension.GenerateTaxAndInvoice();                                        
	    extension.UpdateOppAttributes(taxCalc, true);         
        
        extension.LockUnlockOppBroadcastItems((String)extension.opp.Opportunity_Number__c, true);
        extension.RedirectToOpp();                                                                 
        Test.stopTest();
    }
    
	@isTest(SeeAllData=true)
    static void TestOpportunityFinalTaxInvoiceExtensionNegative()
    {
        List<Account> accounts = TestingUtils.createAccounts(1, true);
        
        Opportunity opp = TestingUtils.createOpportunity(accounts[0].Id);
        opp = TestingUtils.updateOpportunityWithInvalidAddress(opp);
        insert opp;
                
	    Prepaid_Clip_Package__c clipPackage = TestingUtils.createClipPackage(accounts[0].Id, TestingUtils.ADMIN_USER.Id, 'DVD Clip', true);
        Broadcast_Item__c broadcastItem = TestingUtils.createBroadcastItem(opp.Id,clipPackage.Id, true);       	
       	
       	opp = [select Id, Name, Opportunity_Number__c, Amount, AccountId, Opportunity_Status__c, Subtotal__c, Shipping_Cost__c, Sales_Tax__c, Total__c, Shipping_City__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Shipping_Country__c, Do_Not_Validate_Address__c from Opportunity where Id = :opp.Id];
       	       	       	               	         
        PageReference pageRef = Page.OpportunityFinalTaxInvoice;
        pageRef.GetParameters().put('id', opp.Id);
        Test.setCurrentPage(pageRef); 
        
        Test.startTest();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(opp); 
        OpportunityFinalTaxInvoiceExtension extension = new OpportunityFinalTaxInvoiceExtension(controller);
        OpportunityTaxExtension taxCalc = new OpportunityTaxExtension(opp.Id);                                                          
        extension.opp = opp;                       
        //boolean validAddress = taxCalc.ValidateOppShippingAddress(extension.opp);                                          
        extension.GenerateTaxAndInvoice();
        extension.UpdateOppAttributes(taxCalc, false); 
        extension.LockUnlockOppBroadcastItems((String)extension.opp.Opportunity_Number__c, false);
         System.debug('Id = ' + extension.opp.Id);    
        System.debug('Amount = ' + extension.opp.Amount);
        System.debug('Total = ' + extension.opp.Total__c);
        System.debug('Shipping Cost = ' + extension.opp.Shipping_Cost__c);        
        System.debug('Shipping Street Invoice Test 1 = ' + extension.opp.Shipping_Street__c);         
        //extension.GenerateTaxAndInvoice();       
        //opp.Amount = -100;  
        //opp.Shipping_Cost__c = -300;              
        //boolean validAddress = taxCalc.ValidateOppShippingAddress(opp); 
        //System.assert(validAddress, false);        
        //update opp;
        //opp = [select Id, Name, Opportunity_Number__c, Amount, AccountId, Opportunity_Status__c, Subtotal__c, Shipping_Cost__c, Sales_Tax__c, Total__c, Shipping_City__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Shipping_Country__c, Do_Not_Validate_Address__c from Opportunity where Id = :opp.Id];
        //opp = TestingUtils.updateOpportunityWithInvalidAddress(opp);
        //System.assertEquals(updatedOpp.Amount, 1000);
        //System.assertEquals(updatedOpp.Shipping_Cost__c, 300);
        //extension.opp = opp; 
        //System.debug('Id = ' + extension.opp.Id);
        //System.debug('Amount = ' + extension.opp.Amount);
       // System.debug('Total = ' + extension.opp.Total__c);
       // System.debug('Shipping Cost = ' + extension.opp.Shipping_Cost__c);
       // System.debug('Shipping Street Invoice 2 = ' + extension.opp.Shipping_Street__c);
        //opp.Amount = 0;
        //update opp;
        //opp = [select Id, Name, Opportunity_Number__c, Amount, AccountId, Opportunity_Status__c, Subtotal__c, Shipping_Cost__c, Sales_Tax__c, Total__c, Shipping_City__c, Shipping_State__c, Shipping_Street__c, Shipping_Zip__c, Shipping_Country__c from Opportunity where Id = :opp.Id];        
        //extension.GenerateTaxAndInvoice();        
        //extension.CalculateTaxAndInvoice();  
    }
}