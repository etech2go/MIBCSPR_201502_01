<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Broadcast_Items_have_been_changed_by_AE</fullName>
        <description>Email Route To Office when Broadcast Items have been changed by AE</description>
        <protected>false</protected>
        <recipients>
            <field>Route_To_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Broadcast_Items_have_been_changed_by_AE</template>
    </alerts>
    <fieldUpdates>
        <fullName>Item_on_Broadcast_Items</fullName>
        <field>ItemNumber__c</field>
        <formula>IF( Opportunity__r.Broadcast_Item_Count__c   &lt;=9,   TEXT(Opportunity__r.Broadcast_Item_Count__c  + 1), TEXT(Opportunity__r.Broadcast_Item_Count__c + 1 ))</formula>
        <name>Item # on Broadcast Items</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Locked_BI</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Locked_Broadcast_Item</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Locked BI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unlocked_BI</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Broadcast_Item</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Unlocked BI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Add_l_10_minutes</fullName>
        <field>Add_l_10_minutes__c</field>
        <formula>Add_l_10_min_Video_Tape__c +
Add_l_10_min_DigiCombo__c + 
Add_l_10_min_Digital_Clip__c + 
Add_l_10_min_DVD_Clip__c + 
Add_l_10_min_HD_Digital_Blu_Ray_Combo__c + 
Add_l_10_min_HD_Digital_Clip__c + 
Add_l_10_min_Pro_Clip_Fee__c + 
Add_l_10_min_ProCombo_Fee__c + 
Add_l_10_min_Radio_Clip_Fee__c</formula>
        <name>Update Add&apos;l 10 minutes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Discount_to_0</fullName>
        <field>Discount__c</field>
        <formula>0</formula>
        <name>Update Discount to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opp_Voided_field</fullName>
        <field>Opp_Voided__c</field>
        <literalValue>1</literalValue>
        <name>Update Opp Voided field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Price_before_Fees</fullName>
        <field>Price_Before_Fees__c</field>
        <formula>Video_Tape_Detail_Costs__c +
DVD_Video_Detail_Costs__c +
 DVD_Data_Detail_Costs__c +
 Digital_Clip_Detail_Costs__c +
 Transcript_Detail_Costs__c +
 DigiCombo_Video_Detail_costs__c +
 DigiCombo_Data_Detail_Costs__c +
 Reel_Detail_Costs__c +
 Download_Detail_Costs__c +
 Sync_Detail_Costs__c +
 Add_l_Digital_Views_Detail_Costs__c + 
 Report_Ad_Hoc_Detail_Costs__c +
 Report_Flat_Rate_Detail_Costs__c +
  Report_Per_Hit_Detail_Costs__c  + 
 Inventory_Item_Pricing__c</formula>
        <name>Update Price before Fees</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Route_To_Email</fullName>
        <field>Route_To_Email__c</field>
        <formula>Route_To_Email_2__c</formula>
        <name>Update Route To Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Shipping_from_BI</fullName>
        <field>Shipping_Cost__c</field>
        <formula>IF(  Opportunity__r.Subtotal__c &gt; 0, 
IF(  Opportunity__r.Redo_Item_s__c = TRUE, 0.00, CASE( Opportunity__r.Shipping_Method__c , &quot;FedEx: 1st by 8AM&quot;, 93.60,&quot;FedEx: 2 Day&quot;, 22.50,&quot;FedEx: Alaska/Hawaii&quot;, 44.00, &quot;FedEx: Canada&quot;, 58.00, &quot;FedEx: Ground&quot;, 14.00, &quot;FedEx: International&quot;, 85.00, &quot;FedEx: Priority&quot;, 30.00, &quot;FedEx: Saturday&quot;, 48.00, &quot;FedEx: Standard&quot;, 24.00, &quot;Messenger: RUSH&quot;, 40.00, &quot;MESSENGER&quot;, 17.00, 0.00))
,0)</formula>
        <name>Update Shipping from BI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_TCS</fullName>
        <field>TCS__c</field>
        <formula>IF(ISPICKVAL(Opportunity__r.StageName, &quot;Closed Lost&quot;)  ||    (ISPICKVAL(Opportunity__r.StageName, &quot;Voided&quot;)), 0,
IF( Clip_Package_Selected__c &lt;&gt; &quot;&quot;, 1 +  How_many_Clip_Packages_to_pay_for_Fees__c  , 0))</formula>
        <name>Update TCS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_Fees</fullName>
        <field>Total_Fees__c</field>
        <formula>Total_Removable_Fees__c + 
Total_Non_Removable_Fees__c+
IF(  Exclude_Add_l_10_Min_Fee__c  = False,   Add_l_10_minutes__c  , 0 ) +
IF( Exclude_Outside_Market_Fee__c = False,Outside_Market_Fee_26_50__c,0) + 
IF( Exclude_Outside_Market_Fee__c = False,Outside_Market_Fee_51_100__c,0) + 
IF(Exclude_Outside_Market_Fee__c = False,Outside_Market_Fee_100_150__c,0) + 
IF(Exclude_Outside_Market_Fee__c = False,Outside_Market_Fee_150__c,0)+
Misc_Fee__c</formula>
        <name>Update Total Fees</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_Sale</fullName>
        <field>Total_Sale__c</field>
        <formula>Subtotal_w_Discount__c</formula>
        <name>Update Total Sale</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Broadcast Items have been changed by AE</fullName>
        <actions>
            <name>Broadcast_Items_have_been_changed_by_AE</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email alert to the Route To Office if certain fields are changed.</description>
        <formula>AND(  $Profile.Name=&quot;Broadcast Transaction Sales User&quot; , NOT(ISBLANK( Route_To_Email_2__c )),  OR(  ISCHANGED(Shipping_Method__c) ,  ISCHANGED(Format_Options__c) ,  ISCHANGED(Air_Date__c) ,  ISCHANGED(Air_Time__c) ,  ISCHANGED(Subject_Description__c) )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Discount is Null</fullName>
        <actions>
            <name>Update_Discount_to_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Broadcast_Item__c.Discount__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Sets the Broadcast Item.Discount to 0 if it&apos;s blank.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Item %23 on Broadcast Items</fullName>
        <actions>
            <name>Item_on_Broadcast_Items</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Broadcast_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Broadcast Item</value>
        </criteriaItems>
        <description>Set the Item # on Broadcast Items</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Locked BI</fullName>
        <actions>
            <name>Locked_BI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Broadcast_Item__c.Locked__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Unlocked BI</fullName>
        <actions>
            <name>Unlocked_BI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Broadcast_Item__c.Locked__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Add%27l 10 minutes</fullName>
        <actions>
            <name>Update_Add_l_10_minutes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9</booleanFilter>
        <criteriaItems>
            <field>Broadcast_Item__c.Add_l_10_min_DigiCombo__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Broadcast_Item__c.Add_l_10_min_Digital_Clip__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Broadcast_Item__c.Add_l_10_min_DVD_Clip__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Broadcast_Item__c.Add_l_10_min_HD_Digital_Blu_Ray_Combo__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Broadcast_Item__c.Add_l_10_min_HD_Digital_Clip__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Broadcast_Item__c.Add_l_10_min_Pro_Clip_Fee__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Broadcast_Item__c.Add_l_10_min_ProCombo_Fee__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Broadcast_Item__c.Add_l_10_min_Radio_Clip_Fee__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Broadcast_Item__c.Add_l_10_min_Video_Tape__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates the Broadcast Item.Add&apos;l 10 minutes with the Additional 10 minute fee.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Price before Fees</fullName>
        <actions>
            <name>Update_Price_before_Fees</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Broadcast_Item__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates the Broadcast Item.Price Before Fees total.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Route To Email</fullName>
        <actions>
            <name>Update_Route_To_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Route_To_Email_2__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Shipping Costs</fullName>
        <actions>
            <name>Update_Shipping_from_BI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Broadcast_Item__c.Account__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Total Sale and TCS</fullName>
        <actions>
            <name>Update_TCS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Total_Sale</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Broadcast_Item__c.Item_Status__c</field>
            <operation>notEqual</operation>
            <value>Order Voided,Completed</value>
        </criteriaItems>
        <description>Updates pricing on the Broadcast item for rollup to Opportunity</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
