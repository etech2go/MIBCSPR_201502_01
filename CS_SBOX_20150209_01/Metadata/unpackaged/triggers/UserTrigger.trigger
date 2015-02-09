trigger UserTrigger on User (after update)
{
	TriggerFactory.createTriggerDispatcher(User.sObjectType);
}