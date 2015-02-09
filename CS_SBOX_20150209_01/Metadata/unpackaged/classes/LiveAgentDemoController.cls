public with sharing class LiveAgentDemoController
{
	 public PageReference RedirectToCision()
    {
        PageReference ReturnPage = new PageReference('http://www.cision.com/');        
        ReturnPage.setRedirect(true);
        return ReturnPage;           
    }
        
}