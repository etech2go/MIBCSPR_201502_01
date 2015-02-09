public with sharing class OpportunityServices 
{
   	public static boolean runTrigger = true;
   	
    public static void updateBroadcastItems(List<Opportunity> newOpportunities, Map<ID, Opportunity> oldOpportunities)
	{
		List<Opportunity> opportunitiesToProcess = getOpportunitiesToProcess(newOpportunities, oldOpportunities);
    
    	Set<ID> oppIds = new Set<ID>();
	    
	    for(Opportunity opp : opportunitiesToProcess)
	    {
	            oppIds.add(opp.Id);
	    }
	    
	    List<Opportunity> updatedOpps = [SELECT Id, Redo_Item_s__c, (Select Id, Price__c, Update_From_Parent__c from Broadcast_Orders__r)  FROM Opportunity WHERE Id IN :oppIds];
	 
	    List<Broadcast_Item__c> broadcastItems = new List<Broadcast_Item__c>();
	    
	    for (Opportunity opp : updatedOpps)
	    {
	    	
	        // Loop through each BroadcastItem record
	        for(Broadcast_Item__c bi : opp.Broadcast_Orders__r)
	        {
	            bi.Update_From_Parent__c = (!bi.Update_From_Parent__c);
	            System.debug('SERVICES Update From Parent ' + bi.Update_From_Parent__c);
	            broadcastItems.add(bi);
	        }
	        
	    }
	    
	    //update Broadcast Items
	    try
        {
            Database.update(broadcastItems);
        }
        catch (System.DmlException e) 
        {
            for (Integer i = 0; i < e.getNumDml(); i++) 
            {
        		System.debug(e.getDmlMessage(i));
            }
        }
        
 	}
 	
 	
 	public static List<Opportunity> getOpportunitiesToProcess(List<Opportunity> newOpportunities, Map<ID, Opportunity> oldOpportunities)
 	{
 		List<Opportunity> opportunitiesToProcess = new List<Opportunity>();
 		
 		//Only process those Opportunities where the field Redo_Item_s__c has been updated
 		//or StageName has been changed to Opp Voided
 		
 		for (Opportunity o : newOpportunities) 
 		{
        	Opportunity oldOppty = oldOpportunities.get(o.ID);
        	if ( (o.Redo_Item_s__c != oldOppty.Redo_Item_s__c) || (oldOppty.StageName != 'Opp Voided' && o.StageName == 'Opp Voided'))
        	{
            	opportunitiesToProcess.add(o);
        	}
    	}
    	
    	return opportunitiesToProcess;
 	}
 	
 	/*
 	public static void setRunTriggerToFalse()
 	{
 		runTrigger = false;
 	}
 	
 	public static void setRunTriggerToTrue()
 	{
 		runTrigger = true;
 	}
 	*/

}