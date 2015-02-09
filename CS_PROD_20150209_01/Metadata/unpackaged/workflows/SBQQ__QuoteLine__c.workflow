<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>QQ_Monthly_Subscription_False</fullName>
        <field>Monthly_Subscription_2__c</field>
        <literalValue>0</literalValue>
        <name>QQ: Monthly Subscription False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QQ_Monthly_Subscription_True</fullName>
        <field>Monthly_Subscription_2__c</field>
        <literalValue>1</literalValue>
        <name>QQ: Monthly Subscription True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QQ_Product_Name</fullName>
        <field>Product_Name__c</field>
        <formula>SBQQ__ProductName__c</formula>
        <name>QQ: Product Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QQ_Set_Discount_Amount_for_Approval</fullName>
        <description>Sets the discount amount to be considered for approval process.</description>
        <field>Discount_Amount_for_Approval__c</field>
        <formula>/* Rule:
- Do not include predetermined package discounts (in bundles)
- Do not include up to $5,100 (equivalent of 30,000 points) off of RESCPDIST
- Do not include credit for existing services (MONCPUPGRADEPAID and RES-UPGRADE-CP)
- Do not include negative additional discounts
*/

CASE( SBQQ__ProductCode__c ,

  &quot;RESCPDIST&quot; ,
    /* Special case of RESCPDIST */
    IF( SBQQ__ListTotal__c - SBQQ__CustomerTotal__c &lt;= 5100, 
      0,
      SBQQ__ListTotal__c - SBQQ__CustomerTotal__c - 5100
    ),

  &quot;MONCPUPGRADEPAID&quot; ,
    0 ,

  &quot;RES-UPGRADE-CP&quot; ,
    0 ,

  /* No discount from the product option. Use standard discount calculation */
    SBQQ__AdditionalDiscount__c
  
)</formula>
        <name>QQ: Set Discount Amount for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QQ_Set_ProductCode2</fullName>
        <description>Sets ProductCode2 field.</description>
        <field>ProductCode2__c</field>
        <formula>SBQQ__Product__r.ProductCode</formula>
        <name>QQ: Set ProductCode2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QQ_Set_ProductFamily2</fullName>
        <field>ProductFamily2__c</field>
        <formula>TEXT(SBQQ__Product__r.Family)</formula>
        <name>QQ: Set ProductFamily2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_QQ_Start_Date</fullName>
        <field>Cision_Start_Date__c</field>
        <formula>Cision_Start_Date__c</formula>
        <name>Set QQ Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_QQ_Subscription_Term</fullName>
        <field>Cision_Subscription_Term__c</field>
        <formula>Cision_Subscription_Term__c</formula>
        <name>Set QQ Subscription Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>QQ%3A Monthly Subscription False</fullName>
        <actions>
            <name>QQ_Monthly_Subscription_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__QuoteLine__c.Monthly_Subscription__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>QQ%3A Monthly Subscription True</fullName>
        <actions>
            <name>QQ_Monthly_Subscription_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SBQQ__QuoteLine__c.Monthly_Subscription__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>QQ%3A Product Name</fullName>
        <actions>
            <name>QQ_Product_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SBQQ__QuoteLine__c.SBQQ__ProductName__c</field>
            <operation>notEqual</operation>
            <value>Null</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>QQ%3A Set Quote Line Fields</fullName>
        <actions>
            <name>QQ_Set_Discount_Amount_for_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>QQ_Set_ProductCode2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>QQ_Set_ProductFamily2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets field values on quote line.</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
