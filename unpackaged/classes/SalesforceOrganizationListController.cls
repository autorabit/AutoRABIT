public class SalesforceOrganizationListController {

    public String sforgParam { get; set; }
    public String deleteSfOrgName{ get; set; }
    public list<SalesforceOrganization> sforgRegList{get;set;}
    
    public PageReference getRegisterdSfOrgList (){
        parseXmlResponse(getsforgRegList());
        return null;
    }

    public PageReference deleteSfOrgSandbox() {
        String selList=getSelectedDeleteOrg();
         parseDeleteSfOrgRes(deleteSfOrg(selList));   
        return null;
    }
    
    public String getSelectedDeleteOrg(){
        String selectedList='';
        String isChecked;
       for (Integer i = sforgRegList.size()-1; i >= 0 ; --i) {
             isChecked = sforgRegList[i].deleteFlag;
            if (isChecked.equalsIgnoreCase('true')) {
                selectedList=selectedList+','+sforgRegList[i].guid;
            }
           }
           return selectedList;
    }   
        public String getsforgRegList()
        {      
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
                req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getXmlFileContent\"');
                String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getXmlFileContent><orgname>' +UserInfo.getOrganizationId()+ '</orgname><filepath>servers//sandboxregistration.xml</filepath></ws:getXmlFileContent></soapenv:Body></soapenv:Envelope>';
                req.setHeader('Content-Length',String.valueOf(requestString.length()));
                req.setBody(requestString);
                sforgRegList=new List<SalesforceOrganization>();
                String result='';
                if (!Test.isRunningTest()){
                    HttpResponse res = http.send(req);
                    if(res.getStatusCode()== 200){
                        result =res.getBodyDocument().toXmlString();
                    }else{
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'please check the network connection');
                        ApexPages.addmessage(myMsg);
                    }
                }else{
                    if(Test.isRunningTest()){
                        result='<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getXmlFileContentResponse xmlns:ns2="http://ws.service.rabit.com/"><return><sandbox name="semo" type="Dev"><url>https://login.salesforce.com</url><username>rabitforce@dev.com</username><password>rabit@345</password><stoken>UXFtRsSfpIs1tD2DLLbrCIhW</stoken><packageName>SalesAuto</packageName></sandbox></return></ns2:getXmlFileContentResponse></S:Body></S:Envelope>';
                    }
                } 
                return result;   
        }

    public PageReference ShowSalesforceOrganizationRegisterPage() {
       PageReference sfOrgRegPage = Page.sforgregistration;
                sfOrgRegPage.setRedirect(true);
                return sfOrgRegPage;
    }
    
     public Integer deleteSfOrg(String sforceOrgName) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
        req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/deleteSelectedSFOrg\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:deleteSelectedSFOrg><orgname>' +UserInfo.getOrganizationId()+ '</orgname><sfOrgName>'+ sforceOrgName+'</sfOrgName></ws:deleteSelectedSFOrg></soapenv:Body></soapenv:Envelope>';
        req.setHeader('Content-Length',String.valueOf(requestString.length()));
        req.setBody(requestString);
        Integer statucode =0;      
        if (!Test.isRunningTest()){
            HttpResponse res = http.send(req);
             if(res.getStatusCode()== 200){
                    statucode = res.getStatusCode();
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'please check the network connection');
                    ApexPages.addmessage(myMsg);
                }    
        } 
        return statucode; 
    }
       
       public void parseDeleteSfOrgRes(Integer statusCode){
        if(statusCode== 200){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Salesforce Organization deleted sucessfully');
            ApexPages.addmessage(myMsg);
            getRegisterdSfOrgList();
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while deleting Salesforce Organization');
            ApexPages.addmessage(myMsg);
        }
       }
        
     public PageReference showSfOrgDetails() {
        PageReference editsfOrgRegPage = Page.sforgregistration;
        editsfOrgRegPage.getParameters().put('sforgName',sforgParam);
        editsfOrgRegPage.getParameters().put('edit','true');
        editsfOrgRegPage.setRedirect(false);
        return editsfOrgRegPage ;
    }
    
    public void parseXmlResponse(String xmlResponse){
             xmldom d = new xmldom(xmlResponse);
             List<XMLdom.Element> sandboxEles= d.getElementsByTagName('sandbox');
              for(XMLdom.Element sforceRegEle: sandboxEles){
                SalesforceOrganization sforceOrg= new SalesforceOrganization();
                sforceOrg.name=sforceRegEle.getAttribute('name');
                sforceOrg.orgType=sforceRegEle.getAttribute('type');
                sforceOrg.guid=sforceRegEle.getAttribute('id');
                 if(sforceRegEle.getElementByTagName('url')!= NULL){
                         sforceOrg.url = sforceRegEle.getElementByTagName('url').nodeValue;
                }
                if(sforceRegEle.getElementByTagName('userName')!= NULL){
                         sforceOrg.userName = sforceRegEle.getElementByTagName('userName').nodeValue;
                }
                if(sforceRegEle.getElementByTagName('stoken')!= NULL){
                         sforceOrg.stoken = sforceRegEle.getElementByTagName('stoken').nodeValue;
                }
                if(sforceRegEle.getElementByTagName('packageName')!= NULL){
                         sforceOrg.packageName = sforceRegEle.getElementByTagName('packageName').nodeValue;
                }   
                sforgRegList.add(sforceOrg);
              }
    }
      
    public class SalesforceOrganization{
        public String name { get; set; }
        public String orgType{ get; set; }
        public String url{ get; set; }
        public String userName{ get; set; }
        public String stoken{ get; set; }
        public String packageName{ get; set; }
        public String deleteFlag{ get; set; }
        public String guid{ get; set; }
    }    
}