trigger ContactTrigger on Contact bulk (before insert,before update) 
{
	TriggerFactory.createTriggerDispatcher(Contact.sObjectType);
}