public with sharing class PaymentReceiptPDFCntroller {
  private string m_InvoiceId;
  public String InvoiceId {
    get{ return m_InvoiceId;} 
    set{ 
      m_InvoiceId = value;
      setInvoice();
      setInvoiceLine();
    }
  }
  
  public fw1__Invoice__c Invoice {get;set;}
  public List<fw1__Invoice_Line__c> InvoiceLines {get;set;}
  
  private void setInvoice(){
    Invoice = new fw1__Invoice__c();
    Invoice = [SELECT 
                    fw1__Total_Paid_Amount__c,
                    fw1__Total_Lines_Discount_Quantity__c, 
                    fw1__Total_Lines_Discount_Percentage__c, 
                    fw1__Total_Lines_Discount_Amount__c, 
                    fw1__Total_Lines_Amount__c, 
                    fw1__Total_Invoice_Discount_Amount__c, 
                    fw1__Total_Invoice_Amount__c, 
                    fw1__Net_Amount__c, 
                    fw1__Invoice_Discount_Percentage__c, 
                    fw1__Invoice_Discount_Amount__c, 
                    fw1__Invoice_Date__c, 
                    fw1__Email_Currency_Symbol__c, 
                    fw1__Due_Date__c, 
                    fw1__Balance_Due__c,
                    fw1__Tax__c,
                    fw1__Shipping_And_Handling__c,
                    fw1__Authorized_Amount__c,
                    fw1__Required_Down_Payment__c,
                    fw1__Required_Down_Payment_Amount__c,
                    Name
                  FROM fw1__Invoice__c WHERE Id = :InvoiceId]; 
  }
  
  private void setInvoiceLine(){
    InvoiceLines = new List<fw1__Invoice_Line__c>();
    InvoiceLines = [SELECT 
                         fw1__Unit_Price__c, 
                         fw1__Total_Discount_Amount__c, 
                         fw1__Taxable__c, 
                         fw1__Sales_Tax__c, 
                         fw1__Sales_Tax_Rate__c, 
                         fw1__Recurring_Invoice_Line__c, 
                         fw1__Quantity__c, 
                         fw1__Paid_Amount__c, 
                         fw1__Net_Amount__c, 
                         fw1__Item_Description__c, 
                         fw1__Invoice__c, 
                         fw1__Discount_Quantity__c, 
                         fw1__Discount_Percentage__c, 
                         fw1__Discount_Amount__c, 
                         fw1__Amount__c,  
                         Name, Id,
                         Air_Date__c,
                         Air_Time__c,
                         Market_and_Station__c,
                         Program_Title__c
                         FROM fw1__Invoice_Line__c 
                        WHERE fw1__Invoice__c = :InvoiceId];
    
  }
  
  public boolean getDisplayRequiredDownPayment(){
    if (Invoice.fw1__Required_Down_Payment__c == null)
     Invoice.fw1__Required_Down_Payment__c = 0;
     
    return ((Invoice.fw1__Total_Paid_Amount__c < 
    (Invoice.fw1__Total_Invoice_Amount__c * (Invoice.fw1__Required_Down_Payment__c / 100)))) && 
    (Invoice.fw1__Required_Down_Payment_Amount__c == null && Invoice.fw1__Required_Down_Payment__c > 0);
  }
  
  public boolean getDisplayDownPaymentAmount(){
    if (Invoice.fw1__Required_Down_Payment_Amount__c == null)
     Invoice.fw1__Required_Down_Payment_Amount__c = 0;
    return (Invoice.fw1__Total_Paid_Amount__c < Invoice.fw1__Required_Down_Payment_Amount__c) && (Invoice.fw1__Required_Down_Payment_Amount__c > 0);
  }
  
  public boolean getDisplaySubTotal(){
    return(Invoice.fw1__Invoice_Discount_Amount__c != 0 && Invoice.fw1__Invoice_Discount_Amount__c != null ||
           Invoice.fw1__Invoice_Discount_Percentage__c != 0 && Invoice.fw1__Invoice_Discount_Percentage__c != null ||
           Invoice.fw1__Tax__c != 0 && Invoice.fw1__Tax__c != null ||
           Invoice.fw1__Shipping_And_Handling__c != 0 && Invoice.fw1__Shipping_And_Handling__c != null);
  }
  
  
  @isTest    
  public static void testDoPayment(){
    PaymentReceiptPDFCntroller p = new PaymentReceiptPDFCntroller();
    /*
    Account a = new Account();
    a.Name = 'Test Account';
    a.BillingStreet = '123 oak st';
    a.BillingCity = 'torrance';
    a.BillingPostalCode = '90501';
    a.BillingCountry = 'USA';
    insert a;
    
    fw1__Invoice__c inv = new fw1__Invoice__c();
    inv.fw1__Account__c = a.Id;
    inv.fw1__Invoice_Date__c = Date.today();
    insert inv;
    
    p.InvoiceId = inv.id; 
    
    Boolean b;
    b = p.getDisplayRequiredDownPayment();
    b = p.getDisplayDownPaymentAmount();
    b = p.getDisplaySubTotal();
    */
  }
  
}