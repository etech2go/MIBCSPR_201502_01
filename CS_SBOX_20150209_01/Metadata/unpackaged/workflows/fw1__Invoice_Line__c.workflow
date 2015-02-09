<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Locked_Invoice_Line</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Locked_Invoice_Line</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Locked Invoice Line</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Locked Invoice Line</fullName>
        <actions>
            <name>Locked_Invoice_Line</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>fw1__Invoice_Line__c.Locked__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
