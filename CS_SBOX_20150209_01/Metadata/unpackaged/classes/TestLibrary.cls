public with sharing class TestLibrary
{
  // Profiles
  public static final Id STANDARD_USER_PROFILE = [ SELECT Id FROM Profile Where Name = 'Standard User' ].Id;
  public static final Id SYSTEM_ADMIN_USER_PROFILE = [ SELECT Id FROM Profile Where Name = 'System Administrator' ].Id;
  public static final Id BROADCAST_TRANSACTION_PROFILE = [ SELECT Id FROM Profile Where Name = 'Broadcast Transaction Manager' ].Id;
  public static final Id NEW_BIZ_PROFILE = [ SELECT Id FROM Profile Where Name = 'New Biz Manager' ].Id;
  public static final Id MARKETING_PROFILE = [ SELECT Id FROM Profile Where Name = 'Marketing' ].Id;
  
  // Record Types
  public static final Id TASK_CLIENT_SERVICES_RECORD_TYPE = [select Id from RecordType where SObjectType = 'Task' and Name = 'Client Services'].Id;  
  public static final Id OPPORTUNITY_NEW_BIZ_RECORD_TYPE = [select Id from RecordType where SObjectType = 'Opportunity' and Name = 'new Biz'].Id;  
  public static final Id OPPORTUNITY_RENEWALS_RECORD_TYPE = [select Id from RecordType where SObjectType = 'Opportunity' and Name = 'Renewals'].Id;  
  
  // Users
  public static final Id SFDC_ADMIN_USER = [Select Id from User where Name = 'SFDC Admin'].Id;
  
  // Init the AvaTax Code
  public static void InitAvaTax()
  {
    AVA_SFCORE__TaxNowSetting__c taxSetting = new AVA_SFCORE__TaxNowSetting__c(AVA_SFCORE__Active_Setting__c = true, Name = 'Test', AVA_SFCORE__TriggerLimit__c = 1,
      AVA_SFCORE__Service_URL__c = 'https://development.avalara.net', AVA_SFCORE__Account_Number__c = '1100107187', AVA_SFCORE__License_Key__c = '95B2171CB9439C83', 
      AVA_SFCORE__Company_Code__c = 'Cision', AVA_SFCORE__Origin_Street__c = '332 S Michigan Ave Ste 800', AVA_SFCORE__Origin_City__c = 'Chicago', AVA_SFCORE__Origin_State__c = 'IL', 
      AVA_SFCORE__Origin_Postal_Code__c = '60604-4434', AVA_SFCORE__Origin_Country__c = 'US', AVA_SFCORE__Enable_Tax_Calculation__c = true, AVA_SFCORE__Enable_Commits__c = true, 
      AVA_SFCORE__Enable_Address_Validation__c = true, AVA_SFCORE__Verify_Validated_Addresses__c = true);
  
    insert taxSetting;
  }
  
  // Create Users
  public static List<User> CreateUsers(String uName, Id profileId, Integer num)
  {
    List<User> userList = new List<User>();
    
    for (Integer i = 0; i < num; i++)
    {
      userList.add(TestLibrary.CreateUser(uName+i, profileId));  
    }
    
    return userList;
  }
  
  public static User CreateUser ( String uName, Id profileId)
  {
    User u = new User(FirstName='Test', LastName='User', UserName=uname+'@cisionus.com', Email=uname+'@cisionus.com', Alias=uname,
                                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname=uname,
                                ProfileId = profileId, TimeZoneSidKey='America/New_York', isActive = true, Hire_Date__c = Date.today() );
    
    return u;
    }
  
  // Crewate Accounts
  public static List<Account> CreateAccounts(String aName, Id ownerId, Integer num)
  {
    List<Account> accountList = new List<Account>();
    
    for (Integer i = 0; i < num; i++)
    {
      accountList.add(TestLibrary.CreateAccount(aName+i, ownerId));  
    }
    
    return accountList;
  }
  
  public static Account CreateAccount(String aName, Id ownerId)
  {
     Account a = new Account ( Name = aName, BillingCountry = 'USA', BillingStreet = '123 Main St', BillingCity = 'Chicago', BillingState = 'IL',
                      BillingPostalCode = '60603', Phone = '001 323 2121334', Verified__c = true, OwnerId = ownerId, Required_Invoice_Contact_Name__c = 'test', Required_Invoice_Contact_Email__c = 'test@cisionus.com');
    
    return a;
  }
  
  // Create Contacts
  public static List<Contact> CreateContacts(String lastName, String email, Id OwnerId, Id accountId, Integer num)
  {
    List<Contact> contactList = new List<Contact>();
    
    for (Integer i = 0; i < num; i++)
    {
      contactList.add(TestLibrary.CreateContact(lastName+i, email, ownerId, accountId));  
    }
    
    return contactList;
  }
  
  public static Contact CreateContact(String lastName, String email, Id OwnerId, Id accountId)
  {
        Contact c = new Contact(LastName = lastName, Email = email, OwnerId = OwnerId, AccountId = accountId);
        
    return c;
    }
  
  // Create Opportunity
  public static List<Opportunity> CreateOpportunities(String Name, Id OwnerId, Id accountId, Integer num)
  {
    List<Opportunity> OpportunityList = new List<Opportunity>();
    
    for (Integer i = 0; i < num; i++)
    {
      OpportunityList.add(TestLibrary.CreateOpportunity(Name+i, ownerId, accountId));  
    }
    
    return OpportunityList;
  }
  
  public static Opportunity CreateOpportunity(String Name, Id OwnerId, Id accountId)
  {
        Opportunity o = new Opportunity(Name = Name, AccountId = accountId, StageName = 'Contacted', CloseDate = Date.today(), OwnerId = ownerId, PriceBook2Id = Test.getStandardPricebookId(), 
      Shipping_Street__c = '332 S. Michigan', Shipping_City__c = 'Chicago', Shipping_State__c = 'IL', Shipping_Zip__c = '60604', Shipping_Country__c = 'USA', Invoice_Contact_Email__c = 'test@cisionus.com', Invoice_Contact_Name__c = 'Test');
        
    return o;
    }       
  
  // Create Line Items
  public static List<OpportunityLineItem> CreateOpportunityLineItems(String productCode, Id oppId, Integer num)
  {
    List<OpportunityLineItem> liList = new List<OpportunityLineItem>();
    
    Product2 prod = new Product2(Name = 'TestProduct', IsActive=true, ProductCode=productCode);
    insert prod;
    PriceBookEntry pbe = new PriceBookEntry(Product2Id = prod.Id, Pricebook2Id = Test.getStandardPricebookId(), IsActive = true, UnitPrice = 200);
    insert pbe;
    
    for (Integer i = 0; i < num; i++)
      {
      liList.add(new OpportunityLineItem(OpportunityId = oppId, PriceBookEntryId = pbe.Id, UnitPrice = 200, Quantity = 1));
    }
    
    return liList;
  }
  
  public static List<OpportunityLineItem> CreateOpportunityLineItems(Id productId, Id oppId, Integer num)
  {
    List<OpportunityLineItem> liList = new List<OpportunityLineItem>();
    
    PriceBookEntry pbe = new PriceBookEntry(Product2Id = productId, Pricebook2Id = Test.getStandardPricebookId(), IsActive = true, UnitPrice = 200);
    insert pbe;
    
    for (Integer i = 0; i < num; i++)
    {
      liList.add(new OpportunityLineItem(OpportunityId = oppId, PriceBookEntryId = pbe.Id, UnitPrice = 200, Quantity = 1));
    }
    
    return liList;
  }
  
  // Create Line Items
  public static List<OpportunityLineItem> CreateOpportunityLineItems(string productName, string productCode, Id oppId, Integer num, string productFamily, string productEdition, string productSubFamily)
  {
    List<OpportunityLineItem> liList = new List<OpportunityLineItem>();
    
    Product2 prod = new Product2(Name = productName, IsActive=true, ProductCode=productCode, Edition__c = productEdition, Family = productFamily, Sub_Family__c = productSubFamily);
    insert prod;
    PriceBookEntry pbe = new PriceBookEntry(Product2Id = prod.Id, Pricebook2Id = Test.getStandardPricebookId(), IsActive = true, UnitPrice = 200);
    insert pbe;
    
    for (Integer i = 0; i < num; i++)
      {
      liList.add(new OpportunityLineItem(OpportunityId = oppId, PriceBookEntryId = pbe.Id, UnitPrice = 200, Quantity = 1));
    }
    
    return liList;
  }
    
  // Create Campaigns
  public static List<Campaign> CreateCampaigns(String cName, Id ownerId, Integer num)
  {
    List<Campaign> campaignList = new List<Campaign>();
    
    for (Integer i = 0; i < num; i++)
    {
      campaignList.add(TestLibrary.CreateCampaign(cName+i, ownerId));  
    }
    
    return campaignList;
  }
  
  public static Campaign CreateCampaign(String cName, Id ownerId)
    {
    Campaign c = new Campaign(Name = cName, Team_Queue__c = 'New Biz', Campaign_Goal__c = 'Sales Leads (1)', Type = 'Email', 
      Product__c = 'Plan', Offer__c = 'Webinar', OwnerId = ownerId);
          
        return c;
  }
  
  // Create Quote
  public static List<SBQQ__Quote__c> CreateQuotes(Id accountId, Id opportunityId, Integer num)
  {
    List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
    
    for (Integer i = 0; i < num; i++)
    {
      quoteList.add(TestLibrary.CreateQuote(accountId, opportunityId));  
    }
    
    return quoteList;
  }
  
  public static SBQQ__Quote__c CreateQuote(Id accountId, Id opportunityId)
  {
    SBQQ__Quote__c q = new SBQQ__Quote__c(SBQQ__Primary__c = false, SBQQ__Status__c = 'Draft', SBQQ__SubscriptionTerm__c = 12, 
      SBQQ__StartDate__c = Date.today(), Payment_Type__c = 'Credit Card', Payment_Plan__c = 'Custom', SBQQ__Opportunity__c = opportunityId, SBQQ__Type__c = 'Quote', SBQQ__Account__c = accountId);
    
    return q;
  }
  
  // Create Quote Lines
  public static SBQQ__QuoteLine__c createQuoteLine(Id quoteId, Id productId)
  {
    SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c(SBQQ__Quote__c = quoteId, SBQQ__Product__c = productId);
    
    return ql;
  }
  
  public static List<SBQQ__QuoteLine__c> createQuoteLines(Id quoteId, Id productId, Integer num)
  {
    List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
    
    for (Integer i = 0; i < num; i++)
    {
      quoteLineList.add(TestLibrary.createQuoteLine(quoteId, productId));
    }
    
    return quoteLineList;
  }
  
  // Create Case
  public static Case createCase(String subject, Id accountId)
  {
    Case c = new Case(AccountId = accountId, Subject = subject);
    
    return c;
  }
  
  public static List<Case> createCases(String subject, Id accountId, Integer num)
  {
    List<Case> caseList = new List<Case>();
    
    for (Integer i = 0; i < num; i++)
    {
      caseList.add(TestLibrary.createCase(subject+i, accountId));
    }
    
    return caseList;
  }
  
  // Create Product
  public static Product2 createProduct(String name, String code, String family)
  {
    Product2 p = new Product2(Name = name, ProductCode = code, Family = family);
    
    return p;
  }
  
  public static List<Product2> createProducts(String name, String code, String family, Integer num)
  {
    List<Product2> productList = new List<Product2>();
    
    for (Integer i = 0; i < num; i++)
    {
      productList.add(TestLibrary.createProduct(name+i, code+i, family+i));
    }
    
    return productList;
  }
  
  // Create Tasks
   public static List<Task> CreateTasks(String subject, String status, String type, Integer num)
    {
        List<Task> tasks = new List<Task>();
        
    for (Integer i = 0; i < num; i++)
    {
            tasks.add(TestLibrary.CreateTask(subject, status, type));
        }
        
    return tasks;
    }
  
  public static Task CreateTask(String subject, String status, String type)
  {
    Task t = new Task(Subject=subject, Status=status, Type=type, CallType='Outbound');
    
    return t;
  }

}