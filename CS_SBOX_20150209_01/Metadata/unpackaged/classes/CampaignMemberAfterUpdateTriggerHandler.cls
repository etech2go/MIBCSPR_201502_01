public with sharing class CampaignMemberAfterUpdateTriggerHandler extends TriggerHandlerBase
{
    public override void mainEntry(TriggerParameters tp)
    {        
		System.debug('####################AfterUpdate CampaignMemberBeforeUpdateTriggerHandler');
        for (CampaignMember cm : (List<CampaignMember>)tp.newList)
        {           
           
        }
    }
}