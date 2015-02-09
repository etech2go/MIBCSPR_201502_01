trigger ProductTrigger on Product2 (before insert, before update, after update) 
{
	TriggerFactory.createTriggerDispatcher(Product2.sObjectType);		
}