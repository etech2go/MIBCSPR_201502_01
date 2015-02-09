public class ContractHelper
{
	public static List<SObject> objectsToUpdate = new List<SObject>();
	
	public static void AddContractNumberToOpportunity(List<Contract> contractsList)
	{
		Set<Id> oppIds = new Set<Id>();
				
		for (Contract c : contractsList)
		{
			if(c.SBQQ__Opportunity__c != null)
			{
				oppIds.add(c.SBQQ__Opportunity__c);
			}
		}
			
		Map<Id, Opportunity> oppsMap = new Map<Id, Opportunity>([Select Id, Contract_Id__c, Contract_Number__c from Opportunity Where Id in :oppIds]);		
		List<Opportunity> oppsToUpdate = new List<Opportunity>();
		for (Contract c : contractsList)
		{
			Opportunity o = oppsMap.get(c.SBQQ__Opportunity__c);
						
			if (o != null)
			{							
				o.Contract_Number__c = c.ContractNumber;
				o.Contract_Id__c = c.Id;
				oppsToUpdate.add(o);
			}
			
		}
		
		update oppsToUpdate;
	}
	
	

}