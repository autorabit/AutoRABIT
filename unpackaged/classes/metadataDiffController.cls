public class metadataDiffController {

     public String uToken_Param {get;set;}
     
     public String destOrgId {get;set;}
     
     public list<string> srcobj {get;set;}
        
     public list<string> srcTrigg {get;set;}
    
     public list<string> srcvalidation {get;set;}
     
     public PageReference onLoadMetaDataDiffPage() {
         if(System.currentPagereference().getParameters().get('uToken')!= null && System.currentPagereference().getParameters().get('dOrgId')!= null){
             uToken_Param = System.currentPagereference().getParameters().get('uToken').trim();
             destOrgId = System.currentPagereference().getParameters().get('dOrgId').trim();
             return getMetadataDifference(uToken_Param);
          }
         return null;   
    }


    public PageReference Cancel() {
        Integer st_code = logoutcancel(uToken_Param,destOrgId);
        if(st_code == 200){
            PageReference loginPage = Page.DataLoader;
            loginPage.setRedirect(true);
            return loginPage;
         }
        return null;
    }

   public PageReference loadSfObjects() {
        PageReference loadSfObjectsPage = Page.showAllSfObjects;
        loadSfObjectsPage.getParameters().put('uToken',uToken_Param);
        loadSfObjectsPage.getParameters().put('dOrgId',destOrgId);
        loadSfObjectsPage.setRedirect(true);
        return loadSfObjectsPage;
    }
     
     public PageReference getMetadataDifference(string utoken){
            http p =new http ();
            httprequest request= new httprequest();
            request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/checkMetaDataResponse\"');
            string requeststring='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:checkMetaData><uToken>'+utoken+'</uToken></ws:checkMetaData></soapenv:Body></soapenv:Envelope>';
            request.setHeader('Content-Length',String.valueOf(requeststring.length()));
            request.setBody(requeststring);
            if(!Test.isRunningTest()) {   
                HttpResponse res = p.send(request);
                if(res.getStatusCode()== 200){
                   return parseGetMetadataDifference(res.getBodyDocument().toXmlString());
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Check whether services are runing or not');
                    ApexPages.addmessage(myMsg);
                }
            } 
            return null;
     } 
       
   public PageReference parseGetMetadataDifference(String StrResponse){
       xmldom d = new xmldom(StrResponse);
       if(d.getElementByTagName('sourcediff')!=NULL){
            XMLdom.Element sourcediffEle = d.getElementByTagName('sourcediff');
            String diffIndicate= sourcediffEle.getAttribute('status');
            if(diffIndicate.equalsIgnoreCase('true')){
                 List<xmldom.Element> objectList = sourcediffEle.getElementsByTagName('object');
                 List<xmldom.Element> validationruleList = sourcediffEle.getElementsByTagName('validationrule');
                 List<xmldom.Element> triggerList = sourcediffEle.getElementsByTagName('trigger');
                 if(objectList.size()>0){
                     srcobj=new list<string>();
                     for(xmldom.Element obj:objectList){
                         srcobj.add(obj.nodeValue);
                     }
                 
                 }
                 if(validationruleList.size()>0){
                     srcvalidation=new list<string>();
                     for(xmldom.Element vald:validationruleList){
                         srcvalidation.add(vald.nodeValue);
                     }
                 }
                 if(triggerList.size()>0){
                     srcTrigg=new list<string>();
                     for(xmldom.Element trig:triggerList){
                         srcTrigg.add(trig.nodeValue);
                     }
                 }
            }else{
                return loadSfObjects();
            }  
         }
         return null;
     }  
       
   
   public Integer logoutcancel(string utoken, String orgid){
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
               status=200; 
            }
         return status;
    }
}