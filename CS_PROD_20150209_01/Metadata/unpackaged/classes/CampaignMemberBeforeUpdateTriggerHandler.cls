public with sharing class CampaignMemberBeforeUpdateTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{			
		System.debug('####################BeforeUpdate CampaignMemberBeforeUpdateTriggerHandler');
		for (CampaignMember cm : (List<CampaignMember>)tp.newList)
		{			
			CampaignMemberHelper.ExecuteCampaignMemberRules(cm);
		}
	}
}