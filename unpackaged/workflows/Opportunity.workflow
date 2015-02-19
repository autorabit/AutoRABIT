<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ClosureLimit</fullName>
        <field>CloseDate</field>
        <formula>DATE( YEAR(TODAY()) , (MONTH(TODAY()) + 6), DAY(TODAY()))</formula>
        <name>ClosureLimit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
