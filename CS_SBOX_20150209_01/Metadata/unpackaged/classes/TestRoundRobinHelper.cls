@isTest
public with sharing class TestRoundRobinHelper
{
	static testMethod void RoundRobinHelperTest()
	{
		//Setup the Data
		User user1 = TestingUtils.createUser('rrTest1', TestingUtils.TEST_PROFILE_ID);
		insert user1;
		User user2 = TestingUtils.createUser('rrTest2', TestingUtils.TEST_PROFILE_ID);
		insert user2;
		User user3 = TestingUtils.createUser('rrTest3', TestingUtils.TEST_PROFILE_ID);
		insert user3;
		
		Round_Robin__c rr1 = new Round_Robin__c(User__c=user1.Id,Object_Type__c='Opportunity',Group__c='East',Sub_Group__c='NATIONAL',Assign_Records__c=true,Number_of_Records_Assigned__c=null,Last_Allocated__c=true,Store_Stats__c=true,Open_Opps__c=0);
		insert rr1;
		Round_Robin__c rr2 = new Round_Robin__c(User__c=user2.Id,Object_Type__c='Opportunity',Group__c='East',Sub_Group__c='NATIONAL',Assign_Records__c=true,Number_of_Records_Assigned__c=0,Last_Allocated__c=false,Store_Stats__c=true,Open_Opps__c=0);
		insert rr2;
		Round_Robin__c rr3 = new Round_Robin__c(User__c=user3.Id,Object_Type__c='Opportunity',Group__c='East',Sub_Group__c='NATIONAL',Assign_Records__c=true,Number_of_Records_Assigned__c=0,Last_Allocated__c=false,Store_Stats__c=true,Open_Opps__c=0);
		insert rr3;
		
		Test.startTest();
		
		RoundRobinHelper rrTest1 = new RoundRobinHelper('Opportunity', 'East');
		rrTest1.GetUserIds();
		rrTest1.GetNextUser(false, false);
		rrTest1.CreateStatisticRecord('TEST');
		rrTest1.GetNextUser(false, false);
		rrTest1.CreateStatisticRecord('TEST');
		rrTest1.GetNextUser(false, false);
		rrTest1.CreateStatisticRecord('TEST');
		rrTest1.GetNextUser(false, false);
		rrTest1.CreateStatisticRecord('TEST');
		rrTest1.GetNextUser(false, false);
		rrTest1.CreateStatisticRecord('TEST');
		rrTest1.GetNextUser(false, false);
		rrTest1.CreateStatisticRecord('TEST');
		rrTest1.UpdateRoundRobin();
		
		RoundRobinHelper rrTest2 = new RoundRobinHelper('Opportunity', 'East', 'NATIONAL');
		rrTest2.GetNextUser(false, true);
		rrTest2.GetNextUser(false, true);
		rrTest2.GetNextUser(false, true);
		
		Test.stopTest();
	}

}