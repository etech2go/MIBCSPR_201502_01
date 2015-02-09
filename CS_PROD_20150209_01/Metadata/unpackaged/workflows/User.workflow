<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>User_Set_Output_change</fullName>
        <field>SBQQ__OutputFormatChangeAllowed__c</field>
        <literalValue>1</literalValue>
        <name>User Set Output change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>User_Unset_Output_Change</fullName>
        <field>SBQQ__OutputFormatChangeAllowed__c</field>
        <literalValue>0</literalValue>
        <name>User Unset Output Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>User Selected as VP</fullName>
        <actions>
            <name>User_Set_Output_change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Is_VP__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>The User has been selected as a VP</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>User Unselected as VP</fullName>
        <actions>
            <name>User_Unset_Output_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Is_VP__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>The user has lost their VP status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
