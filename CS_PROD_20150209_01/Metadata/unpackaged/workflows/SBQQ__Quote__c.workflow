<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Rejected</fullName>
        <description>Approval Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>SBQQ__SalesRep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/SRepQuoteRejected</template>
    </alerts>
    <alerts>
        <fullName>Quote_Approved</fullName>
        <description>Quote Approved</description>
        <protected>false</protected>
        <recipients>
            <field>SBQQ__SalesRep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/SRepQuoteApproved</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Rejected_Field_Update_Trigger</fullName>
        <field>Approval_Rejected_Flag__c</field>
        <literalValue>1</literalValue>
        <name>Approval Rejected Field Update Trigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CM_Test</fullName>
        <field>STX_Use_Existing_Contract_Number__c</field>
        <literalValue>1</literalValue>
        <name>CM Test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Opp_Status_to_rejected</fullName>
        <field>StageName</field>
        <literalValue>APP: Rejected</literalValue>
        <name>Change Opp Status to rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Number_on_Opp</fullName>
        <field>Contract_Number__c</field>
        <formula>SBQQ__MasterContract__c</formula>
        <name>Contract Number on Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Opened</fullName>
        <field>StageName</field>
        <literalValue>Cust: Contract Opened</literalValue>
        <name>Contract Opened</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Rejected</fullName>
        <field>StageName</field>
        <literalValue>Cust: Contract Rejected</literalValue>
        <name>Contract Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Sent</fullName>
        <description>Sets the Opportunity Stage Name to Contract Sent</description>
        <field>StageName</field>
        <literalValue>Contract Sent</literalValue>
        <name>Contract Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Signed</fullName>
        <field>StageName</field>
        <literalValue>Cust: Contract Signed</literalValue>
        <name>Contract Signed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_Tax_Exempt_Review</fullName>
        <field>StageName</field>
        <literalValue>Finance: Tax Exempt Review</literalValue>
        <name>Finance: Tax Exempt Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Set_Stage_to_Proposal</fullName>
        <field>StageName</field>
        <literalValue>Proposal</literalValue>
        <name>Opportunity - Set Stage to Proposal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PD_Update</fullName>
        <field>StageName</field>
        <literalValue>Finance: Tax Exempt Review</literalValue>
        <name>PD Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QQ_Set_Quote_Status_to_Approval_Rejected</fullName>
        <description>Sets the quote status to Approval Rejected</description>
        <field>SBQQ__Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>QQ: Set Quote Status to ApprovalRejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QQ_Set_Quote_Status_to_Approved</fullName>
        <description>Sets the quote status to Approved</description>
        <field>SBQQ__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>QQ: Set Quote Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QQ_Set_Quote_Status_to_Draft</fullName>
        <field>SBQQ__Status__c</field>
        <literalValue>Draft</literalValue>
        <name>QQ: Set Quote Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QQ_Set_Quote_Status_to_Review</fullName>
        <description>Sets the quote status to In Review</description>
        <field>SBQQ__Status__c</field>
        <literalValue>In Review</literalValue>
        <name>QQ: Set Quote Status to Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Set_Record_Type_to_B_Approvals</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Before_Approvals</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Quote - Set Record Type to B Approvals</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Set_Record_Type_to_Closed</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Quote - Set Record Type to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Set_Record_type_to_a_Approvals</fullName>
        <description>Sets the record type to after Approvals</description>
        <field>RecordTypeId</field>
        <lookupValue>After_Approvals</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Quote - Set Record type to a Approvals</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Set_Start_Date</fullName>
        <field>SBQQ__StartDate__c</field>
        <formula>IF(ISBLANK( SBQQ__StartDate__c ), SBQQ__Opportunity__r.Renewal_Due_Date__c, SBQQ__StartDate__c )</formula>
        <name>Quote - Set Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Set_Subscription_Term_to_12</fullName>
        <field>SBQQ__SubscriptionTerm__c</field>
        <formula>IF(ISBLANK( Subscription_Term__c ), 12, Subscription_Term__c)</formula>
        <name>Quote - Set Subscription Term to 12</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_After_Approvals_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>After_Approvals</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set After Approvals RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opp_Record_Type_to_Renewals</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Renewals</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Opp Record Type to Renewals</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Post_Signature_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Post_Signature</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Post Signature RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Previous_Rejected_Trigger</fullName>
        <field>Approval_Rejected_Flag__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Previous Rejected Trigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opp_Discount</fullName>
        <description>Update Discount Amount on Quote&apos;s opportunity</description>
        <field>Discount_Amount__c</field>
        <name>Update Opp Discount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opp_Stage_to_APP_Approved</fullName>
        <field>StageName</field>
        <literalValue>APP: Approved</literalValue>
        <name>Update Opp Stage to APP: Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opp_Stage_to_CA_Review</fullName>
        <field>StageName</field>
        <literalValue>CA: Review</literalValue>
        <name>Update Opp Stage to CA Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opp_Stage_to_Finance_Review</fullName>
        <field>StageName</field>
        <literalValue>Finance: Tax Exempt Review</literalValue>
        <name>Update Opp Stage to Finance Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opp_Stage_to_In_Negotiation</fullName>
        <field>StageName</field>
        <literalValue>In Negotiation</literalValue>
        <name>Update Opp Stage to In Negotiation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>SBQQ__Opportunity__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>CA Review</fullName>
        <actions>
            <name>Set_Post_Signature_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>CA: Review</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Finance Review</fullName>
        <actions>
            <name>Update_Opp_Stage_to_Finance_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 OR 3 OR 4 OR 5 OR 6) AND 7</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Tax_Exempt__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>SBQQ__Quote__c.Change_Billing_Street__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>SBQQ__Quote__c.Change_Billing_City__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>SBQQ__Quote__c.Change_Billing_State__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>SBQQ__Quote__c.Change_Billing_Zip__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>SBQQ__Quote__c.Change_Billing_Country__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>SBQQ__Quote__c.Docusign_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Quote - Closed</fullName>
        <actions>
            <name>Quote_Set_Record_Type_to_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won,Closed Lost</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Quote - Set Defaults</fullName>
        <actions>
            <name>Quote_Set_Record_Type_to_B_Approvals</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Quote_Set_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Quote_Set_Subscription_Term_to_12</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Quote - Status set to Approved</fullName>
        <actions>
            <name>Quote_Set_Record_type_to_a_Approvals</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.SBQQ__Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Quote - Status set to Draft or In Review</fullName>
        <actions>
            <name>Quote_Set_Record_Type_to_B_Approvals</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Opp_Stage_to_In_Negotiation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.SBQQ__Status__c</field>
            <operation>equals</operation>
            <value>Draft,In Review</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Quote - Status set to Rejected</fullName>
        <actions>
            <name>Quote_Set_Record_Type_to_B_Approvals</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.SBQQ__Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Contract Opened</fullName>
        <actions>
            <name>Contract_Opened</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.Docusign_Status__c</field>
            <operation>equals</operation>
            <value>Delivered</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Contract Sent</value>
        </criteriaItems>
        <description>Update the Opportunity Stage to Contract Opened when a Contract has been opened through Docusign</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Contract Rejected</fullName>
        <actions>
            <name>Contract_Rejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.Docusign_Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <description>Update the Opportunity Stage to Contract Rejected when a Contract has been declined through Docusign</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Contract Sent</fullName>
        <actions>
            <name>Contract_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.Docusign_Status__c</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <description>Update the Opportunity Stage to Contract Sent when a Contract has been sent through Docusign</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Contract Signed</fullName>
        <actions>
            <name>Set_Post_Signature_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Opp_Stage_to_CA_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Quote__c.Docusign_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
