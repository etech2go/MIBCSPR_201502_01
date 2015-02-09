<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_Owner_Assigned</fullName>
        <description>Case Owner Assigned</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Case_Assigned</template>
    </alerts>
    <alerts>
        <fullName>Email_CS_when_DCS_closes_a_Case</fullName>
        <description>Email CS when DCS closes a Case</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_Case_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_CS_when_DCS_Closes_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_CS_when_DCS_needs_more_information</fullName>
        <description>Email CS when DCS needs more information</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_Case_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/DCS_More_Information_Needed</template>
    </alerts>
    <alerts>
        <fullName>Email_Case_Owner_when_CA_ticket</fullName>
        <description>Email Case Owner when CA ticket</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/New_Contract_Admin_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_Case_Owner_when_Jira_Ticket_Number_is_filled_in</fullName>
        <description>Email Case Owner when Jira Ticket Number is filled in</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Jira_Number</template>
    </alerts>
    <alerts>
        <fullName>Email_Case_Owner_when_SD_Ticket_Number_is_filled_in</fullName>
        <description>Email Case Owner when SD Ticket Number is filled in</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/SD_Ticket_Number</template>
    </alerts>
    <alerts>
        <fullName>Email_Case_Owner_when_more_information_is_needed</fullName>
        <description>Email Case Owner when more information is needed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/More_Information_Needed</template>
    </alerts>
    <alerts>
        <fullName>Email_DCS_when_a_new_Case_comes_in</fullName>
        <description>Email DCS when a new Case comes in</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/DCS_Case_Assigned</template>
    </alerts>
    <alerts>
        <fullName>Email_Laura_MacMillan_when_SSG_Case_has_no_assignment</fullName>
        <description>Email Laura MacMillan when SSG Case has no SSG Rep</description>
        <protected>false</protected>
        <recipients>
            <recipient>laura.macmillan@cision.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_Laura_when_SSG_Rep_is_not_assigned</template>
    </alerts>
    <alerts>
        <fullName>Email_Renewal_Rep_About_Case</fullName>
        <description>Email Renewal Rep About Case</description>
        <protected>false</protected>
        <recipients>
            <field>Renewal_Rep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_Renewal_Rep_About_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_Renewal_Rep_About_Missed_Coverage</fullName>
        <description>Email Renewal Rep About Missed Coverage</description>
        <protected>false</protected>
        <recipients>
            <field>Renewal_Rep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_Renewal_Rep_About_Missed_Coverage</template>
    </alerts>
    <alerts>
        <fullName>Email_Renewal_Rep_about_changed_terms</fullName>
        <description>Email Renewal Rep about changed terms</description>
        <protected>false</protected>
        <recipients>
            <field>Renewal_Rep__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/Email_Renewal_Rep_About_Changed_Terms</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_Case_Owner_if_new_email_arrives</fullName>
        <description>Send Notification to Case Owner if new email arrives</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notify_Case_Owner_if_new_email_comes</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_to_CS_Case_Owner_when_SSG_Case_Resolved</fullName>
        <description>Send an email to CS Case Owner when SSG Case Resolved</description>
        <protected>false</protected>
        <recipients>
            <recipient>lisa.murer@cision.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cision_Workflow_Templates/SSG_Resolved_Case</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_to_Sales_Support_when_a_new_Sales_Support_Case_is_created</fullName>
        <description>Send an email to Sales Support when a new Sales Support Case is created</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales_Support</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Templates/Sales_Support_Case_Assigned</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Route_to_SSG_Date_to_blank</fullName>
        <field>Route_to_SSG_Date__c</field>
        <name>Set Route to SSG Date to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Route_to_SSG_to_False</fullName>
        <field>Route_to_SSG__c</field>
        <literalValue>0</literalValue>
        <name>Set Route to SSG to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SSG_Rep_to_Blank</fullName>
        <field>SSG_Rep__c</field>
        <name>Set SSG Rep to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SSG_Rep</fullName>
        <field>SSG_Rep__c</field>
        <lookupValue>laura.macmillan@cision.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update SSG Rep</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>DCS Case Notification</fullName>
        <actions>
            <name>Email_DCS_when_a_new_Case_comes_in</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>DCS Button</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email CS when DCS Closes Case</fullName>
        <actions>
            <name>Email_CS_when_DCS_closes_a_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>DCS Button</value>
        </criteriaItems>
        <description>Update: Email Client Services when DCS Closes a Case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Case Owner when CA Ticket</fullName>
        <actions>
            <name>Email_Case_Owner_when_CA_ticket</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Contract Admin</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email Case Owner when Jira Ticket</fullName>
        <actions>
            <name>Email_Case_Owner_when_Jira_Ticket_Number_is_filled_in</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_SSG_Rep</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change: Email CS Case Owner when Jira Ticket Number is filled in</description>
        <formula>NOT(ISBLANK(Jira_Number__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Case Owner when SD Ticket</fullName>
        <actions>
            <name>Email_Case_Owner_when_SD_Ticket_Number_is_filled_in</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Change: Email CS Case Owner when Service Desk Ticket Number is filled in</description>
        <formula>NOT(ISBLANK(Service_Desk_Ticket_Number__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Case Owner when more info needed</fullName>
        <actions>
            <name>Email_Case_Owner_when_more_information_is_needed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Issue_Status__c</field>
            <operation>equals</operation>
            <value>More Information Needed</value>
        </criteriaItems>
        <description>Change: When Issue Status is More Information Needed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Case Owner when more info needed by DCS</fullName>
        <actions>
            <name>Email_CS_when_DCS_needs_more_information</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.DCS_Issue_Status__c</field>
            <operation>equals</operation>
            <value>More Information Needed</value>
        </criteriaItems>
        <description>Change: When DCS Issue Status is More Information Needed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Laura when SSG Rep is not assigned</fullName>
        <active>true</active>
        <description>Change: Email Laura MacMillan when SSG Rep hasn&apos;t been assigned in 30 minutes.</description>
        <formula>AND( Route_to_SSG__c=TRUE, ISBLANK(SSG_Rep__c), OR(VALUE(MID(TEXT(Route_to_SSG_Date__c),12,2))&gt;13, VALUE(MID(TEXT(Route_to_SSG_Date__c),12,2))&lt;22) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Laura_MacMillan_when_SSG_Case_has_no_assignment</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Route_to_SSG_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Missed Coverage</fullName>
        <actions>
            <name>Email_Renewal_Rep_About_Missed_Coverage</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Sub_Topic__c</field>
            <operation>equals</operation>
            <value>Missed/Incorrect article</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Renewal_Rep__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Case Owner if new email comes</fullName>
        <actions>
            <name>Send_Notification_to_Case_Owner_if_new_email_arrives</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Last_Emailed__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Sales Alert</fullName>
        <actions>
            <name>Email_Renewal_Rep_About_Case</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Case_Notification</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Notify_Sales__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Renewal_Rep__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Sends an email to the Renewal Rep whenever a Case closes with Notify Sales? ticked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Support Case Notification</fullName>
        <actions>
            <name>Send_an_email_to_Sales_Support_when_a_new_Sales_Support_Case_is_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Sales Support Button</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Search Terms Changed</fullName>
        <actions>
            <name>Email_Renewal_Rep_about_changed_terms</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 4 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Sub_Topic__c</field>
            <operation>equals</operation>
            <value>Reading instructions</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Sub_Topic__c</field>
            <operation>equals</operation>
            <value>Search agent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Renewal_Rep__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Email when Case allocated an Owner</fullName>
        <actions>
            <name>Case_Owner_Assigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Case_Owner_Assigned__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update to Case Owner: Send an Email when a Case is allocated an Owner (for Round Robin Allocations Only)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
