@isTest
private class TestAccountProcessEmail {
//Test Method for main class
   
   static testMethod void TestinBoundEmail()
   {
   	
	   	TestLibrary.InitAvaTax();
    
      	User u = TestLibrary.createUser ('Testuser', TestLibrary.BROADCAST_TRANSACTION_PROFILE);
        insert u;
        
    	Account acc = TestLibrary.CreateAccount('TestAccount', u.Id);  
        insert acc;
   	   
   	   
       // create a new email and envelope object
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       
       // setup the data for the email
      email.subject = 'Create Account';
      email.fromAddress = 'someaddress@email.com';
      email.plainTextBody = 'email body\n2225256325\nTitle';
      
      // add an Binary attachment
      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
      attachment.body = blob.valueOf('my attachment text');
      attachment.fileName = 'textfileone.txt';
      attachment.mimeTypeSubType = 'text/plain';
      email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
      
      
  
      // add an Text atatchment
  
      Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
      attachmenttext.body = 'my attachment text';
      attachmenttext.fileName = 'textfiletwo3.txt';
      attachmenttext.mimeTypeSubType = 'text/csv';
      email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
      
      
      // call the email service class and test it with the data in the testMethod
      AccountProcessEmail  testInbound=new AccountProcessEmail();
      testInbound.handleInboundEmail(email, env);
   }
}