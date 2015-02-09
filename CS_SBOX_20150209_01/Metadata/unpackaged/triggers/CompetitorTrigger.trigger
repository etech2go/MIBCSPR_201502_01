trigger CompetitorTrigger on Competitor__c (after insert, after update, after delete)
{
	TriggerFactory.createTriggerDispatcher(Competitor__c.sObjectType);
}