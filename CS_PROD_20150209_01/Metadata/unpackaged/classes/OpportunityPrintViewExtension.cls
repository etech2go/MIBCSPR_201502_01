public with sharing class OpportunityPrintViewExtension
{
    public Opportunity opp {get; set;}
    public List<Broadcast_Item__c> BroadcastItems{get; Set;}
    
    // Store the data for the field sets
    public List<Schema.FieldSetMember> LeftDetailFields{get;Set;}
    public List<Schema.FieldSetMember> RightDetailFields{get;Set;}
    public List<Schema.FieldSetMember> LeftRCNFields{get;Set;}
	//public List<Schema.FieldSetMember> RightRCNFields{get;Set;}
    public List<Schema.FieldSetMember> LeftShippingFields{get;Set;}
    public List<Schema.FieldSetMember> RightShippingFields{get;Set;}
        
    
    public OpportunityPrintViewExtension(ApexPages.StandardController controller) 
    {
        // Get the Opp Record
        opp = (Opportunity)controller.getRecord();
        
        if (opp != null)
        {
            List<Schema.FieldSetMember> oppDetailsList = SObjectType.Opportunity.FieldSets.Opportunity_Details.getFields();
            LeftRCNFields = SObjectType.Opportunity.FieldSets.Recurring_Client_Needs.getFields();
            List<Schema.FieldSetMember> oppShippingList = SObjectType.Opportunity.FieldSets.Shipping.getFields();
                        
            // Query the fields we want form the opp
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : oppDetailsList)
            {
                query += f.getFieldPath() + ', ';
            }
            for(Schema.FieldSetMember f : LeftRCNFields)
            {
                query += f.getFieldPath() + ', ';
            }
            for(Schema.FieldSetMember f : oppShippingList)
            {
                query += f.getFieldPath() + ', ';
            }
            
            query += 'Id, Order_Instructions__c FROM Opportunity where Id = \'' + opp.Id + '\'';
            opp = Database.query(query);
                                
            // Process the fields for display purposes
			LeftDetailFields = new List<Schema.FieldSetMember>();
            RightDetailFields = new List<Schema.FieldSetMember>();
			//LeftRCNFields = new List<Schema.FieldSetMember>();
			//RightRCNFields = new List<Schema.FieldSetMember>();
            LeftShippingFields = new List<Schema.FieldSetMember>();
            RightShippingFields = new List<Schema.FieldSetMember>();
                        
            Integer currentFieldNo = 1;
			for (Schema.FieldSetMember fm : oppDetailsList)
            {
                if (currentFieldNo <= oppDetailsList.size()/2)
                {
                    LeftDetailFields.add(fm);     
                }
                else
                {
                    RightDetailFields.add(fm);
                }
                
                currentFieldNo++;
            }
            
			currentFieldNo = 1;
            for (Schema.FieldSetMember fm : oppShippingList)
            {
                if (currentFieldNo <= oppShippingList.size()/2)
                {
                    LeftShippingFields.add(fm);     
                }
                else
                {
                    RightShippingFields.add(fm);
                }
                
                currentFieldNo++;
            }
			    
                    
            
            BroadcastItems = [Select Id, Name, ItemNumber__c, PinPoint_Notes__c, Item__c, Format_Options__c, Market_Station__c, Air_Date_Time_Time_Zone__c, Program_Title__c, Subject_Description__c, TRT__c, Total_after_Tax__c from Broadcast_Item__c where Opportunity__c = :opp.Id order by  CreatedDate];
        }
    }

}