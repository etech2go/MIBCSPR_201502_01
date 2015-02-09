public with sharing class ShowCallTemplateController
{
	public final BDC_Activity_Type__c ActivityType {get; Set;}
	public Boolean DisplayTemplate {get; Set;}

	public ShowCallTemplateController()
	{
		DisplayTemplate = false;
        Task t = [SELECT Id, Renewal_Phone_Call_Templates__c FROM Task WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
		
		if (t.Renewal_Phone_Call_Templates__c != null)
		{
			ActivityType = [Select Id, Call_Template__c from BDC_Activity_Type__c where Id = :t.Renewal_Phone_Call_Templates__c];
		
			if (ActivityType != null)
			{
				DisplayTemplate = true;
			}
		}
    }
}