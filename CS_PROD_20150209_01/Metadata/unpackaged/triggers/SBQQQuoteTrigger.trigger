trigger SBQQQuoteTrigger on SBQQ__Quote__c bulk (before insert, before update, after insert, after update) 
{
	TriggerFactory.createTriggerDispatcher(SBQQ__Quote__c.sObjectType);
}