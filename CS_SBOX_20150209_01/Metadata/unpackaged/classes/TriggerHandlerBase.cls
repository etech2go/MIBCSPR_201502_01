/**
* @author Hari Krishnan
* @date 07/16/2013
* @description This class implements the ITriggerHandler to provide abstract/virtual methods for the interface methods
*				and so that the trigger handlers need to implement only the method that they have to. The only exception
*				is the mainEntry, which is mandatory for the trigger handlers to implement.
*/
public abstract class TriggerHandlerBase implements ITriggerHandler {
	protected List<SObject> sObjectsToInsert = new List<SObject>();
	protected Map<Id, SObject> sObjectsToUpdate = new Map<Id, SObject>();
	
	/** 
	* @author Hari Krishnan
	* @date 07/16/2013
	* @description Called for the first time in the execution context. The trigger handlers need to implement
	*				this method.
	* @param TriggerParameters The trigger parameters such as the list of records before and after the update.
	*/
	public abstract void mainEntry(TriggerParameters tp);
	
	/** 
	* @author Hari Krishnan
	* @date 07/16/2013
	* @description Called for the subsequent times in the same execution context. The trigger handlers can chose
	*				to ignore if they don't need the reentrant feature.
	* @param TriggerParameters The trigger parameters such as the list of records before and after the update.
	*/
	public virtual void inProgressEntry(TriggerParameters tp) {
		
	}
	
	/** 
	* @author Hari Krishnan
	* @date 06/20/2013
	* @description Updates the objects, if any.
	*/
	public virtual void updateObjects() {
		System.debug('Updating Objects in Trigger');
		
		for (SObject s : sObjectsToUpdate.values())
		{
			System.debug('UDATE Id - ' + s.Id);
		}
		
		Database.SaveResult[] lsr = Database.update(sObjectsToUpdate.values(), false);
		
		for(Database.SaveResult sr : lsr)
		{
		   if (!sr.isSuccess())
		   {
			   System.debug('Record with Id - ' + sr.getId() + 'Failed to update');
		   }
		}
	}
	
	/** 
	* @author Mark Doggett
	* @date 11/14/2013
	* @description Added functionality to insert Objects
	*/
	public virtual void insertObjects() {
		Database.SaveResult[] lsr = Database.update(sObjectsToInsert, false);
		
		for(Database.SaveResult sr : lsr)
		{
		   if (!sr.isSuccess())
		   {
			   Database.Error[] errors = sr.getErrors();
			   
			   for (Database.Error e : errors)
			   {
				   String ErrorMessage = e.getMessage() + 'In Field(s) (';
				   for (String s : e.getFields())
				   {
				   		ErrorMessage += s + ' '; 
				   }
				   ErrorMessage += ') Status Code - ' + e.getStatusCode();
				   
			   	   System.debug('Error adding record ' + ErrorMessage);
		   	   }
		   }
		}
	}
}