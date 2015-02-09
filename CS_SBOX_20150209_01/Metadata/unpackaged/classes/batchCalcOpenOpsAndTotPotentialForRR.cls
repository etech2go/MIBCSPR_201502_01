global class batchCalcOpenOpsAndTotPotentialForRR implements Database.Batchable<sObject>, Schedulable
{
	global final String Query;
   
	global batchCalcOpenOpsAndTotPotentialForRR(string q)     
  	{
  		Query = q;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC)         
    {
    	return Database.getQueryLocator(Query);
    }
     
    global void finish(Database.BatchableContext bc)
	{
	}  
	 
	global void execute(Database.BatchableContext bc, List<Round_Robin__c> scope)
	{
		Date startOfMonth = Date.today().ToStartOfMonth();
		Date endOfMonth = Date.today().addMonths(1).ToStartOfMonth().addDays(-1);
		Date startOfMonthNextYear = Date.today().addYears(1).ToStartOfMonth();
		Date endOfMonthNextYear = Date.today().addMonths(13).ToStartOfMonth().addDays(-1);	
		
		
		// Get all the relevent opps for the Round robin records that we are about to process
		Set<Id> userIds = new Set<Id>();
		Map<Id, List<Opportunity>> userOppsMap = new Map<Id, List<Opportunity>>();
	
		for (Round_Robin__c rr : scope)
		{
			userIds.add(rr.User__c);	
		}
		
		system.debug('****startOfMonth :'+ startOfMonth);
		system.debug('**** endOfMonth :' + endOfMonth);
		system.debug('**** startOfMonthNextYear :'+ startOfMonthNextYear);
		system.debug('**** EndOfMonthNextYear :' + endOfMonthNextYear);
		
        List<Opportunity> oppsList = [Select Id, OwnerId, Commissionable_Potential__c from Opportunity where OwnerId IN :userIds and IsClosed = false and ((Renewal_Due_Date__c >= :startOfMonth and Renewal_Due_Date__c <= :endOfMonth) or (Renewal_Due_Date__c >= :startOfMonthNextYear and Renewal_Due_Date__c <= :endOfMonthNextYear))];
	    
        system.debug('***OppsList ---'+oppsList);
		for (Opportunity opp : oppsList)
		{
			if (userOppsMap.containsKey(opp.OwnerId))
			{
				userOppsMap.get(opp.OwnerId).add(opp);
			}
			else
			{
				List<Opportunity> tempList = new List<Opportunity>();
				tempList.add(opp);
				userOppsMap.put(opp.OwnerId, tempList);
			}
		}
		
		for (Round_Robin__c rr : scope)
		{
			// Get the Opps List for this User
			List<Opportunity> opps = userOppsMap.get(rr.User__c);
			
			if (opps != null)
			{
				rr.Open_Opps__c = opps.size();
				rr.Total_Available_Potential__c = fetchOppOwnerStats(opps); // ****LD need to complete this calc
			    
			    system.debug('***opps List Size '+ opps.size());
				system.debug('***Total_Available_Potential__c '+ rr.Total_Available_Potential__c);
	
			}
			else
			{
				rr.Open_Opps__c = 0;
				rr.Total_Available_Potential__c = 0;
                system.debug('**** no Opps');
			}
		}
		
		update scope;
	}
	
	global void execute(SchedulableContext SC) 
    {  
	   string SOQL = 'Select Id, User__c, Open_Opps__c, Total_Available_Potential__c from Round_Robin__c';
       Database.executeBatch(new batchCalcOpenOpsAndTotPotentialForRR(SOQL),20); 
    }
    
    private Integer fetchOppOwnerStats(List<Opportunity> opList)
    {
       Set<Id> opIds = new Set<Id>();
       Integer totPotential = 0;
       for(Opportunity o: opList){
    	 	opIds.add(o.Id);
    	}
    	
       //system.debug('******Opp Ids :'+ opIds);
    	   
       List<AggregateResult> OppOwnerStats = new List<AggregateResult>(); 
       OppOwnerStats = [SELECT SUM(Commissionable_Potential__c) TotalPotential, COUNT(Id) TotalOpps, OwnerId FROM Opportunity WHERE Id = :opIds GROUP BY OwnerId];
       for(AggregateResult sobj : OppOwnerStats) {
         string oid = String.valueOf(sobj.get('OwnerId'));
         totPotential = Integer.valueOf(sobj.get('TotalPotential'));
        }

       return totPotential;  
     }	

}