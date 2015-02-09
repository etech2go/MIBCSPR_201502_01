<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contact_GA_Compaign</fullName>
        <field>GA_Campaign__c</field>
        <formula>Contact.GA_Campaign__c</formula>
        <name>Contact_GA_Compaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_GA_Content</fullName>
        <field>GA_Content__c</field>
        <formula>Contact.GA_Content__c</formula>
        <name>Contact_GA_Content</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_GA_Medium</fullName>
        <field>GA_Medium__c</field>
        <formula>Contact.GA_Medium__c</formula>
        <name>Contact_GA_Medium</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_GA_Source</fullName>
        <field>GA_Source__c</field>
        <formula>Contact.GA_Source__c</formula>
        <name>Contact_GA_Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_GA_Term</fullName>
        <field>GA_Term__c</field>
        <formula>Contact.GA_Term__c</formula>
        <name>Contact_GA_Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Lead_GA_Term</fullName>
        <field>GA_Term__c</field>
        <formula>Lead.GA_Term__c</formula>
        <name>Copy_Lead_GA_Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Copy_GA_Camp</fullName>
        <field>GA_Campaign__c</field>
        <formula>Lead.GA_Campaign__c</formula>
        <name>Lead_Copy_GA_Camp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Copy_GA_Cont</fullName>
        <field>GA_Content__c</field>
        <formula>Lead.GA_Content__c</formula>
        <name>Lead_Copy_GA_Cont</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Copy_GA_Med</fullName>
        <field>GA_Medium__c</field>
        <formula>Lead.GA_Medium__c</formula>
        <name>Lead_Copy_GA_Med</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Copy_GA_Sou</fullName>
        <field>GA_Source__c</field>
        <formula>Lead.GA_Source__c</formula>
        <name>Lead_Copy_GA_Sou</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Copy_GA_Term</fullName>
        <field>GA_Term__c</field>
        <formula>Lead.GA_Term__c</formula>
        <name>Lead_Copy_GA_Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_GA_Campaign</fullName>
        <field>GA_Campaign__c</field>
        <formula>Lead.GA_Campaign__c</formula>
        <name>Lead_GA_Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_GA_Content</fullName>
        <field>GA_Content__c</field>
        <formula>Lead.GA_Content__c</formula>
        <name>Lead_GA_Content</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_GA_Medium</fullName>
        <field>GA_Medium__c</field>
        <formula>Lead.GA_Medium__c</formula>
        <name>Lead_GA_Medium</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_GA_Source</fullName>
        <field>GA_Source__c</field>
        <formula>Lead.GA_Source__c</formula>
        <name>Lead_GA_Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_GA_Term</fullName>
        <field>GA_Term__c</field>
        <formula>Lead.GA_Term__c</formula>
        <name>Lead_GA_Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy_Contact_GA_Fields</fullName>
        <actions>
            <name>Contact_GA_Compaign</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_GA_Content</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_GA_Medium</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_GA_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_GA_Term</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy all the GA fields from the contact, associated with any campaign</description>
        <formula>NOT(ISBLANK(Contact.Id))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy_Lead_GA_Fields</fullName>
        <actions>
            <name>Lead_Copy_GA_Camp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Copy_GA_Cont</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Copy_GA_Med</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Copy_GA_Sou</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Copy_GA_Term</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy all the GA fields from the lead, associated with any campaign</description>
        <formula>OR(Lead.IsConverted, NOT(ISBLANK(Lead.Id)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
