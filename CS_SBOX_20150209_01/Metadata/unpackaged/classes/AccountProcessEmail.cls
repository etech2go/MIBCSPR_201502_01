/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class AccountProcessEmail implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
    {         
 
    Map<string,Account> accountMap = new Map<string,Account>();
    List<Account> accountList = [Select Id, Name, Gorkana_Account_Type__c, Gorkana_SFDC_Account_ID__c, Vocus_Account_Type__c, Vocus_Org_Id__c, Vocus_SFDC_Account_ID__c FROM Account limit 5];
    string SFOrg = '';
      for(Account a:accountList)
      {
        accountMap.put(a.Name,a);        
      }
      
        system.debug('############### before parsing excel file'+ email.binaryAttachments);
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();  
        if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) 
        {
          List<string> failures = new List<string>();
          string fname = '';
          for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) 
          {
          	fname = email.binaryAttachments[i].filename.toUpperCase();
          	
            if(email.binaryAttachments[i].filename.endsWith('.csv'))
            {
               //check if it's Vocus US/ Vocus UK / Gorkana Data
               if (fname.contains('GORKANA')){
               	   SFOrg = 'GORKANA';
               }
               else if (fname.contains('VOCUS UK')){
               	   SFOrg = 'VOCUS-UK';
               }
               else if (fname.contains('VOCUS US')){
               	   SFOrg = 'VOCUS-US';
               }
               else{
               	  SFOrg = 'ANY';
               }
              system.debug('***SFORG...** :'+ SFOrg);	
              //Get csv file body.
              string csvbody = email.binaryAttachments[i].body.toString(); 
              //Split into list of import records.
              List<string> volumeImports = csvbody.Split('\n');  
              system.debug('###########volumeImports = ' + volumeImports[0]);  
              List<Account> accToUpsert = new List<Account>();
           
              for (integer j = 1; j < volumeImports.size(); j++)
              {  
              	            
                //Split into import fields.
                List<string> importFields = volumeImports[j].Split(',');
                Account acc = new Account();
                String acctName = '';
                
                if (importFields[0].length()> 0) {
	               if (SFOrg != '' && SFOrg != null){
	                  //CRM Account | AccountName | Shipping Street | Shipping City |Shipping County | Shipping Zip | Shipping Country | Phone | Website | DUNS Number
	                   if (SFOrg == 'GORKANA'){
                          acc.Name = importFields[1].trim();
	  	                  acc.ShippingStreet = importFields[2].trim();
			              acc.ShippingCity = importFields[3].trim();
			             //acc.ShippingState = importFields[4];
			              acc.ShippingPostalCode = importFields[5].trim();
			              acc.ShippingCountry = importFields[6].trim();
			              acc.Phone = importFields[7].trim();
			              acc.Website = importFields[8].trim();
			              acc.CRM_Account_ID__c = importFields[0].trim();
	                   } //end of Gorkana check
	                   //AccountId | AccountName | OrgId | Billing Street | Billing City |Billing State | Billing Zip | Billing Country | Phone | Website | DUNS Number
	                   else if (SFOrg == 'VOCUS-UK'){
	    	                acc.Name = importFields[1].trim();
			                acc.BillingStreet = importFields[3].trim();
			                acc.BillingCity = importFields[4].trim();
			                acc.BillingState = importFields[5].trim();
			                acc.BillingPostalCode = importFields[6].trim();
			                acc.BillingCountry = importFields[7].trim();
			                acc.Phone = importFields[8].trim();
			                acc.Website = importFields[9].trim();
			                acc.DUNS_Number__c = importFields[10].trim();
		                    acc.Vocus_SFDC_Account_ID__c = importFields[0].trim();
			                acc.Vocus_Org_Id__c = importFields[2].trim(); 
	                  	} //end of Vocus-UK check
	                	//AccountId | OrgId | Account Name | Shipping Street | Shipping City |Shipping State | Shipping Zip | Shipping Country | Phone | Website | DUNS Number
	                   	else if (SFOrg == 'VOCUS-US'){
	                   		system.debug('************Account Name :'+ importFields[2].trim());
	                        acc.Name = importFields[2].trim();
				            acc.ShippingStreet = importFields[3].trim();
				            acc.ShippingCity = importFields[4].trim();
				            acc.ShippingState = importFields[5].trim();
				            acc.ShippingPostalCode = importFields[6].trim();
				            acc.ShippingCountry = importFields[7].trim();
				            acc.Phone = importFields[8].trim();
				            acc.Website = importFields[9].trim();
				            acc.DUNS_Number__c = importFields[10].trim();
			                acc.Vocus_SFDC_Account_ID__c = importFields[0].trim();
			                acc.Vocus_Org_Id__c = importFields[1].trim(); 
	                  	} //end of Vocus-US check
	                  }
                                                 
                  accToUpsert.add(acc);
        
               } // end if 
              }   // end for 
          
	          if (!accToUpsert.isEmpty())
	          {            
	            //UpsertRecords(accToUpsert);
	            
	            //call batch process
	            List<Account> chunkedAccounts = new List<Account>();
	            for (Account a: accToUpsert){ 
		             chunkedAccounts.add(a);
		             if (chunkedAccounts.size()==10)  {
		           	     //callout Batch process to upsert AccountsList
		           	     batchAccountProcessEmail apebatch = new batchAccountProcessEmail(chunkedAccounts);
		           	     Database.executeBatch(apebatch);
		           	     chunkedAccounts.clear();
		             }
	             }
		         if (!chunkedAccounts.isEmpty()){
		          	 //callout Batch process to upsert AccountsList
		          	 // system.debug('**** Account sent to Batch***' + chunkedAccounts[0]);
		          	 batchAccountProcessEmail apebatch = new batchAccountProcessEmail(chunkedAccounts);
		           	 Database.executeBatch(apebatch);
	             }	
	          }  
	          
	          //Send Email results
	          //Send results email.
              //string volumeErrorEmailRecipients = 'Latha.Davuluri; Mark.Doggett';
              string volumeErrorEmailRecipients = 'Latha.Davuluri';
              
              if (!Test.isRunningTest())
              {
                //volumeErrorEmailRecipients = String.valueOf(Application_Config__c.getInstance('VolumeErrorEmailRecipients').Value__c);
              }
          
              system.debug('############ volumeErrorEmailRecipients =' + volumeErrorEmailRecipients);
          
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              string[] toaddress = volumeErrorEmailRecipients.Split(';');
              for(integer k = 0; k < toaddress.size(); k++)
              {
                toaddress[k] = toaddress[k] + '@cision.com';
              }
              mail.setToAddresses(toaddress);
              mail.setSubject('Volume Import Results');
              string failstring = '';
              string csvcontents = 'AccountId, OrgId, Account Name, Shipping Street, Shipping City, Shipping State, Shipping Zip, Shipping Country, Phone, Website, DUNS Number';
              failstring = accToUpsert.size() + ' imports succeeded.\n';
              if (failures.size() > 0)
              {
                failstring = failstring + 'The attached ' + string.valueOf(failures.size()) + ' imports failed.';
                for (integer l = 0; l < failures.size(); l++)
                {                  
                  csvcontents = csvcontents + '\n' + failures[l];
                }
              
                // add an attachment
	            Messaging.Emailfileattachment attachment = new Messaging.Emailfileattachment();
	            attachment.body = blob.valueOf(csvcontents);
	            attachment.fileName = 'AccountImportErrors.csv';
	            attachment.ContentType = 'text/csv';
	                         
	            mail.setFileAttachments(new Messaging.Emailfileattachment[]{attachment});
	          }
              
              mail.setPlainTextBody(failstring);
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
              
	          //End of email result     
          }
        }
      } 
      return result;
    }
    
  /*  public String UpsertRecords(list<SObject> upsertRecords){
        set<Id> upsertIDSuccesses = new Set<Id>();
        String newerrors ='';
	    try{
	       Database.UpsertResult[] SR = Database.Upsert(upsertRecords, FALSE);
	  
	       Database.Error err; 
	       for (Integer i = 0; i < SR.size(); i++) {                   
	          if (SR[i].isSuccess() == false) {  
	            system.debug('############# upsertRecords[i] ' +upsertRecords[i]);
	         
	            
	            upsertIDSuccesses.add(SR[i].getID());
	            err = SR[i].getErrors()[0];
	            newerrors += err.getMessage() + '   ';
	          }
	       }
	       system.debug('############## newerrors '  + newerrors );
	     }
	    catch (Exception e){
	        system.debug(e);
	        return '';  
	     }  
      return newerrors;    
    }
    */
}