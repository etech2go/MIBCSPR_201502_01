@isTest (seeAllData = true) 
public with sharing class TestBroadcastItemServices 
{
	
    static testMethod void testAddTotalFees()
    {
        Broadcast_Item__c bItem = TestingUtils.createBroadcastItem(true);       
        bItem.TRT__c = '01:00:00'; //Add'l 10 min: DVD Clip = $125
        bItem.Special_Record_Set_Up__c = 10; //Special Record Set Up = $10
        bItem.Search_Fee__c = 15; //Search Fee = $15
        bItem.Creative_Services_Hours_Booked__c = 1; //Creative Services Fee = $150
        bItem.US_Markets__c = 'AO: San Angelo. TX [197]'; //Outside Market Fee 150+ = $100 
        bItem.US_Stations__c = 'KIDY';
        update bItem;
        
        bItem = [Select Id, Add_l_10_minutes__c,
        				Add_l_10_min_DVD_Clip__c,
        				Special_Record_Set_Up__c,
        				Search_Fee__c,
        				Creative_Services_Fee__c, 
        				Total_Fees__c,
        				Total_Removable_Fees__c,
        				Total_Non_Removable_Fees__c,
        				Outside_Market_Fee_26_50__c,
        				Outside_Market_Fee_51_100__c,
        				Outside_Market_Fee_100_150__c,
        				Outside_Market_Fee_150__c,
        				Misc_Fee__c 
                From Broadcast_Item__c 
                Where Id = :bItem.Id];
        
        //125 + 10 + 15 + 150 + 100 = 400       
        //System.assertEquals(bItem.Add_l_10_min_DVD_Clip__c + bItem.Special_Record_Set_Up__c + bItem.Search_Fee__c + bItem.Creative_Services_Fee__c + bItem.Outside_Market_Fee_150__c , bItem.Total_Fees__c);
        
        System.debug('Additional Min Fee : ' + bItem.Add_l_10_minutes__c);
        System.debug('Total Fees : ' + bItem.Total_Fees__c);
        
        
        //Setting this checkbox to true excludes Outside Market Fee 150+
        //from the Total Fee calculation
        bItem.Exclude_Outside_Market_Fee__c = true;
        update bItem;
        
        bItem = [Select Id, Add_l_10_minutes__c,
        				Add_l_10_min_DVD_Clip__c,
        				Special_Record_Set_Up__c,
        				Search_Fee__c,
        				Creative_Services_Fee__c, 
        				Total_Fees__c,
        				Total_Removable_Fees__c,
        				Total_Non_Removable_Fees__c,
        				Outside_Market_Fee_26_50__c,
        				Outside_Market_Fee_51_100__c,
        				Outside_Market_Fee_100_150__c,
        				Outside_Market_Fee_150__c,
        				Misc_Fee__c 
                From Broadcast_Item__c 
                Where Id = :bItem.Id];
        
        //125 + 10 + 15 + 150 + 0 = 300
        //System.assertEquals(bItem.Add_l_10_min_DVD_Clip__c + bItem.Special_Record_Set_Up__c + bItem.Search_Fee__c + bItem.Creative_Services_Fee__c , bItem.Total_Fees__c);
        
        System.debug('Additional Min Fee : ' + bItem.Add_l_10_minutes__c);
        System.debug('Total Fees : ' + bItem.Total_Fees__c);
        
        //Setting this checkbox to true excludes Add'l 10 min: DVD Clip
        //from the Total Fee calculation
        bItem.Exclude_Add_l_10_Min_Fee__c = true;
        update bItem;
        
        bItem = [Select Id, Add_l_10_minutes__c,
        				Add_l_10_min_DVD_Clip__c,
        				Special_Record_Set_Up__c,
        				Search_Fee__c,
        				Creative_Services_Fee__c, 
        				Total_Fees__c,
        				Total_Removable_Fees__c,
        				Total_Non_Removable_Fees__c,
        				Outside_Market_Fee_26_50__c,
        				Outside_Market_Fee_51_100__c,
        				Outside_Market_Fee_100_150__c,
        				Outside_Market_Fee_150__c,
        				Misc_Fee__c 
                From Broadcast_Item__c 
                Where Id = :bItem.Id];
        
        //0 + 10 + 15 + 150 + 0 = 175
        //System.assertEquals(bItem.Special_Record_Set_Up__c + bItem.Search_Fee__c + bItem.Creative_Services_Fee__c , bItem.Total_Fees__c);
        
        System.debug('Additional Min Fee : ' + bItem.Add_l_10_minutes__c);
        System.debug('Total Fees : ' + bItem.Total_Fees__c);
    }
    
    
    static testMethod void testCalculatePrice()
    {
    	Account acc = new Account();
    	acc.Name = 'Test';
	    acc.BillingStreet = '123 Main St';
		acc.BillingCity = 'Chicago';
		acc.BillingState = 'IL';
		acc.BillingPostalCode = '60603';
    	acc.BillingCountry = 'USA';
	   	insert acc;
	   	
	   	
	   	Opportunity opp = TestingUtils.createOpportunity(acc.Id);
    	opp.Invoice_Contact_Name__c = 'John';
    	opp.Invoice_Contact_Email__c = 'john@email.com';
    	opp.Redo_Item_s__c = false;
    	insert opp;
    	
    	
    	/*
    	Opportunity opp = [Select Id, Name, AccountId, Redo_Item_s__c From Opportunity Where Id = '006K0000006cH5i'];
    	opp.Redo_Item_s__c = false;
    	update opp;
    	*/
    	
    	
    	Prepaid_Clip_Package__c cp = TestingUtils.createClipPackage(opp.AccountId, TestingUtils.ADMIN_USER.Id, 'DVD Clip', false );
    	cp.No_Clip_Package__c = true;
    	insert cp;
    	
        Broadcast_Item__c bItem = TestingUtils.createBroadcastItem(opp.Id, cp.Id, false);
        bItem.Special_Record_Set_Up__c = 10; //Special Record Set Up = $10
        bItem.How_many_Clip_Packages_to_pay_for_Fees__c = 0;
        insert bItem;
        
        bItem = [Select Id,
        				Opportunity__r.Redo_Item_s__c,
        				Clip_Package__r.No_Clip_Package__c,
        				Zero_Clip_Package_Selected__c,
        				Redo_Item__c,
        				How_many_Clip_Packages_to_pay_for_Fees__c,
        				Total_Fees__c,
        				Total_Price_Before_Fees__c,
        				Price__c
                From Broadcast_Item__c 
                Where Id = :bItem.Id];
        
        //Total Fees = $10
        //Total Price Before Fees = $165
        //Price = 165 + 10 = $175
        
        System.debug('1) Total Fees : ' + bItem.Total_Fees__c);
        System.debug('1) Total Price Before Fees : ' + bItem.Total_Price_Before_Fees__c);
        System.debug('1) Zero Clip Package Selected : ' + bItem.Zero_Clip_Package_Selected__c);
        System.debug('1) Redo Item : ' + bItem.Redo_Item__c);
        System.debug('1) Opportunity Redo Item : ' + bItem.Opportunity__r.Redo_Item_s__c);
        System.debug('1) No Clip Package : ' + bItem.Clip_Package__r.No_Clip_Package__c);
        System.debug('1) How Many Clip_Packages to Pay for Fees : ' + bItem.How_many_Clip_Packages_to_pay_for_Fees__c);
        System.debug('1) Price : ' + bItem.Price__c);
        
        //System.assertEquals(bItem.Total_Price_Before_Fees__c + bItem.Total_Fees__c, bItem.Price__c);
     
        
        
        //Setting Clip_Package__r.No_Clip_Package__c to FALSE will give Price = Total Fees
        cp.No_Clip_Package__c = false;
        update cp;
        
        bItem.Special_Record_Set_Up__c = 10; //Special Record Set Up = $10
        update bItem;
        
        bItem = [Select Id,
        				Opportunity__r.Redo_Item_s__c,
        				Clip_Package__r.No_Clip_Package__c,
        				Zero_Clip_Package_Selected__c,
        				Redo_Item__c,
        				How_many_Clip_Packages_to_pay_for_Fees__c,
        				Total_Fees__c,
        				Total_Price_Before_Fees__c,
        				Price__c
                From Broadcast_Item__c 
                Where Id = :bItem.Id];
        
        //Total Fees = $135
        //Total Price Before Fees = $165
        //Price = $135
        
        System.debug('2) Total Fees : ' + bItem.Total_Fees__c);
        System.debug('2) Total Price Before Fees : ' + bItem.Total_Price_Before_Fees__c);
        System.debug('2) Zero Clip Package Selected : ' + bItem.Zero_Clip_Package_Selected__c);
        System.debug('2) Redo Item : ' + bItem.Redo_Item__c);
        System.debug('2) Opportunity Redo Item : ' + bItem.Opportunity__r.Redo_Item_s__c);
        System.debug('2) No Clip Package : ' + bItem.Clip_Package__r.No_Clip_Package__c);
        System.debug('2) How Many Clip_Packages to Pay for Fees : ' + bItem.How_many_Clip_Packages_to_pay_for_Fees__c);
        System.debug('2) Price : ' + bItem.Price__c);
        
        //System.assertEquals(bItem.Total_Fees__c, bItem.Price__c);
        
        
        
        //Setting Opportunity__r.Redo_Item_s__c to TRUE will give Price = 0
        opp.Redo_Item_s__c = true;
        opp.Redo_Reasons__c = 'Cision error - AE';
        update opp;
        
        //bItem.Special_Record_Set_Up__c = 20; //Special Record Set Up = $20
       	//update bItem;
        
        bItem = [Select Id,
        				Opportunity__r.Redo_Item_s__c,
        				Clip_Package__r.No_Clip_Package__c,
        				Zero_Clip_Package_Selected__c,
        				Redo_Item__c,
        				How_many_Clip_Packages_to_pay_for_Fees__c,
        				Total_Fees__c,
        				Total_Price_Before_Fees__c,
        				Price__c
                From Broadcast_Item__c 
                Where Id = :bItem.Id];
        
        //Total Fees = $10
        //Total Price Before Fees = $165
        //Price = $0
        
        System.debug('3) Total Fees : ' + bItem.Total_Fees__c);
        System.debug('3) Total Price Before Fees : ' + bItem.Total_Price_Before_Fees__c);
        System.debug('3) Zero Clip Package Selected : ' + bItem.Zero_Clip_Package_Selected__c);
        System.debug('3) Redo Item : ' + bItem.Redo_Item__c);
        System.debug('3) Opportunity Redo Item : ' + bItem.Opportunity__r.Redo_Item_s__c);
        System.debug('3) No Clip Package : ' + bItem.Clip_Package__r.No_Clip_Package__c);
        System.debug('3) How Many Clip_Packages to Pay for Fees : ' + bItem.How_many_Clip_Packages_to_pay_for_Fees__c);
        System.debug('3) Price : ' + bItem.Price__c);
        
        //System.assertEquals(0, bItem.Price__c);
        
        
        
        //Setting Opportunity__r.Redo_Item_s__c to FALSE will calculate Price
        opp.Redo_Item_s__c = false;
        update opp;
        
        //Setting Clip_Package__r.No_Clip_Package__c to TRUE 
        //will give Price = Total Fees + Total Price Before Fees
        cp.No_Clip_Package__c = true;
        update cp;
        
        //bItem.Special_Record_Set_Up__c = 20; //Special Record Set Up = $20
       	//update bItem;
        
        bItem = [Select Id,
        				Opportunity__r.Redo_Item_s__c,
        				Clip_Package__r.No_Clip_Package__c,
        				Zero_Clip_Package_Selected__c,
        				Redo_Item__c,
        				How_many_Clip_Packages_to_pay_for_Fees__c,
        				Total_Fees__c,
        				Total_Price_Before_Fees__c,
        				Price__c
                From Broadcast_Item__c 
                Where Id = :bItem.Id];
        
        //Total Fees = $10
        //Total Price Before Fees = $165
        //Price = $0
        
        System.debug('4) Total Fees : ' + bItem.Total_Fees__c);
        System.debug('4) Total Price Before Fees : ' + bItem.Total_Price_Before_Fees__c);
        System.debug('4) Zero Clip Package Selected : ' + bItem.Zero_Clip_Package_Selected__c);
        System.debug('4) Redo Item : ' + bItem.Redo_Item__c);
        System.debug('4) Opportunity Redo Item : ' + bItem.Opportunity__r.Redo_Item_s__c);
        System.debug('4) No Clip Package : ' + bItem.Clip_Package__r.No_Clip_Package__c);
        System.debug('4) How Many Clip_Packages to Pay for Fees : ' + bItem.How_many_Clip_Packages_to_pay_for_Fees__c);
        System.debug('4) Price : ' + bItem.Price__c);
        
        //System.assertEquals(bItem.Total_Price_Before_Fees__c + bItem.Total_Fees__c, bItem.Price__c);
        
        
        /*
        
        //Update Discount
        bItem.Discount__c = 10;
        update bItem;
        
        bItem = [Select Id,
        				Opportunity__r.Redo_Item_s__c,
        				Clip_Package__r.No_Clip_Package__c,
        				Zero_Clip_Package_Selected__c,
        				Redo_Item__c,
        				How_many_Clip_Packages_to_pay_for_Fees__c,
        				Discount__c,
        				Total_Fees__c,
        				Total_Price_Before_Fees__c,
        				Price__c
                From Broadcast_Item__c 
                Where Id = :bItem.Id];

        System.assertEquals(bItem.Total_Price_Before_Fees__c + bItem.Total_Fees__c - bItem.Discount__c, bItem.Price__c);
        
        
        
        bItem.Discount__c = 0;
        update bItem;
        
        bItem = [Select Id,
        				Opportunity__r.Redo_Item_s__c,
        				Clip_Package__r.No_Clip_Package__c,
        				Zero_Clip_Package_Selected__c,
        				Redo_Item__c,
        				How_many_Clip_Packages_to_pay_for_Fees__c,
        				Discount__c,
        				Account_Level_Discount__c,
        				Total_Fees__c,
        				Total_Price_Before_Fees__c,
        				Price__c
                From Broadcast_Item__c 
                Where Id = :bItem.Id];

        System.assertEquals((bItem.Total_Price_Before_Fees__c + bItem.Total_Fees__c)*(1-(bItem.Account_Level_Discount__c/100)), bItem.Price__c);
        
        */
    }
        
}