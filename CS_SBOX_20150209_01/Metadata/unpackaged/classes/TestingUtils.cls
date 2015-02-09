@isTest
public class TestingUtils {

    public static Boolean WILL_INSERT = true; 
    public static Boolean WONT_INSERT = !WILL_INSERT;
    public static Integer UNIQUE_COUNT = 0;
    public static final Id TEST_PROFILE_ID = [ SELECT Id FROM Profile Where Name = 'Standard User'].Id;
    public static final Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
    public static final Id BROADCAST_TRANSACTION_MANAGER_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'Broadcast Transaction Manager'].Id;
    public static final Id BROADCAST_TRANSACTION_SALES_USER_ID = [SELECT Id FROM Profile WHERE Name = 'Broadcast Transaction Sales User'].Id;
    public static User ADMIN_USER {
        get{
            if ( null == ADMIN_USER ){
                ADMIN_USER = [Select Id from User where ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
            }
            return ADMIN_USER;
        }
        private set;
    }
	
    public static User BT_MANAGER {
        get{
            if ( null == BT_MANAGER ){
                BT_MANAGER = [Select Id from User where ProfileId = :BROADCAST_TRANSACTION_SALES_USER_ID and IsActive = true LIMIT 1];
            }
            return BT_MANAGER;
        }
        private set;
    }
    
    public static Id getSystemAdministratorProfileId() { return SYS_ADMIN_PROFILE_ID; }
    public static Id getBroadcastTransactionManagerProfileId() { return BROADCAST_TRANSACTION_MANAGER_PROFILE_ID; }

	// Init the AvaTax Code
	public static void InitAvaTax()
	{
		AVA_SFCORE__TaxNowSetting__c taxSetting = new AVA_SFCORE__TaxNowSetting__c();
		taxSetting.AVA_SFCORE__Active_Setting__c = true;
		taxSetting.Name = 'Test';
		taxSetting.AVA_SFCORE__TriggerLimit__c = 1;
		taxSetting.AVA_SFCORE__Service_URL__c = 'https://development.avalara.net';
		taxSetting.AVA_SFCORE__Account_Number__c = '1100107187';
		taxSetting.AVA_SFCORE__License_Key__c = '95B2171CB9439C83';
		taxSetting.AVA_SFCORE__Company_Code__c = 'Cision';
		taxSetting.AVA_SFCORE__Origin_Street__c = '332 S Michigan Ave Ste 800';
		taxSetting.AVA_SFCORE__Origin_City__c = 'Chicago';
		taxSetting.AVA_SFCORE__Origin_State__c = 'IL';
		taxSetting.AVA_SFCORE__Origin_Postal_Code__c = '60604-4434';
		taxSetting.AVA_SFCORE__Origin_Country__c = 'US';
		taxSetting.AVA_SFCORE__Enable_Tax_Calculation__c = true;
		taxSetting.AVA_SFCORE__Enable_Commits__c = true;
		taxSetting.AVA_SFCORE__Enable_Address_Validation__c = true;
		taxSetting.AVA_SFCORE__Verify_Validated_Addresses__c = true;
		insert taxSetting;
	}
	
    /*
     *      Account factories
     */
    //Using this
    public static List<Account> createAccounts( Integer numOfAcc, Boolean doInsert )
    {
        List<Account> testAcc = new List<Account>();
        for( Integer i = 0; i < numOfAcc; i++ )
        {
			
           Account acc = new Account ( Name = 'test123' + i,
                                        BillingCountry = 'USA',
										//BillingCountryCode = 'US',
                                        BillingStreet = '123 Main St',
								    	BillingCity = 'Chicago',
								    	BillingState = 'IL',
								    	BillingPostalCode = '60603',
										Phone = '001 323 2121334',
                                        // Due to more rules on Shipping Address
                                        ShippingCountry = 'USA',
                                        //ShippingStreet = '123 Main St',
                                        //ShippingCity = 'Chicago',
                                        //ShippingState = 'IL',
                                        //ShippingPostalCode ='60603',
                                        Verified__c = true										
								    	);
			
			 
            testAcc.add( acc );
        }
        if( doInsert )
            insert testAcc;
        return testAcc;
    }

    public static Account createAccount(){
        List<Account> tempList = createAccounts(1, false);
        return tempList[0];
    }

    public static List<Account> createAccounts( Integer numOfAcc )
    {
        List<Account> testAcc = createAccounts( numOfAcc, true );
        return testAcc;
    }

    public static List<Account> createAccounts( Integer numOfAcc, Id recordTypeId, Boolean doInsert )
    {
        List<Account> accounts = createAccounts( numOfAcc, false );
        for( Account acc : accounts )
        {
            //acc.RecordTypeId = recordTypeId;
        }
        if ( doInsert )
            insert accounts;
        return accounts;
    }

    /*
     *      Opportunity factories
     */
    public static List<Opportunity> createOpportunities(Integer numOfOpp, Boolean doInsert )
    {
        List<Opportunity> testOpp = new List<Opportunity>();
        for ( Integer i = 0; i < numOfOpp; i++ )
        {
            Opportunity opp = new Opportunity ();
            opp.Opportunity_Status__c = 'Pending Sale';
            opp.Name = 'testOppName' + i;
            opp.StageName = 'Closed Won';
			opp.Close_Reasons_del__c = 'Hired Agency';
			opp.Competitor_Name__c = 'Agency';
            opp.CloseDate = Date.today();
			opp.Up_Against__c = 'Agency';
			opp.OwnerId = BT_MANAGER.Id; //UserInfo.getUserId();            
            opp.Invoice_Contact_Name__c = 'Test';
            opp.Invoice_Contact_Email__c = 'test@test.com';
            opp.Shipping_Street__c = '332 S. Michigan';
    		opp.Shipping_City__c = 'Chicago';
    		opp.Shipping_State__c = 'IL';
    		opp.Shipping_Zip__c = '60604';
    		opp.Shipping_Country__c = 'USA';
    		opp.Amount = 200;
    		opp.Shipping_Cost__c = 100;
    		opp.Route_To__c = '';
    		opp.On_Hold_Reason__c = '';
    		//opp.Sales_Tax__c = 20;
            testOpp.add( opp );
        }
        if(doInsert)
        {
            insert testOpp;
        }
        return testOpp;
    }

    public static List<Opportunity> createOpp( Integer numOfOpp, String recType )
    {
        String recTypeId = [select Id from RecordType where SObjectType = 'Opportunity' AND DeveloperName = :recType].Id;
        return createOpportunities( numOfOpp,recTypeId, false );
    }

    public static Opportunity createOpp(String recType){
        List<Opportunity> tempOppList = TestingUtils.createOpp(1, recType);
        return tempOppList[0];
    }
    
    public static Opportunity createOppWithProbability(Integer prob){
        List<Opportunity> tempOppList = TestingUtils.createOpportunities(1, false);
        tempOppList[0].Probability = prob;
        return tempOppList[0];
    }
    
    public static Opportunity createOpportunity(ID accountId){
        List<Opportunity> tempOppList = TestingUtils.createOpportunities(1, false);
        tempOppList[0].AccountId = accountId;
        return tempOppList[0];
    }
    
    public static Opportunity updateOpportunityWithInvalidAddress(Opportunity opp){        
        opp.Shipping_Street__c = '123 Test Street';
    	opp.Shipping_City__c = 'Chicago';
    	opp.Shipping_State__c = 'IL';
    	opp.Shipping_Zip__c = '60604';
    	opp.Shipping_Country__c = 'USA';    	
        return opp;
    }
    
    public static Opportunity updateOpportunityWithValidAddressDoNotValidate(Opportunity opp){        
        opp.Shipping_Street__c = '123 Test Street';
    	opp.Shipping_City__c = 'Chicago';
    	opp.Shipping_State__c = 'IL';
    	opp.Shipping_Zip__c = '60604';
    	opp.Shipping_Country__c = 'USA';    
    	opp.Do_Not_Validate_Address__c = true;	
        return opp;
    }

    public static List<Opportunity> createOpportunities( Integer numOfOpp, Id recTypeId, Boolean doInsert )
    {
        List<Opportunity> testOpp = createOpportunities( numOfOpp, false );
        for ( Opportunity opp : testOpp )
        {
            opp.RecordTypeId = recTypeId;
        }
        if(doInsert)
        {
            insert testOpp;
        }
        return testOpp;
    }

	public static OpportunityContactRole createOpportunityContactRole(ID opportunityId, ID contactId)
	{
		OpportunityContactRole ocr = new OpportunityContactRole();
		ocr.ContactId = contactId;
		ocr.OpportunityId = opportunityId;
		ocr.Role = 'Business User';
		ocr.IsPrimary = true;
		
		return ocr;
	}
	
    public static Contact createAgent(Id accId, String lastName, String phone, Boolean doInsert){
        Contact agent = new Contact(LastName=lastName, Phone=phone, AccountId=accId);
        if(doInsert){
            insert agent;
        }
        return agent;
    }

    //Using this
    public static Opportunity createOpportunity(Id accId, Id agentId, Date startDate, String recTypeName, Boolean doInsert){
        Opportunity testOpp = new Opportunity(Name = 'Test Opp', AccountId = accId, RecordTypeId = getRecordTypeId('Opportunity', recTypeName),
                                    StageName = 'Closed Won', CloseDate = Date.today().addDays(10), Up_Against__c = 'Agency');
        if(doInsert){
            insert testOpp;
        }
        return testOpp;
    }       
        //Using this
    public static List<Opportunity> createOpportunities(Integer numOfOpp, Id accId, Id agentId, Date startDate, String recTypeName, Boolean doInsert){
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i=0; i<numOfOpp; i++){
            oppList.add(new Opportunity(Name = 'Test Opp', AccountId = accId, RecordTypeId = getRecordTypeId('Opportunity', recTypeName),
                                    StageName = 'Closed Won', Up_Against__c = 'Agency', CloseDate = Date.today().addDays(10)));
        }
        if(doInsert){
            insert oppList;
        }
        return oppList;
    }
	
	   //Using this
    public static List<Opportunity> createOpportunitiesWithEndDate(Integer numOfOpp, Id accId, Id agentId, Date startDate, 
    																Date endDate, String recTypeName, Boolean doInsert){
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i=0; i<numOfOpp; i++){
            oppList.add(new Opportunity(Name = 'Test Opp', AccountId = accId, RecordTypeId = getRecordTypeId('Opportunity', recTypeName),
                                    StageName = 'Closed Won', Up_Against__c = 'Agency', CloseDate = Date.today().addDays(10)));
        }
        if(doInsert){
            insert oppList;
        }
        return oppList;
    }
	
	public static Product2 createProduct(Boolean doInsert) {
        Product2 p2 = new Product2(Name = 'Test Product Name', Description = 'Test Product Description', ProductCode = 'TESTPRODUCTCODE');
        if(doInsert)
            insert p2;
        return p2;
    }
	
    //Using this
    public static Id getRecordTypeId(String objectName, String recTypeName){
        return [select Id from RecordType where SObjectType =: objectName  AND DeveloperName = :recTypeName].Id;
    }


    public static PricebookEntry createPriceBookEntry(Id prodId, Id priceBook2Id, Boolean doInsert) {
        PricebookEntry pbe = new PricebookEntry(Product2Id = prodId, PriceBook2Id = priceBook2Id, UnitPrice = 20);
        if(doInsert)
            insert pbe;
        return pbe;
    }

    public static Pricebook2 getStandardPriceBook2() {
        return [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1];
    }
   		
	public static List<Lead> createLeads(Integer size, Boolean doInsert )
    {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < size; i++) {
            Lead lead = new Lead(Company='ABC, Inc', Status='New', LastName='LastName ' + i, FirstName='FirstName ' + i, Email='Testemail@email.com', Country = 'USA', State = 'IL');
            leads.add(lead);
        }
        if ( doInsert )
            insert leads;
		
        return leads;
    }
	
	public static List<CampaignMember> createCampaignMembers(Integer size, Boolean doInsert )
    {
        List<CampaignMember> campaignMembers = new List<CampaignMember>();
        for (Integer i = 0; i < size; i++) {
            CampaignMember cm = new CampaignMember(Status='Responded');
            campaignMembers.add(cm);
        }
        if ( doInsert )
            insert campaignMembers;
		
        return campaignMembers;
    }
	
	public static List<Campaign> createCampaigns(Integer size, Boolean doInsert )
    {
		List<Campaign> campaigns = new List<Campaign>();
        for (Integer i = 0; i < size; i++) {
            Campaign c = new Campaign(Name='Test Campaign ' + i, Team_Queue__c = 'New Biz', Campaign_Goal__c = 'Sales Leads (1)', Type = 'Email', Product__c = 'Plan', Offer__c = 'Webinar');
            campaigns.add(c);
        }
        if ( doInsert )
            insert campaigns;
		
        return campaigns;
	}
	
    public static List<Task> createTasks( Integer size, Id recordTypeId, Boolean doInsert )
    {
        return createTasks( size, doInsert );
    }

    public static List<Task> createTasks( Integer size, Boolean doInsert )
    {
        List<Task> tasks = new List<Task>();
        for (Integer i = 0; i < size; i++) {
            Task newTask = new Task(Subject='Call', Status='Completed', Type='Call', CallType='Outbound');
            tasks.add(newTask);
        }
        if ( doInsert )
            insert tasks;
        return tasks;
    }

    public static List<Event> createEvents( Integer size, Boolean doInsert )
    {
        List<Event> events = new List<Event>();
        for (Integer i = 0; i < size; i++) {
            Event newEvent = new Event(Subject='Call',DurationInMinutes = 0);
            events.add(newEvent);
        }
        if ( doInsert )
            insert events;
        return events;
    }

    public static List<Contact> createContacts( Integer size, Id accId, Boolean doInsert )
    {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < size; i++) {
            Contact newContact = new Contact();
            newContact.AccountId = accId;
            newContact.FirstName = 'testFirstNamexx' + i;
            newContact.LastName = 'testLastNamexx' + i;
			newContact.Phone = '1234567890';
			newContact.Email = 'Test@Test.com';
            contacts.add(newContact);
        }
        if ( doInsert )
            insert contacts;
        return contacts;
    }

    public static List<User> createUsers( List<String> lastNames, Id profileId, Boolean willInsert )
    {
        List<User> testUsers = new List<User>();
        for ( String lastName : lastNames ) {
            User newTestUser = createUser( lastName, profileId, WONT_INSERT );
            newTestUser.LastName = lastName;
            testUsers.add( newTestUser );
        }
        if ( willInsert ){
            System.runAs(ADMIN_USER){
                insert testUsers;
            }
        }
        return testUsers;
    }

    public static User createUser ( String lName, Id profileId, Boolean willInsert ) {
        User testUser = createUser( lName, profileId );
        testUser.Username = lName + '@yayaya.com';
        testUser.Email = lName + '@yayaya.com';
        testUser.FirstName = 'test';
        testUser.LastName = lname;
		testUser.Hire_Date__c = Date.today();
        Integer nameEnd = (lName.length() < 8) ? lName.length()-1 : 8;
        testUser.CommunityNickname = lName.substring( 0, nameEnd );
        testUser.Alias = lName.substring( 0, nameEnd );
        if ( willInsert )
        {
            System.runAs(ADMIN_USER){
                insert testUser;
            }
        }
        return testUser;
    }

    public static User createUser ( String lName, Id profileId ) {
        deactivateUsers();
        User newUser = new User(FirstName='Testttt', LastName=lName, UserName=lname+'@tst.com', Email='test11@test.com', Alias=lname,
                                LocaleSidKey='en_US', LanguageLocaleKey='en_US', EmailEncodingKey='ISO-8859-1', CommunityNickname=lname,
                                ProfileId = profileId, TimeZoneSidKey='America/New_York', isActive = true, Hire_Date__c = Date.today());
        return newUser;
    }

    public static void deactivateUsers()
    {
        List<User> usersToDeactivate = [Select Id, Username, profileId from User where ProfileId =:TEST_PROFILE_ID and isActive=true LIMIT 1];
        if(!usersToDeactivate.isEmpty()){
            usersToDeactivate[0].IsActive = false;
            System.runas(ADMIN_USER){
                update usersToDeactivate;
            }
        }
    }


     /*
        Check if the Apex Page contains a message.
        @param String
        @return Boolean
    */
    public static Boolean pageMessagesContains(String messageNeedle)
    {
        for(ApexPages.Message message : ApexPages.getMessages())
        {
            if(message.getSummary() == messageNeedle)
                return true;
        }
        return false;
    }

        /*
        Creates User Role for testing needs
    */
    public static UserRole createUserRole( String name, Boolean doInsert ) {

        UserRole uRole = new UserRole(Name=name);

        if ( doInsert )
            insert uRole;

        return uRole;
    }

    /*
        Creates list of User Roles for testing needs
    */
    public static List<UserRole> createUserRoles( Integer numToCreate, Id parrentRoleId, Boolean doInsert ) 
    {
    	List<UserRole> userRoles = new List<UserRole>();
        UserRole uRole;

        	for (Integer i = 0; i < numToCreate; i++)
            {
            	uRole = createUserRole('Role-'+i, false );
                uRole.ParentRoleId = parrentRoleId;
               	userRoles.add( uRole );
            }
            if (doInsert)
            	insert userRoles;
            return userRoles;
    }

    /*
        @param SObject - sobject to merge values into. *This object will be modified!
    */
    private static void mergeValues(SObject sobj, Map<String, Object> fieldToValue)
    {
        for ( String fieldName : fieldToValue.keySet()  ){
            sobj.put( fieldName, fieldToValue.get(fieldName) );
        }
    }
    
    public static Note createNote(ID parentId, ID userId, Boolean doInsert)
    {
    	Note note = new Note();
    	note.ParentId = parentId;
    	note.OwnerId = userId;
    	note.Body = 'This is a test note.';
    	note.Title = 'Test note';
    	
    	if ( doInsert ){
            System.runAs(ADMIN_USER){
                insert note;
            }
        }
    	
    	return note;
    }
    
    public static Attachment createAttachment(ID parentId, ID userId, Boolean doInsert)
    {
    	Attachment att = new Attachment();
    	att.ParentId = parentId;
    	att.OwnerId = userId;
    	att.Name = String.valueOf('test.txt');
    	att.ContentType = 'txt';
    	att.Body = Blob.valueOf('This is a test attachment');
    	
    	if ( doInsert ){
            System.runAs(ADMIN_USER){
                insert att;
            }
        }
    	
    	return att;
    }
    
    public static Broadcast_Item__c createBroadcastItem(Boolean doInsert)
    {
    	Account acc = new Account();
    	acc.Name = 'Test';
	    acc.BillingStreet = '123 Main St';
		acc.BillingCity = 'Chicago';
		acc.BillingState = 'IL';
		acc.BillingPostalCode = '60603';
    	acc.BillingCountry = 'USA';
	   	insert acc;

    	Opportunity opp = createOpportunity(acc.Id);
    	opp.Invoice_Contact_Name__c = 'John';
    	opp.Invoice_Contact_Email__c = 'john@email.com';
    	insert opp;
    	
    	Prepaid_Clip_Package__c cp = createClipPackage(acc.Id, ADMIN_USER.Id, 'DVD Clip', true );
    	
    	Broadcast_Item__c bi = new Broadcast_Item__c();
    	bi.Opportunity__c = opp.Id;
    	bi.Clip_Package__c = cp.Id;
    	bi.Inventory_Item__c = 'DVD - Video';
    	bi.Product_Detail__c = 'Standard (720x480)';
    	
    	if ( doInsert ){
            System.runAs(ADMIN_USER){
                insert bi;
            }
        }
    	
    	return bi;
    }
    
    public static Broadcast_Item__c createBroadcastItem(ID opptyId, ID clipPackageId, Boolean doInsert)
    {
    	Broadcast_Item__c bi = new Broadcast_Item__c();
    	bi.Opportunity__c = opptyId;
    	bi.Clip_Package__c = clipPackageId;
    	bi.Inventory_Item__c = 'DVD - Video';
    	bi.Product_Detail__c = 'Standard (720x480)';
    	bi.Tax__c = 100;
    	if ( doInsert ){
            System.runAs(ADMIN_USER){
                insert bi;
            }
        }
    	
    	return bi;
    }
    
    public static Prepaid_Clip_Package__c createClipPackage(ID accountId, ID userId, String clipPackage, Boolean doInsert)
    {
    	Prepaid_Clip_Package__c cp = new Prepaid_Clip_Package__c();
    	cp.Account__c = accountId;
    	cp.Sold_By__c = userId;
    	cp.PrePaid_Package__c = clipPackage;
    	cp.Name = 'Test Clip Package';
    	cp.Purchase_Date__c = Date.today();
    	cp.Expiration_Date__c = Date.today().addDays(10);
    	cp.Total_Package_Amount__c = 100;
    	cp.Number_of_Clips__c = 10;
    	
    	
    	if ( doInsert ){
            System.runAs(ADMIN_USER){
                insert cp;
            }
        }
    	
    	return cp;
    }
	
	public static List<Competitor__c> createCompetitor(Integer num, ID accountId, ID opportunityId)
	{
		List<Competitor__c> compList = new List<Competitor__c>();
		
		for (Integer i = 0; i < num; i++)
		{
			Competitor__c comp = new Competitor__c();
			comp.Account__c = accountId;
			comp.Opportunity__c = opportunityId;
			comp.Competitor_Name__c = 'Test Competitor ' + i;
			comp.Service_Expiration_Date__c = Date.today().addMonths(3);
			compList.add(comp);
		}
		
		return compList;
	}

	public static Campaign createCampaign()
	{
		Campaign camp = new Campaign();
		camp.Name = 'Test Campaign';
		
		return camp;
	}
			
	public static CampaignMember createCampaignMember(ID campaignId, ID contactId)
	{
		CampaignMember campMem = new CampaignMember();
		campMem.CampaignId = campaignId;
		campMem.ContactId = contactId;
		campMem.Status = 'Responded';
				
		return campMem;
	}
	
	public static Case createCase(String subject, String caseType)
	{			
		Case cs = new Case();		
		cs.Subject = subject;
		cs.Type = caseType;
		cs.OwnerId = UserInfo.getUserId();
		return cs;
	}
	
	public static List<Case> createCase(Integer num, ID accountId, ID opportunityId, String caseType)
	{
		List<Case> caseList = new List<Case>();
		
		for (Integer i = 0; i < num; i++)
		{
			Case cs = createCase('Test Subject ' + i + '-' + caseType, caseType);
			cs.AccountId = accountId;
			cs.Opportunity__c = opportunityId;			
			caseList.add(cs);
		}
		
		return caseList;
	}
	
	public static Contract createContract(Id accountId, Id opportunityId)
	{
		Contract cont = new Contract();
		cont.AccountId = accountId;
		cont.SBQQ__Opportunity__c = opportunityId;
		cont.StartDate = Date.today().addMonths(-6);
		cont.ContractTerm = 12;
		cont.Name = 'Test Contract';
				
		return cont;
	}
	
	public static SBQQ__Subscription__c createSubscription(Id accountId, Id contractId, Id productId)
	{
		SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
		sub.SBQQ__Account__c = accountId;
		sub.SBQQ__Contract__c = contractId;
		sub.SBQQ__Product__c = productId;
		sub.SBQQ__ListPrice__c = 100.00;
		sub.SBQQ__Quantity__c = 1;
		sub.SBQQ__NetPrice__c = 100.00;
		
		return sub;
	}
	
	public static Asset createAsset(Id accountId, Id productId)
	{
		Asset ass = new Asset();
		ass.Name = 'Test Asset';
		ass.AccountId = accountId;
		ass.Product2Id = productId;
		
		return ass;
	}
	
	public static void AddRoundRobinGroupsForMarketingCampaigns()
	{
		User user1 = TestingUtils.createUser('rrmark1', TestingUtils.TEST_PROFILE_ID);
		user1.Email = 'Test@Test.com';
		insert user1;		
		
		Round_Robin__c rr1 = new Round_Robin__c(User__c=user1.Id,Object_Type__c='Lead',Group__c='Renewals',Sub_Group__c='',Assign_Records__c=true,Number_of_Records_Assigned__c=0,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=0);
		insert rr1;
		Round_Robin__c rr2 = new Round_Robin__c(User__c=user1.Id,Object_Type__c='Lead',Group__c='Lead Gen',Sub_Group__c='',Assign_Records__c=true,Number_of_Records_Assigned__c=0,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=0);
		insert rr2;
		Round_Robin__c rr3 = new Round_Robin__c(User__c=user1.Id,Object_Type__c='Lead',Group__c='Content Marketing New Biz',Sub_Group__c='',Assign_Records__c=true,Number_of_Records_Assigned__c=0,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=0);
		insert rr3;
		Round_Robin__c rr4 = new Round_Robin__c(User__c=user1.Id,Object_Type__c='Lead',Group__c='New Biz (Broadcast Response)',Sub_Group__c='',Assign_Records__c=true,Number_of_Records_Assigned__c=0,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=0);
		insert rr4;
		Round_Robin__c rr5 = new Round_Robin__c(User__c=user1.Id,Object_Type__c='Lead',Group__c='New Biz (International Response)',Sub_Group__c='',Assign_Records__c=true,Number_of_Records_Assigned__c=0,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=0);
		insert rr5;
		Round_Robin__c rr6 = new Round_Robin__c(User__c=user1.Id,Object_Type__c='Lead',Group__c='East',Sub_Group__c='BDM',Assign_Records__c=true,Number_of_Records_Assigned__c=0,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=0);
		insert rr6;
		Round_Robin__c rr7 = new Round_Robin__c(User__c=user1.Id,Object_Type__c='Lead',Group__c='East',Sub_Group__c='AM',Assign_Records__c=true,Number_of_Records_Assigned__c=0,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=0);
		insert rr7;
		Round_Robin__c rr8 = new Round_Robin__c(User__c=user1.Id,Object_Type__c='Lead',Group__c='West',Sub_Group__c='AM',Assign_Records__c=true,Number_of_Records_Assigned__c=0,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=0);
		insert rr8;
		Round_Robin__c rr9 = new Round_Robin__c(User__c=user1.Id,Object_Type__c='Lead',Group__c='West',Sub_Group__c='BDM',Assign_Records__c=true,Number_of_Records_Assigned__c=0,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=0);
		insert rr9;
		
	}
}