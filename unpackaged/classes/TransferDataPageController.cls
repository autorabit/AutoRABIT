public class TransferDataPageController {
    
    public String uToken_Param {get;set;}
    
    public List<List<ExtractedData>> xmlDataObjList{ get; set; }
     
    public String destOrgId {get;set;}
    
    public String selectedObj { get; set; }
    
    public List<TransferdResult> transferdResList{ get; set; }
    
    public void onLoadTransferPage() {
       if(System.currentPagereference().getParameters().get('uToken')!= null && System.currentPagereference().getParameters().get('dOrgId')!= null){
             uToken_Param = System.currentPagereference().getParameters().get('uToken').trim();
             destOrgId = System.currentPagereference().getParameters().get('dOrgId').trim();
             transferData();
             if(transferdResList.size()>0){
                for(TransferdResult tr:transferdResList){
                    if(tr.eCount =='0'){
                        displayResultData(tr.sfObjectName+'_success');
                    }else{
                        displayResultData(tr.sfObjectName+'_error');
                    }
                }   
             }
        }
    }
    
    public PageReference logoutFrmSf() {
        Integer st_code = logoutcancel(uToken_Param,destOrgId);
        if(st_code == 200){
            PageReference loginPage = Page.DataLoader;
            loginPage.setRedirect(true);
            return loginPage;
         }
        return null;
    }
    
     public void transferData(){
            http p =new http ();
            httprequest request= new httprequest();
            request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/insertDataToDestination\"');
            string requeststring='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:insertDataToDestination><uToken>'+ uToken_Param +'</uToken></ws:insertDataToDestination></soapenv:Body></soapenv:Envelope>';
            request.setHeader('Content-Length',String.valueOf(requeststring.length()));
            request.setBody(requeststring);
            request.setTimeout(100000);
            if(!Test.isRunningTest()) {   
            HttpResponse res = p.send(request);
                if(res.getStatusCode()== 200){
                   parseTransferData(res.getBodyDocument().toXmlString());
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while logout from Salesforce');
                    ApexPages.addmessage(myMsg);
                }
            }          
        }
    
     public void parseTransferData(String resStr){
         xmldom d = new xmldom(resStr);
         if(d.getElementByTagName('result')!=NULL){
              xmldom.Element resultEle = d.getElementByTagName('result');
              if(resultEle.getElementByTagName('object')!=NULL){
                   xmldom.Element objectEle = resultEle.getElementByTagName('object');
                   transferdResList = new List<TransferdResult>();
                   TransferdResult tr = new TransferdResult();
                  if(objectEle.getAttribute('name')!=NULL ){
                      tr.sfObjectName=objectEle.getAttribute('name');
                  }
                  if(objectEle.getAttribute('ecount')!=NULL ){
                      tr.eCount= objectEle.getAttribute('ecount');
                  }
                  if(objectEle.getAttribute('tcount')!=NULL ){
                      tr.tCount= objectEle.getAttribute('tcount');
                  }
                  if(objectEle.getAttribute('scount')!=NULL ){
                      tr.sCount= objectEle.getAttribute('scount');
                  }
                  transferdResList.add(tr); 
              }
          }  
     }
     
     private Integer logoutcancel(string utoken, String orgid){
            Http http = new Http();
            HttpRequest request= new HttpRequest();
            request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/logoutFromSalesForce\"');
            string requeststring='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:logoutFromSalesForce><source>'+utoken+'</source><target>'+orgid+'</target></ws:logoutFromSalesForce></soapenv:Body></soapenv:Envelope>';          
            request.setHeader('Content-Length',String.valueOf(requeststring.length()));
            request.setBody(requeststring);
            Integer status =0;
            if(!Test.isRunningTest()) {   
                HttpResponse res = http.send(request);
                if(res.getStatusCode()== 200){
                    status = res.getStatusCode();
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while logout from Salesforce');
                    ApexPages.addmessage(myMsg);
                }
            }else{
                status = 200;
            }  
            return status;
    }
    
    public void displayResultData(String resultFileName){
        http p =new http ();
        httprequest request= new httprequest();
        request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=utf-8');
        request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getDataLoaderXMLFileObject\"');
        string requeststring='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getXMLFromCSV><orgname>'+ UserInfo.getOrganizationId() +'</orgname><filename>'+ resultFileName +'</filename><uToken>'+ uToken_Param +'</uToken></ws:getXMLFromCSV></soapenv:Body></soapenv:Envelope>';
        request.setHeader('Content-Length',String.valueOf(requeststring.length()));
        request.setBody(requeststring);
        if(!Test.isRunningTest()) {   
                HttpResponse res = p.send(request);
                if(res.getStatusCode()== 200){
                   parseDisplayResultData(res.getBody());
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Check whether services are runing or not');
                    ApexPages.addmessage(myMsg);
                }
            } 
    }
    
   public void parseDisplayResultData(String resStr){
        List<ExtractedData> rowDataLi;
        Dom.Document doc = new Dom.Document();
        doc.load(resStr);    
        Dom.XMLNode Envelope = doc.getRootElement();
        Dom.XMLNode Body= Envelope.getChildElements()[0].getChildElements()[0].getChildElements()[0];
        system.debug('##################################');
    	system.debug(Body);
    	system.debug('##################################');
        xmlDataObjList = new List<List<ExtractedData>>();
        for(Dom.XMLNode rowChilds : Body.getChildElements()) {
            rowDataLi=new List<ExtractedData>();
            for(Dom.XMLNode rowChildRec : rowChilds.getChildElements()) {
                 ExtractedData ed= new ExtractedData();
                 ed.fieldName = rowChildRec.getName();
                 ed.fieldValue = rowChildRec.getText();
                 rowDataLi.add(ed);
            } 
            xmlDataObjList.add(rowDataLi); 
         }       
   }   
    
    public PageReference goToSfObjPage() {
        return null;
    }


    public String extractResList { get; set; }

    public class TransferdResult{
        public String sfObjectName{ get; set; }
        public String sCount{ get; set; }
        public String eCount{ get; set; }
        public String tCount{ get; set; }
    }
    
    public class ExtractedData{
        public String fieldName{ get; set; }
        public String fieldValue{ get; set; }
    }
}