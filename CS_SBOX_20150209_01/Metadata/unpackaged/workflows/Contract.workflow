<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Activate_Contract</fullName>
        <field>Status</field>
        <literalValue>Activated</literalValue>
        <name>Activate Contract</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contract_Start_Date</fullName>
        <field>StartDate</field>
        <formula>STX_Contract_Start_Date__c</formula>
        <name>Set Contract Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Renewal_Forecast_to_True</fullName>
        <field>SBQQ__RenewalForecast__c</field>
        <literalValue>1</literalValue>
        <name>Set Renewal Forecast to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Renewal_Price_List</fullName>
        <field>SBQQ__RenewalPricebookId__c</field>
        <formula>&quot;01sd0000000QCNw&quot;</formula>
        <name>Set Renewal Price List</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Sub_Account</fullName>
        <field>Sub_Account__c</field>
        <formula>SBQQ__Opportunity__r.Sub_Account__r.Name</formula>
        <name>Set Sub Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Renewal Opp Creation</fullName>
        <actions>
            <name>Activate_Contract</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Contract_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Renewal_Forecast_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Renewal_Price_List</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Don_t_Create_Renewal_Opp__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.SBQQ__RenewalForecast__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.STX_Contract_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Migrated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Creating the Renewal Opp</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Store Contract on Opp</fullName>
        <active>false</active>
        <description>Puts the Contract Id and Number onto the Opportunity</description>
        <formula>NOT(ISNULL(Id))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Opp Passed To Stx Flag</fullName>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Contract.STX_Contract_Number__c</field>
            <operation>notEqual</operation>
            <value>Null</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
