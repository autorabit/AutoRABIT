@isTest
public with sharing class metadataDiffController_test {

		static testMethod void onLoadMetaDataDiffPage_test() {
            metadataDiffController m = new metadataDiffController();
			m.onLoadMetaDataDiffPage();	
            PageReference PageRef = Page.metadatadiff;
            PageRef.getParameters().put('uToken','13');
            PageRef.getParameters().put('dOrgId','DEMO');
            Test.setCurrentPage(PageRef);
			m.onLoadMetaDataDiffPage();			
		}
    
	    static testMethod void Cancel_test() {
			metadataDiffController m = new metadataDiffController();
			m.Cancel();			
		}	
    
		static testMethod void loadSfObjects_test() {
			metadataDiffController m = new metadataDiffController();
			m.loadSfObjects();			
		}
    
		static testMethod void getMetadataDifference_test() {
			metadataDiffController m = new metadataDiffController();
			m.getMetadataDifference('bhvb');			
		}
    
		static testMethod void parseGetMetadataDifference_test() {
			metadataDiffController m = new metadataDiffController();
			m.parseGetMetadataDifference('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:checkMetaDataResponse xmlns:ns2="http://ws.service.rabit.com/"><return><sourcediff status="true"><object>smagicbasic__SMS_Magic_Security_Setting__c</object><object>LoginDetail__c</object><object>PRDepartment__c</object><object>Life_Event__c</object><object>PRLeavesConfigure__c</object><object>PRCtc__c</object><object>PRHolidaysMaster__c</object><object>PRTaxMaster__c</object><object>PRBranch__c</object><object>codebackup__SVN__c</object><object>Daily_Tasks__c</object><object>PRLeavesMaster__c</object><object>smagicbasic__smsMagic__c</object><object>schedule__c</object><object>smagicbasic__SMS_SenderId__c</object><object>PRPosition__c</object><object>PRPay_Roll__c</object><object>PREmployee__c</object><object>LoginSession__c</object><object>smagicbasic__SMS_Template__c</object><object>PRManager__c</object><object>smagicbasic__SMS_Template_Type__c</object><trigger>smagicbasic__SendSMSTrigger</trigger><trigger>contactemail</trigger><trigger>codebackup__TestTigger</trigger></sourcediff></return></ns2:checkMetaDataResponse></S:Body></S:Envelope>');
			m.parseGetMetadataDifference('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:checkMetaDataResponse xmlns:ns2="http://ws.service.rabit.com/"><return><sourcediff status="true"><validationrule>smagicbasic__SMS_Magic_Security_Setting__c</validationrule><validationrule>LoginDetail__c</validationrule><validationrule>PRDepartment__c</validationrule><validationrule>Life_Event__c</validationrule><validationrule>PRLeavesConfigure__c</validationrule><validationrule>PRCtc__c</validationrule><validationrule>PRHolidaysMaster__c</validationrule><validationrule>PRTaxMaster__c</validationrule><validationrule>PRBranch__c</validationrule><validationrule>codebackup__SVN__c</validationrule><validationrule>Daily_Tasks__c</validationrule><validationrule>PRLeavesMaster__c</validationrule><validationrule>smagicbasic__smsMagic__c</validationrule><validationrule>schedule__c</validationrule><validationrule>smagicbasic__SMS_SenderId__c</validationrule><validationrule>PRPosition__c</validationrule><validationrule>PRPay_Roll__c</validationrule><validationrule>PREmployee__c</validationrule><validationrule>LoginSession__c</validationrule><validationrule>smagicbasic__SMS_Template__c</validationrule><validationrule>PRManager__c</validationrule><validationrule>smagicbasic__SMS_Template_Type__c</validationrule><trigger>smagicbasic__SendSMSTrigger</trigger><trigger>contactemail</trigger><trigger>codebackup__TestTigger</trigger></sourcediff></return></ns2:checkMetaDataResponse></S:Body></S:Envelope>');	
			m.parseGetMetadataDifference('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:checkMetaDataResponse xmlns:ns2="http://ws.service.rabit.com/"><return><sourcediff status="true"><trigger>smagicbasic__SMS_Magic_Security_Setting__c</trigger><trigger>LoginDetail__c</trigger><trigger>PRDepartment__c</trigger><trigger>Life_Event__c</trigger><trigger>PRLeavesConfigure__c</trigger><trigger>PRCtc__c</trigger><trigger>PRHolidaysMaster__c</trigger><trigger>PRTaxMaster__c</trigger><trigger>PRBranch__c</trigger><trigger>codebackup__SVN__c</trigger><trigger>Daily_Tasks__c</trigger><trigger>PRLeavesMaster__c</trigger><trigger>smagicbasic__smsMagic__c</trigger><trigger>schedule__c</trigger><trigger>smagicbasic__SMS_SenderId__c</trigger><trigger>PRPosition__c</trigger><trigger>PRPay_Roll__c</trigger><trigger>PREmployee__c</trigger><trigger>LoginSession__c</trigger><trigger>smagicbasic__SMS_Template__c</trigger><trigger>PRManager__c</trigger><trigger>smagicbasic__SMS_Template_Type__c</trigger><trigger>smagicbasic__SendSMSTrigger</trigger><trigger>contactemail</trigger><trigger>codebackup__TestTigger</trigger></sourcediff></return></ns2:checkMetaDataResponse></S:Body></S:Envelope>');		
            m.parseGetMetadataDifference('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:checkMetaDataResponse xmlns:ns2="http://ws.service.rabit.com/"><return><sourcediff status="false"/></return></ns2:checkMetaDataResponse></S:Body></S:Envelope>');		
		}
    
		static testMethod void logoutcancel_test() {
			metadataDiffController m = new metadataDiffController();
			m.logoutcancel('fsfdfd','sdfsd');			
		}
}