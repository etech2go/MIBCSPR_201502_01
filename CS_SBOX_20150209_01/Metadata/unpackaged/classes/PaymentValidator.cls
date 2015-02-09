public with sharing class PaymentValidator{

  
  fw1__Payment__c payment;
  string m_CreditCardNumber = 'Credit Card Number is required' ;
  string m_Type = 'Select a value for Payment Type' ;
  string m_Amount = 'Amount must be greater than zero' ;
  string m_CreditCardExpired = 'Credit Card is Expired';
  string m_FirstName = 'First Name is required';
  string m_LastName = 'Last Name is required';
  string m_NullCreditCardType = 'Select a value for Credit Card Type' ;
  string m_NullExpirationCard= 'Expiration date is required' ;
  string m_NullCVV2 = 'CVV2 is required' ;
  string m_NullBillStreet = 'Billing Street is required' ;
  string m_NullBillCity = 'Billing City is required' ;
  string m_NullBillState = 'Billing State is required' ;
  string m_NullBillCountry = 'Billing Country is required' ;
  string m_NullBillZip ='Billing Zip is required' ; 
  string m_InvalidCard ='Invalid Credit Card Number. Card Number must be in this format 9999-9999-9999-9999' ; 
  string m_ABACode = 'Bank ABA Code/Routing Number is required';
  string m_BankAccountNumber = 'Bank Account Number is required';
  string errorMessage = ' ';
  
  public Boolean DisplayAll {get; set;}
  public Boolean DoValidate(fw1__Payment__c payment){
    this.payment = payment;
    Boolean isValidData = true;
    
    if (payment.fw1__Payment_Method__c == 'Credit Card') {
        if(payment.fw1__Credit_Card_Number__c == null){
          errorMessage += m_CreditCardNumber + '\n';
          isValidData = false;
        }
    
        DateTime d = Datetime.now();
        if (payment.fw1__Expiry_Year__c + payment.fw1__Expiry_Month__c < d.format('yyyy') + d.format('MM')){
          errorMessage += m_CreditCardExpired + '\n';
          isValidData = false;
        }    
    
        if (payment.fw1__First_Name__c == null){
          errorMessage += m_FirstName + '\n';
          isValidData = false;
        }
        if (payment.fw1__Last_Name__c == null){
          errorMessage += m_LastName + '\n';
          isValidData = false;
        }
        if(payment.fw1__Credit_Card_Type__c == null){
          errorMessage += m_NullCreditCardType + '\n';
          isValidData = false;
        }
    
        if (payment.fw1__Expiry_Year__c == null || payment.fw1__Expiry_Month__c == null || payment.fw1__Expiry_Year__c == 'Year' || payment.fw1__Expiry_Month__c == 'Month' ){
          errorMessage += m_NullExpirationCard + '\n';
          isValidData = false;
        }
    
        if (payment.fw1__Billing_Street__c == null){
          errorMessage += m_NullBillStreet ;
          isValidData = false;
        }

        if (payment.fw1__Billing_City__c == null){
          errorMessage += m_NullBillCity + '\n';
          isValidData = false;
        }

        if (payment.fw1__Billing_State__c == null){
          errorMessage += m_NullBillState + '\n';
          isValidData = false;
        }

        if (payment.fw1__Billing_Country__c == null){
          errorMessage += m_NullBillCountry + '\n';
          isValidData = false;
        }

        if (payment.fw1__Billing_Zip__c == null){
          errorMessage += m_NullBillZip + '\n';
          isValidData = false;
        }  
    }
    else if (payment.fw1__Payment_Method__c == 'eCheck') {
        if (payment.fw1__Bank_ABA_Code__c == null) {
            errorMessage += m_ABACode + '\n';
            isValidData = false;
        }
        if (payment.fw1__Bank_Account_Number__c == null) {
            errorMessage += m_BankAccountNumber + '\n';
            isValidData = false;
        }
    }
    
    if(payment.fw1__Amount__c <= 0 || payment.fw1__Amount__c == null){
      errorMessage += m_Amount + '\n';
      isValidData = false;
    }
    if(payment.fw1__Type__c == null){
      errorMessage += m_Type + '\n' ;
      isValidData = false;
    }
    


    // get Payment Processor details
    fw1__Payment_Processor__c payProcessor = getInfo(payment.fw1__Payment_Processor__c);
    if (payProcessor != null) {
        if (payProcessor.fw1__Require_CVV2__c == true) {
            if (payment.fw1__CVV2__c == null && payment.fw1__Payment_Method__c == 'Credit Card'){
                errorMessage += m_NullCVV2 + '\n';
                isValidData = false;
            }
        }
        if (payProcessor.fw1__Use_CyberSource_API__c == true) {
            if (payment.fw1__Email__c == null || payment.fw1__Email__c == '') {
                errorMessage += 'Email is required' + '\n';
                isValidData = false;
            }
        }
        
        if (payProcessor.fw1__Use_Stripe_API__c || payProcessor.fw1__Use_Recurly_API__c){
            if (payment.fw1__Type__c != 'Charge'){
                errorMessage += 'Only Charge payment type is supported' + '\n';
                isValidData = false;
            }
        }
        // give warning message if Payment Processor is not "live"
        // Ensure that username, password, URL, Signature, etc are set
        if (payProcessor.fw1__Live__c == false) {
            if (payProcessor.fw1__Use_Paypal_API__c == true || payProcessor.fw1__Use_AuthorizeNet_API__c == true) {
                if (payProcessor.fw1__API_Test_User__c == null || payProcessor.fw1__API_Test_User__c == '' || 
                    payProcessor.fw1__API_Test_Password2__c == null || payProcessor.fw1__API_Test_Password2__c == '') {
                    errorMessage += 'Username/Password is not set. Please go to Payment Processors tab and check your settings.' + '\n';
                    isValidData = false;
                }
            }
            if (payProcessor.fw1__Use_URL__c == 'URL1' && (payProcessor.fw1__API_Test_URL1__c == null || payProcessor.fw1__API_Test_URL1__c == '')) {
                errorMessage += 'Endpoint URL is not set. Please go to Payment Processors tab and check your settings.' + '\n';
                isValidData = false;
            }
            if (payProcessor.fw1__Use_URL__c == 'URL2' && (payProcessor.fw1__API_Test_URL2__c == null || payProcessor.fw1__API_Test_URL2__c == '')) {
                errorMessage += 'Endpoint URL is not set. Please go to Payment Processors tab and check your settings.' + '\n';
                isValidData = false;
            }
            if (payProcessor.fw1__Use_Paypal_API__c == true) {
                if (payProcessor.fw1__API_Test_Signature2__c == null || payProcessor.fw1__API_Test_Signature2__c == '') {
                    errorMessage += 'Signature is not set. Please go to Payment Processors tab and check your settings.' + '\n';
                    isValidData = false;
                }
            }
            
            
        } else if (payProcessor.fw1__Live__c == true) {
            if (payProcessor.fw1__Use_Paypal_API__c == true || payProcessor.fw1__Use_AuthorizeNet_API__c == true) {
                if (payProcessor.fw1__API_Live_User__c == null || payProcessor.fw1__API_Live_User__c == '' || 
                    payProcessor.fw1__API_Live_Password2__c == null || payProcessor.fw1__API_Live_Password2__c == '') {
                     errorMessage += 'Username/Password is not set. Please go to Payment Processors tab and check your settings.' + '\n';
                    isValidData = false;
                }
            }
            if (payProcessor.fw1__Use_URL__c == 'URL1' && (payProcessor.fw1__API_Live_URL1__c == null || payProcessor.fw1__API_Live_URL1__c == '')) {
                 errorMessage += 'Endpoint URL is not set. Please go to Payment Processors tab and check your settings.' + '\n';
                isValidData = false;
            }
            if (payProcessor.fw1__Use_URL__c == 'URL2' && (payProcessor.fw1__API_Live_URL2__c == null || payProcessor.fw1__API_Live_URL2__c == '')) {
                 errorMessage += 'Endpoint URL is not set. Please go to Payment Processors tab and check your settings.' + '\n';
                isValidData = false;
            }
            if (payProcessor.fw1__Use_Paypal_API__c == true) {
                if (payProcessor.fw1__API_Live_Signature2__c == null || payProcessor.fw1__API_Live_Signature2__c == '') {
                     errorMessage += 'Signature is not set. Please go to Payment Processors tab and check your settings.' + '\n';
                    isValidData = false;
                }
            }
        }
        
    }
    if(!isValidData)
      AddNote(payment.fw1__Invoice__c,'Auto-BillPay Error',errorMessage);
      
    return isValidData;
  }
  
  // getInfo
    public static fw1__Payment_Processor__c getInfo(String paymentProcessor) {
        fw1__Payment_Processor__c processor;
        
        try {
            processor = [SELECT fw1__API_Test_User__c, fw1__API_Test_Password2__c, fw1__API_Test_Signature2__c, fw1__API_Test_URL1__c, fw1__API_Test_URL2__c,
                                fw1__API_Live_User__c, fw1__API_Live_Password2__c, fw1__API_Live_Signature2__c, fw1__API_Live_URL1__c, fw1__API_Live_URL2__c,
                                fw1__API_Version__c, fw1__Use_URL__c, fw1__Live__c,
                                fw1__Use_Paypal_API__c, fw1__Use_AuthorizeNet_API__c, fw1__Use_CyberSource_API__c, fw1__Use_Stripe_API__c,
                                fw1__Allow_Multi_Capture__c, fw1__Require_CVV2__c,
                                fw1__Test_Credit_Card_Number__c, fw1__Test_Amount__c,fw1__Use_Recurly_API__c,
                                fw1__Enable_eCheck__c
                           FROM fw1__Payment_Processor__c
                          WHERE Name = :paymentProcessor];
        }
        catch(Exception e) {
            System.debug('getInfo exception: ' + e);
        }
        
        return processor;
    }
  
   public static void AddNote(Id invoiceId, String noteTitle, String noteBody) {
        Note note = new Note();
        note.Title = noteTitle;
        note.Body = noteBody;
        note.ParentId = invoiceId;
        insert note;
        
       
       
    } 
  
  

}