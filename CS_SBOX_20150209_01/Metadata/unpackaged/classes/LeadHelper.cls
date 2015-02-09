public with sharing class LeadHelper
{
	//To reduce code, this is being used when campaign members are added and Lead Pass is being done.
	public static void ExecuteLeadGenNewBizRules(Id contactId, Id leadId, Boolean newBiz, Id whatIdForTask, String leadPassCampaignName, String leadRatingTypeCampaignGoal, Boolean leadPass)
	{	
		system.debug('***LD ExecuteLeadGenNewBizRules');		    								
		Task t;
		Contact con;
		if(contactId != null)
		{			
			if(!leadPass)
				t = new Task();
			else
				t = UtilityClass.GetTask(whatIdForTask);						
			
			con = UtilityClass.GetContact(contactId);
			
			System.debug('#######################' + con);
			if(con.AccountId != null)
			{					
				//Do a check to make sure that there isn't anything related to a renewal.+
				//System.debug('#######################RenewalResponseThroughNewBiz(con)= ' + RenewalResponseThroughNewBiz(con));
				System.debug('#######################Contact Description = ' + con.Description);
				if(CampaignMemberHelper.RenewalResponseThroughNewBiz(con))
				{
					t.OwnerId = con.Account.Renewal_Rep__c;
					System.debug('#######################Task Assigned To Renewal Rep = ' + con.Account.Renewal_Rep__c);
				}				
				//If there is a New Biz Rep assigned to that account, make them owner for task
				else if(con.Account.New_Biz_Rep__c != null)
				{				
					t.OwnerId = con.Account.New_Biz_Rep__c;				
					System.debug('#######################Task Assigned To New Biz Rep = ' + con.Account.New_Biz_Rep__c);
				}				
				else
				{
					if(newBiz)
					{											
						RoundRobinHelper LNBHelper = null;			
						//International Repsponse
						if(CampaignMemberHelper.IsInternational(con.Account.BillingCountry))
						{
							LNBHelper = new RoundRobinHelper(Constants.ObjectLead, Constants.NewBizInternationalResponse);
							System.debug('#######################Round Robin = ' + Constants.NewBizInternationalResponse);
						}//Broadcast Response
						else if(CampaignMemberHelper.LeadTaskDescriptionContainPhrases(con.Description)) //
						{
							LNBHelper = new RoundRobinHelper(Constants.ObjectLead, Constants.NewBizBroadcastResponse);
							System.debug('#######################Round Robin = ' + Constants.NewBizBroadcastResponse);
						}//Assign to BDM or AM Round Robin based off criteria						
						else if(con.Web_Revenue__c == Constants.GreaterThan150Mil || con.Account.AnnualRevenue > 150000000 ||  con.Account.Fortune_1000_Ranking__c != null 
						|| CampaignMemberHelper.NameCompanyContainPhrases(con.Account.Name) || CampaignMemberHelper.ContainEmailWebExtensions(con.Email) || CampaignMemberHelper.ContainEmailWebExtensions(con.Account.Website) || CampaignMemberHelper.ContainsNAICSNumbers(con.Account.NAICS_Code_1__c))
						{
							//removed con.Web_Employees__c == Constants.MoreThan1000 || 
							LNBHelper = new RoundRobinHelper(Constants.ObjectLead, CampaignMemberHelper.IsEastOrWest(con.Account.BillingState), Constants.Bdm);	
							System.debug('#######################Round Robin = ' + Constants.Bdm);
						}
						else
						{
							//GA is shared now for BDM and AM.  If GA is AM then it goes to the East, it is normally a West State
							if(con.Account.BillingState == 'GA')
							{
								LNBHelper = new RoundRobinHelper(Constants.ObjectLead, Constants.East, Constants.Am);
								System.debug('#######################Round Robin = ' + Constants.Am);
							}
							else
							{
								LNBHelper = new RoundRobinHelper(Constants.ObjectLead, CampaignMemberHelper.IsEastOrWest(con.Account.BillingState), Constants.Am);
								System.debug('#######################Round Robin = ' + Constants.Am);
							}
						}
						
						t.OwnerId = LNBHelper.GetNextUser(false, CampaignMemberHelper.GetLeadRatingType(leadRatingTypeCampaignGoal));
						CampaignMemberHelper.UpdateRoundRobin(LNBHelper, t.Subject);								
					}
					else // Lead Gen
					{
						RoundRobinHelper rrLLGHelper = new RoundRobinHelper(Constants.ObjectLead, Constants.GroupLeadGen);	
						System.debug('#######################Round Robin = ' + Constants.GroupLeadGen);
						t.OwnerId = rrLLGHelper.GetNextUser(false, CampaignMemberHelper.GetLeadRatingType(leadRatingTypeCampaignGoal));
						CampaignMemberHelper.UpdateRoundRobin(rrLLGHelper, t.Subject);							
					}
				}			
								
				System.debug('####################### before Update Task owner Id = ' + t.OwnerId);
				
				//Only create the Task if associating to campaign.  If coming from Lead Pass process, then the task already exists.
				if(!leadPass)
					CampaignMemberHelper.CreateTaskForCampaignMember(t, con, whatIdForTask, leadPassCampaignName, CampaignMemberHelper.GetLeadRatingType(leadRatingTypeCampaignGoal));					
				else											
					update t; //Update the Task Owner Change from Round Robin				
				
				System.debug('####################### after update Task owner Id = ' + t.OwnerId);
				
				//Only Send Emails to New Biz, do not sent to Lead Gen
				if(newBiz)
				{
					CampaignMemberHelper.SendLeadEmail(leadPassCampaignName, null, con, UtilityClass.GetUser(t.OwnerId), '');
				}
			}											
		}
		else if(leadId != null)
		{
			
			Lead l = UtilityClass.GetLead(leadId);	
			String owner = l.Owner.Name;
			string includedEmails = '';
			system.debug('*** CampaignMemberHelper.IsEloquaAdmin(owner)' + CampaignMemberHelper.IsEloquaAdmin(owner));
			system.debug('*** leadPass :'+ leadPass);
			if(CampaignMemberHelper.IsEloquaAdmin(owner) || leadPass)
			{
				System.debug('#######################' + l);
				System.debug('#######################Lead Name = ' + l.Name);
				RoundRobinHelper rrLLGHelper = null;	
				boolean intlLeadByPass = false;
				if(newBiz)
				{			
					if(CampaignMemberHelper.IsInternational(l.Country))
					{
						/* Mod by LD on 1/10/15 - Add the International filter code here... */
						List<International_Country_Filter__c> IntlCntFil = International_Country_Filter__c.getall().values();
		                 
				        for(International_Country_Filter__c c : IntlCntFil){
							if(l.Country != null)
							{
				        	   if(l.Country.toupperCase() == c.Name || l.Country.toupperCase() == c.Country_Code__c)
							   {
				        		 //notify the contact..
				        		  intlLeadByPass = true;
				        		  l.status = 'Unqualified';
				        		  l.Lead_Substatus__c='Bad Info';
				        		  includedEmails = c.Owner_Email__c;
				        		  CampaignMemberHelper.SendLeadEmail(leadPassCampaignName, l, con, null, includedEmails);
				
				        	    }
							}
				        }
				        // Intl Inbound lead...
				        if (!intlLeadByPass){													   						   
						   rrLLGHelper = new RoundRobinHelper(Constants.ObjectLead, Constants.NewBizInternationalResponse);							   
						   System.debug('#######################Round Robin = ' + Constants.NewBizInternationalResponse);
				        }
					}		
					else if(CampaignMemberHelper.LeadTaskDescriptionContainPhrases(l.Description)) //Broadcast check
					{
						rrLLGHelper = new RoundRobinHelper(Constants.ObjectLead, Constants.NewBizBroadcastResponse);
						System.debug('#######################Round Robin = ' + Constants.NewBizBroadcastResponse);
					}//
					else if(l.Web_Employees__c == Constants.MoreThan1000 || l.Web_Revenue__c == Constants.GreaterThan150Mil || CampaignMemberHelper.NameCompanyContainPhrases(l.Company) || CampaignMemberHelper.ContainEmailWebExtensions(l.Email))
					{
						rrLLGHelper = new RoundRobinHelper(Constants.ObjectLead, CampaignMemberHelper.IsEastOrWest(l.State), Constants.Bdm);		
						System.debug('#######################Round Robin = ' + Constants.Bdm);
					}
					else
					{
						rrLLGHelper = new RoundRobinHelper(Constants.ObjectLead, CampaignMemberHelper.IsEastOrWest(l.State), Constants.Am);		
						System.debug('#######################Round Robin = ' + Constants.Am);
					}
					
					if (!intlLeadByPass){					
					   l.OwnerId = rrLLGHelper.GetNextUser(false, CampaignMemberHelper.GetLeadRatingType(l.Rating));
					   CampaignMemberHelper.UpdateRoundRobin(rrLLGHelper, l.Name);						   
					}
				}
				else
				{
					rrLLGHelper = new RoundRobinHelper(Constants.ObjectLead, Constants.GroupLeadGen);
					System.debug('#######################Round Robin = ' + Constants.GroupLeadGen);
					l.OwnerId = rrLLGHelper.GetNextUser(false, CampaignMemberHelper.GetLeadRatingType(leadRatingTypeCampaignGoal));
					CampaignMemberHelper.UpdateRoundRobin(rrLLGHelper, l.Name);	
				}					
								
				CampaignMemberHelper.UpdateLeadRating(l.Rating, l);	
				
				update l;
				
				//Only Send Emails to New Biz, do not sent to Lead Gen
				if(newBiz && !intlLeadByPass)
				{
				    CampaignMemberHelper.SendLeadEmail(leadPassCampaignName, l, con, UtilityClass.GetUser(l.OwnerId), rrLLGHelper.CurrentRoundRobin.Include_Emails__c);
				}
				//SendLeadEmailFromTemplate(c, l, con, GetUserInfo(l.OwnerId), rrLLGHelper.CurrentRoundRobin.Include_Emails__c);
			}
			else
			{
				System.debug('#####################***Will not go through Assignment logic because lead is assigned to = ' + owner);	
			}
		}
	}
	
	public static void ExecuteRenewalRules(Id contactId, Id leadId, Id whatIdForTask, String leadPassCampaignName, String leadRatingTypeCampaignGoal, Boolean leadPass)
	{
		system.debug('***LD ExecuteRenewalRules');				  
		Task t;
		Contact con;
		
		List<Task> tasksToUpd = new List<Task>();
		List<Lead> leadsToUpd = new List<Lead>();
		
		if(contactId != null)
		{
			if(!leadPass)
				t = new Task();
			else
				t = UtilityClass.GetTask(whatIdForTask);						
			
			con = UtilityClass.GetContact(contactId);
			if(con.AccountId != null)
			{									
				if(con.Account.Renewal_Rep__c != null)
				{				
					t.OwnerId = con.Account.Renewal_Rep__c;		
					System.debug('#######################Task Assigned To Renewal Rep =' + con.Account.Renewal_Rep__c);
				}
				else
				{
					RoundRobinHelper rrLRHelper = new RoundRobinHelper(Constants.ObjectLead,  Constants.GroupRenewals);
					System.debug('#######################Round Robin = ' + Constants.GroupRenewals);
					t.OwnerId = rrLRHelper.GetNextUser(false, CampaignMemberHelper.GetLeadRatingType(leadRatingTypeCampaignGoal));					
					CampaignMemberHelper.UpdateRoundRobin(rrLRHelper, t.Subject);
					CampaignMemberHelper.SendLeadEmail(leadPassCampaignName, null, con, UtilityClass.GetUser(t.OwnerId), rrLRHelper.CurrentRoundRobin.Include_Emails__c);
				}			
			}		
			
			System.debug('####################### Task owner = ' + t.Owner.Name);
			
			//Only create the Task if associating to campaign.  If coming from Lead Pass process, then the task already exists.
			if(!leadPass)
				CampaignMemberHelper.CreateTaskForCampaignMember(t, con, whatIdForTask, leadPassCampaignName, leadRatingTypeCampaignGoal);		
			else
			 //Mod by LD 11/26/14 - remove update calls from within loop
				//update t; //Update the Task Owner Change from Round Robin
				tasksToUpd.add(t);
		}
		else if(leadId != null)
		{			
			Lead l = UtilityClass.GetLead(leadId);
			String owner = l.Owner.Name;
			if(CampaignMemberHelper.IsEloquaAdmin(owner) || leadPass)
			{
				RoundRobinHelper rrLRHelper = new RoundRobinHelper(Constants.ObjectLead, Constants.GroupRenewals);		
				System.debug('#######################Round Robin = ' + Constants.GroupRenewals);
							
				l.OwnerId = rrLRHelper.GetNextUser(false, CampaignMemberHelper.GetLeadRatingType(leadRatingTypeCampaignGoal));
				CampaignMemberHelper.UpdateRoundRobin(rrLRHelper, l.Description);	
				CampaignMemberHelper.SendLeadEmail(leadPassCampaignName, l, con, UtilityClass.GetUser(l.OwnerId), rrLRHelper.CurrentRoundRobin.Include_Emails__c);
				//Mod by LD 11/26/14 - Adding the missing update call on Lead
				leadsToUpd.add(l);
			}
			else
			{
				System.debug('#####################Will not go through Assignment logic because lead is assigned to = ' + owner);	
			}
			
		}
		// Mod by LD 11/26/14
		if (tasksToUpd.size() > 0){
			update tasksToUpd;
		}
		
		if (leadsToUpd.size() > 0)	{
			update leadsToUpd;
		}
		
	}
		
	public static void ExecuteRegionalLeadGenRules(Id contactId, Id leadId, Id whatIdForTask, String leadPassCampaignName, String leadRatingTypeCampaignGoal, Boolean leadPass)
	{
		system.debug('***LD ExecuteRegionalLeadGenRules');	
		Task t;
		Contact con;
		
		if(contactId != null)
		{
			if(!leadPass)
				t = new Task();
			else
				t = UtilityClass.GetTask(whatIdForTask);						
			
			con = UtilityClass.GetContact(contactId);
			System.debug('#######################' + con);
			
			if(con.AccountId != null)
			{										
				if(con.Account.Renewal_Rep__c != null)
				{				
					t.OwnerId = con.Account.Renewal_Rep__c;		
					System.debug('#######################Task Assigned To Renewal Rep = ' + con.Account.Renewal_Rep__c);
				}
				else
				{			
					RoundRobinHelper rrTRSGHelper = null;
					if(CampaignMemberHelper.IsEastOrWest(con.Account.BillingState) == Constants.West)
					{
						rrTRSGHelper = new RoundRobinHelper(Constants.ObjectLead, Constants.GroupLeadGen);
						System.debug('#######################Round Robin = ' + Constants.GroupLeadGen);
					}
					else
					{
						rrTRSGHelper = new RoundRobinHelper(Constants.ObjectLead, Constants.RegionalLeadGen);		
						System.debug('#######################Round Robin = ' + Constants.RegionalLeadGen);
					}
											
					t.OwnerId = rrTRSGHelper.GetNextUser(false, CampaignMemberHelper.GetLeadRatingType(leadRatingTypeCampaignGoal));
					CampaignMemberHelper.UpdateRoundRobin(rrTRSGHelper, t.Subject);			
					CampaignMemberHelper.SendLeadEmail(leadPassCampaignName, null, con, UtilityClass.GetUser(t.OwnerId), rrTRSGHelper.CurrentRoundRobin.Include_Emails__c);
				}			
			}				
			System.debug('####################### Task owner = ' + t.Owner.Name);
			
			//Only create the Task if associating to campaign.  If coming from Lead Pass process, then the task already exists.
			if(!leadPass)
				CampaignMemberHelper.CreateTaskForCampaignMember(t, con, whatIdForTask, leadPassCampaignName, leadRatingTypeCampaignGoal);					
			else
				update t; //Update the Task Owner Change from Round Robin
		}
		else if(leadId != null)
		{						
			Lead l = UtilityClass.GetLead(leadId);
			String owner = l.Owner.Name;
			if(CampaignMemberHelper.IsEloquaAdmin(owner) || leadPass)
			{
				RoundRobinHelper rrLRSGHelper = null;
				if(CampaignMemberHelper.IsEastOrWest(l.State) == Constants.West)
				{
					rrLRSGHelper = new RoundRobinHelper(Constants.ObjectLead, Constants.GroupLeadGen);
					System.debug('#######################Round Robin = ' + Constants.GroupLeadGen);
				}
				else
				{
					rrLRSGHelper = new RoundRobinHelper(Constants.ObjectLead, Constants.RegionalLeadGen);
					System.debug('#######################Round Robin = ' + Constants.RegionalLeadGen);
				}
				
				l.OwnerId = rrLRSGHelper.GetNextUser(false, CampaignMemberHelper.GetLeadRatingType(leadRatingTypeCampaignGoal));
				CampaignMemberHelper.UpdateRoundRobin(rrLRSGHelper, l.Description);	
				CampaignMemberHelper.UpdateLeadRating(leadRatingTypeCampaignGoal, l);
				update l;
				CampaignMemberHelper.SendLeadEmail(leadPassCampaignName, l, con, UtilityClass.GetUser(l.OwnerId), rrLRSGHelper.CurrentRoundRobin.Include_Emails__c);
			}
			else
			{
				System.debug('#####################Will not go through Assignment logic because lead is assigned to = ' + owner);	
			}
		}
	}		
}