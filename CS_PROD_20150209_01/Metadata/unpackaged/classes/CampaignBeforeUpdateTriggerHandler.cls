public with sharing class CampaignBeforeUpdateTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{					
		Map<String, Campaign> campMap = CampaignHelper.GetCampaignMap();
		
		for (Campaign c : (List<Campaign>)tp.newList)
		{
			if (CampaignHelper.DoesCampaignNameExist(c, campMap))
			{
				c.addError('Campaign Name ' + c.Name + ' already exists. Campaign Names must be Unique.');
			}
		}				
	}

}