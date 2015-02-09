trigger SBQQQuoteLineTrigger on SBQQ__QuoteLine__c bulk (before insert, before update) {
    TriggerFactory.createTriggerDispatcher(SBQQ__QuoteLine__c.sObjectType);
}