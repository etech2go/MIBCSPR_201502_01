<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Potential_Amount_Update</fullName>
        <field>Potential_Amount__c</field>
        <formula>SBQQ__NetPrice__c</formula>
        <name>Potential Amount Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Potential_Changed_By</fullName>
        <field>Potential_Changed_By__c</field>
        <formula>LastModifiedBy.FirstName + &apos; &apos; + LastModifiedBy.LastName</formula>
        <name>Update Potential Changed By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Potential Amount</fullName>
        <actions>
            <name>Potential_Amount_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__Subscription__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Record Potential Adjustments</fullName>
        <actions>
            <name>Update_Potential_Changed_By</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Potential_Adjustment_Reason__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
