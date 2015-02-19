@isTest
public with sharing class ShowAllSfObjectsController_test {
    
    static testMethod void onLoadShowAllSfObjects_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.onLoadShowAllSfObjects(); 
      PageReference PageRef = Page.metadatadiff;
      PageRef.getParameters().put('uToken','13');
      PageRef.getParameters().put('dOrgId','DEMO');
      Test.setCurrentPage(PageRef); 
      s.onLoadShowAllSfObjects();  
    }
    
    static testMethod void logoutFrmSf_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.logoutFrmSf(); 
    }
   
    static testMethod void displayExtractedData_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.displayExtractedData(); 
    }
    static testMethod void parseDisplayExtractedData_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.fieldsOfSelObj = new Set<String>();
      s.fieldsOfSelObj.add('IsDeleted');
      s.fieldsOfSelObj.add('Id');
      s.fieldsOfSelObj.add('AccountId');     
      s.parseDisplayExtractedData('<return><demo><develop><test><result><row><Id><![CDATA[0039000000CeNDcAAN]]></Id><IsDeleted><![CDATA[false]]></IsDeleted> <AccountId><![CDATA[0019000000Cc6lHAAR]]></AccountId><LastName><![CDATA[Song]]></LastName><FirstName><![CDATA[Arthur]]></FirstName><Salutation><![CDATA[Mr.]]></Salutation></row><row><Id><![CDATA[0039000000CeNDdAAN]]></Id><IsDeleted><![CDATA[false]]></IsDeleted><AccountId><![CDATA[0019000000Cc6lIAAR]]></AccountId><LastName><![CDATA[Song]]></LastName><FirstName><![CDATA[Arthur]]></FirstName><Salutation><![CDATA[Mr.]]></Salutation></row></result></test></develop></demo></return>'); 
    }
    static testMethod void parseGetSfdcAllObjects_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.parseGetSfdcAllObjects('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:extractDataFromSingleObjectResponse xmlns:ns2="http://ws.service.rabit.com/"><return><export><object name="Contact" rows="30" size="11"/></export></return></ns2:extractDataFromSingleObjectResponse></S:Body></S:Envelope>'); 
    }
    static testMethod void parseGetFieldsObj_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.parseGetFieldsObj('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getRelatedObjectsResponse xmlns:ns2="http://ws.service.rabit.com/"><return><relation selectedobject="Account"><object name="Asset" type="child"/><object name="Case" type="child"/><object name="Contact" type="child"/><object name="Contract" type="child"/><object name="Lead" type="child"/><object name="Opportunity" type="child"/></relation><fields><field type="id">Id</field><field type="_boolean">IsDeleted</field><field type="reference">MasterRecordId</field></fields></return></ns2:getRelatedObjectsResponse></S:Body></S:Envelope>'); 
    }
    static testMethod void parseValidateQuery_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.parseValidateQuery('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:extractDataFromSingleObjectResponse xmlns:ns2="http://ws.service.rabit.com/"><return><export><object name="Contact" rows="30" size="11"/></export></return></ns2:extractDataFromSingleObjectResponse></S:Body></S:Envelope>'); 
    }
    static testMethod void closePopup_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.closePopup(); 
    }
    static testMethod void showPopup_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.quryFilterList = new List<ShowAllSfObjectsController.FilterQuery>();
      ShowAllSfObjectsController.FilterQuery fq= new ShowAllSfObjectsController.FilterQuery();
      fq.field_name='demo';
      fq.field_type='string';
      fq.guid ='qqqqqq';
      fq.operator = 'equals';
      s.quryFilterList.add(fq);    
      s.validateQuery(); 
    }
    static testMethod void goToExtractDataPage_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.quryFilterList = new List<ShowAllSfObjectsController.FilterQuery>();
      ShowAllSfObjectsController.FilterQuery fq= new ShowAllSfObjectsController.FilterQuery();
      fq.field_name='demo';
      fq.field_type='_boolean';
      fq.guid ='qqqqqq';
      fq.operator = 'equals';
      s.quryFilterList.add(fq); 
      ShowAllSfObjectsController.FilterQuery fq1= new ShowAllSfObjectsController.FilterQuery();
      fq1.field_name='demo';
      fq1.field_type='id';
      fq1.guid ='ffffff';
      fq1.operator = 'notequals';
      s.quryFilterList.add(fq1); 
      ShowAllSfObjectsController.FilterQuery fq2= new ShowAllSfObjectsController.FilterQuery();
      fq2.field_name='demo';
      fq2.field_type='string';
      fq2.guid ='gggggg';
      fq2.operator = 'like';
      s.quryFilterList.add(fq2); 
      ShowAllSfObjectsController.FilterQuery fq3= new ShowAllSfObjectsController.FilterQuery();
      fq3.field_name='demo';
      fq3.field_type='string';
      fq3.guid ='hhhhhhh';
      fq3.operator = 'starts';
      s.quryFilterList.add(fq3); 
      ShowAllSfObjectsController.FilterQuery fq4= new ShowAllSfObjectsController.FilterQuery();
      fq4.field_name='demo';
      fq4.field_type='string';
      fq4.guid ='iiiiiiii';
      fq4.operator = 'ends';
      s.quryFilterList.add(fq4);  
      ShowAllSfObjectsController.FilterQuery fq5= new ShowAllSfObjectsController.FilterQuery();
      fq5.field_name='demo';
      fq5.field_type='string';
      fq5.guid ='jjjjjjj';
      fq5.operator = 'contains';
      s.quryFilterList.add(fq5); 
      ShowAllSfObjectsController.FilterQuery fq6= new ShowAllSfObjectsController.FilterQuery();
      fq6.field_name='demo';
      fq6.field_type='string';
      fq6.guid ='kkkkkk';
      fq6.operator = 'lessthan';
      s.quryFilterList.add(fq6); 
      ShowAllSfObjectsController.FilterQuery fq7= new ShowAllSfObjectsController.FilterQuery();
      fq7.field_name='demo';
      fq7.field_type='string';
      fq7.guid ='lllllll';
      fq7.operator = 'greaterthan';
      s.quryFilterList.add(fq7);
      ShowAllSfObjectsController.FilterQuery fq8= new ShowAllSfObjectsController.FilterQuery();
      fq8.field_name='demo';
      fq8.field_type='string';
      fq8.guid ='mmmmmmmm';
      fq8.operator = 'ltorequals';
      s.quryFilterList.add(fq8);  
      ShowAllSfObjectsController.FilterQuery fq9= new ShowAllSfObjectsController.FilterQuery();
      fq9.field_name='demo';
      fq9.field_type='string';
      fq9.guid ='nnnnnnnn';
      fq9.operator = 'gtorequals';
      s.quryFilterList.add(fq9);    
      s.showPopup(); 
    }
    static testMethod void transferData_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.transferData(); 
    }
    static testMethod void cancel_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.cancel(); 
    }
    static testMethod void parseExtractFromSingle_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.parseExtractFromSingle('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:extractDataFromSingleObjectResponse xmlns:ns2="http://ws.service.rabit.com/"><return><export><object name="Contact" rows="30" size="11"/></export></return></ns2:extractDataFromSingleObjectResponse></S:Body></S:Envelope>'); 
    }
    static testMethod void checkValidations_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.fieldName ='';
      s.checkValidations();
      s.fieldName ='rdgr';
      s.enterValue ='';
      s.checkValidations(); 
      s.fieldName ='rdgr';
      s.enterValue ='fe';
      boolean b=s.checkValidations(); 
      System.assertEquals(true, b);
    }
            
    static testMethod void addFilter_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      ShowAllSfObjectsController.FilterQuery s1= new  ShowAllSfObjectsController.FilterQuery(); 
      s.quryFilterList = new List<ShowAllSfObjectsController.FilterQuery>(); 
      s.fieldsMap = new Map<String,String>();
      s.fieldsMap.put('_string','Demo');  
      s.fieldName='Demo';
      s.enterValue ='test';
      s1.field_name='dfdf';
      s1.guid='fhfui';
      s1.operator='jdj';
      s1.value='diojf';  
      s.addFilter();   
      s.fieldName ='';
      s.enterValue ='';
      s.addFilter(); 
    }
    
     static testMethod void deleteFilter_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      ShowAllSfObjectsController.FilterQuery s1= new  ShowAllSfObjectsController.FilterQuery(); 
      s.quryFilterList = new List<ShowAllSfObjectsController.FilterQuery>(); 
      s1.field_name='dfdf';
      s1.guid='fhfui';
      s1.operator='jdj';
      s1.value='diojf';
      s.quryFilterList.add(s1); 
      s.filterDelId = 'fhfui';
      s.deleteFilter();
    }
    
    static testMethod void getOperatorsList_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.getOperatorsList(); 
    }
    
    static testMethod void getFieldsOfSelectedObj_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.getFieldsOfSelectedObj(); 
    }
    
    static testMethod void validateQuery_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.quryFilterList = new List<ShowAllSfObjectsController.FilterQuery>();
      ShowAllSfObjectsController.FilterQuery fq= new ShowAllSfObjectsController.FilterQuery();
      fq.field_name='demo';
      fq.field_type='string';
      fq.guid ='qqqqqq';
      fq.operator = 'equals';
      s.quryFilterList.add(fq);    
      s.validateQuery(); 
    }
    
    static testMethod void getSfdcAllObjects_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.getSfdcAllObjects('bfhibir'); 
    }
    static testMethod void extractFromSingle_test() {
      ShowAllSfObjectsController s=new ShowAllSfObjectsController();
      s.quryFilterList = new List<ShowAllSfObjectsController.FilterQuery>();
      ShowAllSfObjectsController.FilterQuery fq= new ShowAllSfObjectsController.FilterQuery();
      fq.field_name='demo';
      fq.field_type='string';
      fq.guid ='qqqqqq';
      fq.operator = 'equals';
      s.quryFilterList.add(fq);    
      s.extract(); 
    }
    static testMethod void goToExtractDataPage_test1() {
    	ShowAllSfObjectsController s=new ShowAllSfObjectsController();
        s.quryFilterList = new List<ShowAllSfObjectsController.FilterQuery>();
        ShowAllSfObjectsController.FilterQuery fq= new ShowAllSfObjectsController.FilterQuery();
        fq.field_name='demo';
        fq.field_type='string';
        fq.guid ='qqqqqq';
        fq.operator = 'equals';
        s.quryFilterList.add(fq);  
        s.goToExtractDataPage();
    }
}