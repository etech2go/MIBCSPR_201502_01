public with sharing class CaseSupportExtension
{
    public Case cs {get; set;}  
    public Opportunity opp {get; set;}  
    public Account acct {get; set;} 
    public String headerTitle {get; set;}   
    public String attachHeaderTitle {get; set;} 
    public List<Schema.FieldSetMember> CustomFieldSetList {get;set;}
    public Attachment caseAttachment {get {
      if (caseAttachment == null)
        caseAttachment = new Attachment();
      return caseAttachment;
    } set;}
	/*public List<SelectOption> CaseTypes {get {
			if(CaseTypes == null) 
				CaseTypes = new List<SelectOption>();
				return GetCaseTypes();	
	} set;}	*/
    public Boolean closeWindow {get;set;}
	public Boolean filteredBroadcastLink {get;set;}
	public Boolean trainingDropdown {get;set;}
	public Boolean caseDropdown {get;set;}
	public Boolean showSave {get;set;}
    public List<SelectOption> filesCountList {get; set;}
    public List<Attachment> allFileList {get; set;}
    public String FileCount {get; set;}  
    public String TrainingOption {get; set;}
    public Boolean showAttachment {get;set;}
    public String caseType {get;set;}   
	private String caseId {get;set;} 
    private Id caseRecordTypeId {get;set;}
	
    public CaseSupportExtension(ApexPages.StandardController controller) 
    {
        cs = (Case)controller.getRecord();   
		showSave = true;
        showAttachment = false;
        filteredBroadcastLink  = false;
        String accountId = ApexPages.currentPage().getParameters().get('aid');  
        String oppId = ApexPages.currentPage().getParameters().get('oid');  
        caseRecordTypeId = ApexPages.currentPage().getParameters().get('rtid');		
		caseId = ApexPages.currentPage().getParameters().get('cid');
        
        System.debug('oppId=' + oppId);
        System.debug('accountId=' + accountId);
        System.debug('caseRecordTypeId=' + caseRecordTypeId);		
		System.debug('caseId=' + caseId);
        InitializeAttachmentControls();        		
				
        if(caseRecordTypeId != null)
        {
            cs.RecordTypeId = caseRecordTypeId;					
        }
        
        if(oppId != null)
        {
            opp =  [select Id, Name from Opportunity where Id = :oppId];            
        }           			
		
        if(accountId != null && accountId != '')
        {						
            acct = [select Id, Name, Type, CisionPoint_ID__c, BillingStreet, BillingCity, BillingCountry, BillingState, BillingPostalCode, GP_Cust_ID__c  from Account where Id = :accountId]; 			            
			//System.debug('Account=' + acct);            
            GetCaseFieldSet();
			LoadTrainingDropdown(caseRecordTypeId);
        }     
		else
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, 'You must add an Account Name to this Case before entering more Information'));
			FileCount = null;
			caseDropdown = false;
			showSave = false;
		}
		
		System.debug(cs);
    }
    
    private void InitializeAttachmentControls()
    {
        filesCountList = new List<SelectOption>() ;  
        FileCount = '2' ;  
        allFileList = new List<Attachment>() ;  
        
        for(Integer i = 1 ; i <= 2 ; i++)  
            allFileList.add(new Attachment()) ;               
    }
        
    public void GetCaseFieldSet()
    {       		
        if(cs.Type != null)
        {   			
			CustomFieldSetList = new List<Schema.FieldSetMember>();
			System.debug('cs.Type=' + cs.Type);
        	headerTitle = cs.Type;		
			if(cs.Type == 'Training')
				CustomFieldSetList = UtilityClass.ReturnFieldSet('Case', 'Internal Training Request');
			else
				CustomFieldSetList = UtilityClass.ReturnFieldSet('Case', cs.Type);
			
			if(cs.Type == 'Trials')
			{
				filteredBroadcastLink = true;
			}
			else
			{
				filteredBroadcastLink = false;
			}
			
			LoadAccountInfoAndChangeAttributes(CustomFieldSetList);			
			showAttachment = true;			
		}                     
    }       
    	
    public void LoadAccountInfoAndChangeAttributes (List<Schema.FieldSetMember> customList) 
    {               
        System.debug('customList=' + customList);
                
        for(Integer i=0; i < customList.size(); i++)        
        {
            Schema.FieldSetMember f = customList[i];
            System.debug('f.getFieldPath()=' + f.getFieldPath());
			//System.debug(f);
        
            if(f.getFieldPath() == Constants.AccountID)
            {
				if(acct.Id != null)
                	cs.AccountId = acct.Id; 
            }
            Else if(f.getFieldPath() == Constants.OpportunityName)
            {
                if(opp != null)
                    cs.Opportunity__c = opp.Id; 
            }
            //#TODO Make more dynamic
            else if(f.getFieldPath() == Constants.AccountContactTitle || f.getFieldPath() == Constants.AccountBillingStreet || f.getFieldPath() == Constants.AccountBillingCity || f.getFieldPath() == Constants.AccountBillingZip || f.getFieldPath() == Constants.AccountBillingCountry || f.getFieldPath() == Constants.AccountBillingState || f.getFieldPath() == Constants.GpCustId || f.getFieldPath() == Constants.CisionPointId || f.getFieldPath() == Constants.AccountWebSite || f.getFieldPath() == Constants.AccountType || f.getFieldPath() == 'CaseNumber')
            {               
                customList.remove(i);   
                i--;
            }			
        }
        
        CustomFieldSetList = customList;        
    }		    	
	
	private void LoadTrainingDropdown(Id recordTypeId)
	{		
		if(UtilityClass.GetRecordType(recordTypeId).Name == 'Training')
		{			  
			trainingDropdown = true;
			caseDropdown = false;
		}
		else
		{
			trainingDropdown = false;
			caseDropdown = true;
		}
	}
	
    public PageReference Save() 
    {                          
		if(cs.Type != null)
		{
	        //System.debug('cs.Type=' + cs.Type);
	        Case caseToAdd = new Case();
	        caseToAdd = cs;
	        caseToAdd.Subject = acct.Name + ' - ' + cs.Type;	        
	        
			System.debug('cs.Type=' + cs.Type);
			String caseSupportType = cs.Type.replace(' ', '_').replace('-', '_').replace('/', '_').replace('(', '_').replace(')', ' ').trim();
			System.debug('caseSupportType=' + caseSupportType);
			System.debug('caseRecordTypeId=' + caseRecordTypeId);
			System.debug('caseId=' + caseId);
			if(caseId != null)
			{				
				RecordType currentRecordType = UtilityClass.GetRecordType(caseRecordTypeId);
				System.debug('currentRecordType = ' + currentRecordType);
				
				if(currentRecordType.Name.contains('DCS'))
				{
					SaveExtendedDcsInfo(caseToAdd, caseId);
					caseToAdd.RecordTypeId = GetCaseSupportRecordType('DCS_' + caseSupportType).Id;								
				}
				else if(currentRecordType.Name.contains('Training'))
				{
					SaveExtendedTrainingInfo(caseToAdd, caseId);
				}
				else
				{
					SaveExtendedContractAdminInfo(caseToAdd, caseId);
					caseToAdd.RecordTypeId = caseRecordTypeId;	
				}
			}		
			else
			{
				caseToAdd.OwnerId = AssignToQueue(caseToAdd, Constants.SalesSupportQueue);				
				caseToAdd.RecordTypeId = GetCaseSupportRecordType('Sales_Support_' + caseSupportType).Id;
			}
			
			System.debug('#######################################CaseBeforeInsert=' + caseToAdd);	
	        insert caseToAdd;   
	        
	        List<Attachment> listToInsert = new List<Attachment>() ;  	                
	        for(Attachment a: allFileList)  
	        {  
	            if(a.name != '' && a.name != '' && a.body != null)  
	                listToInsert.add(new Attachment(parentId = caseToAdd.Id, name = a.name, body = a.body)) ;  
	        }  
	        
	        if(listToInsert.size() > 0)  
	        {  
	            insert listToInsert ;  	             
	            FileCount = '' ;  
	        }               
	        //System.debug('#######################################' + caseToAdd);	        
	        
			Case c = [SELECT Id, CaseNumber FROM Case WHERE Id = :cs.Id];
			
			ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, 'Case ' + c.CaseNumber + ' has been saved successfully')); 
		}
		else
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a Case Type')); 
		}
		
        return null;		
    }
    
	private void SaveExtendedTrainingInfo(Case trainingCase, String cId)
	{
		Case c = [Select C.Type, C.Id, C.Monitoring_ID__c, C.ParentId, C.Subject, C.AccountId, C.OwnerId, C.ContactId, C.Priority, C.Origin, C.Status, C.Sub_Account_Name__c, C.Parent_Case_Owner__c FROM CASE C where Id = :cId];
		trainingCase.Subject = 'Training Request';
		trainingCase.ParentId = cId;
		trainingCase.AccountId = c.AccountId;	
		trainingCase.Origin = 'Training Request Button';
		trainingCase.OwnerId = AssignToQueue(trainingCase, 'Training Request');
		trainingCase.Id = null;
	}
	
	private void SaveExtendedContractAdminInfo(Case caCase, String cId)
	{		
		Case c = [Select C.Type, C.Id, C.Monitoring_ID__c, C.ParentId, C.Subject, C.AccountId, C.OwnerId, C.ContactId, C.Priority, C.Origin, C.Status, C.Sub_Account_Name__c, C.Parent_Case_Owner__c FROM CASE C where Id = :cId];
		caCase.Subject = c.Subject;
		caCase.ParentId = cId;
		caCase.AccountId = c.AccountId;		
		caCase.Sub_Account_Name__c = c.Sub_Account_Name__c;
		caCase.ContactId = c.ContactId;
		caCase.Priority = 'Medium';		
		caCase.Id = null;
		
		//Set the CA Rep as the owner per Business Rules, otherwise set it to the creator of the case.
		Id caseOwnerId = UtilityClass.GetUser(C.OwnerId).Ca_Rep__c;		
		if(caseOwnerId != null)
			caCase.OwnerId = UtilityClass.GetUser(C.OwnerId).Ca_Rep__c;
		else
		{
			RoundRobinHelper caRRHelper = new RoundRobinHelper('Case', 'Contract Admin');
			caCase.OwnerId = caRRHelper.GetNextUser(false, false);
			caRRHelper.UpdateRoundRobin();
		}
		
		caCase.Origin = 'Contract Admin Button';		
		caCase.Parent_Case_Owner__c = c.OwnerId;		
	}
	
	private void SaveExtendedDcsInfo(Case dcsCase, String cId)
	{
		Case c = [Select C.Type, C.Id, C.Monitoring_ID__c, C.ParentId, C.AccountId, C.ContactId, C.OwnerId, C.Opportunity_Owner__c, C.Priority, C.Origin, C.Status, C.DCS_Reasons__c FROM CASE C where Id = :cId];
		System.debug('c=' + c);
		dcsCase.ParentId = cId;
		dcsCase.AccountId = c.AccountId;		
		dcsCase.OwnerId = AssignToQueue(dcsCase, Constants.DcsQueue);
		dcsCase.Id = null;
		dcsCase.Follow_Up_Date__c = Date.today();
		dcsCase.ContactId = c.ContactId;
		
		if(String.valueOf(c.Ownerid).startsWith('00G'))
		{
			dcsCase.Parent_Case_Owner__c = UtilityClass.GetUser(Constants.SfdcAdmin).Id; //AssignToQueue(dcsCase, Constants.DcsQueue);
		}
		else
		{
			dcsCase.Parent_Case_Owner__c = c.OwnerId;
		}//*/
		
		dcsCase.Priority = c.Priority;
		dcsCase.Status = c.Status;
		//dcsCase.Monitoring_ID__c = c.Monitoring_ID__c;
		dcsCase.DCS_Reasons__c = c.DCS_Reasons__c;		
		dcsCase.Origin = Constants.CaseOriginDcsButton;		
	}	
	
	private RecordType GetCaseSupportRecordType(String description)
	{
		System.debug('description=' + description);
		RecordType caseSupportRecordType = [Select R.IsActive, R.Description, R.Name, R.Id, R.DeveloperName from RecordType R WHERE R.DeveloperName  =: description and R.SObjectType = 'Case'];
		
		if(caseSupportRecordType != null)
			return caseSupportRecordType;
		else
			return null;
	}		   
    
    private Id AssignToQueue(Case caseToQueue, String queueName)
    {  
		System.debug('Queue Name = ' + queueName);
		Group caseSupportQueue = [select Id, OwnerId, Name, Email from Group where Name = :queueName and Type = 'Queue'];
        caseToQueue.OwnerId = caseSupportQueue.Id; 
		return caseSupportQueue.Id;
    }	
    
	 /*private String GetFieldsSetQuery()
    {
        String query = 'SELECT ';
        
        for(Schema.FieldSetMember f : CustomFieldSetList)
        {
            query += f.getFieldPath() + ', ';           
        }           
        
        return query;
    }   */
	
	/*public List<SelectOption> GetCaseTypes() 
    {
        List<SelectOption> options = new List<SelectOption>();
        		
        Schema.DescribeFieldResult rsCaseType = Schema.sObjectType.Case.fields.Type.getSObjectField().getDescribe();
		Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
		Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
		Schema.RecordTypeInfo rtById =  rtMapById.get(cs.RecordTypeId);
		
		System.debug(rtMapById);
		System.debug(rtById);
		System.debug(d);
 		for(Picklistentry entry : rsCaseType.getpicklistValues()) 
		{
			System.debug(entry);
			options.add(new SelectOption(entry.getValue(), entry.getLabel()));   
        }              			
		
		return options;
    }*/
}