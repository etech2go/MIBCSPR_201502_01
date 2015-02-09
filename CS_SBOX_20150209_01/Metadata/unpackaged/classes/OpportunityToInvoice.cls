// --------------------------------------------------------------------------
// Ammendments:
//   When         Who          What
//   ===========  ===========  =================================================
//   22-FEB-2014  E Reyes      get Billing Address from account and Shipping Address from Opp
// --------------------------------------------------------------------------
public with sharing class OpportunityToInvoice {
    private Opportunity opp;
    private fw1__Invoice__c invoice;
    private fw1__Payment_Center_Setting__c setting;
    private decimal taxInAmount;
    private string INVOICED = 'Invoiced';
     
    
    public OpportunityToInvoice(string oppId){
        getPaymentSettings();  
        opp = getOpportunity(oppId);
    }
    
    public void process(){ 
    
    if (opp != null){
          if (isInvoiceForOpportunityExist(opp.id))
             return;
             
        //if (opp.Ready_for_Billing__c){
           invoice = createInvoice();
           updateOpportunityStatus();        
           updateInvoiceTax();
                     
           if (invoice.fw1__Balance_Due__c > 0){
               if (isPaymentProfileExists(opp.AccountId)){
                   InvoicePayment.doPayment(invoice.Id);
               } else {
                 fw1.Invoice.SendEmail(invoice.Id);
               }
           }
        //}
    }  
  }
  
    
    public fw1__Invoice__c createInvoice(){
         if (isInvoiceForOpportunityExist(opp.id))
           return null;
          
        addInvoice();
        addInvoiceLine();
        
        invoice = getInvoice(invoice.Id);
        updateOpportunityStatus();        
        updateInvoiceTax();
               
       return invoice;
    }
    
    private fw1__Invoice__c getInvoice(id invId){
         return [SELECT id,fw1__Balance_Due__c,fw1__Total_Lines_Amount__c,
                fw1__Tax__c,Name
                 FROM fw1__Invoice__c
                 WHERE id = :invId];
    }
    
    private boolean isInvoiceForOpportunityExist(id oppId){
         List<fw1__Invoice__c> invoices = new List<fw1__Invoice__c>();
         invoices = [ SELECT id,Name
                 FROM fw1__Invoice__c
                   WHERE fw2__Opportunity__c = :oppId
                   AND fw1__Is_Voided__c = false
                   LIMIT 1];
                      
       if (invoices.size() > 0) {
          return true;
        } else {
          return false;
        }
                   
    }
    
    private void updateOpportunityStatus(){
        opp.Invoice__c = invoice.Name;
      opp.Opportunity_Status__c = INVOICED;
      update opp;
    }
    
    private void updateInvoiceTax(){
        
       if (invoice.fw1__Total_Lines_Amount__c > 0 && invoice.fw1__Total_Lines_Amount__c != null){
          invoice.fw1__Tax__c = (taxInAmount * 100) / invoice.fw1__Total_Lines_Amount__c;
          update invoice;
       }
    }
    
    private boolean isPaymentProfileExists(string accountId){
        List<fw1__PaymentProfile__c> profiles = new List<fw1__PaymentProfile__c>();
        
        profiles = [SELECT Name,Id, fw1__Name_On_Account__c, fw1__Last_Name__c, fw1__First_Name__c, 
                      fw1__ExpiryYear__c, fw1__ExpiryMonth__c, fw1__CreditCardType__c, fw1__CreditCardNumber__c, 
                      fw1__Bank_Account_Number__c, fw1__Bank_ABA_Code__c
                    FROM fw1__PaymentProfile__c
                    WHERE fw1__Account__c = :accountId
                    AND fw1__UseAsDefault__c = true
                    LIMIT 1]; 
                    
        if (profiles.size() > 0) {
          return true;
        } else {
          return false;
        }
    }
    
    private Opportunity getOpportunity(string oppId){
         Opportunity o;
         try{
             o = [SELECT Name, AccountId, Description, Id,Billing_Address__c,
                    Ready_for_Billing__c, Shipping_Method__c,
                    Opportunity_Number__c,P_O_Number__c,OwnerId,Terms__c,
                    Invoice_Contact_Name__c,Invoice_Contact_Email__c,
                    Shipping_Cost__c,Shipping_Zip__c, Shipping_Street__c, 
                    Shipping_State__c, Shipping_Country__c, Shipping_City__c, 
                    Billing_Zip__c, Billing_Street__c, Billing_State__c, 
                    Billing_Country__c, Billing_City__c,Opportunity_Status__c,
                    CreatedById, Invoice_CC_Recipients__c
              FROM Opportunity
              WHERE Id = :oppId
              LIMIT 1];
         } catch (Exception e) {
     }
     return o;
    }
    
    private void addInvoice(){
        invoice = new fw1__Invoice__c();          
    invoice.fw1__Account__c = opp.AccountId;
    
    if (opp.Description != null){
        if (opp.Description.length() > 255)
          invoice.fw1__Description__c = opp.Description.substring(0,254);
        else
          invoice.fw1__Description__c = opp.Description;
    }
      
    invoice.fw2__Opportunity__c = opp.Id;
         
      
    //if(opp.Invoice_Contact_Name__c != null){
      invoice.fw1__Recipient_Name__c = opp.Invoice_Contact_Name__c;
      invoice.fw1__Recipient_Email__c = opp.Invoice_Contact_Email__c;
    //} else {
    //    invoice.fw1__Contact__c = opp.Invoice_Contact__c;
    //} 
    
    
    invoice.Opportunity_Number__c = opp.Opportunity_Number__c;
    invoice.PO_Number__c = opp.P_O_Number__c;
    invoice.Shipping_Method__c = opp.Shipping_Method__c;
    invoice.Billing_Terms__c = opp.Terms__c;
    invoice.fw1__Terms__c = getTerms(opp.Terms__c);
    User salesPerson = getSalesperson(opp.OwnerId);
    invoice.Salesperson__c = salesPerson.Name;
    invoice.fw1__Reply_To_Email__c  = salesPerson.Email;
    invoice.fw1__Email_CC_Recipients__c = opp.Invoice_CC_Recipients__c;
    
    invoice.fw1__Shipping_And_Handling__c = opp.Shipping_Cost__c;
    invoice.fw1__Email_Subject__c = ConvertVariables(setting.fw1__Default_Email_Subject__c);
    invoice.fw1__Email_Message__c = ConvertVariables(setting.fw1__Default_Email_Message__c);
    invoice.fw1__Terms_And_Conditions__c = ConvertVariables(setting.fw1__Default_Terms_And_Conditions__c);
    
    if (setting.fw1__Domain_Name__c != null) {
        if (setting.fw1__Domain_Name__c.contains('http')) {
            invoice.fw1__Domain_Name__c = setting.fw1__Domain_Name__c.substring(setting.fw1__Domain_Name__c.indexOf('//') + 2);
        } else {
          invoice.fw1__Domain_Name__c = setting.fw1__Domain_Name__c;
        }
    } else {
      invoice.fw1__Domain_Name__c = null;
    }
    
    setShippingAddressFromOpp();
    //if (invoice.fw1__Billing_Street__c == null){
    setBillingAddressFromAccount(opp.AccountId);
    //}
    
    insert invoice;
    }
    
    private double getTerms(string sTerms){
        double terms = 0.0;
        
        if (sTerms != null) {
            string termstr = sTerms.removeStartIgnoreCase('NET');
            if (termstr.isNumericSpace())
              terms = double.valueOf(termstr.trim());
        }
          
        return terms;
    }
    
    private User getSalesperson(id userId){
        User u;
        if(userId != null){
            try {
               u = [SELECT Name,Email FROM User WHERE Id = :userId]; 
            } catch (Exception e){
                
            }
        }
        return u;
    }
    
    private void addInvoiceLine(){
        List<fw1__Invoice_Line__c> invLines = new List<fw1__Invoice_Line__c>();
        List<Broadcast_Item__c> items = new List<Broadcast_Item__c>();
        items = [SELECT Id,Product_Detail__c, Price__c, Inventory_Item__c, Discount__c,
                  Subject_Description__c,Air_Date__c,Air_Time__c,Market_Station__c,
                  Program_Title__c,Item__c,Tax__c,Subtotal_w_Discount__c
                 FROM Broadcast_Item__c
                 WHERE Opportunity__c = :opp.Id];
                 
        taxInAmount = 0;   
        for (Broadcast_Item__c item : items){
          fw1__Invoice_Line__c invLine = new fw1__Invoice_Line__c();
              invLine.fw1__Invoice__c = invoice.Id;
              invLine.fw1__Quantity__c = 1;
              invLine.fw1__Unit_Price__c = item.Subtotal_w_Discount__c;
              invLine.fw1__Item_Description__c = item.Subject_Description__c;
              //invLine.fw1__Discount_Amount__c = item.Discount__c;
              invLine.Name = item.Item__c;
              invLine.Air_Date__c = item.Air_Date__c;
              invLine.Air_Time__c = item.Air_Time__c;
              invLine.Market_and_Station__c = item.Market_Station__c;
              invLine.Program_Title__c = item.Program_Title__c;
              
              if (item.Tax__c != null && item.Tax__c > 0)
                taxInAmount += item.Tax__c;
                
              invLines.add(invLine);
        }
        
        insert invLines;
    }

    private void getPaymentSettings(){
        setting = 
          [SELECT 
           fw1__Default_Email_Subject__c, fw1__Default_Email_Message__c, 
           fw1__Default_Terms_And_Conditions__c,
             fw1__Online_Payment_Type__c,  
             fw1__Domain_Name__c,  fw1__Email_Currency_Symbol__c,
             fw1__Sender_Display_Name__c     
      FROM fw1__Payment_Center_Setting__c
      WHERE Name = 'Default Settings'
      LIMIT 1];
    }
 
  private void setBillingAddressFromAccount(string accountId) {
     
    
    Account acct = [SELECT 
         BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,
         ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry
         FROM Account
         WHERE id = :accountId];
         
      if (acct != null) {
            if (acct.BillingStreet != null) {
                invoice.fw1__Billing_Street__c = acct.BillingStreet;
                invoice.fw1__Billing_City__c = acct.BillingCity;
                invoice.fw1__Billing_State__c = acct.BillingState;
                invoice.fw1__Billing_Zip__c = acct.BillingPostalCode;
                invoice.fw1__Billing_Country__c = fixCountry(acct.BillingCountry);
            }
          /*  
          if (acct.ShippingStreet != null) {
              invoice.fw1__Shipping_Street__c = acct.ShippingStreet;
              invoice.fw1__Shipping_City__c = acct.ShippingCity;
              invoice.fw1__Shipping_State__c = acct.ShippingState;
              invoice.fw1__Shipping_Zip__c = acct.ShippingPostalCode;
              invoice.fw1__Shipping_Country__c = fixCountry(acct.ShippingCountry);
          }
          */
            
      }
  }
  
  private void setShippingAddressFromOpp() {
    /*  
    if (opp.Billing_Street__c != null) {
        invoice.fw1__Billing_Street__c = opp.Billing_Street__c;
        invoice.fw1__Billing_City__c = opp.Billing_City__c;
        invoice.fw1__Billing_State__c = opp.Billing_State__c;
        invoice.fw1__Billing_Zip__c = opp.Billing_Zip__c;
        invoice.fw1__Billing_Country__c = fixCountry(opp.Billing_Country__c);
    }
    */
      if (opp.Shipping_Street__c != null) {
          invoice.fw1__Shipping_Street__c = opp.Shipping_Street__c;
          invoice.fw1__Shipping_City__c = opp.Shipping_City__c;
          invoice.fw1__Shipping_State__c = opp.Shipping_State__c;
          invoice.fw1__Shipping_Zip__c = opp.Shipping_Zip__c;
          invoice.fw1__Shipping_Country__c = fixCountry(opp.Shipping_Country__c);
      }
            
      
  }
  
  public static string fixCountry(String inputCountry) {
        String outputCountry;
        if (inputCountry != null) {
            Map<String, String> countryMap = getCountryCrossRef();
            outputCountry = countryMap.get(inputCountry.toUpperCase());
            if (outputCountry == null) {
                Integer strLen = inputCountry.length();
                if (strLen > 10) {
                    strLen = 10;
                }
                outputCountry = inputCountry.substring(0,strLen);
            }
        }
        return outputCountry;
  }
    
    
  
   private string ConvertVariables(String inputString) {
        String outputString = inputString;
        
        if (inputString != null) {
            String companyName;
            try {
                User u = [SELECT Email, CompanyName
                            FROM User
                           WHERE Id = :Userinfo.getUserId()];
                
                companyName = u.CompanyName;
            }
            catch (Exception e) {
            }
            
            if (companyName == null) {
                
                companyName = setting.fw1__Sender_Display_Name__c;
            }
            
            if (inputString.contains('{COMPANY_NAME}')) {
                outputString = inputString.replace('{COMPANY_NAME}',companyName);
            }
        }
        
        return outputString;
    }
    
    
    
    public static Map<String, String> getCountryCrossRef() {
        Map<String, String> countryCrossRef = new Map<String, String>{
            'UNITED STATES' => 'US',
            'UNITED STATES OF AMERICA' => 'US',
            'USA' => 'US',
            'UNITED KINGDOM' => 'GB',
            'UK' => 'GB',
            'U.K.' => 'GB',
            'ENGLAND' => 'GB',
            'ARGENTINA' => 'AR',
            'ARUBA' => 'AW',
            'AUSTRALIA' => 'AU',
            'AUSTRIA' => 'AT',
            'BAHRAIN' => 'BH',
            'BELGIUM' => 'BE',
            'BELIZE' => 'BZ',
            'BRAZIL' => 'BR',
            'BULGARIA' => 'BG',
            'CANADA' => 'CA',
            'CHILE' => 'CL',
            'CHINA' => 'CN',
            'COLOMBIA' => 'CO',
            'COSTA RICA' => 'CR',
            'CYPRUS' => 'CY',
            'CZECH REPUBLIC' => 'CZ',
            'DENMARK' => 'DK',
            'DOMINICAN REPUBLIC' => 'DO',
            'ECUADOR' => 'EC',
            'EGYPT' => 'EG',
            'FINLAND' => 'FI',
            'FRANCE' => 'FR',
            'GERMANY' => 'DE',
            'GHANA' => 'GH',
            'GREECE' => 'GR',
            'GUAM' => 'GU',
            'HONDURAS' => 'HN',
            'HONG KONG' => 'HK',
            'HUNGARY' => 'HU',
            'ICELAND' => 'IS',
            'INDIA' => 'IN',
            'INDONESIA' => 'ID',
            'IRELAND' => 'IE',
            'ISRAEL' => 'IL',
            'ITALY' => 'IT',
            'JAMAICA' => 'JM',
            'JAPAN' => 'JP',
            'JORDAN' => 'JO',
            'REPUBLIC OF KOREA' => 'KR',
            'KOREA' => 'KR',
            'KUWAIT' => 'KW',
            'LITHUANIA' => 'LT',
            'LUXEMBOURG' => 'LU',
            'MACAO' => 'MO',
            'MALAYSIA' => 'MY',
            'MAURITIUS' => 'MU',
            'MEXICO' => 'MX',
            'MONACO' => 'MC',
            'MONGOLIA' => 'MN',
            'MONTENEGRO' => 'ME',
            'MOROCCO' => 'MA',
            'NAMIBIA' => 'NA',
            'NETHERLANDS' => 'NL',
            'THE NETHERLANDS' => 'NL',
            'NEW ZEALAND' => 'NZ',
            'NICARAGUA' => 'NI',
            'NORWAY' => 'NO',
            'OMAN' => 'OM',
            'PALESTINE' => 'PS',
            'PANAMA' => 'PA',
            'PARAGUAY' => 'PY',
            'PERU' => 'PE',
            'PHILIPPINES' => 'PH',
            'POLAND' => 'PL',
            'PORTUGAL' => 'PT',
            'PUERTO RICO' => 'PR',
            'QATAR' => 'QA',
            'RUSSIAN FEDERATION' => 'RU',
            'RUSSIA' => 'RU',
            'SAMOA' => 'WS',
            'SAUDI ARABIA' => 'SA',
            'SERBIA' => 'RS',
            'SINGAPORE' => 'SG',
            'SOUTH AFRICA' => 'ZA',
            'SPAIN' => 'ES',
            'ESPANA' => 'ES',
            'SWEDEN' => 'SE',
            'SWITZERLAND' => 'CH',
            'TAIWAN' => 'TW',
            'TANZANIA' => 'TZ',
            'THAILAND' => 'TH',
            'TRINIDAD AND TOBAGO' => 'TT',
            'TURKEY' => 'TR',
            'UGANDA' => 'UG',
            'UKRAINE' => 'UA',
            'UNITED ARAB EMIRATES' => 'AE',
            'URUGUAY' => 'UY',
            'VENEZUELA' => 'VE',
            'VIET NAM' => 'VN',
            'VIETNAM' => 'VN',
            'BRITISH VIRGIN ISLANDS' => 'VG',
            'ZAMBIA' => 'ZM'
        };
        return countryCrossRef;
    }
    
   @isTest(SeeAllData=true)
    public static  void testCreateInvoice() {
    
    // Create an account
    Account a = new Account();
    a.Name = 'Test Account';
    a.BillingStreet = 'BillingStreet';
    a.BillingCity = 'BillingCity';
    a.BillingState = 'CA';
    a.BillingPostalCode = '90210';
    a.BillingCountry = 'US';
    a.Terms__c = 'Net 30';
    a.ShippingStreet = 'ShippingStreet';
    a.ShippingCity = 'ShippingCity';
    a.ShippingState = 'CA';
    a.ShippingPostalCode = '90210';
    a.ShippingCountry = 'US';
    insert a;
    
    fw1__PaymentProfile__c profile = new fw1__PaymentProfile__c();
    profile.fw1__Account__c = a.Id;
    insert profile;
    
              
    // Create an opportunity
    Opportunity o = new Opportunity();
    o.Name = 'Test Opportunity';
    o.Description = 'Test Opportunity Description';
    o.StageName = 'Closed';
    o.CloseDate = Date.today();
    o.AccountId = a.Id;
    o.Shipping_Method__c = 'E-mail';
    o.P_O_Number__c = 'Test PO';
    o.Invoice_Contact_Name__c = 'Jack Ryan';
    o.Invoice_Contact_Email__c = 'test@kulturra.com';
    o.Shipping_Cost__c = 1;
    o.Shipping_Zip__c = a.ShippingPostalCode; 
    o.Shipping_Street__c = a.ShippingStreet;
    o.Shipping_State__c = a.ShippingState;
    o.Shipping_Country__c = a.ShippingCountry; 
    o.Shipping_City__c  = a.ShippingCity;
    o.Billing_Zip__c = a.BillingPostalCode;
    o.Billing_Street__c = a.BillingStreet; 
    o.Billing_State__c = a.BillingState;
    o.Billing_Country__c = a.BillingCountry; 
    o.Billing_City__c = a.BillingCity;
    insert o;
    
    Prepaid_Clip_Package__c clip;
    clip = new Prepaid_Clip_Package__c();
    clip.Account__c = a.Id;
    clip.Expiration_Date__c = Date.today();
    clip.Purchase_Date__c = Date.today();
    clip.Total_Package_Amount__c = 99.99;
    clip.Sold_By__c = o.OwnerId;
    clip.Number_of_Clips__c = 1;
    insert clip;
        
    Broadcast_Item__c item = new Broadcast_Item__c();
    item.Opportunity__c = o.id;
    item.Inventory_Item__c = 'DVD - Video';
    item.Product_Detail__c = 'Standard (720x480)';
    item.Air_Date__c = Date.today();
    item.Air_Time__c = '11:59 PM';
    item.Program_Title__c = 'Test Program';
    item.Subject_Description__c = 'Test Description';
    item.Clip_Package__c = clip.id;
    
    
    
    insert item;
        
     OpportunityToInvoice opp2inv = new OpportunityToInvoice(o.Id);
     opp2inv.process();
    
    ApexPages.StandardController std = new ApexPages.StandardController(o);
    OpportunityToInvoiceController controller = new OpportunityToInvoiceController (std);
    controller.createInvoice();
        
             
  }
  
  @isTest(SeeAllData=true)
    static void TestOpportunityToInvoice()
    {
        List<Account> accounts = TestingUtils.createAccounts(1, true);
        
        Opportunity opp = TestingUtils.createOpportunity(accounts[0].Id);
        insert opp;
        Prepaid_Clip_Package__c clipPackage = TestingUtils.createClipPackage(accounts[0].Id, TestingUtils.ADMIN_USER.Id, 'DVD Clip', true);
        Broadcast_Item__c broadcastItem = TestingUtils.createBroadcastItem(opp.Id,clipPackage.Id, true);
                            
        Test.StartTest();
        OpportunityToInvoice inv = new OpportunityToInvoice(opp.Id);
        inv.process();
                
        Test.StopTest();
        
        
    }
}