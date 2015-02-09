<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_AE_when_Payment_is_unsuccessful</fullName>
        <description>Email AE when Payment is unsuccessful</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_AE_when_Payment_is_unsuccessful</template>
    </alerts>
    <alerts>
        <fullName>Email_AE_when_Routed_Back_to_AE</fullName>
        <description>Email AE when Routed Back to AE</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_AE_when_Routed_Back_to_AE</template>
    </alerts>
    <alerts>
        <fullName>Email_Billing_to_finish_Tax_Exempt_setup</fullName>
        <description>Email Billing to finish Tax Exempt setup</description>
        <protected>false</protected>
        <recipients>
            <recipient>lisa.murer@cision.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_Billing_to_finish_Tax_Exempt</template>
    </alerts>
    <alerts>
        <fullName>Email_Renewal_Rep_when_Lost_Renewal</fullName>
        <description>Email Renewal Rep when Lost Renewal</description>
        <protected>false</protected>
        <recipients>
            <recipient>lisa.murer@cision.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_Renewal_Rep_when_Lost_Renewal</template>
    </alerts>
    <alerts>
        <fullName>Email_Sales_Rep_when_Customer_opens_Contract</fullName>
        <description>Email Sales Rep when Customer opens Contract</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Cision_Workflow_Templates/Email_Sales_Rep_when_Customer_Opens_Contract</template>
    </alerts>
    <alerts>
        <fullName>Email_Sales_Rep_when_Customer_rejects_Contract</fullName>
        <description>Email Sales Rep when Customer rejects Contract</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_Sales_Rep_when_Customer_Rejects_Contract</template>
    </alerts>
    <alerts>
        <fullName>Email_Sales_Rep_when_Customer_signs_Contract</fullName>
        <description>Email Sales Rep when Customer signs Contract</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_Sales_Rep_when_Customer_Signs_Contract</template>
    </alerts>
    <alerts>
        <fullName>Email_Sales_and_CA_Rep_when_Opportunity_submitted_to_Softrax</fullName>
        <description>Email Sales and CA Rep when Opportunity submitted to Softrax (add CA Rep and opp owner)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>CA_Rep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Opportunity_Processed_Notification</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_has_exceeded_Due_Date</fullName>
        <description>Email Route To Office when Opportunity has exceeded Due Date</description>
        <protected>false</protected>
        <recipients>
            <field>Route_To_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Opportunity_has_exceeded_Due_Date</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_sitting_in_Traffic</fullName>
        <ccEmails>BroadcastProductionManagers.us@cision.com</ccEmails>
        <description>Email Route To Office when Opportunity sitting in Traffic</description>
        <protected>false</protected>
        <recipients>
            <field>Route_To_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Opportunity_has_been_sitting_in_Traffic_s_view</template>
    </alerts>
    <alerts>
        <fullName>Routed_to_DNR</fullName>
        <ccEmails>digitalcontent.support@cision.com</ccEmails>
        <description>Email Digital Content Support when Opportunity is Routed to DNR</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_Broadcast_Monitoring_when_Routed_to_DNR</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_to_Analysis_Services_about_a_new_Order</fullName>
        <description>Send an email to Analysis Services about a new Order</description>
        <protected>false</protected>
        <recipients>
            <recipient>lisa.murer@cision.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Analysis_Services_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_to_Billing_about_Tax_Exempt</fullName>
        <description>Send an email to Billing about Tax Exempt</description>
        <protected>false</protected>
        <recipients>
            <recipient>uscabilling.us@cision.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_Billing_for_Tax_Review</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_to_Managed_Services_about_a_new_Order</fullName>
        <description>Send an email to Managed Services about a new Order</description>
        <protected>false</protected>
        <recipients>
            <recipient>lisa.murer@cision.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Managed_Services_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_to_the_new_Renewal_Opportunity_owner</fullName>
        <description>Send an email to the new Renewal Opportunity owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Renewal_Rep_New_Opportunity_Notification</template>
    </alerts>
    <alerts>
        <fullName>Unrouted_Opportunity_Check</fullName>
        <description>Email AE Unrouted Opportunity Check</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Opportunity_has_not_been_routed_to_Traffic</template>
    </alerts>
    <fieldUpdates>
        <fullName>CA_Reviewed_Temp</fullName>
        <field>StageName</field>
        <literalValue>CA: Review</literalValue>
        <name>CA Reviewed (Temp)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Fulfillment_Status</fullName>
        <field>Fulfillment_Status__c</field>
        <literalValue>Order Revised</literalValue>
        <name>Change Fulfillment Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Date</fullName>
        <field>CloseDate</field>
        <formula>NOW()</formula>
        <name>Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Sent_Date</fullName>
        <field>Contract_Sent_Date__c</field>
        <formula>NOW()</formula>
        <name>Contract Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Campaign_Type</fullName>
        <field>Campaign_Type__c</field>
        <formula>TEXT(Campaign.Type)</formula>
        <name>Copy Campaign_Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fix_US_and_CAN</fullName>
        <description>Need to update this!</description>
        <field>Shipping_Country__c</field>
        <formula>CASE(Shipping_Country__c, &apos;U.S.A.&apos;, &apos;United States&apos;, &apos;USA&apos;, &apos;United States&apos;, &apos;US&apos;, &apos;United States&apos;, &apos;CAN&apos;, &apos;Canada&apos;, &apos;CA&apos;, &apos;Canada&apos;, Shipping_Country__c)</formula>
        <name>Fix US and CAN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Gone_Silent</fullName>
        <field>Gone_Silent__c</field>
        <literalValue>1</literalValue>
        <name>Gone Silent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Gone_Silent_Date</fullName>
        <field>Gone_Silent_Date__c</field>
        <formula>NOW()</formula>
        <name>Gone Silent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Locked_Opp</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Locked_Transactional_Broadcast</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Locked Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Name</fullName>
        <field>Name</field>
        <formula>TEXT(MONTH(CloseDate)) &amp; &quot;/&quot;
&amp; TEXT(DAY(CloseDate)) &amp; &quot;/&quot;
&amp; TEXT(YEAR(CloseDate)) &amp; &quot; Renewal&quot;</formula>
        <name>Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Biz_Opp_Record_Type_Correction</fullName>
        <field>RecordTypeId</field>
        <lookupValue>New_Biz</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>New Biz Opp Record Type Correction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Number_to_Opp_Name</fullName>
        <field>Name</field>
        <formula>IF(AND(Search_Request__c = TRUE, ISPICKVAL(Search_Request_Status__c,&quot;&quot;)), &quot;SR&quot; + MID(Opportunity_Number__c, 3, 8),IF(Redo_Item_s__c = TRUE, &quot;RD&quot; + MID(Opportunity_Number__c, 3, 8), Opportunity_Number__c))</formula>
        <name>Opp Number to Opp Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Changed_Hands</fullName>
        <field>Opportunity_Changed_Hands_Date__c</field>
        <formula>TODAY()</formula>
        <name>Opportunity Changed Hands</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Created_Date_Time</fullName>
        <field>Created_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Opportunity Created Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Status</fullName>
        <field>Opportunity_Status__c</field>
        <literalValue>Pending Fulfillment</literalValue>
        <name>Opportunity Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Status_Pending_Invoicing</fullName>
        <field>Opportunity_Status__c</field>
        <literalValue>Pending Invoicing</literalValue>
        <name>Opportunity Status: Pending Invoicing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Update_Record_Type_to_R</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Renewals</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Opportunity - Update Record Type to R</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Update_Stage_to_Approved</fullName>
        <field>StageName</field>
        <literalValue>APP: Approved</literalValue>
        <name>Opportunity - Update Stage to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_B_to_S_City</fullName>
        <field>Shipping_City__c</field>
        <formula>Billing_City__c</formula>
        <name>Oppty: B to S City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_B_to_S_Country</fullName>
        <field>Shipping_Country__c</field>
        <formula>Billing_Country__c</formula>
        <name>Oppty: B to S Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_B_to_S_State</fullName>
        <field>Shipping_State__c</field>
        <formula>Billing_State__c</formula>
        <name>Oppty: B to S State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_B_to_S_Street</fullName>
        <field>Shipping_Street__c</field>
        <formula>Billing_Street__c</formula>
        <name>Oppty: B to S Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_B_to_S_Zip</fullName>
        <field>Shipping_Zip__c</field>
        <formula>Billing_Zip__c</formula>
        <name>Oppty: B to S Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Renewals</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewal_Date</fullName>
        <field>Renewal_Due_Date__c</field>
        <formula>CloseDate</formula>
        <name>Renewal Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewal_Type</fullName>
        <field>Renewal_Type__c</field>
        <literalValue>Renewal</literalValue>
        <name>Renewal Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewals_Opp_Record_Type_Correction</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Renewals</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Renewals Opp Record Type Correction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Route_To_Email</fullName>
        <field>Route_To_Email__c</field>
        <formula>Case( Route_To__c , 
&quot;**CH**&quot; , &quot;BroadcastProduction-CH.us@cision.com&quot;, 
&quot;**LA**&quot; , &quot;BroadcastProduction-LA.us@cision.com&quot;, 
&quot;**NY**&quot; , &quot;BroadcastProduction-NY.us@cision.com&quot;, 
&quot;**SF**&quot; , &quot;BroadcastProduction-SF.us@cision.com&quot;, 
&quot;*Trans*&quot; , &quot;Transcriptionists.us@cision.com&quot;, 
&quot;Creat Svcs&quot; , &quot;CreativeServices.us@cision.com&quot;, 
&quot;DNR&quot; , &quot;digitalcontent.support@cision.com&quot;, 
&quot;Med Rel&quot; , &quot;MR.us@cision.com&quot;, 
&quot;Reports&quot; , &quot;ReportsServices.us@cision.com&quot;, 
&quot;Reports Trial&quot; , &quot;Stephenie.Wilson@cision.com&quot;, 
&quot;Traffic&quot;, &quot;Traffic.us@cision.com&quot;, 
&quot;WOP - SR&quot;, &quot;Traffic.us@cision.com&quot;, 
&quot;Self Service&quot;, &quot;Traffic.us@cision.com&quot;, 
&quot;Pending Orders&quot; , &quot;Traffic.us@cision.com&quot;, 
&quot;NULL&quot;, &quot;&quot;, 
&quot;&quot;)</formula>
        <name>Route To Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Closed_Won_Date_Time</fullName>
        <field>Closed_Won_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Closed Won Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Fulfillment_Date</fullName>
        <field>Fulfillment_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Fulfillment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Fulfillment_Status_to_Rush</fullName>
        <field>Fulfillment_Status__c</field>
        <literalValue>R*U*S*H</literalValue>
        <name>Set Fulfillment Status to Rush</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_New_Biz_Engagement_Date</fullName>
        <field>New_Biz_Engagement_Date__c</field>
        <formula>Renewal_Due_Date__c + 60</formula>
        <name>Set New Biz Engagement Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owners_Profile</fullName>
        <field>Owners_Profile_When_Opportunity_Created__c</field>
        <formula>Owner.Profile.Name</formula>
        <name>Set Owners Profile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Softrax_Flag</fullName>
        <field>Passed_to_Softrax__c</field>
        <literalValue>1</literalValue>
        <name>Set Passed to Softrax Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Shipping_Costs</fullName>
        <field>Shipping_Cost__c</field>
        <formula>IF( Redo_Item_s__c = TRUE, 0.00, CASE(Shipping_Method__c, &quot;FedEx: 1st by 8AM&quot;, 93.60,&quot;FedEx: 2 Day&quot;, 22.50,&quot;FedEx: Alaska/Hawaii&quot;, 44.00, &quot;FedEx: Canada&quot;, 58.00, &quot;FedEx: Ground&quot;, 14.00, &quot;FedEx: International&quot;, 85.00, &quot;FedEx: Priority&quot;, 30.00, &quot;FedEx: Saturday&quot;, 48.00, &quot;FedEx: Standard&quot;, 24.00, &quot;Messenger: RUSH&quot;, 40.00, &quot;MESSENGER&quot;, 17.00, 0.00))</formula>
        <name>Shipping Costs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Type</fullName>
        <field>Type</field>
        <literalValue>Renewal</literalValue>
        <name>Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unlocked_Opp</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Transactional_Broadcast</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Unlocked Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contracted</fullName>
        <field>SBQQ__Contracted__c</field>
        <literalValue>1</literalValue>
        <name>Update Contracted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ORT_to_Approved</fullName>
        <description>Changes the Opportunity Record Type to Document Approved
[NOTICE - Ed changed the field value from Document Approved to TB so I could deactivate the Document Approved Opportunity Record Type]</description>
        <field>RecordTypeId</field>
        <lookupValue>Transactional_Broadcast</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update ORT to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Status</fullName>
        <field>Opportunity_Status__c</field>
        <literalValue>Pending Fulfillment</literalValue>
        <name>Update Opportunity Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Oppty_Amount</fullName>
        <description>Sets the Opportunity Amount field to be the value of the Opportunity formula field Total_Broadcast_Sales__c.</description>
        <field>Amount</field>
        <formula>Total_Broadcast_Sales__c</formula>
        <name>Update Oppty Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Passed_To_Stx_Flag</fullName>
        <field>Passed_to_Softrax__c</field>
        <literalValue>1</literalValue>
        <name>Update Passed To Stx Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Push_Counter</fullName>
        <field>Push_Counter__c</field>
        <formula>Push_Counter__c + 1</formula>
        <name>Update Push Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Route_Date_Time</fullName>
        <field>Route_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Route Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Routing_Time_Hour</fullName>
        <field>Routing_Time_Hour__c</field>
        <formula>VALUE(MID(TEXT( Route_Date_Time__c ), 12,2))-5</formula>
        <name>Update Routing Time-Hour</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Softrax_Synced_Date</fullName>
        <field>Softrax_Synced_Date__c</field>
        <formula>Now()</formula>
        <name>Update Softrax Synced Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Contract_Approved</fullName>
        <field>StageName</field>
        <literalValue>Contract Approved</literalValue>
        <name>Update Stage to Contract Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Contract_Opened</fullName>
        <field>StageName</field>
        <literalValue>Cust: Contract Opened</literalValue>
        <name>Update Stage to Contract Opened</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Contract_Rejected</fullName>
        <field>StageName</field>
        <literalValue>Cust: Contract Rejected</literalValue>
        <name>Update Stage to Contract Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Contract_Signed</fullName>
        <field>StageName</field>
        <literalValue>Cust: Contract Signed</literalValue>
        <name>Update Stage to Contract Signed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Analysis Services Email</fullName>
        <actions>
            <name>Send_an_email_to_Analysis_Services_about_a_new_Order</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Number_of_Analysis_Services_Products__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <description>Need to add real distribution group: Craig Mitchell, Wayne Bullock, Mathilda Joubert, Jori Neft, Linda Mantegani, Troy Gilbert</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>At Risk Clients</fullName>
        <actions>
            <name>At_Risk_Training</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.At_Risk__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Renewal_Type__c</field>
            <operation>notEqual</operation>
            <value>Broadcast Renewal</value>
        </criteriaItems>
        <description>I think we can delete this now.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CA Reviewed %28Temp%29</fullName>
        <actions>
            <name>CA_Reviewed_Temp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Cust: Contract Signed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change Close Date</fullName>
        <actions>
            <name>Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(StageName, &quot;Closed Won&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change this Fixing Shipping Country</fullName>
        <actions>
            <name>Fix_US_and_CAN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>LEN(Shipping_Country__c)&lt;4</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Close Date - Test</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Contacted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Contract Opened</fullName>
        <actions>
            <name>Update_Stage_to_Contract_Opened</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.DocuSign_Contract_Opened__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Rejected</fullName>
        <actions>
            <name>Update_Stage_to_Contract_Rejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.DocuSign_Contract_Rejected__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Sent Date</fullName>
        <actions>
            <name>Contract_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Contract Sent</value>
        </criteriaItems>
        <description>Populate the Contract Sent Date when a Contract has been sent.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Signed</fullName>
        <actions>
            <name>Update_Stage_to_Contract_Signed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.DocuSign_Contract_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy Campaign_Type</fullName>
        <actions>
            <name>Copy_Campaign_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy Campaign_Type to this opportunity if it is coming from Campaign Lead Conversion.</description>
        <formula>NOT(ISBLANK(TEXT(Campaign.Type)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email AE when Payment is unsuccessful</fullName>
        <actions>
            <name>Email_AE_when_Payment_is_unsuccessful</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Status__c</field>
            <operation>equals</operation>
            <value>Payment Error</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Renewal Rep when Lost Renewal</fullName>
        <actions>
            <name>Email_Renewal_Rep_when_Lost_Renewal</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>Closed Won,Voided</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
            <value>Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Renewal_Due_Date__c</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Change from Lisa to real owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Opportunity.Renewal_Due_Date__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email Sales Rep when Customer Signs Contract</fullName>
        <actions>
            <name>Email_Sales_Rep_when_Customer_signs_Contract</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.DocuSign_Contract_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Sales Rep when Customer opens Contract</fullName>
        <actions>
            <name>Email_Sales_Rep_when_Customer_opens_Contract</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Cust: Contract Opened</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Sales Rep when Customer rejects Contract</fullName>
        <actions>
            <name>Email_Sales_Rep_when_Customer_rejects_Contract</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Cust: Contract Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email to Sales and CA when Opportunity submitted to Softrax</fullName>
        <actions>
            <name>Email_Sales_and_CA_Rep_when_Opportunity_submitted_to_Softrax</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Locked New Biz,Locked Renewals</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Gone Silent</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>Suspect,Establish Value,Prove Capability,Buying Alignment,Decision Due,Closed Won,Closed Lost,Voided</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Sales_Last_Touched_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>New Biz</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Gone_Silent</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Gone_Silent_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.Sales_Last_Touched_Date__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Locked Opp</fullName>
        <actions>
            <name>Locked_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Locked__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Managed Services Email</fullName>
        <actions>
            <name>Send_an_email_to_Managed_Services_about_a_new_Order</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Number_of_Managed_Services_Products__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Biz Lead Conversion</fullName>
        <actions>
            <name>New_Biz_Opp_Record_Type_Correction</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Lead_Opp_Record_Type__c</field>
            <operation>equals</operation>
            <value>New Biz</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity %3A Set Softrax Flag for Broadcast</fullName>
        <actions>
            <name>Set_Softrax_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Transactional Broadcast,Locked Transactional Broadcast</value>
        </criteriaItems>
        <description>Sets the Softrax flag for Broadcast records</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Generate Contract</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SBQQ__Contracted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>New Biz,Renewals,Locked New Biz,Locked Renewals</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Contracted</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.CreatedTime_Minus_55_Minutes__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity Changed Hands</fullName>
        <actions>
            <name>Opportunity_Changed_Hands</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED(OwnerId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Status%3A Pending Fulfillment</fullName>
        <actions>
            <name>Update_Opportunity_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Opportunity_Status__c,&quot;Pending Sale&quot;),NOT(ISPICKVAL(Route_To__c,&quot;&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Status%3A Pending Invoicing</fullName>
        <actions>
            <name>Opportunity_Status_Pending_Invoicing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(OR(ISPICKVAL(Route_To__c ,&quot;Cision Hero&quot;), ISPICKVAL(Route_To__c ,&quot;On Hold&quot;)),ISPICKVAL(Opportunity_Status__c,&quot;Pending Fulfillment&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity has exceeded Due Date</fullName>
        <active>true</active>
        <description>Temp Inactive: An email alert is sent to the Routing office if an Opportunity is not fulfilled by its Due Date.</description>
        <formula>AND(  ISPICKVAL(Opportunity_Status__c, &quot;Pending Fulfillment&quot;), Due_Date__c &lt; TODAY() )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_has_exceeded_Due_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Due_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity sitting in Traffic</fullName>
        <active>true</active>
        <description>Temp Inactive: This rule will fire when an Opportunity has been sitting in the Traffic view for more than an hour.</description>
        <formula>AND (ISPICKVAL(Route_To__c, &quot;Traffic&quot;),  RecordType.DeveloperName=&quot;Transactional Broadcast&quot;, OR(VALUE(MID(TEXT(CreatedDate),12,2))&gt;13,  VALUE(MID(TEXT(CreatedDate),12,2))&lt;22)   )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_sitting_in_Traffic</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Route_Date_Time__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Pending Fulfillment Date</fullName>
        <actions>
            <name>Set_Fulfillment_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populate the Pending Fulfillment Date</description>
        <formula>AND( ISPICKVAL(PRIORVALUE(Opportunity_Status__c),&quot;Pending Fulfillment&quot;), OR( ISPICKVAL(Opportunity_Status__c,&quot;Pending Invoicing&quot;), ISPICKVAL(Opportunity_Status__c,&quot;Invoiced&quot;) ), ISBLANK(Fulfillment_Date__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Route To Email</fullName>
        <actions>
            <name>Route_To_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Route_To__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Push Counter</fullName>
        <actions>
            <name>Update_Push_Counter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(CloseDate)=TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Quote Approved changed</fullName>
        <actions>
            <name>Opportunity_Update_Record_Type_to_R</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Update_Stage_to_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Number_of_quotes_that_are_Approved__c ) &amp;&amp; Number_of_quotes_that_are_Approved__c &gt; 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renewal Opp Creation Update</fullName>
        <actions>
            <name>Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Renewal_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Renewal_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>equals</operation>
            <value>Renewal Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Renewal_Due_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Renewal Rep%3A Account Change Notification</fullName>
        <actions>
            <name>Send_an_email_to_the_new_Renewal_Opportunity_owner</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Switch from Lisa name to Opp Owner</description>
        <formula>AND (ISCHANGED(OwnerId), RecordType.DeveloperName = &quot;Renewals&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renewals Lead Conversion</fullName>
        <actions>
            <name>Renewals_Opp_Record_Type_Correction</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Lead_Opp_Record_Type__c</field>
            <operation>equals</operation>
            <value>Renewals</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Routed Back to AE</fullName>
        <actions>
            <name>Email_AE_when_Routed_Back_to_AE</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Route_To__c</field>
            <operation>equals</operation>
            <value>AE</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Routed Back to Traffic</fullName>
        <actions>
            <name>Change_Fulfillment_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(ISPICKVAL(PRIORVALUE(Route_To__c), &quot;AE&quot;),  ISPICKVAL(Route_To__c, &quot;Traffic&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Routed to DNR</fullName>
        <actions>
            <name>Routed_to_DNR</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Route_To__c</field>
            <operation>equals</operation>
            <value>DNR</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Rush Order</fullName>
        <actions>
            <name>Set_Fulfillment_Status_to_Rush</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(Rush_Order__c= TRUE, ISPICKVAL(Fulfillment_Status__c,&quot;&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Closed Won Date Time</fullName>
        <actions>
            <name>Set_Closed_Won_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set New Biz Engagement Date</fullName>
        <actions>
            <name>Set_New_Biz_Engagement_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Renewal_Due_Date__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Opportunity Created Date Time</fullName>
        <actions>
            <name>Opportunity_Created_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>1/1/1900</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Profile when Opp Created</fullName>
        <actions>
            <name>Set_Owners_Profile</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Routing Date%2FTime on Route To</fullName>
        <actions>
            <name>Update_Route_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Routing_Time_Hour</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Route_To__c), NOT( ISPICKVAL(Route_To__c, &quot;Cision Hero&quot;)), NOT( ISPICKVAL(Route_To__c, &quot;On Hold&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Shipping Methods And Costs</fullName>
        <actions>
            <name>Shipping_Costs</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the appropriate Shipping Costs based on the Shipping Method chosen.</description>
        <formula>NOT(ISPICKVAL (Shipping_Method__c, &quot;&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Temp Turn offOpportunity sitting in Traffic</fullName>
        <active>false</active>
        <description>This rule will fire when an Opportunity has been sitting in the Traffic view for more than an hour.</description>
        <formula>AND ( 

ISPICKVAL(Route_To__c, &quot;Traffic&quot;),

OR(VALUE(MID(TEXT(CreatedDate),12,2))&gt;13, 
VALUE(MID(TEXT(CreatedDate),12,2))&lt;22) 

)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_sitting_in_Traffic</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Route_Date_Time__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Turned Off-it%27s a trigger NowCreate Contract</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.SBQQ__Contracted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Renewals,New Biz</value>
        </criteriaItems>
        <description>Creates the Contact and Subscriptions</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Contracted</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.Time_59_Minutes_before_save__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Unlocked Opp</fullName>
        <actions>
            <name>Unlocked_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Locked__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Unrouted Opportunities Check</fullName>
        <active>true</active>
        <description>Sends an email alert for Opportunities that have are Closed Won and have not been Routed to Traffic within an hour.</description>
        <formula>AND(  
ISPICKVAL(Route_To__c,&quot;&quot;), 
RecordType.DeveloperName=&quot;Transactional Broadcast&quot;,
ISPICKVAL(StageName, &quot;Closed Won&quot;),  OR(VALUE(MID(TEXT(CreatedDate),12,2))&gt;13,  VALUE(MID(TEXT(CreatedDate),12,2))&lt;22)
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Unrouted_Opportunity_Check</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Amount with Total Broadcast</fullName>
        <actions>
            <name>Shipping_Costs</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Oppty_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Transactional Broadcast</value>
        </criteriaItems>
        <description>Sets the Opportunity Amount field to be the value of the Opportunity formula field Total_Broadcast_Sales__c.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Opp Name</fullName>
        <actions>
            <name>Opp_Number_to_Opp_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Transactional Broadcast</value>
        </criteriaItems>
        <description>For Broadcast Opps, the Opp Name is changed to be the Opp Number.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Softrax Synced Date</fullName>
        <actions>
            <name>Update_Softrax_Synced_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Passed_to_Softrax__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When the Passed To Softrax Flag is updated from the batch job, it should update this field&apos;s date time</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
