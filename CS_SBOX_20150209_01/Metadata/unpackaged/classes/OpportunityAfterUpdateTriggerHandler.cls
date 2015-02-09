public class OpportunityAfterUpdateTriggerHandler extends TriggerHandlerBase
{
    public override void mainEntry(TriggerParameters tp)
    {
        OpportunityServices.updateBroadcastItems((List<Opportunity>)tp.newList, (Map<ID, Opportunity>)tp.oldMap);     
        
        OpportunityHelper.AddCompetitor((List<Opportunity>)tp.newList, (Map<Id, Opportunity>)tp.oldMap);
                        
        OpportunityHelper.UpdateContactIfShippingDetailsChange((List<Opportunity>)tp.newList);
        
        OpportunityHelper.UpdateQuoteIfOppStageChanges((List<Opportunity>)tp.newList,(Map<Id, Opportunity>)tp.oldMap);//Stage is CA Rejected or Closed Won
    	
		if(OpportunityHelper.objectsToUpdate != null){
			sObjectsToUpdate.putAll(OpportunityHelper.objectsToUpdate);
		}
		
	}
    
}