public with sharing class CaseHelper
{
    // Store the CC Email addresses
    private String cmTeamEmail = 'cmteam.us@cision.com';
    private String csMajorAccountsEmail = 'csmajoraccounts.us@cision.com';
    private String agencySupportEmail = 'agencysupport@cision.com';
        
    private Map<Id,Account> accountMap = null;
    private Map<Id, User> userMap = null;
    
    private RoundRobinHelper rrCSHelper = new RoundRobinHelper('Case', 'Customer Services');
    private RoundRobinHelper rrTHelper = new RoundRobinHelper('Case', 'Training');
    private RoundRobinHelper rrMHelper = new RoundRobinHelper('Case', 'Monitoring');
    private RoundRobinHelper atRiskHelper = new RoundRobinHelper('Case', 'At Risk');
    private RoundRobinHelper consultHelper = new RoundRobinHelper('Case', 'OnSite/Consult');
    
    private Id MichelleId = null;
    private Id JamesId = null;
    private Id JenniferId = null;
    
    public CaseHelper(List<Case> newList)
    {
        Set<Id> accountIds = new Set<Id>();
        Set<String> contactEmails = new Set<String>();
        Set<Id> userIds = new Set<Id>();  
                                        
        // Get the Round Robin records that we need to play with
        userIds.addAll(rrCSHelper.GetUserIds());
        userIds.addAll(rrTHelper.GetUserIds());
        userIds.addAll(rrMHelper.GetUserIds()); 
        userIds.addAll(atRiskHelper.GetUserIds());
        userIds.addAll(consultHelper.GetUserIds()); 
          
        for (Case c : newList) 
        {
            System.Debug('Getting ContactId for Case. AccountId = ' + c.AccountId + ' Contact Id = ' + c.ContactId);
            if(c.SuppliedEmail != null && c.SuppliedEmail != '') 
            {
                contactEmails.add(c.SuppliedEmail);
            }
        }
        
        List<Contact> contList = [Select Id, AccountId from Contact where Email IN :contactEmails];
        
        for (Contact cont : contList) 
        {
            if(cont.AccountId != null) 
            {
                accountIds.add(cont.AccountId);
            }
        }
        
        accountMap = new Map<Id, Account>([select Id, Renewal_Rep__c, CS_Tier__c, Project_Lead__c  from Account where Id IN :accountIds]);
        
        for (Account a : accountMap.values()) 
        {
            if(a.Renewal_Rep__c != null) 
            {
                userIds.add(a.Renewal_Rep__c);
            }
            
            if (a.Project_Lead__c != null)
            {
                userIds.add(a.Project_Lead__c);
            }
        }
        
        userMap = new Map<Id,User>([select Id, Name, Email, ManagerId from User where Id IN :userIds]);
        
        List<User> uList = [select Id, Name from User where Name = 'Michelle Dziuban' or Name = 'James Hart' or Name = 'Jennifer Torrens'];
        if (uList != null && uList.size() > 0)
        {
            for (User u : uList)
            {
                if (u.Name == 'Michelle Dziuban')
                {
                    System.debug('Found Michelle. Id = ' + u.Id);
                    MichelleId = u.Id;
                }
                if (u.Name == 'James Hart')
                {
                    JamesId = u.Id;
                }
                if (u.Name == 'Jennifer Torrens')
                {
                    JenniferId = u.Id;
                }
            }
        }
    }
    
    public void AssignRenewalRep(Case c)
    {
        if(userMap.size() > 0) 
        {
            // Make sure there is an Account linked to the Case and our Account query captured  it
            if (c.AccountId != null && accountMap.ContainsKey(c.AccountId)                       
                    && accountMap.get(c.AccountId).Renewal_Rep__c != null               // Make sure that account has an owner
                    && usermap.ContainsKey(accountMap.get(c.AccountId).Renewal_Rep__c))  // Finally make sure our User query found the owner
            {
                c.Renewal_Rep__c = userMap.get(accountMap.get(c.AccountId).Renewal_Rep__c).Id;
                System.debug('Renewal Rep=' + c.Renewal_Rep__c);
            }
        }
    }
        
    public void AssignCaseOwner(Case c)
    {
        System.Debug('Assigning Case Owner');
        
        System.Debug('Checking Case OWner Assigned');
        
        if (!c.Case_Owner_Assigned__c)
        {
            System.Debug('Case OWner Not Assigned');
            // See if we should assign this to the Project Lead
            
            System.Debug('Checking Project Lead');
            if (c.AccountId != null && accountMap.ContainsKey(c.AccountId) && (c.Origin == 'Customer Support Email' || c.Origin == 'Monitoring Email'))
            {
                System.Debug('Getting Account Map');
                Account a = accountMap.get(c.AccountId);
        
                if (a.Project_Lead__c != null && a.CS_Tier__c != 'Tier3' && a.CS_Tier__c != 'Setup Team')
                {
                    System.Debug('Assigning Project Lead');
                    c.OwnerId = a.Project_Lead__c;
                    c.Case_Owner_Assigned__c = true;
                    return;
                }
            }
            else
            {
                System.Debug('No Account or Wrong Origin');
            }
      
            // There was no project lead so lets start the Round Robin Allocation
            System.debug('No Project Lead');
            ID newUserId = null;
      
            if (c.Origin == 'Customer Support Email')
            {
                // Remember to set first parameter to true before go live
                newUserId = rrCSHelper.GetNextUser(true, false);
                System.Debug('Customer Support Email = ' + newUserId);
            }
            else if (c.Origin == 'Monitoring Email' )
            {
                System.Debug('Getting Monitoring User Id');
                // Remember to set first parameter to true before go live
                newUserId = rrMHelper.GetNextUser(true, false);
                System.Debug('User Id = ' + newUserId);
            }
            else if ((c.Origin == 'Training Email' || c.Origin == 'Automated Training Case') && c.Type != 'At Risk Request' && c.Type != 'Consult Request' && c.Type != 'On-Site Request')
            {
                newUserId = rrTHelper.GetNextUser(false, false);
            }
            else if (c.Type == 'At Risk Request')
            {
                newUserId = atRiskHelper.GetNextUser(false, false);
            }
            else if (c.Type == 'Consult Request' || c.Type == 'On-Site Request')
            {
                System.debug('Consult Request');
                Set<String> michelleStates = new Set<String>{'AL', 'AR', 'IA', 'IL', 'IN', 'FL', 'GA', 'KS', 'KY', 'LA', 'MI', 'MN', 'MO', 'MS', 'NC', 'ND', 'NE', 'OH', 'OK', 'SC', 'SD', 'TN', 'TX', 'WI'};
                Set<String> jamesStates = new Set<String>{'CT', 'DC', 'DE', 'MA', 'MD', 'ME', 'NH', 'NJ', 'NY', 'PA', 'RI', 'VA', 'VT', 'WV'};
                Set<String> jenniferStates = new Set<String>{'AZ', 'AK', 'CA', 'CO', 'HI', 'ID', 'MT', 'NM', 'NV', 'OR', 'UT', 'WA', 'WY'};
                
                if (michelleStates.Contains(c.State_Province__c))
                {
                    System.debug('Setting Michelle Id = ' + michelleId);
                    newUserId = michelleId;
                }
                else if (jamesStates.Contains(c.State_Province__c))
                {
                    newUserId = JamesId;
                }
                else if (jenniferStates.Contains(c.State_Province__c))
                {
                    newUserId = JenniferId;
                }
                else 
                {
                    newUserId = consultHelper.GetNextUser(false, false);
                }
            }
      
            
            if (newUserId != null)
            {
                c.OwnerId = newUserId;
                c.Case_Owner_Assigned__c = true;
                
                if (c.Origin == 'Customer Support Email')
                {
                    // Now add the Statistic
                    rrCSHelper.CreateStatisticRecord(c.Subject);
                }
                else if (c.Origin == 'Monitoring Email')
                {
                    rrMHelper.CreateStatisticRecord(c.Subject);
                }
                else if (c.Origin == 'Training Email')
                {
                    // Now add the Statistic
                    rrTHelper.CreateStatisticRecord(c.Subject);
                } 
                else if (c.Type == 'At Risk Request')
                {
                    atRiskHelper.CreateStatisticRecord(c.Subject);
                }
                else if (c.Type == 'Consult Request' || c.Type == 'On-Site Request')
                {
                    consultHelper.CreateStatisticRecord(c.Subject);
                }
                
            }
         }
        else
        {
            System.debug('Case Owner Already Assigned');
        }
    }
    
    public void AddOpportunityOwnerAndManager(Case c)
    {       
        System.debug('c.Opportunity__c=' + c.Opportunity__c);
        if(c.Opportunity__c != null)
        {                       
            Opportunity opp = [Select Id, OwnerId from Opportunity where Id =: c.Opportunity__c];
            c.Opportunity_Owner__c = opp.OwnerId;           
            User u = [Select Id, ManagerId from User Where Id =: opp.OwnerId];    
            System.debug('opp.OwnerId=' + opp.OwnerId); 
            if(u.ManagerId !=null)
                c.Opportunity_Owner_Manager__c = u.ManagerId;            
        }
    }
    
    public void UpdateRoundRobin()
    {
        rrCSHelper.UpdateRoundRobin();
        rrTHelper.UpdateRoundRobin();
        rrMHelper.UpdateRoundRobin();
        atRiskHelper.UpdateRoundRobin();
        consultHelper.UpdateRoundRobin();
    }
}