public class ShowAllSfObjectsController {
    
    public String limitQry { get; set; }

    public String fieldColName { get; set; }

    public String filterDelId
    { get; set; }
    
    public Map<String, String> fieldsMap {get; set; }
    
    public String selectedvalue { get; set; } 
      
    public String oper { get; set; }

    public String fieldName { get; set; }
    
    public Set<String> fieldsOfSelObj {get;set;}

    public List<ExtractedResult> extractResList{ get; set; }
    
    public List<List<ExtractedData>> xmlDataObjList{ get; set; }
    
    public String enterValue { get; set; }
    
    public String uToken_Param {get;set;}
     
    public String destOrgId {get;set;}
    
    public Boolean disableValidate {get;set;}
    
    public Boolean disableExtract {get;set;}

    public String selectedObj
    { get; set; }
    
    public List<SelectOption> allObjFields { get; set; }
    
    public List<SelectOption> operators { get; set; }
    
    public List<FilterQuery> quryFilterList { get; set; }
    
    public List<SalesForceObject> sfObjList { get; set; }
     
    public String allrec { get; set; }

    public boolean displayPopup {get; set;}
    
    public void onLoadShowAllSfObjects() {
        if(System.currentPagereference().getParameters().get('uToken')!= null && System.currentPagereference().getParameters().get('dOrgId')!= null){
             uToken_Param = System.currentPagereference().getParameters().get('uToken').trim();
             destOrgId = System.currentPagereference().getParameters().get('dOrgId').trim();
             getSfdcAllObjects(uToken_Param);
        }
        disableValidate = true;
        disableExtract = true;
        getOperatorsList();
        quryFilterList = new List<FilterQuery>(); 
    }
    
     public PageReference goToExtractDataPage() {
         extractFromSingle();
         pagereference pg = new pagereference('/apex/extractDataPage');
         return pg;
    }


    public PageReference extract() {
        extractFromSingle();
        pagereference pg = new pagereference('/apex/extractDataPage');
        return pg;
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

     public Boolean checkValidations(){
        if(fieldName.trim().equalsIgnoreCase('')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Field empty');
            ApexPages.addmessage(myMsg);
            return false;
       }else if(enterValue.trim().equalsIgnoreCase('')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave  Value empty');
            ApexPages.addmessage(myMsg);
            return false;
       }
    return true;
    }
    
    public void addFilter() {
        if(checkValidations()){
            DateTime dateTimeNow = dateTime.now();
            String unixTime = ''+dateTimeNow.getTime()/1000;
            FilterQuery fq= new FilterQuery();
            fq.field_name = fieldName ;
            fq.field_type = fieldsMap.get(fieldName);
            fq.operator = oper ;
            fq.value = enterValue ;
            fq.guid= unixTime;
            quryFilterList.add(fq); 
        }
    }
    
    public void deleteFilter() {
        for(Integer i=0;i<quryFilterList.size();i++ ){
            if(quryFilterList.get(i).guid == filterDelId){
                quryFilterList.remove(i);
            }   
        }
    }
    
    public void getOperatorsList() {
            operators = new List<SelectOption>();
            operators.add(new SelectOption('equals','equals'));
            operators.add(new SelectOption('notequals','notequals'));
            operators.add(new SelectOption('like','like'));
            operators.add(new SelectOption('starts with','starts with'));
            operators.add(new SelectOption('ends with','ends with'));
            operators.add(new SelectOption('contains','contains'));
            operators.add(new SelectOption('less than','less than'));
            operators.add(new SelectOption('greater than','greater than'));
            operators.add(new SelectOption('less than or equals','less than or equals'));
            operators.add(new SelectOption('greater than or equals','greater than or equals'));
        }   
    
    public void getFieldsOfSelectedObj(){
        disableValidate = false;
        disableExtract = false;
        getFieldsObj();
    } 
    public void displayExtractedData(){
        http p =new http ();
        httprequest request= new httprequest();
        request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=utf-8');
        request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getDataLoaderXMLFileObject\"');
        string requeststring='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getDataLoaderXMLFileObject><orgname>'+ UserInfo.getOrganizationId() +'</orgname><filename>'+ selectedObj +'.xml</filename><uToken>'+ uToken_Param +'</uToken></ws:getDataLoaderXMLFileObject></soapenv:Body></soapenv:Envelope>';  
        request.setHeader('Content-Length',String.valueOf(requeststring.length()));
        request.setBody(requeststring);
        if(!Test.isRunningTest()) {   
                HttpResponse res = p.send(request);
                if(res.getStatusCode()== 200){
                   parseDisplayExtractedData(res.getBody());
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Check whether services are runing or not');
                    ApexPages.addmessage(myMsg);
                }
            } 
    }
    
   public void parseDisplayExtractedData(String resStr){
        List<ExtractedData> rowDataLi;
        Dom.Document doc = new Dom.Document();
        doc.load(resStr);    
        Dom.XMLNode Envelope = doc.getRootElement();
        Dom.XMLNode Body= Envelope.getChildElements()[0].getChildElements()[0].getChildElements()[0].getChildElements()[0];
        xmlDataObjList = new List<List<ExtractedData>>();
        for(Dom.XMLNode rowChilds : Body.getChildElements()) {
            rowDataLi=new List<ExtractedData>();
            for(Dom.XMLNode rowChildRec : rowChilds.getChildElements()) {
                    if(fieldsOfSelObj.contains(rowChildRec.getName())){
                         ExtractedData ed= new ExtractedData();
                         ed.fieldName = rowChildRec.getName();
                         ed.fieldValue = rowChildRec.getText();
                         rowDataLi.add(ed);
                   }   
            } 
            xmlDataObjList.add(rowDataLi); 
         }       
   } 
   
   public void getSfdcAllObjects(string utoken){
        http p =new http ();
        httprequest request= new httprequest();
        request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=utf-8');
        request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getAllSFObjects\"');
        string requeststring='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getAllSFObjects><uToken>'+ utoken +'</uToken></ws:getAllSFObjects></soapenv:Body></soapenv:Envelope>';  
        request.setHeader('Content-Length',String.valueOf(requeststring.length()));
        request.setBody(requeststring);
        if(!Test.isRunningTest()) {   
                HttpResponse res = p.send(request);
                if(res.getStatusCode()== 200){
                   parseGetSfdcAllObjects(res.getBodyDocument().toXmlString());
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Check whether services are runing or not');
                    ApexPages.addmessage(myMsg);
                }
            } 
    }
   
   public void parseGetSfdcAllObjects(String strRes){
       xmldom d = new xmldom(strRes);
       if(d.getElementByTagName('return')!=NULL){
           List<xmldom.Element> sfObjectList = d.getElementsByTagName('object');
           if(sfObjectList.size()>0){
               sfObjList = new list<SalesForceObject>();
               for(xmldom.Element sfObj:sfObjectList){
                   SalesForceObject sfOb = new SalesForceObject();
                   sfOb.sfObjApiName =sfObj.getAttribute('name');
                   sfOb.sfObjType=sfObj.getAttribute('type');
                   sfOb.sfObjName=sfObj.nodeValue;
                   sfObjList.add(sfOb);
               }
           }
       }
   }
   
   public void getFieldsObj(){
            http p =new http ();
            httprequest request= new httprequest();
            request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getRelatedObjects\"');
            string requeststring='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getRelatedObjects><selected>'+ selectedObj +'</selected><uToken>'+uToken_Param+'</uToken></ws:getRelatedObjects></soapenv:Body></soapenv:Envelope>';
            request.setHeader('Content-Length',String.valueOf(requeststring.length()));
            request.setBody(requeststring);
            if(!Test.isRunningTest()) {   
                HttpResponse res = p.send(request);
                if(res.getStatusCode()== 200){
                   parseGetFieldsObj(res.getBodyDocument().toXmlString());
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Check whether services are runing or not');
                    ApexPages.addmessage(myMsg);
                }
            }  
    }
    
    public void parseGetFieldsObj(String strRes){
       xmldom d = new xmldom(strRes);
       if(d.getElementByTagName('fields')!=NULL){ 
           fieldsMap = new Map<String, String>();
           xmldom.Element sfObjectFieldsEle = d.getElementByTagName('fields');
           List<xmldom.Element> sfObjectFieldsList = sfObjectFieldsEle.getElementsByTagName('field');
           if(sfObjectFieldsList.size()>0){
               allObjFields = new List<SelectOption>();
               fieldsOfSelObj = new Set<String>();
               for(xmldom.Element field:sfObjectFieldsList){
                  allObjFields.add(new SelectOption(field.getAttribute('type'),field.nodeValue));
                   fieldsOfSelObj.add(field.nodeValue);
                   fieldsMap.put(field.nodeValue,field.getAttribute('type')); 
               }
           }
       }
   }
   
    public String buildFilterQuery(){
        String filterStr ='';
        String fltrVal ='';
        if(quryFilterList.size()>0){
            for(FilterQuery filQry:quryFilterList){
                if(filQry.field_type.equalsIgnoreCase('_boolean') || filQry.field_type.equalsIgnoreCase('picklist') || filQry.field_type.equalsIgnoreCase('currency') || filQry.field_type.equalsIgnoreCase('date') || filQry.field_type.equalsIgnoreCase('datetime') || filQry.field_type.equalsIgnoreCase('_int') || filQry.field_type.equalsIgnoreCase('__double')){
                    fltrVal = filQry.field_name;
                }else if(filQry.field_type.equalsIgnoreCase('id') || filQry.field_type.equalsIgnoreCase('string') || filQry.field_type.equalsIgnoreCase('textarea') || filQry.field_type.equalsIgnoreCase('reference') || filQry.field_type.equalsIgnoreCase('phone') || filQry.field_type.equalsIgnoreCase('url') || filQry.field_type.equalsIgnoreCase('checkbox')){
                    fltrVal =  '\''+ filQry.field_name +'\'' ;
                }
                if(quryFilterList.size()>0){
                    filterStr += ' AND ';
                }
                if (filQry.operator.equalsIgnoreCase('equals')){
                    filterStr += filQry.field_name +' = '+fltrVal;
                }
                if (filQry.operator.equalsIgnoreCase('notequals')){
                    filterStr += filQry.field_name +' != '+fltrVal;
                }
                if (filQry.operator.equalsIgnoreCase('like')){
                    filterStr += filQry.field_name +' like '+fltrVal;
                }
                if (filQry.operator.equalsIgnoreCase('starts')){
                    filterStr += filQry.field_name +' like '+fltrVal;
                }
                if (filQry.operator.equalsIgnoreCase('ends')){
                    filterStr += filQry.field_name +' like \'%'+fltrVal;
                }   
                if (filQry.operator.equalsIgnoreCase('contains')){
                    filterStr += filQry.field_name +' like \'%'+fltrVal;
                } 
                if (filQry.operator.equalsIgnoreCase('lessthan')){
                    filterStr += filQry.field_name +' < '+fltrVal;
                }
                if (filQry.operator.equalsIgnoreCase('greaterthan')){
                    filterStr += filQry.field_name +' > '+fltrVal;
                }
                if (filQry.operator.equalsIgnoreCase('ltorequals')){
                    filterStr += filQry.field_name +' <= '+fltrVal;
                }
                if (filQry.operator.equalsIgnoreCase('gtorequals')){
                    filterStr += filQry.field_name +' >= '+fltrVal;
                }
            }
        }
        return filterStr;
    }
   
    public void validateQuery(){
            http p =new http ();
            httprequest request= new httprequest();
            request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/ValidateQuery\"');
            string requeststring='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:ValidateQuery><selected>'+selectedObj+'</selected><filter>'+ buildFilterQuery() +'</filter><limit>'+ limitQry +'</limit><isdelete></isdelete><uToken>'+ uToken_Param +'</uToken></ws:ValidateQuery></soapenv:Body></soapenv:Envelope>';
            request.setHeader('Content-Length',String.valueOf(requeststring.length()));
            request.setBody(requeststring);
            if(!Test.isRunningTest()) {   
                HttpResponse res = p.send(request);
                if(res.getStatusCode()== 200){
                    parseValidateQuery(res.getBodyDocument().toXmlString());
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Check whether services are runing or not');
                    ApexPages.addmessage(myMsg);
                }
            }  
        }
        
   public void parseValidateQuery(String resStr){
        xmldom d = new xmldom(resStr);
       if(d.getElementByTagName('return')!=NULL){ 
           String countAllRec= d.getElementByTagName('return').nodeValue;
               allrec = countAllRec;
       }
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
             status = 200;   
            }
            return status;
    }  
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {
        validateQuery();        
        displayPopup = true;    
    }
   
   public class SalesForceObject{
       public String sfObjName{get;set;}
       public String sfObjApiName{ get; set; }
       public String sfObjType{ get; set; }
   }
   
    public class FilterQuery{
         public String field_name{ get; set; }
         public String field_type{ get; set; }
         public String operator { get; set; }
         public String value{ get; set; }
         public String guid{ get; set; }
    }
   
   /*  code for extractDataPage */
   
   public PageReference transferData() {
        PageReference transferDataPage = Page.transferDataPage;
        transferDataPage.getParameters().put('uToken',uToken_Param);
        transferDataPage.getParameters().put('dOrgId',destOrgId);
        transferDataPage.setRedirect(true);
        return transferDataPage;
    }
    
   public PageReference cancel() {
        PageReference sfObjPage = Page.showallsfobjects;
        sfObjPage.getParameters().put('uToken',uToken_Param);
        sfObjPage.getParameters().put('dOrgId',destOrgId);
        sfObjPage.setRedirect(true);
        return sfObjPage;
    } 
    public void extractFromSingle(){
        http p =new http ();
        httprequest request= new httprequest();                
        request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=utf-8');
        request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/extractDataFromSingleObject\"');
        string requeststring='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:extractDataFromSingleObject><selected>'+ selectedObj +'</selected><filter>'+ buildFilterQuery() +'</filter><childs></childs><levels></levels><limit>'+ limitQry +'</limit><isdelete></isdelete><uToken>'+ uToken_Param +'</uToken></ws:extractDataFromSingleObject></soapenv:Body></soapenv:Envelope>';  
        request.setHeader('Content-Length',String.valueOf(requeststring.length()));
        request.setBody(requeststring);
        if(!Test.isRunningTest()) {   
            HttpResponse res = p.send(request);
            if(res.getStatusCode()== 200){
               parseExtractFromSingle(res.getBodyDocument().toXmlString());
               displayExtractedData();
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while logout from Salesforce');
                ApexPages.addmessage(myMsg);
            }
        }          
    } 
    
    public void parseExtractFromSingle(String resStr){
         xmldom d = new xmldom(resStr);
         if(d.getElementByTagName('export')!=NULL){
              xmldom.Element exportEle = d.getElementByTagName('export');
              if(exportEle.getElementByTagName('object')!=NULL){
                   xmldom.Element objectEle = exportEle.getElementByTagName('object');
                   extractResList = new List<ExtractedResult>();
                   ExtractedResult er = new ExtractedResult();
                  if(objectEle.getAttribute('name')!=NULL ){
                      er.sfObjectName =objectEle.getAttribute('name');
                  }
                  if(objectEle.getAttribute('rows')!=NULL ){
                      er.rowCount = objectEle.getAttribute('rows');
                  }
                  if(objectEle.getAttribute('size')!=NULL ){
                      er.fileSize = objectEle.getAttribute('size');
                  }
                  extractResList.add(er); 
              }
          }  
    } 
    
    public class ExtractedResult{
        public String sfObjectName{ get; set; }
        public String rowCount{ get; set; }
        public String fileSize{ get; set; }
    }
    public class ExtractedData{
        public String fieldName{ get; set; }
        public String fieldValue{ get; set; }
    }
}