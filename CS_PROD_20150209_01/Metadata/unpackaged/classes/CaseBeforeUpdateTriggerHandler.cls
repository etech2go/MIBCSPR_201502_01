public with sharing class CaseBeforeUpdateTriggerHandler extends TriggerHandlerBase
{
	
	public override void mainEntry(TriggerParameters tp)
	{
		CaseHelper helper = new CaseHelper((List<Case>)tp.newList);
		
		for (Case c : (List<Case>)tp.newList) 
        {
			helper.AssignRenewalRep(c);
            						
            helper.AddOpportunityOwnerAndManager(c);
				
			if (c.Origin == 'Training Email' || c.Type == 'At Risk Request' || c.Type == 'Consult Request' || c.Type == 'On-Site Request')
          	{
            	helper.AssignCaseOwner(c);
            }
			
			
		}
		
		helper.UpdateRoundRobin();
	}

}