trigger CampaignMemberTrigger on CampaignMember (before insert, before update, after update)
{	
	TriggerFactory.createTriggerDispatcher(CampaignMember.sObjectType);	
}