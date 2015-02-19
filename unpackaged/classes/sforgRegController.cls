public class sforgRegController {

    public String url { get; set; }
    
    public String guid{ get; set;}

    public String sforgType { get; set; }

    public String environment { get; set; }

    public String sforgPckgName { get; set; }

    public String sforgStoken { get; set; }

    public String sforgPassword { get; set; }

    public String sforgUName { get; set; }

    public String sforgName { get; set; }
    
    public void onLoadSforgReg(){
        url ='https://login.salesforce.com';
        if(System.currentPagereference().getParameters().get('sforgName')!= null){
                guid =System.currentPagereference().getParameters().get('sforgName').trim();
                getSfOrgDetails(guid);
            }else{
                guid = getGuid();
            }    
    } 
    
    
    public void getUrlVale(){
        url=environment; 
    }
    
    public String getGuid(){
        String result='';
        for(Integer i=0;i<32;i++){
            result+= (String.valueOf(Integer.valueOf(Math.random()*16))).touppercase();
        }
        return result;
    }
    
    public String getSfOrgRegXmlNode()
       {
             Dom.Document doc = new Dom.Document();
             Dom.Xmlnode rootNode = doc.createRootElement('sandbox', null, null);
             rootNode.setAttribute('id',guid);
             rootNode.setAttribute('name',sforgName);
             rootNode.setAttribute('type',sforgType);
             rootNode.addChildElement('url', null, null).addTextNode(environment);
             rootNode.addChildElement('username', null, null).addTextNode(sforgUName);
             rootNode.addChildElement('password', null, null).addTextNode(encryptPassword(sforgPassword));
             rootNode.addChildElement('stoken', null, null).addTextNode(sforgStoken);
             rootNode.addChildElement('packageName', null, null).addTextNode(sforgPckgName);
             return doc.toXmlString().replace('<?xml version="1.0" encoding="UTF-8"?>','');
      }
    
    public void  CheckSalesforceCredentials(String userName,String password,String url){
        parseOfCheckSalesforceCredentials(testConnectionRequest(userName,password,url));    
       } 
       
    public PageReference parseOfCheckSalesforceCredentials (Integer stsCode){
        if(stsCode == 200){
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Salesforce Organization Credentials Valid');
                   ApexPages.addmessage(myMsg);
                   PageReference sforglistPage = Page.sforgRegList;
                   sforglistPage.setRedirect(true);
                   return sforglistPage;
              }else{
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid.Please Check Salesforce Organization Credentials');
                   ApexPages.addmessage(myMsg);
                   return null;
              }
    } 
    public Integer testConnectionRequest(String userName,String password,String url){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getOrganizationID\"');
            String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getOrganizationID><username>'+ userName +'</username><password>'+ password  +'</password><endpoint>'+ url +'/services/Soap/u/27.0/</endpoint></ws:getOrganizationID></soapenv:Body></soapenv:Envelope>';
            request.setBody('');
            request.setHeader('Content-Length',String.valueOf(requestString.length()));
            request.setBody(requestString);   
            Integer resCode=0;
            if(!Test.isRunningTest()){
                HttpResponse res = http.send(request);
                if(res.getStatusCode()==200){
                    resCode=res.getStatusCode();
                }
            }else{
                resCode=200;
            }
            return resCode ;
    }   
    
    public PageReference cancelSfOrgReg() {
       PageReference sforglistPage = Page.sforgRegList;
       sforglistPage.setRedirect(true);
       return sforglistPage ;
    }

    public PageReference saveSfOrgReg() {
         if(checkValidations()){
            Integer res=testConnectionRequest(sforgUName, sforgPassword +sforgStoken , environment);
             if(res == 200){
                  Integer response = SaveSfOrgDetails(getSfOrgRegXmlNode(),UserInfo.getOrganizationId()+'/servers/sandboxregistration.xml','./sandbox[@id="'+guid+'"]');
                return parseOfSaveSfOrgReg(response);
             }else{
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid.Please Check Salesforce Organization Credentials');
                   ApexPages.addmessage(myMsg);
                   return null;
              }
        }
        return null;       
    }

   public PageReference parseOfSaveSfOrgReg(Integer stsCode){
            if(stsCode== 200){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Salesforce Organization registered sucessfully');
                    ApexPages.addmessage(myMsg);    
                    PageReference sforglistPage = Page.sforgRegList;
                    sforglistPage.setRedirect(true);
                    return sforglistPage ;
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while registering Salesforce Organization');
                    ApexPages.addmessage(myMsg);
                    return null;
                } 
   }

    public PageReference verifySFCredentials() {
        if(checkValidations()){
            CheckSalesforceCredentials(sforgUName, sforgPassword +sforgStoken , environment);
        }
        return null;
    }
    
    public Boolean checkValidations(){
        if(sforgName.equalsIgnoreCase('')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Name empty');
            ApexPages.addmessage(myMsg);
            return false;
       }else if(sforgUName.equalsIgnoreCase('')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave  User Name empty');
            ApexPages.addmessage(myMsg);
            return false;
       }else if(sforgPassword.equalsIgnoreCase('')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Password empty');
            ApexPages.addmessage(myMsg);
            return false;
       }else if(sforgStoken.equalsIgnoreCase('')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Security Token empty');
            ApexPages.addmessage(myMsg);
            return false;
       }else if(sforgPckgName.equalsIgnoreCase('')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Package Name empty');
            ApexPages.addmessage(myMsg);
            return false;
       }         
    return true;
    }
    
     public Integer SaveSfOrgDetails(String xmlNode,String filepath,String xpath)
    {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
            req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/saveXMLData\"');
            String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:saveXMLData><xmlnode>'+ xmlNode +'</xmlnode><filepath>'+ filepath +'</filepath><xpathStr>'+ xpath +'</xpathStr></ws:saveXMLData></soapenv:Body></soapenv:Envelope>';
            req.setHeader('Content-Length',String.valueOf(requestString.length()));
            req.setBody(requestString);   
            Integer stcCode=0;
            if(!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                if(res.getStatusCode()==200){
                    stcCode=res.getStatusCode();
                }
            }  
            
            return stcCode ;
    }
     public void getSfOrgDetails(String sforceOrgName) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
        req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/deleteSelectedSFOrg\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getSelectedSFOrgForEdit><orgname>' +UserInfo.getOrganizationId()+ '</orgname><sfOrgName>'+ sforceOrgName+'</sfOrgName></ws:getSelectedSFOrgForEdit></soapenv:Body></soapenv:Envelope>';
        req.setHeader('Content-Length',String.valueOf(requestString.length()));
        req.setBody(requestString);
        if(!Test.isRunningTest()){
            HttpResponse res = http.send(req);
            if(res.getStatusCode()== 200){  
                setSforgRegistrationDetails(res.getBodyDocument().toXmlString());
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Remote server is down. please try again later...');
                ApexPages.addmessage(myMsg);
            }
        }      
    }
    
     public void setSforgRegistrationDetails(String xmlResponse){
             xmldom d = new xmldom(xmlResponse);
             XMLdom.Element sforceRegEle= d.getElementByTagName('sandbox');
                sforgName=sforceRegEle.getAttribute('name');
                sforgType=sforceRegEle.getAttribute('type');
                guid=sforceRegEle.getAttribute('id');
                 if(sforceRegEle.getElementByTagName('url')!= NULL){
                        environment  = sforceRegEle.getElementByTagName('url').nodeValue;
                        url = sforceRegEle.getElementByTagName('url').nodeValue;
                }
                if(sforceRegEle.getElementByTagName('userName')!= NULL){
                         sforgUName = sforceRegEle.getElementByTagName('userName').nodeValue;
                }
                if(sforceRegEle.getElementByTagName('password')!= NULL){
                         sforgPassword = decryptPassword(sforceRegEle.getElementByTagName('password').nodeValue);
                }
                if(sforceRegEle.getElementByTagName('stoken')!= NULL){
                         sforgStoken = sforceRegEle.getElementByTagName('stoken').nodeValue;
                }
                if(sforceRegEle.getElementByTagName('packageName')!= NULL){
                         sforgPckgName = sforceRegEle.getElementByTagName('packageName').nodeValue;
                }        
    }
    
    public String encryptPassword(String pass){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'text/xml;charset=utf-8');
            req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getEncryptPassword\"');
            String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getEncryptPassword><password>'+ pass +'</password></ws:getEncryptPassword></soapenv:Body></soapenv:Envelope>';
            req.setHeader('Content-Length',String.valueOf(requestString.length()));
            req.setBody(requestString);
            String resStr='';
            if(!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                if(res.getStatusCode()== 200){
                   resStr = encryptPasswordSucess(res.getBodyDocument().toXmlString());     
                }
            }
           return resStr;     
    }
    public String encryptPasswordSucess(String res){
        String resStr; 
        xmldom d = new xmldom(res);
        if(d.getElementByTagName('return')!= NULL){
            resStr = d.getElementByTagName('return').nodeValue;
        }
        return resStr; 
    }
    public String decryptPassword(String pass){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'text/xml;charset=utf-8');
            req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getDecryptPassword\"');
            String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getDecryptPassword><password>'+ pass +'</password></ws:getDecryptPassword></soapenv:Body></soapenv:Envelope>';
            req.setHeader('Content-Length',String.valueOf(requestString.length()));
            req.setBody(requestString);
            String resStr='';
            if(!Test.isRunningTest()){
                 HttpResponse res = http.send(req);
                if(res.getStatusCode()== 200){
                    	resStr = decryptPasswordSucess(res.getBodyDocument().toXmlString());
                    }
                }
           return resStr;     
    }
    public String decryptPasswordSucess(String res){
        String resStr; 
        xmldom d = new xmldom(res);
        if(d.getElementByTagName('return')!= NULL){
            resStr = d.getElementByTagName('return').nodeValue;
        }
        return resStr; 
    }
    
}