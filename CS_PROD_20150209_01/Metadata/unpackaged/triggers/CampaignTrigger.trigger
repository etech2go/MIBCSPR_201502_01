trigger CampaignTrigger on Campaign  (before insert,before update)
{
	TriggerFactory.createTriggerDispatcher(Campaign.sObjectType);
}