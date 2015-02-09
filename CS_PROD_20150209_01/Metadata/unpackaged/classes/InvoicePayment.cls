public with sharing class InvoicePayment {
  @future (callout=true)
  public static void doPayment(id invId){
  	
  	fw1__Payment__c payment = new fw1__Payment__c();
  	fw1__Invoice__c invoice = getInvoice(invId);
  	fw1__Payment_Center_Setting__c setting = getPaymentSettings();
  	fw1__PaymentProfile__c profile = getPaymentProfile(invoice.fw1__Account__c);
    string processor = getDefaultPaymentProcessor();
    string paymentType = setting.fw1__Online_Payment_Type__c;
    
    
    if (processor != null && paymentType != null) {
        payment.fw1__Payment_Processor__c = processor;
        
                   
        if (invoice.fw1__Alternate_Invoice_Number__c != null) {
            payment.Name = 'Payment for ' + invoice.fw1__Alternate_Invoice_Number__c;
        } else {
            payment.Name = 'Payment for ' + invoice.Name;
        }
               
        payment.fw1__Amount__c = invoice.fw1__Balance_Due__c;
        payment.fw1__Type__c = paymentType;
        
        system.debug('===>' + payment.fw1__Payment_Processor__c + ';' + payment.fw1__Type__c + ';' + string.valueOf(payment.fw1__Amount__c));
        payment.fw1__Payment_Date__c = System.Now();
        payment.fw1__Invoice__c = invoice.Id;
        payment.fw1__Account__c = invoice.fw1__Account__c;
        payment.fw1__Contact__c = invoice.fw1__Contact__c;
        payment.fw1__Opportunity__c = invoice.fw2__Opportunity__c;
        payment.fw1__Email__c = invoice.fw1__Recipient_Email__c;
        payment.fw1__Auto_BillPay__c = true;
        payment.fw1__Email_Currency_Symbol__c = setting.fw1__Email_Currency_Symbol__c;  
        if (invoice.fw1__Billing_Street__c != null) {
		      payment.fw1__Billing_Street__c = invoice.fw1__Billing_Street__c;
		      payment.fw1__Billing_City__c = invoice.fw1__Billing_City__c;
		      payment.fw1__Billing_State__c = invoice.fw1__Billing_State__c;
		      payment.fw1__Billing_Zip__c = invoice.fw1__Billing_Zip__c;
		      payment.fw1__Billing_Country__c = invoice.fw1__Billing_Country__c;
        }  
        if (invoice.fw1__Shipping_Street__c != null) {
          payment.fw1__Shipping_Street__c = invoice.fw1__Shipping_Street__c;
          payment.fw1__Shipping_City__c = invoice.fw1__Shipping_City__c;
          payment.fw1__Shipping_State__c = invoice.fw1__Shipping_State__c;
          payment.fw1__Shipping_Zip__c = invoice.fw1__Shipping_Zip__c;
          payment.fw1__Shipping_Country__c = invoice.fw1__Shipping_Country__c;
        }
        if (profile.fw1__Bank_Account_Number__c != null){
          payment.fw1__Payment_Method__c = 'eCheck';
        } else {
          payment.fw1__Payment_Method__c = 'Credit Card';
        }
        if (payment.fw1__Payment_Method__c == 'Credit Card' || payment.fw1__Payment_Method__c == null) {
            payment.fw1__Credit_Card_Type__c = profile.fw1__CreditCardType__c;
            payment.fw1__First_Name__c = profile.fw1__First_Name__c;
            payment.fw1__Last_Name__c = profile.fw1__Last_Name__c;
            payment.fw1__Credit_Card_Number__c = profile.fw1__CreditCardNumber__c;
            payment.fw1__Expiry_Month__c = profile.fw1__ExpiryMonth__c;
            payment.fw1__Expiry_Year__c = profile.fw1__ExpiryYear__c;
        } else if (payment.fw1__Payment_Method__c == 'eCheck') {
            payment.fw1__Bank_ABA_Code__c = profile.fw1__Bank_ABA_Code__c;
            payment.fw1__Bank_Account_Number__c = profile.fw1__Bank_Account_Number__c;
            payment.fw1__Name_On_Account__c = profile.fw1__Name_On_Account__c;
            payment.fw1__ECheck_Type__c = 'WEB';
            payment.fw1__Type__c = 'Charge';                     
        }
        PaymentValidator validator = new PaymentValidator();
        
        Boolean isSuccessful;
        if(validator.DoValidate(payment)){
          isSuccessful = fw1.PaymentProcessor.doPayment(payment);
                 
        } else {
        	isSuccessful = false;
        }
        updateOpportunityStatus(invoice.fw2__Opportunity__c,isSuccessful);
        
    }
  }
  
  private static void updateOpportunityStatus(Id oppId, boolean isSuccessful){
  	string CLOSED = 'Closed';
    string PAYMENTERROR = 'Payment Error';
    
     Opportunity o;
     try{
         o = [SELECT Name,Opportunity_Status__c
              FROM Opportunity
              WHERE Id = :oppId
              LIMIT 1];
     } catch (Exception e) { }
     
     if (isSuccessful)
        o.Opportunity_Status__c = CLOSED;
     else
        o.Opportunity_Status__c = PAYMENTERROR;
     
     update o;
  }
  
  private static fw1__Invoice__c getInvoice(id invId){
  	
  	return [SELECT Name, Id,fw1__Balance_Due__c, fw1__Retry_Date__c, fw1__Total_Paid_Amount__c,
  	       fw1__Pending_Auto_Bill_Pay__c, fw1__Alternate_Invoice_Number__c,
  	       fw1__Account__c,fw1__Contact__c,fw1__Billing_Street__c,
  	       fw1__Billing_City__c,fw1__Billing_State__c,fw1__Billing_Zip__c,
  	       fw1__Billing_Country__c,fw1__Shipping_Street__c,fw1__Shipping_City__c,
  	       fw1__Shipping_State__c,fw1__Shipping_Zip__c,fw1__Shipping_Country__c,
  	       fw2__Opportunity__c,fw1__Recipient_Email__c
           FROM fw1__Invoice__c
           WHERE Id = :invId];
  }
  
  private static fw1__Payment_Center_Setting__c getPaymentSettings(){
    return 
      [SELECT 
         fw1__Default_Email_Subject__c, fw1__Default_Email_Message__c, 
         fw1__Default_Terms_And_Conditions__c,
         fw1__Online_Payment_Type__c,  
         fw1__Domain_Name__c,  fw1__Email_Currency_Symbol__c,
         fw1__Sender_Display_Name__c,
         fw1__Failed_Attempt1__c,fw1__Failed_Attempt2__c,
         fw1__Failed_Attempt3__c,fw1__Failed_Attempt_Final__c     
      FROM fw1__Payment_Center_Setting__c
      WHERE Name = 'Default Settings'
      LIMIT 1];
  }
  
  private static string getDefaultPaymentProcessor() {
    String defaultPaymentProcessor = '';
        
    fw1__Payment_Processor__c pProcessor = new fw1__Payment_Processor__c();
    try {
      pProcessor = [SELECT Name
                    FROM fw1__Payment_Processor__c
                    WHERE fw1__Use_As_Default__c = true
                    LIMIT 1];
      defaultPaymentProcessor = pProcessor.Name;
    } catch (Exception e) {
        System.Debug('There is no default Payment Processor: ' + e);
        try {
                pProcessor = [SELECT Name
                                FROM fw1__Payment_Processor__c
                               LIMIT 1];
                defaultPaymentProcessor = pProcessor.Name;
          } catch (Exception ex) {
                System.Debug('There are no Payment Processors.' + ex);
          }
    }
    return defaultPaymentProcessor;
  }
  
  private static fw1__PaymentProfile__c getPaymentProfile(id accountId){
    List<fw1__PaymentProfile__c> profiles = new List<fw1__PaymentProfile__c>();
    
    profiles = [SELECT Name,Id, fw1__Name_On_Account__c, fw1__Last_Name__c, fw1__First_Name__c, 
                  fw1__ExpiryYear__c, fw1__ExpiryMonth__c, fw1__CreditCardType__c, fw1__CreditCardNumber__c, 
                  fw1__Bank_Account_Number__c, fw1__Bank_ABA_Code__c
                FROM fw1__PaymentProfile__c
                WHERE fw1__Account__c = :accountId
                AND fw1__UseAsDefault__c = true
                LIMIT 1]; 
                
    if (profiles.size() > 0) 
      return profiles[0];
    else 
    	 return null;
   
  }
           
}