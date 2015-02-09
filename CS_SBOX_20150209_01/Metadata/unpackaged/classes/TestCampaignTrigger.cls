@isTest
private class TestCampaignTrigger
{
	static testMethod void TestDuplicateCampaignName()
	{
		User u = TestLibrary.createUser ('Test', TestLibrary.STANDARD_USER_PROFILE);
        insert u;
		
		Campaign camp1 = TestLibrary.createCampaign('Test', u.Id);
		Campaign camp2 = TestLibrary.createCampaign('Test', u.Id);
		
		insert camp1;
		
		Test.startTest();
			
		try
		{
			insert camp2;
		}
		catch (Exception e)
		{
			System.Assert(e.getMessage().contains('Campaign Names must be Unique'));
		}
					
		Test.stopTest();
	}
	
	static testMethod void TestDuplicateCampaignNameOnUpdate()
	{
		User u = TestLibrary.createUser ('Test', TestLibrary.STANDARD_USER_PROFILE);
        insert u;
		
		Campaign camp1 = TestLibrary.createCampaign('Test1', u.Id);
		Campaign camp2 = TestLibrary.createCampaign('Test2', u.Id);
		
		insert camp1;
		insert camp2;
		
		Test.startTest();
			
		try
		{
			camp2.Name = 'Test1';
			update camp2;
		}
		catch (Exception e)
		{
			System.Assert(e.getMessage().contains('Campaign Names must be Unique'));
		}
					
		Test.stopTest();
	}
}