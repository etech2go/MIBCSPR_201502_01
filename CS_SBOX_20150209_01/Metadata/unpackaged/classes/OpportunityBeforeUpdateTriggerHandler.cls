public class OpportunityBeforeUpdateTriggerHandler extends TriggerHandlerBase
{
    public override void mainEntry(TriggerParameters tp)
    {
		
        OpportunityHelper.UpdateInvoiceDetails((List<Opportunity>)tp.newList, (Map<Id, Opportunity>)tp.oldMap, true);           
        
        OpportunityHelper.AssignCARep((List<Opportunity>)tp.newList,(Map<Id, Opportunity>)tp.oldMap);     
		
             
    }
}