public class NewOpportunityController
{
    private final ApexPages.StandardController controller;
    
    public NewOpportunityController(ApexPages.StandardController controller)
    {
        this.controller = controller;
    }
    
    public PageReference getNewOppPage()
    {
        if (ApexPages.currentPage().getParameters().get('RecordType') == null)
        {
            Schema.DescribeSObjectResult describeOpp = Schema.SObjectType.Opportunity;
            List<Schema.RecordTypeInfo> rtInfos = describeOpp.getRecordTypeInfos();
            for(Schema.RecordTypeInfo rtInfo : rtInfos)
            {
                // walk through the map to determine the correct record type, this is done with the isAvailable() function
                if(rtInfo.getName() != 'Master' && rtInfo.isAvailable())
                {
                    // below lines will only run one time only
                    System.debug('The RecordType :' +rtInfo.getName() + ' and the id: ' + rtInfo.getRecordTypeId() +' is available, adding it as parameter to the page.');
                    ApexPages.currentPage().getParameters().put('RecordType', rtInfo.getRecordTypeId());
                }
            }
            
            if (ApexPages.currentPage().getParameters().get('RecordType') == null)
            {
                System.debug('Still null after for, this should never happen.');
            }
        }
        
        string recordtype = ApexPages.currentPage().getParameters().get('RecordType');                
        
        // See if there is an account to get
        string account = ApexPages.currentPage().getParameters().get('accid');
        PageReference newPage;
       
        if (account == null)
        {
            newPage = new PageReference('/006/e?&nooverride=1&RecordType=' + recordtype + '&opp3=<New Opportunity>');
        }
        else
        {
             Account a = [Select Id, Required_Invoice_Contact_Name__c, Required_Invoice_Contact_Email__c From Account Where id=:account];
       
            //redirect based on the Account details
            if (a.Required_Invoice_Contact_Name__c == null || a.Required_Invoice_Contact_Email__c == null)
             {
               newPage = new PageReference('/006/e?&nooverride=1&RecordType=' + recordtype + '&opp3=<New Opportunity>&accid=' + a.Id);
             }
            else
            {
              newPage = new PageReference('/006/e?&nooverride=1&RecordType=' + recordtype + '&opp3=<New Opportunity>&accid=' + a.Id + '&00Nd0000006Qzfw=' + a.Required_Invoice_Contact_Name__c + '&00Nd0000006Qzg1=' + a.Required_Invoice_Contact_Email__c);    
             }
         }
        
          
        return newPage.setRedirect(true);
        return null;
    }
    
   
}