@isTest
private class TestBatchJobTestHarnessController {
	static testMethod void TestOption1()
	{
		PageReference pageRef = Page.batchJobTestHarness;
		pageRef.GetParameters().put('RowId', '1');
		Test.setCurrentPage(pageRef); 
		batchJobTestHarnessController cont = new batchJobTestHarnessController();
		cont.RunJobs();
	}
	
	static testMethod void TestOption2()
	{
		PageReference pageRef = Page.batchJobTestHarness;
		pageRef.GetParameters().put('RowId', '2');
		Test.setCurrentPage(pageRef); 
		batchJobTestHarnessController cont = new batchJobTestHarnessController();
		cont.RunJobs();
		cont.UpdateStatuses();
	}
	
	/*static testMethod void TestOption3()
	{
		PageReference pageRef = Page.batchJobTestHarness;
		pageRef.GetParameters().put('RowId', '3');
		Test.setCurrentPage(pageRef); 
		batchJobTestHarnessController cont = new batchJobTestHarnessController();
		cont.RunJobs();
	}*/
	
	static testMethod void TestOption4()
	{
		PageReference pageRef = Page.batchJobTestHarness;
		pageRef.GetParameters().put('RowId', '4');
		Test.setCurrentPage(pageRef); 
		batchJobTestHarnessController cont = new batchJobTestHarnessController();
		cont.RunJobs();
	}
	
	static testMethod void TestOption5()
	{
		PageReference pageRef = Page.batchJobTestHarness;
		pageRef.GetParameters().put('RowId', '5');
		Test.setCurrentPage(pageRef); 
		batchJobTestHarnessController cont = new batchJobTestHarnessController();
		cont.RunJobs();
	}
	
	static testMethod void TestOption6()
	{
		PageReference pageRef = Page.batchJobTestHarness;
		pageRef.GetParameters().put('RowId', '6');
		Test.setCurrentPage(pageRef); 
		batchJobTestHarnessController cont = new batchJobTestHarnessController();
		cont.RunJobs();
	}
	
	static testMethod void TestOption7()
	{
		PageReference pageRef = Page.batchJobTestHarness;
		pageRef.GetParameters().put('RowId', '7');
		Test.setCurrentPage(pageRef); 
		batchJobTestHarnessController cont = new batchJobTestHarnessController();
		cont.RunJobs();
	}

}