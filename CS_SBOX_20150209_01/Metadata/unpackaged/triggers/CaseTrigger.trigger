trigger CaseTrigger on Case bulk (before insert, after Insert, before update) 
{	
	TriggerFactory.createTriggerDispatcher(Case.sObjectType);
}