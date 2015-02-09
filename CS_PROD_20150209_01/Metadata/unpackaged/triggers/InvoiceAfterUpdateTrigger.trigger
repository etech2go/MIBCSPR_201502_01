trigger InvoiceAfterUpdateTrigger on fw1__Invoice__c (after update) {
	string oppStatus;
	boolean locked;
	if(trigger.isAfter && trigger.isUpdate) {
		  for (fw1__Invoice__c newInv : Trigger.new) {
		  	   fw1__Invoice__c oldInv = Trigger.oldMap.get(newInv.Id);
		  	   if (newInv.fw2__Opportunity__c != null){
				  	   if(newInv.fw1__Balance_Due__c == 0 && newInv.fw1__Balance_Due__c != oldInv.fw1__Balance_Due__c){
				  	   	   oppStatus = 'Closed';	
						   //locked = true;
				  	   	   System.Debug('#######################################Step 1'); 	   
				  	   }
				  	   
				  	   if(oldInv.fw1__Balance_Due__c == 0 && newInv.fw1__Balance_Due__c > 0) {
				  	   	   oppStatus = 'Invoiced';				  	   	   
						   //locked = true;
				  	   	   System.Debug('#######################################Step 2');
				  	   }
				  	   
				  	   if(!oldInv.fw1__Is_Voided__c  && newInv.fw1__Is_Voided__c ){
				  	   	   oppStatus = 'Pending Invoicing';
				  	   	   locked = false;
				  	   	   LockUnlockOppBroadcastItems(newInv.Opportunity_Number__c, false);
				  	   	   System.Debug('#######################################Step 3');
				  	   }
				  	   
				  	   if(oldInv.fw1__Is_Voided__c  && !newInv.fw1__Is_Voided__c ){
                   			oppStatus = 'Invoiced';                   			
						    locked = true;
                   			System.Debug('#######################################Step 4');
               		 	}
				  	   System.Debug('#######################################Opportunity_Number__c = ' + newInv.Opportunity_Number__c);
				  	   System.Debug('#######################################OPP Status = ' + oppStatus);					   
				  	   
				  	   if (oppStatus != null) {
						  	   try{
		                Opportunity o = [SELECT Name,Opportunity_Status__c, Locked__c
		                      FROM Opportunity
		                      WHERE Id = :newInv.fw2__Opportunity__c
		                      LIMIT 1];
		                o.Opportunity_Status__c = oppStatus;
                        System.Debug('#######################################o.Locked = ' + o.Locked__c);
                        System.Debug('#######################################Locked = ' + locked);
		 				o.Locked__c = locked;
		                update o;
		              } catch (Exception e) { }
				  	  }
		  	   }
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
			
			update lineItemsList;
    	}    	
    }              
}