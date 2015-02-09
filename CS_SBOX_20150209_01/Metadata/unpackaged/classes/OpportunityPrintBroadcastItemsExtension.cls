public with sharing class OpportunityPrintBroadcastItemsExtension{
	
	public List<Broadcast_Item__c> lineItemsList {get; set;}
	public String BroadcastItemListHeader {get; set;}
	public Opportunity opp {get; set;}	
	
	public OpportunityPrintBroadcastItemsExtension(ApexPages.StandardController controller) 
    {
		opp = (Opportunity)controller.getRecord();
    	if (opp != null)
    	{
    		opp = [select Id, Name, opportunity_number__c, accountId from Opportunity where Id = :opp.Id]; 
			GetBroadcastItemList();
    	}
	}
	
	private void GetBroadcastItemList()
	{
		lineItemsList = [select Id, Market_Station__c, itemnumber__c, program_title__c, air_date_time__c, trt__c, Do_Not_Print_On_Labels__c, Subject_Description__c from Broadcast_Item__c where opportunity_number__c = :opp.opportunity_number__c and Do_Not_Print_On_Labels__c = false];
		Broadcast_Item__c item = lineItemsList.get(0);
		BroadcastItemListHeader = item.Subject_Description__c;
	}
}