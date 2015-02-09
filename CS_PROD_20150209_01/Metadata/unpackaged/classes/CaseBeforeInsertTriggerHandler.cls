public with sharing class CaseBeforeInsertTriggerHandler extends TriggerHandlerBase
{
	
	public override void mainEntry(TriggerParameters tp)
	{
		CaseHelper helper = new CaseHelper((List<Case>)tp.newList);
		
		// Get the restricted terms
		List<Emails_to_Block__c> etb = null;
		
		if (Emails_to_Block__c.getall() != null)
		{
			etb = Emails_to_Block__c.getall().values();
		}
		
		for (Case c : (List<Case>)tp.newList) 
        {
			System.debug('###################################################Creating new Case');
			if (c.SuppliedEmail == 'customercare@gototraining.com' || c.SuppliedEmail == 'mailer-daemon@messagelabs.com' || c.Subject.contains('AUTO-REPLY'))
			{
				c.addError('Case not inserted as the Email was sent from customercare@gototraining.com, mailer-daemon@messagelabs.com or has AUTO-REPLY in the Subject');		
			}
			else
			{
				Boolean blockEmail = false;
				
				System.debug('###################################################Blocked = ' + blockEmail);
				if (etb != null)
				{
					for (Emails_to_Block__c e : etb)
					{
						if (e.Starts_With__c)
						{
							if (c.Subject != null && c.Subject.ToLowerCase().StartsWith(e.Name.ToLowerCase()))
							{
								blockEmail = true;
								break;
							}
							
							if (e.Check_in_Body__c)
							{
								if (c.Description != null && c.Description.ToLowerCase().StartsWith(e.Name.ToLowerCase()))
								{	
									blockEmail = true;
									break;
								}	
							}
						}
						else
						{
							if (c.Subject != null && c.Subject.ToLowerCase().Contains(e.Name.ToLowerCase()))
							{
								blockEmail = true;
								break;
							}
							
							if (e.Check_in_Body__c)
							{
								if (c.Description != null && c.Description.ToLowerCase().Contains(e.Name.ToLowerCase()))
								{	
									blockEmail = true;
									break;
								}	
							}
						}
					}
				}
				
				System.debug('###################################################Blocked 2  = ' + blockEmail);
				
				if (!blockEmail)
				{
					helper.AssignRenewalRep(c);
                          
              		helper.AddOpportunityOwnerAndManager(c);
          
        			// Set the correct Type of the case
              		if (c.Origin == 'Customer Support Email' || c.Origin == 'Monitoring Email')
        			{
          				c.Type = 'Client Services';
        			}
        			else if (c.Origin == 'Training Email')
        			{
          				c.Type = 'General Request';
        			}
          
        			if (c.Origin == 'Training Email' || c.Type == 'At Risk Request' || c.Type == 'Consult Request' || c.Type == 'On-Site Request')
              		{
                		helper.AssignCaseOwner(c);
              		}
				}
				else
				{
					c.addError('Case not inserted as this contains blocked Text');	
				}
			}
		}
		
		helper.UpdateRoundRobin();
		
	}

}