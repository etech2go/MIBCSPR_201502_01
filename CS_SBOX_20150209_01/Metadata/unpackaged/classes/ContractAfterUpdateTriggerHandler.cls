public with sharing class ContractAfterUpdateTriggerHandler extends TriggerHandlerBase
{
	public override void mainEntry(TriggerParameters tp)
	{
		ContractHelper.AddContractNumberToOpportunity((List<Contract>)tp.newList);		
		
	}

}