<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Locked_Invoice</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Locked_Invoice</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Locked Invoice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Void_Date</fullName>
        <field>Void_Date__c</field>
        <formula>NOW()</formula>
        <name>Populate Void Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Locked Invoice</fullName>
        <actions>
            <name>Locked_Invoice</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>fw1__Invoice__c.Locked__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Void Date</fullName>
        <actions>
            <name>Populate_Void_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>fw1__Invoice__c.fw1__Is_Voided__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
