trigger TaskTrigger on Task bulk (before insert,before update,after update)  {
	
	TriggerFactory.createTriggerDispatcher(Task.sObjectType);
}