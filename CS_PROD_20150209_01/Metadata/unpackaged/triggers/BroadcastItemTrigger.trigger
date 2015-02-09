trigger BroadcastItemTrigger on Broadcast_Item__c (before insert, before update) 
{
	BroadcastItemServices.addTotalFees(Trigger.new);
	BroadcastItemServices.calculatePrice(Trigger.new);
}