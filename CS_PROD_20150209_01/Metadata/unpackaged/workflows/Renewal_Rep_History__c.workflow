<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_New_Renewal_Rep_and_Previous_Renewal_Rep_about_Account_Change</fullName>
        <description>Email New Renewal Rep and Previous Renewal Rep about Account Change</description>
        <protected>false</protected>
        <recipients>
            <field>New_Renewal_Rep__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Old_Renewal_Rep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Renewal_Rep_Account_Change_Notification</template>
    </alerts>
    <rules>
        <fullName>Renewal Rep Change Notification</fullName>
        <actions>
            <name>Email_New_Renewal_Rep_and_Previous_Renewal_Rep_about_Account_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Renewal_Rep_History__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
