<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Credit_for_Existing_Services_Quote_Request</fullName>
        <description>Credit for Existing Services Quote Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>uscabilling.us@cision.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Credit_for_Existing_Services_Quote</template>
    </alerts>
    <alerts>
        <fullName>Credit_for_Existing_Services_Quote_Request_Completed</fullName>
        <description>Credit for Existing Services Quote Request Completed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Credit_for_Existing_Services_Quote_Completed</template>
    </alerts>
    <alerts>
        <fullName>Credit_for_Existing_Services_Quote_Request_Rejected</fullName>
        <description>Credit for Existing Services Quote Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Credit_for_Existing_Services_Quote_Request_Rejected</template>
    </alerts>
    <rules>
        <fullName>Credit for Existing Services Quote Completed</fullName>
        <actions>
            <name>Credit_for_Existing_Services_Quote_Request_Completed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Credit_for_Existing_Services_Quote__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit for Existing Services Quote Rejected</fullName>
        <actions>
            <name>Credit_for_Existing_Services_Quote_Request_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Credit_for_Existing_Services_Quote__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit for Existing Services Quote Request</fullName>
        <actions>
            <name>Credit_for_Existing_Services_Quote_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Credit_for_Existing_Services_Quote__c.Start_Date_of_New_Contract__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
