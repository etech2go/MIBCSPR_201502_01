public class UnlockQuoteExtension
{
	public SBQQ__Quote__c q {get; set;}
	
	private Opportunity opp;
			
	public UnlockQuoteExtension(ApexPages.StandardController controller) 
    {
    	// Get the Opp Record
    	q = (SBQQ__Quote__c)controller.getRecord();
    	    	
    	if (q != null)
    	{
    		q = [Select Id, Name, SBQQ__Status__c, SBQQ__Opportunity__c from SBQQ__Quote__c where Id = :q.Id];
    		opp = [Select Id, StageName from Opportunity where Id = :q.SBQQ__Opportunity__c];
		}
    }
	
	public PageReference UnlockQuote()
	{
		Boolean updateRecords = false;
					
		// First think is to try and revoke the Approval
		if (opp.StageName == 'APP: Pending Approval')
		{
			List<ProcessInstanceWorkItem> workItemList = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId,p.ProcessInstanceId,p.OriginalActorId,p.Id,p.ActorId
        		From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :q.Id];
			
			if (workItemList != null && workItemList.size() > 0)
			{
				Approval.ProcessWorkitemRequest PWR = new Approval.ProcessWorkitemRequest();
				PWR.setComments('Removed by Request from ' + UserInfo.getName());
				PWR.setAction('Removed');
				PWR.setWorkitemId(workItemList[0].Id);
				Approval.process(PWR);
			}
			
			updateRecords = true;
		}
		
		if (opp.StageName == 'APP: Rejected' || opp.StageName == 'APP: Approved' ||  opp.StageName == 'CA: Review' ||  opp.StageName == 'CA: Rejected')
		{
			updateRecords = true;	
		}
		else if (opp.StageName == 'Contract Sent' || opp.StageName == 'Cust: Contract Opened' || opp.StageName == 'Cust: Contract Signed' || opp.StageName == 'Cust: Contract Rejected')
		{
			q.Docusign_Envelope_Id__c = '';
			q.Docusign_Status__c = '';
			updateRecords = true;	
		}
		
		if (updateRecords)
		{
			User u = [Select Id, Bypass_Validation__c from User where Id = :UserInfo.getUserId()];
			u.Bypass_Validation__c = true;
			update u;
			
			opp.StageName = 'In Negotiation';
			update opp;
			
			q.SBQQ__Status__c = 'Draft';
			update q;
			
			u.Bypass_Validation__c = false;
			update u;
		}
		
		return null;
	}

}