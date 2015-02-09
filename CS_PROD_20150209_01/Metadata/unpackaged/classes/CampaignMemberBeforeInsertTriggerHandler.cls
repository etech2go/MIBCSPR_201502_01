public with sharing class CampaignMemberBeforeInsertTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		System.debug('####################BeforeInsert CampaignMemberBeforeInsertTriggerHandler');
		for (CampaignMember cm : (List<CampaignMember>)tp.newList)
		{			
			CampaignMemberHelper.ExecuteCampaignMemberRules(cm);					
		}
	}
}