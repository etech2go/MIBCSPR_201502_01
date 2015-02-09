<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>OP_Set_Commissionable_Product</fullName>
        <description>Sets the Commissionable Product flag to true</description>
        <field>Commissionable_Product__c</field>
        <literalValue>1</literalValue>
        <name>OP: Set Commissionable Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewable_Product</fullName>
        <field>Renewable_Product__c</field>
        <formula>IF(ISPICKVAL(PricebookEntry.Product2.SBQQ__SubscriptionBase__c,&quot;&quot;),0, 1)</formula>
        <name>Renewable Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Analysis_Services_Workflow</fullName>
        <field>Workflow_Analysis_Services_Product__c</field>
        <formula>1</formula>
        <name>Update Analysis Services Workflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Family</fullName>
        <field>Product_Family__c</field>
        <formula>TEXT(Product2.Family)</formula>
        <name>Update Product Family</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Workflow_Managed_Services_Product</fullName>
        <field>Workflow_Managed_Services_Product__c</field>
        <formula>1</formula>
        <name>Update Workflow Managed Services Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>OP %3A Set Commission Product</fullName>
        <actions>
            <name>OP_Set_Commissionable_Product</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>PricebookEntry.Product2.Commissionable_Product__c = TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Renewable Product</fullName>
        <actions>
            <name>Renewable_Product</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
