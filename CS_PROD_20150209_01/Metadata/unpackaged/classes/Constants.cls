/* Constants class
*
* 5/03/2013 - Marc Lain (Bluewolf)
* Constants class used by other classes. 
*   
*/
public class Constants
{
    public static final String BROADCAST_ITEM_NO_CLIP_PACKAGE = 'No Clip Package';
    public static final String AccountID = 'AccountId';
    public static final String OpportunityName = 'Opportunity__c';    
    public static final String AccountContactTitle = 'Contact_Title__c';
    public static final String AccountBillingStreet = 'Account_Billing_Street__c';
    public static final String AccountBillingCity = 'Account_Billing_City__c';
    public static final String AccountBillingState = 'Account_Billing_State__c';
    public static final String AccountBillingZip = 'Account_Billing_Zip__c';    
    public static final String AccountBillingCountry = 'Account_Billing_Country__c';    
    public static final String CisionPointId = 'CisionPoint_ID__c'; 
    public static final String GpCustId = 'GP_Cust_ID__c';  
    public static final String AccountWebSite = 'Account_Website__c';
    public static final String AccountType = 'Account_Type__c';
	public static final String DcsQueue = 'DCS';
	public static final String SalesSupportQueue = 'Sales Support';
	public static final String NewBizQueue = 'New Biz';
	public static final String RenewalsQueue = 'Renewals';
	public static final String LeadGenerationQueue = 'Lead Generation';
	public static final String SalesGenerationQueue = 'Sales Generation';
	public static final String ContentMarketingNewBiz = 'Content Marketing New Biz';
	public static final String NewBizInternationalResponse = 'New Biz (International Response)';
	public static final String NewBizBroadcastResponse = 'New Biz (Broadcast Response)';
	public static final String RegionalLeadGen = 'Regional Lead Gen';
	public static final String BroadcastQueue = 'Broadcast';
	public static final String CaseOriginDcsButton = 'DCS Button';
	public static final String CampaignResponded = 'Responded';
	public static final String StatusNotStarted = 'Not Started';
	public static final String AnalysisQueue = 'Analysis';
	public static final String OtherQueue = 'Other';
	public static final String ObjectTask = 'Task';
	public static final String ObjectLead = 'Lead';
	
	public static final String RecordTypeLockedNewBiz = 'Locked New Biz';
	public static final String RecordTypeLockedRenewals = 'Locked Renewals';
	public static final String RecordTypeRenewals = 'Renewals';
	public static final String RecordTypeNewBiz = 'New Biz';
	public static final String RecordTypeBroadcast = 'Transactional Broadcast';
	public static final String RecordTypeLockedBroadcast = 'Locked Transactional Broadcast';
	
	public static final String RecordTypeNewQuote = 'New Quote';
	public static final String RecordTypeAfterApprovals = 'After Approvals';
	public static final String RecordTypeBeforeApprovals = 'Before Approvals';
	public static final String RecordTypePostSignature = 'Post Signature';
	public static final String RecordTypeClosed = 'Closed';
	public static final String RecordTypeAdmin = 'Admin';
	
	public static final String GroupNewBiz = 'New Biz';
	public static final String GroupLeadGen = 'Lead Gen';
	public static final String GroupRenewals = 'Renewals';
	public static final String GroupBroadcast = 'Broadcast';
	public static final String GroupContractAdmin = 'Contract Admin';
	public static final String GreaterThan150Mil = 'Greater than $150 Million';
	public static final String MoreThan1000 = 'More than 1,000';
	public static final String East = 'East';
	public static final String West = 'West';
	public static final String Bdm = 'BDM';
	public static final String Am = 'AM';
	public static final String CampaignResponseTaskType = 'Campaign Response';
	public static final String EloquaAdmin = 'Eloqua Admin';
	public static final String UnitedStateBillingCountryCode = 'USA';	//US for BillingCountryCode Picklist
	public static final String Customer = 'Customer';
	public static final String SfdcAdmin = 'SFDC Admin';
	public static final String CampaignHotLead = 'Sales Leads (1)';
	public static final String HotRating = 'Hot';
	public static final String WarmRating = 'Warm';
	public static final String LeadQualified = 'Qualified';
	public static final String LeadStatusCompleted = 'Completed';
	public static final String OppSalesStageContacted = 'Contacted';
	public static final String ContactRoleDecisionMaker = 'Decision Maker';
	public static final String OppTypeUpsell = 'Upsell';
	public static final String OppTypeNew = 'New';
	public static final String OppNewBizSourceInbound = 'Inbound Lead';
	public static final String BroadcastTransactionManager = 'Broadcast Transaction Manager';
	public static final String BroadcastTransactionSalesUser = 'Broadcast Transaction Sales User';
	public static final String NewBizManager = 'New Biz Manager';
	public static final String NewBizSalesUser = 'New Biz Sales User';
	public static final String RenewalsManager = 'Renewals Manager';
	public static final String RenewalsSalesUser = 'Renewals Sales User';
	public static final String OpportunityStageContacted = 'Contacted';
	public static final String OpportunityStageQualified = 'Qualified';
	public static final String OpportunityStageTrial = 'Trial';
	public static final String OpportunityStageNeedsAnalysis = 'Needs Analysis Completed';
	public static final String OpportunityStageDemo = 'Demo';
	public static final String OpportunityStageProposal = 'Proposal';
	public static final String OpportunityStageInNegotiation = 'In Negotiation';
	public static final String OpportunityStageAppPendingApproval = 'APP: Pending Approval';
	public static final String OpportunityStageAppApproved = 'APP: Approved';
	public static final String OpportunityStageClosedWon = 'Closed Won';
	public static final String OpportunityStageCaReview = 'CA: Review';
	public static final String OpportunityStageCaRejected = 'CA: Rejected';
	public static final String OpportunityStageClosedLost = 'Closed Lost';
	public static final String OpportunityStageVoided = 'Voided';
	public static final String OpportunityStageFinanceTaxExemptReview = 'Finance: Tax Exempt Review';
	public static final String OpportunityStageCustomerContractOpened = 'Cust: Contract Opened';
	public static final String OpportunityStageCustomerContractSent = 'Contract Sent';
	public static final String OpportunityStageCustomerContractSigned = 'Cust: Contract Signed';
	public static final String OpportunityStageCustomerContractRejected = 'Cust: Contract Rejected';
	
	public static final String QuoteStatusDraft = 'Draft';
	public static final String QuoteStatusInReview = 'In Review';
	public static final String QuoteStatusApproved = 'Approved';
	public static final String QuoteStatusRejected = 'Rejected';
	
	public static boolean IsProduction() { return ( UserInfo.getOrganizationId() == '00Dd0000000iEuwEAE' ); }
}