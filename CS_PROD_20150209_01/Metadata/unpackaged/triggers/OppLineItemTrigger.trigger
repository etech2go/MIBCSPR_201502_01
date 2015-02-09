trigger OppLineItemTrigger on OpportunityLineItem bulk (before insert)
{
	// This is the only line of code that is required.	
	TriggerFactory.createTriggerDispatcher(OpportunityLineItem.sObjectType);
}