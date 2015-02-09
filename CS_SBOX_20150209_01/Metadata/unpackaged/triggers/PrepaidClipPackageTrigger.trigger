trigger PrepaidClipPackageTrigger on Prepaid_Clip_Package__c (after update) 
{
	if(trigger.isAfter && trigger.isUpdate)
	{
		PrepaidClipPackageServices.updateBroadcastItems(Trigger.new, Trigger.oldMap);
	}

}