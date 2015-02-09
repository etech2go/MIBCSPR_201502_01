<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Insert_Date_Completed</fullName>
        <description>Inserts today&apos;s date into Date Completed</description>
        <field>Date_Completed__c</field>
        <formula>TODAY()</formula>
        <name>Insert Date Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Training_Tasks_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Training</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Training Tasks Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Note_Snippet</fullName>
        <field>Note_Snippet__c</field>
        <formula>LEFT(Description,255)</formula>
        <name>Update Note Snippet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Insert Date Completed</fullName>
        <actions>
            <name>Insert_Date_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>When the Task is marked &quot;Complete,&quot; the date is added to the Date Completed field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Note Snippet</fullName>
        <actions>
            <name>Update_Note_Snippet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Description</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
