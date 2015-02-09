<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Competitor_Note_Snippet</fullName>
        <field>Note_Snippet__c</field>
        <formula>LEFT(Competitor_Notes__c,255)</formula>
        <name>Update Competitor Note Snippet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Competitor Note Snippet</fullName>
        <actions>
            <name>Update_Competitor_Note_Snippet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Competitor__c.Competitor_Notes__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
