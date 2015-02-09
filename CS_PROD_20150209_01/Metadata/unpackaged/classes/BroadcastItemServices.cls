/* BroadcastItemServices class
*
* 5/02/2013 - Marc Lain (Bluewolf)
* Services class for the BroadcastItem object. 
*   
*/



public with sharing class BroadcastItemServices 
{
	
	public static void addTotalFees(List<Broadcast_Item__c> broadcastItems)
	{
		//Add fees to Total Fees. 
		//Reproduce formula field below when BroadcastItem inserted/updated
		
		
		//Total_Fees__c =
		//	Total_Removable_Fees__c + 
		//	Total_Non_Removable_Fees__c+ 
		//	IF( Exclude_Outside_Market_Fee__c = False,Outside_Market_Fee_26_50__c,0) + 
		//	IF( Exclude_Outside_Market_Fee__c = False,Outside_Market_Fee_51_100__c,0) + 
		//	IF(Exclude_Outside_Market_Fee__c = False,Outside_Market_Fee_100_150__c,0) + 
		//	IF(Exclude_Outside_Market_Fee__c = False,Outside_Market_Fee_150__c,0)+ 
		//	IF( Exclude_Add_l_10_Min_Fee__c = False, Add_l_10_minutes__c, 0 ) + 
		//	Misc_Fee__c
		

		for(Broadcast_Item__c bi : broadcastItems)
		{	
			bi.Total_Fees__c = 0;
			
			//Make sure Misc_Fee__c is not null
			if(bi.Misc_Fee__c == null)
			{
				bi.Misc_Fee__c = 0;
			}
				
			bi.Total_Fees__c = 	bi.Total_Removable_Fees__c + 
								bi.Total_Non_Removable_Fees__c + 
								bi.Misc_Fee__c;
			
			if(!bi.Exclude_Outside_Market_Fee__c)
			{
				//add Outside Market Fees
				bi.Total_Fees__c += bi.Outside_Market_Fee_26_50__c +
														bi.Outside_Market_Fee_51_100__c +
														bi.Outside_Market_Fee_100_150__c + 
														bi.Outside_Market_Fee_150__c;
			}
			
			
			if(!bi.Exclude_Add_l_10_Min_Fee__c && bi.Add_l_10_minutes__c != null)
			{
				//add Add'l 10 Min Fee
				bi.Total_Fees__c += bi.Add_l_10_minutes__c;
			}
		}
		
	}
	
	public static void calculatePrice(List<Broadcast_Item__c> broadcastItems)
	{
		//List<Broadcast_Item__c> bItems = queryParentFields(broadcastItems);
		
		for(Broadcast_Item__c bi : broadcastItems)
		{
			bi.Price__c = 0;
						
			//If Redo_Item__c is equal to Yes, then zero out entire price.
			//If No, then do the calculations
			if(bi.Redo_Item__c == 'No')
			{
				bi.Price__c = bi.Total_Fees__c;
				
				//If the user selects anything other than “No Clip Package” on the Clip_Package__c,
				//then do not add Total_Price_Before_Fees__c
				if(bi.Zero_Clip_Package_Selected__c == 'Yes')
				{	
					bi.Price__c = bi.Price__c + bi.Total_Price_Before_Fees__c;
				}
				
				/*
				//If How_many_Clip_Packages_to_pay_for_Fees__c is greater than 0, the zero out Total_Fees__c.
				if(bi.How_many_Clip_Packages_to_pay_for_Fees__c == null || bi.How_many_Clip_Packages_to_pay_for_Fees__c == 0)
				{
					bi.Price__c = bi.Price__c + bi.Total_Fees__c;

				}	
				
				
				//Apply discounts
				if(bi.Account_Level_Discount__c != null)
				{
					bi.Price__c = bi.Price__c - (bi.Price__c * (bi.Account_Level_Discount__c/100));
				}
								
				if(bi.Discount__c != null)
				{
					bi.Price__c = bi.Price__c - bi.Discount__c;
				}
				*/
				
				
			}
			else
			{
				bi.Price__c = 0;
			}
			
			//Make sure Discount__c is not null
			if(bi.Discount__c == null)
			{
				bi.Discount__c = 0;
			}
			
			//Update Total Sale
			bi.Total_Sale__c = bi.Price__c - ( bi.Price__c * (bi.Account_Level_Discount__c/100) + bi.Discount__c);
		}
	}
	
	/*
	public static List<Broadcast_Item__c> queryParentFields(List<Broadcast_Item__c> broadcastItems)
	{
		Set<ID> bItemIDs = new Set<ID>();

		for(Broadcast_Item__c bi : broadcastItems)
		{
			bItemIDs.add(bi.Id);
		}
		
		List<Broadcast_Item__c> bItems = [Select Id, 
												Opportunity__r.Redo_Item_s__c,
												Clip_Package__r.No_Clip_Package__c,
												How_many_Clip_Packages_to_pay_for_Fees__c,
												Total_Fees__c,
												Total_Price_Before_Fees__c,
												Price__c
											From Broadcast_Item__c
											Where Id IN : bItemIDs];
											
		return bItems;	
	}
	*/
	
	/*
	public static void getTotalPriceBeforeFees(List<Broadcast_Item__c> broadcastItems)
	{
		
		//Total_Price_Before_Fees__c =
		//	Market_Adjustment__c + Price_Before_Fees__c

		for(Broadcast_Item__c bi : broadcastItems)
		{	
			bi.Total_Fees__c = 0;
			
			bi.Total_Price_Before_Fees__c = bi.Market_Adjustment__c + 
											bi.Price_Before_Fees__c;
		}
		
	}
	*/
	
}