public with sharing class TaskAfterUpdateTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		TaskHelper helper = new TaskHelper((List<Task>)tp.newList);
		
		for (Task t : (List<Task>)tp.newList)
		{
			helper.SetOppRenewalFlags(t);
		}
		
		sObjectsToUpdate.putAll((Map<ID, Sobject>)helper.oMap);
	}

}