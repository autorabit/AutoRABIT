public class PromotionControler {

    public Boolean statusOfPro { get; set; }

    public String previousPromoteLog 
    { get; set; }
    
    public String proLogOfProjName
     { get; set; }
    
    public String proLogOfBuildNo { get; set; }

    public String pro { get; set; }

    public String promoteLog { get; set; }

    public String promoteSforgName { get; set; }

    public List<SelectOption> sforgListReg { get; set; }
    
    private List<Promote> promoteSummaryList{ get; set; }
    
    public List<Promote> preListOfPromotes{ get; set; }
    
    public String buildNo { get; set; }

    public String selProjName { get; set; }
    
    public String urlProjName { get; set; }
    
    public List<SelectOption> projectList { get; set; }
    
    public List<SelectOption> buildNumberList { get; set; }
    
    public Boolean BtnStatus { get; set; }
    
    public Boolean displayPopup {get; set;}     
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    
    public void showPromotionLog() {
        displayPopup = true;
        previousPromoteLog ='';
        previousPromoteLog = getPromotionLog(proLogOfProjName,proLogOfBuildNo);
    }

 
    public void onLoadPromotionControler(){
           getProjects();
           BtnStatus = true;
           statusOfPro = false;
           urlProjName = System.currentPagereference().getParameters().get('proj');
           selProjName = urlProjName ;
           buildNo = System.currentPagereference().getParameters().get('bno');
           getRegSfOrgList();
           if(urlProjName != null){
               parseBuildSummary(getProjectBuildSummary());
               parsePromoteSummary(getProjectBuildSummary());
           }
    }
    
    public PageReference cancel() {
        PageReference homepage = Page.RabitIndex;
        homepage.getParameters().put('proj',urlProjName);
        homepage.setRedirect(true);
        return homepage;  
    }
        
     public void getProjects(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
        req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getActiveProjectNames\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getActiveProjectNames><orgname>'+ UserInfo.getOrganizationId() +'</orgname></ws:getActiveProjectNames></soapenv:Body></soapenv:Envelope>';
        req.setHeader('Content-Length',String.valueOf(requestString.length()));
        req.setBody(requestString);
        String resStr='';  
        if(!Test.isRunningTest()){    
            HttpResponse res = http.send(req);
                if(res.getStatusCode()== 200){
                    parseOfGetProjects(res.getBodyDocument().toXmlString());
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'please check the network connection');
                    ApexPages.addmessage(myMsg);
                }
        } 
     }   
     
      public void parseOfGetProjects(String resStr){
            String responseInXml = resStr.replace('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getActiveProjectNamesResponse xmlns:ns2="http://ws.service.rabit.com/"><return>', '');
            String responseInString = responseInXml.replace(',</return></ns2:getActiveProjectNamesResponse></S:Body></S:Envelope>',''); 
            projectList= new List<SelectOption>();
            List<String> projectLists= responseInString.split(',');
            for(Integer i=0;i< projectLists.size();i++ ){
               projectList.add(new SelectOption(projectLists[i], projectLists[i]));
            }
      }  
    
    public String getPromotionLog(String projectName,String buildNumber){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
        req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getPromotionLog\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getPromotionLog><orgname>'+ UserInfo.getOrganizationId() +'</orgname><projectname>'+ projectName +'</projectname><buildnumber>'+ buildNumber +'</buildnumber></ws:getPromotionLog></soapenv:Body></soapenv:Envelope>';
        req.setHeader('Content-Length',String.valueOf(requestString.length()));
        String resStr='';
        req.setBody(requestString);   
         if (!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                if(res.getStatusCode()== 200){  
                    resStr = parseGetPromotionLog(res.getBodyDocument().toXmlString());
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please check the server is runing or not');
                    ApexPages.addmessage(myMsg);
                }
            }
       return resStr;     
    }
    
    public String parseGetPromotionLog(String response){
      String status='';  
      xmldom d = new xmldom(response);
      XMLdom.Element responseEle= d.getElementByTagName('return');
      if(responseEle.nodeValue.equalsIgnoreCase('404')){
         status='There is no log file of this promotion'; 
      }else{
         status =responseEle.nodeValue; 
      }
      return status ;
    }
    
     public void deployBuild() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
        req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/triggerPromote\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:triggerPromote><orgname>'+ UserInfo.getOrganizationId() +'</orgname><projectname>'+ selProjName +'</projectname><buildnumber>'+ buildNo +'</buildnumber><sandboxid>'+ promoteSforgName +'</sandboxid><iscustompromote>false</iscustompromote></ws:triggerPromote></soapenv:Body></soapenv:Envelope>';
        req.setHeader('Content-Length',String.valueOf(requestString.length()));
        req.setBody(requestString);   
         if (!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                if(res.getStatusCode()== 200){  
                     deployBuildSucess();
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please check the server is runing or not');
                    ApexPages.addmessage(myMsg);
                }
            }
    }
    public void deployBuildSucess(){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Promotion invoked successfully');
        ApexPages.addmessage(myMsg);   
        statusOfPro = true;            
        showCurrentPromotionLog();  
    }
    public void showCurrentPromotionLog(){
         promoteLog ='';
         promoteLog = getPromotionLog(selProjName,buildNo);
         parsePromoteSummary(getProjectBuildSummary());
    }
    
    
     public void getRegSfOrgList(){     
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
                req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/deleteSelectedSFOrg\"');
                String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getXmlFileContent><orgname>' +UserInfo.getOrganizationId()+ '</orgname><filepath>servers//sandboxregistration.xml</filepath></ws:getXmlFileContent></soapenv:Body></soapenv:Envelope>';
                req.setHeader('Content-Length',String.valueOf(requestString.length()));
                req.setBody(requestString);
                String result='';
                if (!Test.isRunningTest()){
                        HttpResponse res = http.send(req);
                        if(res.getStatusCode()== 200){
                                parseOfGetRegSfOrgList(res.getBodyDocument().toXmlString());
                        }else{
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'please check the network connection');
                            ApexPages.addmessage(myMsg);
                        }
                } 
    }
    
    public void parseOfGetRegSfOrgList(String xmlResponse){
             xmldom d = new xmldom(xmlResponse);
             List<XMLdom.Element> sandboxEles= d.getElementsByTagName('sandbox');
             sforgListReg = new List<SelectOption>();
              for(XMLdom.Element sforceRegEle: sandboxEles){
                    if(sforceRegEle.getAttribute('id')!= NULL){
                         sforgListReg.add(new SelectOption(sforceRegEle.getAttribute('id'),sforceRegEle.getAttribute('name')));
                    }
               }
    }
    
    public String getProjectBuildSummary(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
        req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getXmlFileContent\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getXmlFileContent><orgname>'+ UserInfo.getOrganizationId() +'</orgname><filepath>data/'+ selProjName +'/buildsummary.xml</filepath></ws:getXmlFileContent></soapenv:Body></soapenv:Envelope>';
        req.setHeader('Content-Length',String.valueOf(requestString.length()));
        req.setBody(requestString); 
        String result = '';   
         if (!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                if(res.getStatusCode()== 200){                 
                    result = res.getBodyDocument().toXmlString();
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'please check the network connection');
                    ApexPages.addmessage(myMsg);
                }
            }
          return result;  
        }
        
   public void parseBuildSummary(String str)
      {
        if (str!= null){  
             xmldom d = new xmldom(str);
                 List<XMLdom.Element> buildsEles= d.getElementsByTagName('build');
                  if(buildsEles.size()>0){
                      buildNumberList = new List<SelectOption>();
                      for(XMLdom.Element buildEle: buildsEles){ 
                           if(buildEle.getAttribute('buildnumber')!= NULL){
                               buildNumberList.add(new SelectOption(buildEle.getAttribute('buildnumber'), buildEle.getAttribute('buildnumber')));
                            }  
                        }
                     }   
                  }      
        } 
   
   public void parsePromoteSummary(String str)
      {
      	    if (str!= null){  
             xmldom d = new xmldom(str);
                 List<XMLdom.Element> buildsEles= d.getElementsByTagName('build');
                  if(buildsEles.size()>0){
                      promoteSummaryList = new List<Promote>();
                      for(XMLdom.Element buildEle: buildsEles){
                           if(buildEle.getElementByTagName('server')!= NULL){
                              Promote pro= new Promote(); 
                              XMLdom.Element serverEle= buildEle.getElementByTagName('server'); 
                              pro.buildNumber = buildEle.getAttribute('buildnumber');
                              pro.projectName = buildEle.getAttribute('branch');
                              pro.serverName = serverEle.getAttribute('name');
                              pro.dTime = serverEle.getAttribute('insstarttime');
                              pro.status = serverEle.getAttribute('result');
                              if(buildEle.getAttribute('buildnumber').trim().equalsIgnoreCase(buildNo)){
                                  if(serverEle.getAttribute('result').trim().equalsIgnoreCase('completed')){
                                      statusOfPro = false;
                                  }   
                              }
                              promoteSummaryList.add(pro);
                            }   
                        }
                        if(promoteSummaryList.size()>0){
                          preListOfPromotes = new List<Promote>();
                          for(Integer i = promoteSummaryList.size()-1; i>=0;i--)
                            {
                                preListOfPromotes.add(promoteSummaryList.get(i));
                            }
                        }
                     }   
                  }      
                } 
                
   public class Promote{
       public String buildNumber{ get; set; }
       public String serverName{ get; set; }
       public String projectName{ get; set; }
       public String dTime { get; set; }
       public String status{ get; set; }
   }                    
      }