public class BuildsManagement{

    public String lastBuildTime { get; set; }

    public void redirectPopup() {
       saveBuildPreferences();
       displayPopup = false;
    }

    public PageReference enableBuildPref() {
        return null;
    }

    public String emptyproj;
    
    public String serverIp { get; set; }
    
    public String promotionBuildNo { get; set; }

    public String noOfBuildsToShow { get; set; }
    
    public List<SelectOption> projectList { get; set; }
    
    public List<Components> compList { get; set; }
    
    public List<Categories> categList { get; set; }
    
    public List<TestTypes> ttList { get; set; }
    
    public Set<String> catgSet { get; set; }
    
    public String fTime { get; set; }
    
    public String build { get; set; }
   
    public String testRun { get; set; }
    
    public String installBuild { get; set; }

    public String selectedProject { get; set; }
    
    public String proBno{ get; set; }
    
    public String isJiraMapped { get; set; }
    
    public String jiraMappedProjKey { get; set; }
    
    public List<BuildSummary> listOfBuilds { get; set; }
    
    public List<BuildSummary> reOrderOfBuilds { get; set; }
    
    public boolean displayPopup {get; set;}     
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true; 
         getDataFromConfig();   
    }
    
    public PageReference onloadPage(){
        parseResponseofGetProjects();
        getDataFromConfig(); 
        getProjectBuildSummary();
        integer i=reOrderOfBuilds.size();
        return null; 
    } 
    
    public String getProjects()
    {   
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
        req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getActiveProjectNames\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getActiveProjectNames><orgname>'+ UserInfo.getOrganizationId()  +'</orgname></ws:getActiveProjectNames></soapenv:Body></soapenv:Envelope>';
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
        } else {
            if(Test.isRunningTest()){
                result = '<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getActiveProjectNamesResponse xmlns:ns2="http://ws.service.rabit.com/"><return>DemoProject,TestProject,</return></ns2:getActiveProjectNamesResponse></S:Body></S:Envelope>';
            }
        }
        return result;      
    }  
        
        
   public void parseResponseofGetProjects(){
            String projectsResponse = getProjects();
            String responseInXml = projectsResponse.replace('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getActiveProjectNamesResponse xmlns:ns2="http://ws.service.rabit.com/"><return>', '');
            String responseInString = responseInXml.replace(',</return></ns2:getActiveProjectNamesResponse></S:Body></S:Envelope>',''); 
            projectList= new List<SelectOption>();
            List<String> projectLists= responseInString.split(',');
            for(Integer i=0;i< projectLists.size();i++ ){
               projectList.add(new SelectOption(projectLists[i], projectLists[i]));
            }
            emptyproj = projectLists[0];
    }   
    
    public String prepareBuildPreferenceNode(){
        Dom.Document doc = new Dom.Document();
        Dom.Xmlnode buildpreferenceNode = doc.createRootElement('buildpreferences', null, null);
            buildpreferenceNode.setAttribute('projecttype','SalesForce');
            buildpreferenceNode.setAttribute('buildnumber',(integer.ValueOf(listOfBuilds.get(0).buildNumber)+1)+'');
        Dom.Xmlnode buildNode = buildpreferenceNode.addChildElement('build', null, null);
            buildNode.setAttribute('exec',build); 
        Dom.Xmlnode installNode = buildpreferenceNode.addChildElement('installation', null, null);
            installNode.setAttribute('exec',installBuild);
            installNode.setAttribute('serviceip',serverIp);
        Dom.Xmlnode testNode = buildpreferenceNode.addChildElement('tests', null, null);
            testNode.setAttribute('exec',testRun);
        Dom.Xmlnode testGroupNode=testNode.addChildElement('testgroups', null, null);
        Dom.Xmlnode groupNode=testGroupNode.addChildElement('group', null, null);
            groupNode.setAttribute('name','unit');
        Dom.Xmlnode browsersNode=testNode.addChildElement('browsers', null, null);
        Dom.Xmlnode browserNode=browsersNode.addChildElement('browser', null, null);
            browserNode.setAttribute('name','firefox'); 
        if(compList.size()>0){
            Dom.Xmlnode modulesNode=testNode.addChildElement('modules', null, null);
            for(Components comp:compList){
                if((comp.flag).equalsIgnoreCase('true')){
                      Dom.Xmlnode moduleNode=modulesNode.addChildElement('module', null, null);
                      moduleNode.setAttribute('name',comp.name); 
                  }     
            }
        } 
        if(categList.size()>0){
            Dom.Xmlnode testcategoriesNode=testNode.addChildElement('testcategories', null, null);
            for(Categories categ:categList){
                if((categ.flag).equalsIgnoreCase('true')){
                      Dom.Xmlnode categoryNode=testcategoriesNode.addChildElement('category', null, null);
                      categoryNode.setAttribute('name',categ.name); 
                  }  
            } 
        }
        if(ttList.size()>0){
            Dom.Xmlnode testtypesNode=testNode.addChildElement('testtypes', null, null);
            for(TestTypes testType:ttList){
                if((testType.flag).equalsIgnoreCase('true')){
                      Dom.Xmlnode typeNode=testtypesNode.addChildElement('type', null, null);
                      typeNode.setAttribute('name','selenium'); 
                  }
             }
        }        
        return doc.toXmlString().replace('<?xml version="1.0" encoding="UTF-8"?>','');
    }
    
    public void saveBuildPreferences(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://www.rabitforce.com:3232/buildservices?wsdl');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=utf-8');
        request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/saveBuildPreferences\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.build.rabit.com/"><soapenv:Header/><soapenv:Body><ws:saveBuildPreferences><orgname>'+ UserInfo.getOrganizationId() +'</orgname><projectname>'+ selectedProject +'</projectname><preferencenode>'+ prepareBuildPreferenceNode()+'</preferencenode></ws:saveBuildPreferences></soapenv:Body></soapenv:Envelope>';
        request.setHeader('Content-Length',String.valueOf(requestString.length()));
        request.setBody(requestString);
        if(!Test.isRunningTest()){     
            HttpResponse res = http.send(request);
            if(res.getStatusCode() == 200){  
                      webserviceCallForTriggerBuild();
                  }else{
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving BuildPreference');
                       ApexPages.addmessage(myMsg);
                  } 
              } 
    }
    
    public void parseResponseOfTriggerBuild(String response){
        String responseInXml = response.replace('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:startBuildResponse xmlns:ns2="http://ws.build.rabit.com/"><return>', '');
        String responseInString = responseInXml.replace('</return></ns2:startBuildResponse></S:Body></S:Envelope>',''); 
         if(responseInString.contains('Build invoked successfully')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Build invoked successfully');
            ApexPages.addmessage(myMsg);
         }
         if(responseInString.contains('in build queue')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Build is in queue');
            ApexPages.addmessage(myMsg);
         }
    }
    
   public void webserviceCallForTriggerBuild(){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://www.rabitforce.com:3232/buildservices?wsdl');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
            req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/startBuild\"');
            String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.build.rabit.com/"><soapenv:Header/><soapenv:Body><ws:startBuild><orgname>'+ UserInfo.getOrganizationId() +'</orgname><projectname>'+ selectedProject +'</projectname><iscustombuild>false</iscustombuild></ws:startBuild></soapenv:Body></soapenv:Envelope>';
            req.setHeader('Content-Length',String.valueOf(requestString.length()));
            req.setBody(requestString);        
            if (!Test.isRunningTest()){
                    HttpResponse res = http.send(req);
                    if(res.getStatusCode()== 200){    
                        parseResponseOfTriggerBuild(res.getBodyDocument().toXmlString());
                    }
                 }
    }
    
     public PageReference showDashBoard() 
        {
            PageReference dashboardpage = Page.dashboard;
            dashboardpage.getParameters().put('proj',selectedProject);
            dashboardpage.getParameters().put('bno',proBno);
            dashboardpage.getParameters().put('key',jiraMappedProjKey);
            dashboardpage.setRedirect(true);
            return dashboardpage;     
        }
     
     public PageReference TestReportPage() {
            PageReference testReportpage = Page.testreportpage;
            testReportpage.getParameters().put('proj',selectedProject);
            testReportpage.getParameters().put('bno',proBno);
            testReportpage .setRedirect(true);
            return testReportpage ;
    }   
    
     public PageReference promotionBuild() 
        {
                PageReference promotionpage = Page.promotionBuild;
                promotionpage.getParameters().put('proj',selectedProject);
                promotionpage.getParameters().put('bno',proBno);
                promotionpage.setRedirect(true);
                return promotionpage;  
        }
    
     public void getDataFromConfig(){
        String projName;
        if(selectedProject == NULL){
            projName = emptyproj;
        }else{
            projName = selectedProject;
        } 
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=utf-8');
        request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getProjectConfig\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getProjectConfig><orgname>'+ UserInfo.getOrganizationId() +'</orgname><projectname>'+ projName +'</projectname></ws:getProjectConfig></soapenv:Body></soapenv:Envelope>';
        request.setHeader('Content-Length',String.valueOf(requestString.length()));
        request.setBody(requestString);
        String resStr='';
        if(!Test.isRunningTest()){      
            HttpResponse res = http.send(request);
            if(res.getStatusCode() == 200){
                       parseCongfigXml(res.getBodyDocument().toXmlString());
                  }else{
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'check whether server is runing or not!');
                       ApexPages.addmessage(myMsg);
                  } 
              }
    }
    
     public void parseCongfigXml(String xmlResponse){
         fTime = 'fullcycle';
         build ='true';
         testRun = 'true';
         installBuild = 'true';
        xmldom d = new xmldom(xmlResponse);
        XMLdom.Element projDet= d.getElementByTagName('projectdetails');
        XMLdom.Element buildDet= d.getElementByTagName('builddetails');
        if(projDet!= NULL){
            XMLdom.Element integrationsEle= d.getElementByTagName('integrations');
            if(projDet.getElementByTagName('buildstobeshown')!= NULL){
              noOfBuildsToShow = projDet.getElementByTagName('buildstobeshown').nodeValue;
            }
            if(integrationsEle.getElementByTagName('jira')!= NULL){
                String jiraInteg = integrationsEle.getElementByTagName('jira').nodeValue;
                if(jiraInteg.equalsIgnoreCase('true')){
                    isJiraMapped = true+'';
                }else{
                    isJiraMapped = false+'';
                }
            }
           if(isJiraMapped.equalsIgnoreCase('true')){
               if(d.getElementByTagName('jira')!= NULL){
                    XMLdom.Element jiraDiv = d.getElementByPath('.*/project/jira');
                    if(jiraDiv!= NULL){
                        if(jiraDiv.getElementByTagName('mappedtoproject')!= NULL){
                            XMLdom.Element jiraProjectName = jiraDiv.getElementByTagName('mappedtoproject');
                            jiraMappedProjKey = jiraProjectName.getAttribute('projkey');
                        }
                    }   
                }
           } 
        }
       if(d.getElementByTagName('components')!= NULL){
           XMLdom.Element rabitComp = d.getElementByTagName('components');
           List<xmldom.Element> components = rabitComp.getElementsByTagName('component');
           if(components.size()>0){
                compList = new list<Components>();
                for(XMLdom.Element comp:components) 
                { 
                    Components cmp= new Components();
                    cmp.name = comp.getAttribute('name'); 
                    cmp.flag = true+'';
                    compList.add(cmp); 
                   
                   if(comp.getElementByTagName('testtypes')!=null) {
                       catgSet= new Set<String>();
                      List<XMLdom.Element> testTyps = d.getElementsByTagName('type');
                       if(testTyps.size()>0){
                           for(XMLdom.Element testTy:testTyps){
                               if(testTy.getAttribute('name').equalsIgnoreCase('Selenium')){
                                   ttList = new List<TestTypes>();
                                   TestTypes tt = new TestTypes();
                                   tt.name = 'Functional Tests';
                                   tt.flag = 'true';
                                   ttList.add(tt); 
                                  List<XMLdom.Element> categorys = d.getElementsByTagName('category');
                                      if(categorys.size()>0){
                                          for(XMLdom.Element cate:categorys){
                                              if(cate.getElementsByTagName('package')!= null){
                                                   catgSet.add(cate.getAttribute('name'));
                                              }
                                          }
                                          if(catgSet.size()>0){
                                              categList = new List<Categories>();
                                              for (String setcon:catgSet) {
                                                    Categories cat= new Categories();
                                                    cat.name = setcon;
                                                    cat.flag = 'true';
                                                    categList.add(cat);
                                                }                    
                                          }
                                      } 
                               }
                           }
                       }
                   }
                }   
            }
        } 
       if(buildDet!= NULL){  
             if(buildDet.getElementByTagName('server')!= NULL){ 
                 serverIp = buildDet.getElementByTagName('server').nodeValue; 
             }      
         }       
     }
    
     public void getProjectBuildSummary(){
        String projName;
        if(selectedProject == NULL){
            projName = emptyproj;
        }else{
            projName = selectedProject;
        }
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
        req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getXmlFileContent\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getXmlFileContent><orgname>'+ UserInfo.getOrganizationId() +'</orgname><filepath>data/'+ projName +'/buildsummary.xml</filepath></ws:getXmlFileContent></soapenv:Body></soapenv:Envelope>';
        req.setHeader('Content-Length',String.valueOf(requestString.length()));
        req.setBody(requestString);   
         if (!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                if(res.getStatusCode()== 200){                 
                    parseBuildSummary(res.getBodyDocument().toXmlString());
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'please check the network connection');
                    ApexPages.addmessage(myMsg);
                }
            }
        }
    
 public void parseBuildSummary(String str)
      {
        if (str!= null){  
             xmldom d = new xmldom(str);
             reOrderOfBuilds = new List<BuildSummary>();    
                 List<XMLdom.Element> buildsEles= d.getElementsByTagName('build');
                  if(buildsEles.size()>0){
                      for(XMLdom.Element buildEle: buildsEles){
                           BuildSummary bs = new BuildSummary(); 
                           if(buildEle.getAttribute('buildnumber')!= NULL){
                                bs.buildNumber=buildEle.getAttribute('buildnumber');
                            }
                            if(buildEle.getAttribute('timeofbuild')!= NULL){
                                bs.buildDTime = buildEle.getAttribute('timeofbuild');
                            }
                            if(buildEle.getElementByTagName('osstatus')!= NULL){
                                bs.buildStatus =buildEle.getElementByTagName('osstatus').nodeValue;
                                if((buildEle.getElementByTagName('osstatus').nodeValue).equalsIgnoreCase('Ready')){
                                    bs.buildPass = true;
                                    bs.buildFail = false;
                                    bs.buildInProgress = false;
                                }else if((buildEle.getElementByTagName('osstatus').nodeValue).equalsIgnoreCase('Failed')){
                                    bs.buildPass = false;
                                    bs.buildFail = true;
                                    bs.buildInProgress = false;
                                }else{
                                    bs.buildPass = false;
                                    bs.buildFail = false;
                                    bs.buildInProgress = true;
                                }
                            }
                            XMLdom.Element regressionstatusEle =buildEle.getElementByTagName('regressionstatus');
                            if(regressionstatusEle!= NULL ){
                               if(regressionstatusEle.getElementByTagName('installationstatus')!= NULL){
                                   if((regressionstatusEle.getElementByTagName('installationStatus').nodeValue).equalsIgnoreCase('Successful')){
                                        bs.installPass = true;
                                        bs.installationStatus = 'All Passed';
                                        bs.installFail = false;
                                        bs.installEmpty = false;
                                        bs.installInProgress= false;
                                    }  
                                    if((regressionstatusEle.getElementByTagName('installationStatus').nodeValue).equalsIgnoreCase('Failed')){
                                        bs.installationStatus = 'Failed';
                                        bs.installPass = false;
                                        bs.installFail = true;
                                        bs.installEmpty = false;
                                        bs.installInProgress= false;
                                    }
                                    if((regressionstatusEle.getElementByTagName('installationStatus').nodeValue).equalsIgnoreCase('Inprogress')){
                                        bs.installationStatus = 'InProgress';
                                        bs.installPass = false;
                                        bs.installFail = false;
                                        bs.installEmpty = false;
                                        bs.installInProgress= true;
                                    }
                               }
                           }else{
                                    bs.installationStatus = '';
                                    bs.installPass = false;
                                    bs.installFail = false;
                                    bs.installEmpty = true;
                                    bs.installInProgress= false;
                           }
                           if(buildEle.getElementByTagName('os')!= NULL){
                               XMLdom.Element testresEle = buildEle.getElementByTagName('os');
                               if(testresEle.getAttribute('failures').equalsIgnoreCase('0')){
                                    bs.failedUITests= 'All Passed';
                                    bs.testsPass = true;
                                    bs.testsFail = false;
                                    bs.testsEmpty = false;
                                    bs.testsInProgress = false;
                                }else{  
                                    bs.failedUITests = testresEle.getAttribute('failures')+' Failed';
                                    bs.testsPass = false;
                                    bs.testsFail = true;
                                    bs.testsEmpty = false;
                                    bs.testsInProgress = false;
                                }
                                if(testresEle.getAttribute('failures').equalsIgnoreCase('')){
                                    bs.failedUITests= 'InProgress';
                                    bs.testsPass = false;
                                    bs.testsFail = false;
                                    bs.testsEmpty = false;
                                    bs.testsInProgress = true;
                                }
                           }else{
                                    bs.installationStatus = '';
                                    bs.testsPass = false;
                                    bs.testsFail = false;
                                    bs.testsEmpty = true;
                                    bs.testsInProgress = false;
                           }
                        reOrderOfBuilds.add(bs);        
                      }
                      if(reOrderOfBuilds.size()>0){
                          listOfBuilds = new List<BuildSummary>();
                          for(Integer i = reOrderOfBuilds.size()-1; i>=0;i--)
                            {
                                listOfBuilds.add(reOrderOfBuilds.get(i));
                            }
                        }
                  }
            }
            lastBuildTime = listOfBuilds.get(0).buildDTime; 
    }    
    
    public class BuildSummary{
        public String buildNumber { get; set; }
        public String buildDTime { get; set; }
        public String buildStatus { get; set; }
        public String installationStatus { get; set; }
        public String failedUITests { get; set; }
        public Boolean buildPass { get; set; }
        public Boolean buildFail { get; set; }
        public Boolean buildInProgress { get; set; }
        public Boolean installPass { get; set; }
        public Boolean installFail { get; set; }
        public Boolean installInProgress { get; set; }
        public Boolean installEmpty { get; set; }
        public Boolean testsPass { get; set; }
        public Boolean testsFail { get; set; }
        public Boolean testsInProgress { get; set; }
        public Boolean testsEmpty { get; set; }
       public BuildSummary(){
             buildPass = false;
             buildFail = false;
             buildInProgress = false;
             installPass = false;
             installFail = false;
             installEmpty = true;
             installInProgress = false; 
             testsPass = false; 
             testsFail = false;
             testsInProgress = false;
             testsEmpty =true;
       } 
    }  
    
    public class Components{
          public string name{ get;set;}
          public string flag{get;set;}
      } 
   public class Categories{
          public string name{ get;set;}
          public string flag{get;set;}
      } 
   public class TestTypes{
          public string name{ get;set;}
          public string flag{get;set;}
      }     
}