public with sharing class RoundRobinHelper
{
    private List<Round_Robin__c> roundRobinList = null;
    private Map<ID, Round_Robin__c> roundRobinMap = null;
    private List<Round_Robin_Statistic__c> statsList = new List<Round_Robin_Statistic__c>();
    private ID lastRecordAllocated = null;
    public Round_Robin__c CurrentRoundRobin {get; set;}
	
	private Id SFDCAdmin = null;
	
    public RoundRobinHelper(String objectType, String grp)
    {
        roundRobinList = [Select Id, Name, Last_Allocated__c, Object_Type__c, Number_of_Records_Assigned__c, Store_Stats__c, User__c, User__r.LastLoginDate, Open_Opps__c, Include_Emails__c, Max_Hot_Leads_Monthly__c, Max_Warm_Leads_Monthly__c, Open_Hot_Leads_This_Month__c, Open_Warm_Leads_This_Month__c from Round_Robin__c where Object_Type__c = :objectType and Group__c = :grp and Assign_Records__c = true and User__r.IsActive = true order by Id ];
        if (roundRobinList != null && roundRobinList.size() > 0)
        {
			// If none of the records have Last Allocated selected then make the first record the last allocated one
			Boolean hasLastAllocated = false;
			for (Round_Robin__c rr : roundRobinList)
			{
				if (rr.Last_Allocated__c)
				{
					hasLastAllocated = true;
					break;
				}
			}
			
			if (!hasLastAllocated)
			{
				roundRobinList[0].Last_Allocated__c = true;
			}
			
            roundRobinMap = new Map<ID, Round_Robin__c>(roundRobinList);
        }
		
		List<User> adminUser = [Select Id from User where Name = 'SFDC Admin'];
		if (adminUser != null && adminUser.size() > 0)
		{
			SFDCAdmin = adminUser[0].Id;
		}
    }
	
	public RoundRobinHelper(String objectType, String grp, String subGrp)
    {
      	roundRobinList = [Select Id, Name, Last_Allocated__c, Object_Type__c, Number_of_Records_Assigned__c, Store_Stats__c, User__c, User__r.LastLoginDate, Open_Opps__c, Total_Available_Potential__c, Include_Emails__c, Max_Hot_Leads_Monthly__c, Max_Warm_Leads_Monthly__c, Open_Hot_Leads_This_Month__c, Open_Warm_Leads_This_Month__c from Round_Robin__c where Object_Type__c = :objectType and Group__c = :grp and Sub_Group__c = :subGrp and Assign_Records__c = true and User__r.IsActive = true order by Id ];
           
        if (roundRobinList != null && roundRobinList.size() > 0)
        {
			// If none of the records have Last Allocated selected then make the first record the last allocated one
			Boolean hasLastAllocated = false;
			for (Round_Robin__c rr : roundRobinList)
			{
				if (rr.Last_Allocated__c)
				{
					hasLastAllocated = true;
					break;
				}
			}
			
			if (!hasLastAllocated)
			{
				roundRobinList[0].Last_Allocated__c = true;
			}
			
            roundRobinMap = new Map<ID, Round_Robin__c>(roundRobinList);
        }
		
		List<User> adminUser = [Select Id from User where Name = 'SFDC Admin'];
		if (adminUser != null && adminUser.size() > 0)
		{
			SFDCAdmin = adminUser[0].Id;
		}
    }
    
    public Set<ID> GetUserIds()
    {
        Set<ID> userIdSet = new Set<ID>();
        
		if (roundRobinList != null && roundRobinList.size() > 0)
		{
        	for (Round_Robin__c rr : roundRobinList)
        	{
            	userIdSet.add(rr.User__c);
        	}
		}
		else
		{
			userIdSet.add(SFDCAdmin);
		}
        
        return userIdSet;
    }
    
	public ID GetNextUser(Boolean onlyIfLoggedInToday, Boolean allocateToLeastOpenOpps)
	{
		return GetNextUser(onlyIfLoggedInToday, allocateToLeastOpenOpps, 0);
	}
	
    public ID GetNextUser(Boolean onlyIfLoggedInToday, Boolean allocateToLeastOpenOpps, decimal OppCommPotential)
    {
        Boolean allocateNextRecord = false;
        Decimal commPotentialAmt = 0.0;
				
		if (OppCommPotential != null && OppCommPotential > 0.00)
		  	commPotentialAmt = OppCommPotential;
        
		if (roundRobinList != null && roundRobinList.size() > 0)
		{
			if (allocateToLeastOpenOpps)
			{
				// If one user has less than anyone else we should assign to them
				ID leastRoundRobinId = null;
				Decimal leastOpenOpps = null;
				Decimal leastTotalPotential = null;
				Integer numberOfUsersWithSameLeastValue = 0;
				
				
				for (Round_Robin__c rr : roundRobinList)
	        	{
					if (rr.Open_Opps__c == null)
					{
						rr.Open_Opps__c = 0;	
					}
					
					if (leastRoundRobinId == null)
					{
						leastRoundRobinId = rr.Id;
						leastOpenOpps = rr.Open_Opps__c;
						leastTotalPotential = rr.Total_Available_Potential__c;
						numberOfUsersWithSameLeastValue = 1;
					}
					else
					{
						if (leastOpenOpps > rr.Open_Opps__c)
						{
							leastRoundRobinId = rr.Id;
							leastOpenOpps = rr.Open_Opps__c;
							leastTotalPotential = rr.Total_Available_Potential__c;
							numberOfUsersWithSameLeastValue = 1;
						}
						else if (leastOpenOpps == rr.Open_Opps__c)
						{
						    if (leastTotalPotential > rr.Total_Available_Potential__c){
	                            leastRoundRobinId = rr.Id;
							    leastOpenOpps = rr.Open_Opps__c;
							    leastTotalPotential = rr.Total_Available_Potential__c;
							    numberOfUsersWithSameLeastValue = 1;
						     }
						     else if (leastTotalPotential == rr.Total_Available_Potential__c){	
							    numberOfUsersWithSameLeastValue++;
						     }
						}
					}
				}
				
				if (numberOfUsersWithSameLeastValue < roundRobinList.size())
				{
					Round_Robin__c rr = roundRobinMap.get(leastRoundRobinId);
					rr.Open_Opps__c++;
					lastRecordAllocated = rr.Id;
					currentRoundRobin = rr;
					
					return rr.User__c;
				}
			}
			
			System.debug('Number of Round Robin Records = ' + roundRobinList.size());
	        for (Round_Robin__c rr : roundRobinList)
	        {
	            if (rr.Last_Allocated__c)
	            {
	                // This was the last record allocated so we should reset it
	                rr.Last_Allocated__c = false;
	                allocateNextRecord = true;
	            }
	            else if (allocateNextRecord)
	            {
	                Date lastLogin = Date.today().addDays(-1);
					
					System.debug('Last Login Date = ' + rr.User__r.LastLoginDate + 'User Id = ' + rr.User__c);
	                if (rr.User__r.LastLoginDate != null)
	                {
	                    lastLogin = rr.User__r.LastLoginDate.Date();
	                }
	                                
	               if (!onlyIfLoggedInToday || (onlyIfLoggedInToday && lastLogin == Date.today()))
	               {
	                    // We should allocate to this record
	                    rr.Last_Allocated__c = true;
	                    lastRecordAllocated = rr.Id;
	                    allocateNextRecord = false;
					   
					   	if (rr.Number_of_Records_Assigned__c == null)
					   	{
							rr.Number_of_Records_Assigned__c = 1;
					   	}
					   	else
					   	{
	                    	rr.Number_of_Records_Assigned__c++;
					   	}
					   	
						if (rr.Object_Type__c == 'Opportunity')
					   	{
							if (rr.Open_Opps__c == null)
							{
								rr.Open_Opps__c = 1;
								rr.Total_Available_Potential__c = commPotentialAmt;
							}
							else
							{
								rr.Open_Opps__c++;
								
							}
							if (rr.Total_Available_Potential__c == null){
								rr.Total_Available_Potential__c = commPotentialAmt;
							}
							else{
								rr.Total_Available_Potential__c = rr.Total_Available_Potential__c + commPotentialAmt;
							}
						}			
											
						currentRoundRobin = rr;
						
	                    return rr.User__c;
	               }
				   else
				   {
					   allocateNextRecord = true;
				   }
	            }
	        }
			
			System.debug('Out of loop and Allocate Next record = ' + allocateNextRecord);
	        
	        // If we have come out of the loop and need to allocate the record we should do it to the first one (or the first one with todays logged in date)
			if (allocateNextRecord)
			{
				System.debug('In Allocate Code');
				Round_Robin__c recordToUse = null;
				
				if (onlyIfLoggedInToday)
				{
					Date lastLogin = Date.today().addDays(-1);
				
					for (Round_Robin__c rr : roundRobinList)
					{
						if (rr.User__r.LastLoginDate != null){
	                        if (rr.User__r.LastLoginDate.Date() == Date.today())
							{
								recordToUse = rr;
								break;
							}
	        			     }
					 }
				 }
				else{
					System.debug('Setting Record to Use');
					recordToUse = roundRobinList[0];
				 }
				
	       		if (recordToUse != null)
				{
					recordToUse.Last_Allocated__c = true;
	            	    lastRecordAllocated = recordToUse.Id;
				
					if (recordToUse.Number_of_Records_Assigned__c == null)
					{
						recordToUse.Number_of_Records_Assigned__c = 1;
					}
					else
					{
	            		recordToUse.Number_of_Records_Assigned__c++;
					}
	            			
					if (recordToUse.Object_Type__c == 'Opportunity')
					{
						if (recordToUse.Open_Opps__c == null)
						{
							recordToUse.Open_Opps__c = 1;
						}
						else
						{
							recordToUse.Open_Opps__c++;
						}
						
						if (recordToUse.Total_Available_Potential__c == null){
							recordToUse.Total_Available_Potential__c = commPotentialAmt;
						}
						else{
							recordToUse.Total_Available_Potential__c = recordToUse.Total_Available_Potential__c + commPotentialAmt;
						}
					}
				
					currentRoundRobin =recordToUse;
				
	           		return recordToUse.User__c;
	        	}
			}
		}
		else
		{
			return SFDCAdmin;
		}
		
        return null;
    }
	
    //mimic above logic for Leads
	public ID GetNextUser(Boolean onlyIfLoggedInToday, String leadRatingType)
	{					
		Boolean allocateNextRecord = false;
		System.debug('***#########################Lead Rating = ' + leadRatingType);	
		
		if (roundRobinList != null && roundRobinList.size() > 0)
		{
			for (Round_Robin__c rr : roundRobinList)
	        {			
				system.debug('***######################### = ' + rr);
	            if (rr.Last_Allocated__c)
	            {
	                // This was the last record allocated so we should reset it
	                rr.Last_Allocated__c = false;
	                allocateNextRecord = true;
	            }
	            else if (allocateNextRecord)
	            {
	                Date lastLogin = Date.today().addDays(-1);
	                if (rr.User__r.LastLoginDate != null)
	                {
	                    lastLogin = rr.User__r.LastLoginDate.Date();
	                }
	                                
	               if (!onlyIfLoggedInToday || (onlyIfLoggedInToday && lastLogin == Date.today()))
	               {
					   if(leadRatingType == Constants.HotRating)
					   {
						   System.debug('***#########################rr.Max_Hot_Leads_Monthly__c = ' + rr.Max_Hot_Leads_Monthly__c);
							if(rr.Max_Hot_Leads_Monthly__c != null)
						  	{
							   if(rr.Open_Hot_Leads_This_Month__c < rr.Max_Hot_Leads_Monthly__c)
							   {
								   rr.Open_Hot_Leads_This_Month__c++;
							   }
							   else
							   {
									continue;   
							   }
							}
							else
							{
								rr.Open_Hot_Leads_This_Month__c = 1;
							}
					   }
					   else
					   {
						   System.debug('***#########################rr.Max_Warm_Leads_Monthly__c = ' + rr.Max_Warm_Leads_Monthly__c);
						   if(rr.Max_Warm_Leads_Monthly__c != null)
						   {
		                       if(rr.Open_Warm_Leads_This_Month__c < rr.Max_Warm_Leads_Monthly__c)
							   {
								   rr.Open_Warm_Leads_This_Month__c++;
							   }
							   else
							   {
									continue;   
							   }
						   }
						   else
						   {
							   rr.Max_Warm_Leads_Monthly__c = 1;
						   }
					   }
					   
					   // We should allocate to this record
	                    rr.Last_Allocated__c = true;
	                    lastRecordAllocated = rr.Id;
	                    allocateNextRecord = false;
					   
					   	if (rr.Number_of_Records_Assigned__c == null)
					   	{
							rr.Number_of_Records_Assigned__c = 1;
					   	}
					   	else
					   	{
	                    	rr.Number_of_Records_Assigned__c++;
					   	}
					   										
						currentRoundRobin = rr;
						
	                    return rr.User__c;
	               }
	            }
			}
			
			System.debug('***Out of loop and Allocate Next record = ' + allocateNextRecord);
			System.debug('***roundRobinList[0] = ' + roundRobinList[0]);
			System.debug('***SFDCAdmin = ' + SFDCAdmin);
	        Date lastLogin = Date.today().addDays(-1);
	        if (roundRobinList[0].User__r.LastLoginDate != null)
	        {
	            lastLogin = roundRobinList[0].User__r.LastLoginDate.Date();
	        }

			if (allocateNextRecord && (!onlyIfLoggedInToday || (onlyIfLoggedInToday && lastLogin == Date.today())))
	        {
	            roundRobinList[0].Last_Allocated__c = true;
	            lastRecordAllocated = roundRobinList[0].Id;
				
				if (roundRobinList[0].Number_of_Records_Assigned__c == null)
				{
					roundRobinList[0].Number_of_Records_Assigned__c = 1;
				}
				else
				{
	            	roundRobinList[0].Number_of_Records_Assigned__c++;
				}
	            			
				if(roundRobinList[0].Open_Hot_Leads_This_Month__c == null)
				{
					roundRobinList[0].Open_Hot_Leads_This_Month__c = 0;
				}
				
				if(roundRobinList[0].Open_Warm_Leads_This_Month__c == null)
				{
					roundRobinList[0].Open_Warm_Leads_This_Month__c = 0;
				}
				
				if(leadRatingType == Constants.HotRating)
				{
					roundRobinList[0].Open_Hot_Leads_This_Month__c++;
				}
				else
				{
					roundRobinList[0].Open_Warm_Leads_This_Month__c++;
				}
								
				currentRoundRobin = roundRobinList[0];
				
	            return roundRobinList[0].User__c;
	        }
		}
		else
		{
			System.debug('***Round Robin last else statement = ' + SFDCAdmin);
			return SFDCAdmin;
		}
		
		return null;	
	}
	
    public void CreateStatisticRecord(String description)
    {
		if (roundRobinList != null && roundRobinList.size() > 0)
		{
	        if (lastRecordAllocated != null && roundRobinMap != null && roundRobinMap.ContainsKey(lastRecordAllocated))
	        {
	            Round_Robin__c rr = roundRobinMap.get(lastRecordAllocated);
	            
	            if (rr.Store_Stats__c)
	            {
	                // We should create a stat record for this Round Robin Record
	                Round_Robin_Statistic__c stat = new Round_Robin_Statistic__c();
	                stat.Round_Robin__c = lastRecordAllocated;
	                stat.Description__c = rr.Object_Type__c + ' - ' + description;
	                statsList.add(stat);
	            }
	        }
		}
    }
    
    public void UpdateRoundRobin()
    {
		if (roundRobinList != null && roundRobinList.size() > 0)
		{
        	update roundRobinList;
        	insert statsList;
		}
    }
}