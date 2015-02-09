public with sharing class PrepaidClipPackageServices 
{
   	
    public static void updateBroadcastItems(List<Prepaid_Clip_Package__c> newClipPackages, Map<ID, Prepaid_Clip_Package__c> oldClipPackages)
	{
    
		List<Prepaid_Clip_Package__c> clipPackagesToProcess = getClipPackagesToProcess(newClipPackages, oldClipPackages);
    	
    	Set<ID> cpIds = new Set<ID>();
	    
	    for(Prepaid_Clip_Package__c cp : clipPackagesToProcess)
	    {
	            cpIds.add(cp.Id);
	    }
	    
	    List<Prepaid_Clip_Package__c> updatedClipPackages = [SELECT Id, (Select Id, Update_From_Parent__c from Broadcast_Items__r)  FROM Prepaid_Clip_Package__c WHERE Id IN :cpIds];
	 
	    List<Broadcast_Item__c> broadcastItems = new List<Broadcast_Item__c>();
	    
	    for (Prepaid_Clip_Package__c cp : updatedClipPackages)
	    {
	    	
	        // Loop through each BroadcastItem record
	        for(Broadcast_Item__c bi : cp.Broadcast_Items__r)
	        {
	            bi.Update_From_Parent__c = (!bi.Update_From_Parent__c);
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
 	
 	public static List<Prepaid_Clip_Package__c> getClipPackagesToProcess(List<Prepaid_Clip_Package__c> newClipPackages, Map<ID, Prepaid_Clip_Package__c> oldClipPackages)
 	{
 		List<Prepaid_Clip_Package__c> clipPackagesToProcess = new List<Prepaid_Clip_Package__c>();
 		
 		//Only process those ClipPackages where the field No_Clip_Package__c has been updated
 		
 		for (Prepaid_Clip_Package__c cp : newClipPackages) 
 		{
        	Prepaid_Clip_Package__c oldOppty = oldClipPackages.get(cp.ID);
        	if (cp.No_Clip_Package__c != oldOppty.No_Clip_Package__c) 
        	{
            	clipPackagesToProcess.add(cp);
        	}
    	}
    	
    	return clipPackagesToProcess;
 	}

}