public with sharing class replaceProductController{
	
	public List<Pricebook2> pbList = new List<Pricebook2>();
	public Id selectedRenewalProduct {get;set;}
	public Id selectedRenewalPriceBook {get;set;}
	public Id currentProduct {get;set;}
	public string processMessage {get;set;}
	private ApexPages.standardController product2_sc = null;
    
    public replaceProductController(ApexPages.StandardController sc) {
        
       product2_sc = sc;
       Product2 p = (Product2) product2_sc.getRecord();
       currentProduct = p.Id;    
     }
      
	public List<SelectOption> PriceBookList
    {
        get
        {
            pbList = [Select Id,Name From Pricebook2 Where IsActive = true];
            
            PriceBookList = new List<SelectOption>();
            
            for(Pricebook2 pb : pbList)
            {
                PriceBookList.add(new SelectOption(pb.Id, pb.Name));
            }
            return PriceBookList;
        }
        set;
    }
	
	public PageReference save()
    {
    	Product2 p = (Product2) product2_sc.getRecord();
	    selectedRenewalProduct = p.SBQQ__RenewalProduct__c;
      
        processMessage = 'Product replacement is in process....';
        //process the product replacement...
        batchReplacementProduct rpbatch = new batchReplacementProduct(currentProduct, selectedRenewalProduct, selectedRenewalPriceBook);
	    Database.executeBatch(rpbatch,10);
        
        return null;
    }

}