public with sharing class CampaignMemberAfterInsertTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		System.debug('####################AfterInsert CampaignMemberAfterInsertTriggerHandler');
		for (CampaignMember cm : (List<CampaignMember>)tp.newList)
		{			
			//CampaignMemberHelper.ExecuteCampaignMemberRules(cm);		
			if(cm.CRM_Response_Date__c != null)
			{
				//cm.FirstRespondedDate = cm.CRM_Response_Date__c;
				//cm.CreatedDate = cm.CRM_Response_Date__c;
			}
		}
	}
}