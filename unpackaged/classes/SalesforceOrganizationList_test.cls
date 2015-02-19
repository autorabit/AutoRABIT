@isTest
private class SalesforceOrganizationList_test {

    static testMethod void showSalesforceOrganizationRegisterPage_test() {
        SalesforceOrganizationListController sflc = new SalesforceOrganizationListController();
        String url= sflc.ShowSalesforceOrganizationRegisterPage().getUrl();
        System.assertEquals('/apex/rabitforce__sforgregistration', url);
    }
    
     static testMethod void showSfOrgDetails_test() {
        SalesforceOrganizationListController sflc = new SalesforceOrganizationListController();
        sflc.sforgParam='test';
        String url=sflc.showSfOrgDetails().getUrl();
        System.assertEquals('/apex/rabitforce__sforgregistration?edit=true&sforgName=test', url);
     }
     
     static testMethod void deleteSfOrg_test() {
        SalesforceOrganizationListController sflc = new SalesforceOrganizationListController();
        Integer statuscode=sflc.deleteSfOrg('demo, stu, ');
        System.assertEquals(0, statuscode);
     }
    static testMethod void parseDeleteSfOrgRes_test() {
        SalesforceOrganizationListController sflc = new SalesforceOrganizationListController();
        sflc.parseDeleteSfOrgRes(0);
        sflc.parseDeleteSfOrgRes(200);
     }
     
     static testMethod void getsforgRegList_test() {
        SalesforceOrganizationListController sflc = new SalesforceOrganizationListController();
        String response=sflc.getsforgRegList();
        String expectedResult ='<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getXmlFileContentResponse xmlns:ns2="http://ws.service.rabit.com/"><return><sandbox name="semo" type="Dev"><url>https://login.salesforce.com</url><username>rabitforce@dev.com</username><password>rabit@345</password><stoken>UXFtRsSfpIs1tD2DLLbrCIhW</stoken><packageName>SalesAuto</packageName></sandbox></return></ns2:getXmlFileContentResponse></S:Body></S:Envelope>';
        System.assertEquals(expectedResult, response);     
     }
     
     static testMethod void parseXmlResponse_test() {
        SalesforceOrganizationListController sflc = new SalesforceOrganizationListController();
        SalesforceOrganizationListController.SalesforceOrganization s = new SalesforceOrganizationListController.SalesforceOrganization();
        s.name='sdvg';
        s.orgType='nfui';
        s.deleteFlag='true';
        s.guid='fsf';
        s.packageName='gdsggh';
        s.stoken='bfd';
        s.userName='asdfg';
        s.url='vjhfgsjdff';
        sflc.sforgRegList=new List<SalesforceOrganizationListController.SalesforceOrganization>();
        sflc.sforgRegList.add(s);
        String inputStr ='<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getXmlFileContentResponse xmlns:ns2="http://ws.service.rabit.com/"><return><sandboxes><sandbox name="test" type="Dev"><url>https://login.salesforce.com</url><username>rabitforce@dev.com</username><password>rabit@345</password><stoken>UXFtRsSfpIs1tD2DLLbrCIhW</stoken><packageName>SalesAuto</packageName></sandbox><sandbox name="semo" type="Dev"><url>https://login.salesforce.com</url><username>rabitforce@dev.com</username><password>rabit@345</password><stoken>UXFtRsSfpIs1tD2DLLbrCIhW</stoken><packageName>SalesAuto</packageName></sandbox></sandboxes></return></ns2:getXmlFileContentResponse></S:Body></S:Envelope>';
        sflc.parseXmlResponse(inputStr);
         }
     
     static testMethod void getSelectedDeleteOrg_test() {
        SalesforceOrganizationListController sflc = new SalesforceOrganizationListController();
        SalesforceOrganizationListController.SalesforceOrganization s = new SalesforceOrganizationListController.SalesforceOrganization();
        s.name='sdvg';
        s.orgType='nfui';
        s.deleteFlag='true';
        s.guid='Demo';
        s.packageName='gdsggh';
        s.stoken='bfd';
        s.userName='asdfg';
        s.url='vjhfgsjdff';
        sflc.sforgRegList=new List<SalesforceOrganizationListController.SalesforceOrganization>();
        sflc.sforgRegList.add(s);
        String retVal=sflc.getSelectedDeleteOrg();
        System.assertEquals(',Demo',retVal);
     }
     static testMethod void getRegisterdSfOrgList_test(){
     	SalesforceOrganizationListController sflc = new SalesforceOrganizationListController();
     	sflc.getRegisterdSfOrgList();
     }
     static testMethod void deleteSfOrgSandbox_test(){
       SalesforceOrganizationListController sflc = new SalesforceOrganizationListController();
       SalesforceOrganizationListController.SalesforceOrganization s = new SalesforceOrganizationListController.SalesforceOrganization();
       s.name='sdvg';
       s.orgType='nfui';
       s.deleteFlag='true';
       s.guid='fsf';
       s.packageName='gdsggh';
       s.stoken='bfd';
       s.userName='asdfg';
       s.url='vjhfgsjdff';
       sflc.sforgRegList=new List<SalesforceOrganizationListController.SalesforceOrganization>();
       sflc.sforgRegList.add(s);
       sflc.deleteSfOrgSandbox();
     }
}