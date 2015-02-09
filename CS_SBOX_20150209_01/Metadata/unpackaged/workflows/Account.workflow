<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_has_gone_off_credit_hold</fullName>
        <description>Account has gone off credit hold</description>
        <protected>false</protected>
        <recipients>
            <field>Renewal_Rep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_Renewal_Rep_when_Account_goes_off_Credit_Hold</template>
    </alerts>
    <alerts>
        <fullName>Account_has_gone_on_credit_hold</fullName>
        <description>Account has gone on credit hold</description>
        <protected>false</protected>
        <recipients>
            <field>Renewal_Rep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_Renewal_Rep_when_Account_goes_on_Credit_Hold</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Set_Co_Term_to_Prompt</fullName>
        <description>Sets the Steelbrick Co-Term Event to Prompt</description>
        <field>SBQQ__ContractCoTermination__c</field>
        <literalValue>Prompt</literalValue>
        <name>Account - Set Co Term to Prompt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Set_Co_Term_type_to_AddOn</fullName>
        <field>SBQQ__CoTerminationEvent__c</field>
        <literalValue>Add-on</literalValue>
        <name>Account Set Co Term type to AddOn</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acct_B_to_A_Street</fullName>
        <field>ShippingStreet</field>
        <formula>BillingStreet</formula>
        <name>Acct: B to S Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acct_B_to_S_City</fullName>
        <field>ShippingCity</field>
        <formula>BillingCity</formula>
        <name>Acct: B to S City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acct_B_to_S_Country</fullName>
        <field>ShippingCountry</field>
        <formula>BillingCountry</formula>
        <name>Acct: B to S Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acct_B_to_S_State</fullName>
        <field>ShippingState</field>
        <formula>BillingState</formula>
        <name>Acct: B to S State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Acct_B_to_S_Zip</fullName>
        <field>ShippingPostalCode</field>
        <formula>BillingPostalCode</formula>
        <name>Acct: B to S Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bill_To_Three_Letter_Country</fullName>
        <field>BillingCountry</field>
        <formula>CASE(BillingCountry, &apos;U.S.A.&apos;, &apos;USA&apos;, &apos;United States&apos;, &apos;USA&apos;, &apos;US&apos;, &apos;USA&apos;, &apos;Canada&apos;, &apos;CAN&apos;, &apos;CA&apos;, &apos;Canada&apos;, &apos;United Kingdom&apos;, &apos;GBR&apos;, &apos;UK&apos;, &apos;GBR&apos;, &apos;Scotland&apos;, &apos;GBR&apos;, &apos;Germany&apos;, &apos;DEU&apos;, &apos;Bermuda&apos;, &apos;BMU&apos;, &apos;Australia&apos;, &apos;AUS&apos;, &apos;Chile&apos;, &apos;CHL&apos;, &apos;Thailand&apos;, &apos;THA&apos;, &apos;Japan&apos;, &apos;JPN&apos;, &apos;Italia&apos;, &apos;ITA&apos;, &apos;Italy&apos;, &apos;ITA&apos;, &apos;Denmark&apos;, &apos;DNK&apos;, BillingCountry)</formula>
        <name>Bill To: Three Letter Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_Tier_Tier_1</fullName>
        <field>CS_Tier__c</field>
        <literalValue>Tier1</literalValue>
        <name>CS Tier - Tier 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_Tier_Tier_2</fullName>
        <field>CS_Tier__c</field>
        <literalValue>Tier2</literalValue>
        <name>CS Tier - Tier 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CS_Tier_Tier_3</fullName>
        <field>CS_Tier__c</field>
        <literalValue>Tier3</literalValue>
        <name>CS Tier - Tier 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Client_Services_Info_Exp_Date_Removal</fullName>
        <field>Client_Services_Info_Exp_Date__c</field>
        <name>Client Services Info Exp Date Removal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Client_Services_Info_Removal</fullName>
        <field>Client_Services_Info__c</field>
        <name>Client Services Info Removal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Collections_Info_Exp_Date_Removal</fullName>
        <field>Collections_Info_Exp_Date__c</field>
        <name>Collections Info Exp Date Removal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Collections_Info_Removal</fullName>
        <field>Collections_Info__c</field>
        <name>Collections Info Removal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Risk_Values_Date_Update</fullName>
        <field>Credit_Risk_Values_Date__c</field>
        <formula>NOW()</formula>
        <name>Credit Risk Values Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Extensions_Info_Exp_Date_Removal</fullName>
        <field>Extensions_Info_Exp_Date__c</field>
        <name>Extensions Info Exp Date Removal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Extensions_Info_Removal</fullName>
        <field>Extensions_Info__c</field>
        <name>Extensions Info Removal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fill_Sales_Last_Touch_Date</fullName>
        <field>Sales_Last_Touched_Date__c</field>
        <formula>IF(   DATEVALUE(LastModifiedDate)   &gt;   LastActivityDate ,  DATEVALUE(LastModifiedDate), LastActivityDate)</formula>
        <name>Fill Sales Last Touch Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Biz_Info_Exp_Date_Removal</fullName>
        <field>New_Biz_Info_Exp_Date__c</field>
        <name>New Biz Info Exp Date Removal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Biz_Info_Removal</fullName>
        <field>New_Biz_Info__c</field>
        <name>New Biz Info Removal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QQ1</fullName>
        <field>SBQQ__ContractCoTermination__c</field>
        <literalValue>Prompt</literalValue>
        <name>QQ1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QQ2</fullName>
        <field>SBQQ__CoTerminationEvent__c</field>
        <literalValue>Add-on</literalValue>
        <name>QQ2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>QQ3</fullName>
        <field>SBQQ__RenewalPricingMethod__c</field>
        <literalValue>Same</literalValue>
        <name>QQ3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Credit_Hold_Message</fullName>
        <field>rrpu__Alert_Message__c</field>
        <name>Remove Credit Hold Message</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewal_Info_Exp_Date_Removal</fullName>
        <field>Renewal_Info_Exp_Date__c</field>
        <name>Renewal Info Exp Date Removal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewal_Info_Removal</fullName>
        <field>Renewal_Info__c</field>
        <name>Renewal Info Removal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_to_Verified</fullName>
        <field>Verified__c</field>
        <literalValue>1</literalValue>
        <name>Set Account to Verified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Credit_Hold_Message</fullName>
        <field>rrpu__Alert_Message__c</field>
        <formula>&quot;CREDIT HOLD ALERT. Contact &quot; + AR_Rep__c + &quot; to see what needs to be done to get this Account off credit hold. You can&apos;t submit any Opps for this Account until the credit hold issue has been resolved. Do NOT create a new Account to bypass the credit hold.&quot;</formula>
        <name>Set Credit Hold Message</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ship_To_Three_Letter_Country</fullName>
        <field>ShippingCountry</field>
        <formula>CASE(ShippingCountry, &apos;U.S.A.&apos;, &apos;USA&apos;, &apos;United States&apos;, &apos;USA&apos;, &apos;US&apos;, &apos;USA&apos;, &apos;Canada&apos;, &apos;CAN&apos;, &apos;CA&apos;, &apos;Canada&apos;, &apos;United Kingdom&apos;, &apos;GBR&apos;, &apos;UK&apos;, &apos;GBR&apos;, &apos;Scotland&apos;, &apos;GBR&apos;, &apos;Germany&apos;, &apos;DEU&apos;, &apos;Bermuda&apos;, &apos;BMU&apos;, &apos;Australia&apos;, &apos;AUS&apos;, &apos;Chile&apos;, &apos;CHL&apos;, &apos;Thailand&apos;, &apos;THA&apos;, &apos;Japan&apos;, &apos;JPN&apos;, &apos;Italia&apos;, &apos;ITA&apos;, &apos;Italy&apos;, &apos;ITA&apos;, &apos;Denmark&apos;, &apos;DNK&apos;, ShippingCountry)</formula>
        <name>Ship To: Three Letter Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account - Copy Billing Address to Shipping</fullName>
        <actions>
            <name>Acct_B_to_A_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Acct_B_to_S_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Acct_B_to_S_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Acct_B_to_S_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Acct_B_to_S_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Copy_Billing_Address_to_Shipping_Address__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account - Set Steelbrick Defaults</fullName>
        <actions>
            <name>Account_Set_Co_Term_to_Prompt</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Set_Co_Term_type_to_AddOn</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sets the Default values used by Steelbrick</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account Name Changes</fullName>
        <active>false</active>
        <formula>AND( ISCHANGED(Name), NOT(ISBLANK(GP_Cust_ID__c)), Verified__c=False )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account has gone off Credit Hold</fullName>
        <actions>
            <name>Account_has_gone_off_credit_hold</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  ISCHANGED(Credit_Hold__c),  Credit_Hold__c=FALSE,  NOT(ISBLANK(Renewal_Rep__c))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account has gone on Credit Hold</fullName>
        <actions>
            <name>Account_has_gone_on_credit_hold</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Account_has_gone_on_Credit_Hold</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Credit_Hold__c), Credit_Hold__c=TRUE, NOT(ISBLANK(Renewal_Rep__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Bill To%3A Three Letter Country</fullName>
        <actions>
            <name>Bill_To_Three_Letter_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Get rid of: Using Validation Rules instead</description>
        <formula>LEN(BillingCountry)&lt;&gt;3</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CS Tier - Tier 1</fullName>
        <actions>
            <name>CS_Tier_Tier_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.GP_Cust_ID__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CS_Tier__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Total_Spend_Non_Broadcast__c</field>
            <operation>greaterOrEqual</operation>
            <value>20000</value>
        </criteriaItems>
        <description>Inactive until Phase 2: Set CS Tier to Tier 1 if Account Value &gt; 20,000</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CS Tier - Tier 2</fullName>
        <actions>
            <name>CS_Tier_Tier_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.GP_Cust_ID__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CS_Tier__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Total_Spend_Non_Broadcast__c</field>
            <operation>greaterOrEqual</operation>
            <value>6000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Total_Spend_Non_Broadcast__c</field>
            <operation>lessThan</operation>
            <value>20000</value>
        </criteriaItems>
        <description>Inactive until Phase 2: Set CS Tier to Tier 2 if Account Value between 6,000 and 20,000</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CS Tier - Tier 3</fullName>
        <actions>
            <name>CS_Tier_Tier_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.GP_Cust_ID__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CS_Tier__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Total_Spend_Non_Broadcast__c</field>
            <operation>lessThan</operation>
            <value>6000</value>
        </criteriaItems>
        <description>Inactive until Phase 2: Set CS Tier to Tier 3 if Account Value &lt; 6000</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Client Services Info Removal</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Client_Services_Info_Exp_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Remove Client Services Info when it passes Expiration Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Client_Services_Info_Exp_Date_Removal</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Client_Services_Info_Removal</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Client_Services_Info_Exp_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Collections Info Removal</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Collections_Info_Exp_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Remove Collections Info when it passes Expiration Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Collections_Info_Exp_Date_Removal</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Collections_Info_Removal</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Collections_Info_Exp_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Credit Risk Values Date Update</fullName>
        <actions>
            <name>Credit_Risk_Values_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( AND(ISCHANGED(Paydex__c),NOT(ISBLANK(Paydex__c))), AND(ISCHANGED(Credit_Limit__c),NOT(ISBLANK(Credit_Limit__c))) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Extensions Info Removal</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Extensions_Info_Exp_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Remove Extensions Info when it passes Expiration Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Extensions_Info_Exp_Date_Removal</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Extensions_Info_Removal</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Extensions_Info_Exp_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Fill Sales Last Touched On</fullName>
        <actions>
            <name>Fill_Sales_Last_Touch_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Fills the date field Sales Last Touched On with either the Last Modified Date or the date of the most recent Completed Sales Activity.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Biz Info Removal</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.New_Biz_Info_Exp_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Remove New Biz Info when it passes Expiration Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Biz_Info_Exp_Date_Removal</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>New_Biz_Info_Removal</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.New_Biz_Info_Exp_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Remove Credit Hold Message</fullName>
        <actions>
            <name>Remove_Credit_Hold_Message</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Credit_Hold__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Get rid of in Phase2</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Renewals Info Removal</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Renewal_Info_Exp_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Remove Renewals Info when it passes Expiration Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Renewal_Info_Exp_Date_Removal</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Renewal_Info_Removal</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Renewal_Info_Exp_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set Credit Hold Message</fullName>
        <actions>
            <name>Set_Credit_Hold_Message</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Credit_Hold__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Get rid of in Phase2</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Ship To%3A Three Letter Country</fullName>
        <actions>
            <name>Ship_To_Three_Letter_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>LEN(ShippingCountry)&lt;&gt;3</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Untouched Account Email Alert</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Transactional Broadcast,Customer,Prospect</value>
        </criteriaItems>
        <description>If there has been no activity on an Account for 30 days, an email is sent to the Account Owner.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Account.Sales_Last_Touched_On__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
