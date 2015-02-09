<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Blank_Quote_End_Date</fullName>
        <field>Quote_End_Date__c</field>
        <formula>Date(Year(Quote_Start_Date__c)+1,
Month(Quote_Start_Date__c),
Day(Quote_Start_Date__c)
)</formula>
        <name>Blank Quote End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_End_Date</fullName>
        <field>Quote_End_Date__c</field>
        <formula>SBQQ__QuoteLine__r.SBQQ__Quote__r.SBQQ__EndDate__c</formula>
        <name>Quote End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Start_Date</fullName>
        <field>Quote_Start_Date__c</field>
        <formula>SBQQ__QuoteLine__r.SBQQ__Quote__r.SBQQ__StartDate__c</formula>
        <name>Quote Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Quote End Date</fullName>
        <actions>
            <name>Blank_Quote_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISBLANK(Quote_End_Date__c) &amp;&amp;  NOT(ISBLANK(Quote_Start_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
