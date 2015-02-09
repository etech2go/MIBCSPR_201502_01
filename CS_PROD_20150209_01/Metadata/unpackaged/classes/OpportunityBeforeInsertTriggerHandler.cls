public class OpportunityBeforeInsertTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		OpportunityHelper.AssignCARep((List<Opportunity>)tp.newList,(Map<Id, Opportunity>)tp.oldMap);
	}

}