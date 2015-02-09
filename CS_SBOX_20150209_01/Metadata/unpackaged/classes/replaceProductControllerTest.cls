@isTest
private class replaceProductControllerTest {
  static testMethod void replaceProductControllerTest() {
    
        Product2 currProduct = TestLibrary.createProduct('Test Product', 'CUR', 'Connect Services');
        insert currProduct;
        PricebookEntry standardPrice= new PricebookEntry (Product2Id = currProduct.id,unitprice=200,Pricebook2Id = Test.getStandardPricebookId(),UseStandardPrice=false,isActive=true);
        insert standardPrice;       
        
        PageReference pageRef = ApexPages.currentPage();
        Apexpages.StandardController stdController = new Apexpages.StandardController(currProduct); 
        replaceProductController rpc = new replaceProductController(stdController);
        
        List<SelectOption> pbook2 = rpc.PriceBookList;
        rpc.save();

        Test.setCurrentPageReference(pageRef);   
     
  }

}