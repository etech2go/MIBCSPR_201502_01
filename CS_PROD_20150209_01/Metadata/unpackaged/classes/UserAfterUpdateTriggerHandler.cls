public class UserAfterUpdateTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		for (User u : (List<User>)tp.newList)
		{	
			// Get the old user
			User oldUser = (User)tp.oldMap.get(u.Id);
			
			if (oldUser.CA_Rep__c != u.CA_Rep__c)
			{
				ChangeCAForUser(u.Id);
			}
			
			if (oldUser.IsActive && !u.IsActive)
			{
				RemoveUserFromRoundRobin(u.Id);
			}
			
		}
	}
	
	@future
	public static void RemoveUserFromRoundRobin(Id userId)
	{
		// Get all the round robin record relating to this user
		List<Round_Robin__c> rrList = [Select Id, Assign_Records__c from Round_Robin__c where User__c = :userId];
	
		if (rrList != null)
		{
			for (Round_Robin__c rr : rrList)
			{
				rr.Assign_Records__c = false;
			}
		}
		
		update rrList;
	}
	
	@future
	public static void ChangeCAForUser(Id userId)
	{
		List<Opportunity> oppsList = [select Id, OwnerId, CA_Rep__c from Opportunity where OwnerId = :userId and IsClosed = false];
		User u = [Select Id, CA_Rep__c from User where Id = :userId];
		List<Opportunity> oppsToUpdate = new List<Opportunity>();
		
		for (Opportunity o : oppsList)
		{
			if (o.CA_Rep__c != u.CA_Rep__c)
			{
				o.CA_Rep__c = u.CA_Rep__c;
				oppsToUpdate.add(o);
			}
		}
		
		update oppsToUpdate;
	}
}