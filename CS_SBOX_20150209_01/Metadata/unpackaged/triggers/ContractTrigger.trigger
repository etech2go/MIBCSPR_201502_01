trigger ContractTrigger on Contract bulk (after Insert, after update) {

	TriggerFactory.createTriggerDispatcher(Contract.sObjectType);
}