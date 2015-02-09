trigger OpportunityTrigger on Opportunity (before Insert, after insert, before update, after update) 
{
	TriggerFactory.createTriggerDispatcher(Opportunity.sObjectType);
}