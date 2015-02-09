public class OpportunityTriggerDispatcher extends TriggerDispatcherBase {
	private static Boolean isBeforeInsertProcessing = false;
	private static Boolean isBeforeUpdateProcessing = false;
	private static Boolean isAfterUpdateProcessing = false;	
	
	public virtual override void beforeInsert(TriggerParameters tp) {
		System.debug('OpportunityTriggerDispatcher.isBeforeInsertProcessing = ' + OpportunityTriggerDispatcher.isBeforeInsertProcessing);
		if(!OpportunityTriggerDispatcher.isBeforeInsertProcessing) {
			OpportunityTriggerDispatcher.isBeforeInsertProcessing = true;
			execute(new OpportunityBeforeInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
			OpportunityTriggerDispatcher.isBeforeInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
	}
	
	public virtual override void beforeUpdate(TriggerParameters tp) {
		System.debug('Before OpportunityTriggerDispatcher.isBeforeUpdateProcessing = ' + OpportunityTriggerDispatcher.isBeforeUpdateProcessing);
		if(!OpportunityTriggerDispatcher.isBeforeUpdateProcessing) {			
			OpportunityTriggerDispatcher.isBeforeUpdateProcessing = true;
			System.debug('After OpportunityTriggerDispatcher.isBeforeUpdateProcessing = ' + OpportunityTriggerDispatcher.isBeforeUpdateProcessing);
			execute(new OpportunityBeforeUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);			
			OpportunityTriggerDispatcher.isBeforeUpdateProcessing = false;
			System.debug('After execute OpportunityTriggerDispatcher.isBeforeUpdateProcessing = ' + OpportunityTriggerDispatcher.isBeforeUpdateProcessing);
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
	}

	public virtual override void afterUpdate(TriggerParameters tp) {
		System.debug('OpportunityTriggerDispatcher.isAfterUpdateProcessing = ' + OpportunityTriggerDispatcher.isAfterUpdateProcessing);
		if(!OpportunityTriggerDispatcher.isAfterUpdateProcessing) {
			OpportunityTriggerDispatcher.isAfterUpdateProcessing = true;
			execute(new OpportunityAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
			OpportunityTriggerDispatcher.isAfterUpdateProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
	}
}