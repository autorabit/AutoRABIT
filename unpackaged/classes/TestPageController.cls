public class TestPageController {
    public String scmPassword { get; set; }
    
    public String[] weeklyDays = new String[]{};
    
    
     public String[] getWeeklyDays() {
        return weeklyDays;
    }

    public void setWeeklyDays(String[] weeklyDays) {
        this.weeklyDays = weeklyDays;
    }
    public Set<String> categorySet; 
    
    public Set<String> componentSet;
    
    public String scmUserName { get; set; }

    public String scmUrl { get; set; }
    

    public String retrivalSforgName { get; set; }
    
    public List<SelectOption> sforgListReg { get; set; }
    
    public String deploySforgName{ get; set; }

    public String fixedintervelatHours { get; set; }

    public String fixedintervelHours { get; set; }

    public String fixedtimeMints { get; set; }

    public String fixedtimeHours { get; set; }

    public String weeklymints { get; set; }

    public String weeklyHours { get; set; }

    public String finterval { get; set; }

    public String fTime { get; set; }

    public String scheduleOpt { get; set; }

    public String editMode { get; set; } 
    
    public Boolean buildEnabled { get; set; }
    
    public Boolean testEnabled { get; set; }
    
    public Boolean projectMgmtSystem { get; set; }
    
    public Boolean intervelOpt { get; set; }
    
    public Boolean intervelOptTime { get; set; }

    public Boolean testCaseMgmtSystem { get; set; }

    public Boolean defectTracker { get; set; }

    public Boolean isActive { get; set; }

    public String noOfShownBuilds { get; set; }

    public Integer columnsTestDiv { get; set; }

    public String bronze { get; set; }

    public Boolean testDiv { get; set; }
    
    public Boolean codeCover{ get; set; }
     
    public Boolean selenium{ get; set; }
    
    public Boolean schOpt { get; set; }

    public String silver { get; set; }

    public String gold { get; set; }

    public String platinum { get; set; }

    public String selected_comp { get; set; }

    public String sourceTitle { get; set; }

    public String sourceType { get; set; }

    public List<SelectOption> jiraprojectList { get; set; }
    
    public List<SelectOption> componentsList { get; set; }
    
    public List<SelectOption> JiracomponentsList { get; set; }

    public list<Components> lstComponent {get;set;}
    
    public list<TestComponents> testCasesComponent {get;set;}
    
    public list<ComponentsMap> jiraComponents {get;set;}
    
    public String jiraSelProject { get; set; }

    public String jiraPassword { get; set; }

    public String jiraUserName { get; set; }

    public String jiraPort { get; set; }

    public String jiraIp { get; set; }

    public String jira { get; set; }

    public String toAddresses { get; set; }

    public String senderAddress { get; set; }

    public String name { get; set; }
    
    public Boolean srcBtnStatus { get; set; }
    
    public Boolean dstBtnStatus { get; set; }
    
    public Boolean jiraBtnStatus { get; set; }
    
    public Boolean jiracompStatus { get; set; }
    
    public Boolean jiraFldStatus { get; set; }
    
    public Map<String, Object> projects;
    
    public Map<String, Object> components;
   
   
   public PageReference getscheduleOption() {
        if(scheduleOpt.equalsIgnoreCase('daily')){
            intervelOpt = true;
       }else if(scheduleOpt.equalsIgnoreCase('weekly')){
            intervelOpt = false;
            intervelOptTime = false;
       }
       return null;
    }
    
    public PageReference getSelectedSchOptTime() {
        if(fTime.equalsIgnoreCase('fixtime')){
            intervelOptTime = true;
       }else if(fTime.equalsIgnoreCase('finterval')){
            intervelOptTime = false;
       }
       return null;
    }
    public void onLoadPageController(){
            jira = false+'';  
            editMode =false+'';
            intervelOpt = true;
            fTime = 'fixtime';
            intervelOptTime = true;
            fixedtimeHours ='21';
            srcBtnStatus = true; 
            dstBtnStatus = true;
            buildEnabled = false;
            testEnabled = false;
            jiraBtnStatus = true;
            jiraFldStatus = false;
            jiraFldStatus = false;
            sourceType = 'sandbox';
            testCasesComponent = new List<TestComponents>();
            sourceTitle = 'Retrieval Salesforce Organization Properties';
             getRegSfOrgList();
            if(System.currentPagereference().getParameters().get('projectName')!= null){
                 name = System.currentPagereference().getParameters().get('projectName').trim();
            }
            if(System.currentPagereference().getParameters().get('jira')!= null){
             jira = System.currentPagereference().getParameters().get('jira').trim();
             if(jira.equalsIgnoreCase('true')){
                projectMgmtSystem = true;
             }
            }
            if(System.currentPagereference().getParameters().get('edit')!= null){
                 editMode = System.currentPagereference().getParameters().get('edit').trim();
            }
            if(editMode.equalsIgnoreCase('true')){
                getDataFromConfig();
            }
            if(!editMode.equalsIgnoreCase('true')){
                    this.lstComponent = new list<Components>();
                    Components newComp= new Components();
                    newComp.ComponentName=''; 
                    newComp.ComponentFlag= ''; 
                    lstComponent.add(newComp);
            }
            
           
    } 
    
    public String PrepareProjectXmlNode()
          {
                    Dom.Document doc = new Dom.Document();
                    Dom.Xmlnode projectNode = doc.createRootElement('project', null, null);
                    projectNode.setAttribute('name',name);
                    Dom.Xmlnode projectdetailsNode = projectNode.addChildElement('projectdetails', null, null);
                    projectdetailsNode.addChildElement('buildstobeshown', null, null).addTextNode(noOfShownBuilds+'');
                    projectdetailsNode.addChildElement('isactive', null, null).addTextNode(isActive+'');
                    Dom.Xmlnode integrationsNode = projectdetailsNode.addChildElement('integrations', null, null);
                    integrationsNode.addChildElement('jira', null, null).addTextNode(projectMgmtSystem+'');
                    return doc.toXmlString().replace('<?xml version="1.0" encoding="UTF-8"?>','');
        }
    
    public PageReference createProject() {
             if(name.equalsIgnoreCase('')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Project Name empty');
                ApexPages.addmessage(myMsg);
                return null;
             }  
            Integer res_saveproject = SaveProjectBuildDetails(PrepareProjectXmlNode(),UserInfo.getOrganizationId()+'/projects/'+ name +'_configuration.xml','./configuration/project');
            Integer res_saveProjectMetaInfo = SaveProjectBuildDetails('<project configfile="'+ name +'_configuration.xml" isactive="'+ isActive +'" name="'+name+'"/>',UserInfo.getOrganizationId()+'/projects/projectmetainfo.xml','./projectmetadata/project');
             
          return parseOfCreateProject(res_saveproject,res_saveProjectMetaInfo);
    } 
     
    public PageReference parseOfCreateProject(Integer rescode,Integer stcCode){
         if(rescode == 200 && stcCode == 200){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Project saved sucessfully');
                ApexPages.addmessage(myMsg);  
                return ShowPojectsPageDiv();
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving Project');
                ApexPages.addmessage(myMsg);
                return null;
            } 
  }   
  
  public void saveScheduleBuildPreferences() {  
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://www.rabitforce.com:3232/buildservices?wsdl');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
        req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/saveScheduleBuildPreferences\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.build.rabit.com/"><soapenv:Header/><soapenv:Body><ws:saveScheduleBuildPreferences><orgname>'+ UserInfo.getOrganizationId() +'</orgname><projectname>'+ name +'</projectname><preferencenode>'+ prepareSchedulePreferenceNode()+'</preferencenode></ws:saveScheduleBuildPreferences></soapenv:Body></soapenv:Envelope>';
        req.setHeader('Content-Length',String.valueOf(requestString.length()));
        req.setBody(requestString); 
        if (!Test.isRunningTest()){
            HttpResponse res = http.send(req);
             if(res.getStatusCode()== 200){
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving BuildPreference');
                    ApexPages.addmessage(myMsg);
                }    
          }                
    }
    
    public String prepareSchedulePreferenceNode(){
        Dom.Document doc = new Dom.Document();
        Dom.Xmlnode buildpreferenceNode = doc.createRootElement('buildpreferences', null, null);
            buildpreferenceNode.setAttribute('projecttype','SalesForce');
        if(buildEnabled){    
            Dom.Xmlnode buildNode = buildpreferenceNode.addChildElement('build', null, null);
                buildNode.setAttribute('exec','true'); 
            Dom.Xmlnode installNode = buildpreferenceNode.addChildElement('installation', null, null);
                installNode.setAttribute('exec','true');
                installNode.setAttribute('serviceip','182.18.162.12');
          }  
        if(testEnabled){      
            Dom.Xmlnode testNode = buildpreferenceNode.addChildElement('tests', null, null);
                testNode.setAttribute('exec','true');
            Dom.Xmlnode testGroupNode=testNode.addChildElement('testgroups', null, null);
            Dom.Xmlnode groupNode=testGroupNode.addChildElement('group', null, null);
                groupNode.setAttribute('name','unit');
            Dom.Xmlnode browsersNode=testNode.addChildElement('browsers', null, null);
            Dom.Xmlnode browserNode=browsersNode.addChildElement('browser', null, null);
                browserNode.setAttribute('name','firefox'); 
            if(testCasesComponent.size()>0){
                for (TestComponents tstCaseComp:testCasesComponent) {
                      categorySet = new Set<String>();
                      componentSet = new Set<String>();
                      componentSet.add(tstCaseComp.CompName);
                      if(tstCaseComp.Gold != null){
                         categorySet.add('gold');
                      }
                      if(tstCaseComp.Platinum!= null){
                         categorySet.add('platinum');
                      }
                      if(tstCaseComp.Silver!= null){
                         categorySet.add('silver');
                      }
                      if(tstCaseComp.Bronze!= null){
                         categorySet.add('bronze');
                      }     
                }
            } 
            if(componentSet.size()>0){
                Dom.Xmlnode modulesNode=testNode.addChildElement('modules', null, null);
                for(String compet:componentSet){
                    Dom.Xmlnode moduleNode=modulesNode.addChildElement('module', null, null);
                     moduleNode.setAttribute('name',compet); 
                } 
            }
            if(categorySet.size()>0){
                Dom.Xmlnode testcategoriesNode=testNode.addChildElement('testcategories', null, null);
                for(String categ:categorySet){
                    Dom.Xmlnode categoryNode=testcategoriesNode.addChildElement('category', null, null);
                    categoryNode.setAttribute('name',categ); 
                } 
            }
            if(selenium){
                  Dom.Xmlnode testtypesNode=testNode.addChildElement('testtypes', null, null);
                  Dom.Xmlnode typeNode=testtypesNode.addChildElement('type', null, null);
                  typeNode.setAttribute('name','selenium'); 
                      
                }
            }       
        return doc.toXmlString().replace('<?xml version="1.0" encoding="UTF-8"?>','');
    }
   
   public PageReference ShowPojectsPageDiv() {
        PageReference projectBuildPage = Page.testpage;
        projectBuildPage.setRedirect(true);
        return projectBuildPage;
    }
     public PageReference ShowTestTypesDiv() {
       if(editMode.equals('true')){
           bronze = '';
           silver = '';
           gold = '';
           platinum= '';
           selenium =  false;
           testDiv = false;
           for (Integer i = 0; i < testCasesComponent.size(); i++) {
                  String compName = testCasesComponent[i].CompName;
                 if(compName.equalsIgnoreCase(Selected_comp)){
                    Boolean sel = testCasesComponent[i].selenium;
                    codeCover =  testCasesComponent[i].ApexCode;
                     if(sel ==true){
                       selenium = true;
                       testDiv = true;
                       bronze = testCasesComponent[i].Bronze;
                       silver = testCasesComponent[i].Silver;
                       gold = testCasesComponent[i].Gold;
                       platinum= testCasesComponent[i].Platinum;
                     }
               }
           }
       }else{   
       if(selenium == true && Selected_comp != NULL){
           testDiv = true;
           selenium = true;
           codeCover = false;
           bronze = '';
           silver = '';
           gold = '';
           platinum= ''; 
           
       }else{
               testDiv = false;
           }
       }
        return null;
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
    
    public void getDataFromConfig(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=utf-8');
        request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getProjectConfig\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getProjectConfig><orgname>'+ UserInfo.getOrganizationId() +'</orgname><projectname>'+ name +'</projectname></ws:getProjectConfig></soapenv:Body></soapenv:Envelope>';
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
        xmldom d = new xmldom(xmlResponse);
        XMLdom.Element projDet= d.getElementByTagName('projectdetails');
        if(projDet.getElementByTagName('buildstobeshown')!= NULL){
                noOfShownBuilds = projDet.getElementByTagName('buildstobeshown').nodeValue;
        }
        if(projDet.getElementByTagName('isactive')!= NULL){
                String active = projDet.getElementByTagName('isactive').nodeValue;
                if(active.equalsIgnoreCase('false')){
                        isActive = false;
                }
                    if(active.equalsIgnoreCase('true')){
                        isActive = true;
                }       
        }
        XMLdom.Element integrationsEle= d.getElementByTagName('integrations');
       
        if(integrationsEle.getElementByTagName('jira')!= NULL){
                String jiraInteg = integrationsEle.getElementByTagName('jira').nodeValue;
                if(jiraInteg.equalsIgnoreCase('false')){
                        projectMgmtSystem = false;
                        jira = false+'';
                }
                if(jiraInteg.equalsIgnoreCase('true')){
                        projectMgmtSystem = true;
                        jira = true+'';
                      getJiraCredentials();   
                }
        }
        XMLdom.Element buildDet= d.getElementByTagName('builddetails');      
        if(buildDet.getElementByTagName('source')!= NULL){
                XMLdom.Element sourceEle = buildDet.getElementByTagName('source');
                 sourceType = sourceEle.getAttribute('type');
                if(sourceType.equalsIgnoreCase('git')){
                    columnsTestDiv = 1;
                    srcBtnStatus = false;
                    sourceTitle = 'Git Repository Properties';
                    if(sourceEle.getAttribute('scmurl')!= NULL){
                                 scmUrl = sourceEle.getAttribute('scmurl');
                        }
                        if(sourceEle.getAttribute('scmuser')!= NULL){
                                 scmUserName = sourceEle.getAttribute('scmuser');
                        }
                        if(sourceEle.getAttribute('scmpass')!= NULL){
                                 scmPassword = decryptPassword(sourceEle.getAttribute('scmpass'));
                        }
                }else if(sourceType.equalsIgnoreCase('sandbox')){
                    columnsTestDiv = 2;
                    srcBtnStatus = true;
                    sourceTitle = 'Retrieval Salesforce Organization Properties';
                    if(sourceEle.getAttribute('id')!= NULL){
                            retrivalSforgName= sourceEle.getAttribute('id');
                    }
            }else if(sourceType.equalsIgnoreCase('svn')){
                columnsTestDiv = 1;
                sourceTitle = 'SCM Configuration Settings';
                srcBtnStatus = false;
                if(sourceEle.getAttribute('scmurl')!= NULL){
                             scmUrl = sourceEle.getAttribute('scmurl');
                }
                if(sourceEle.getAttribute('scmuser')!= NULL){
                         scmUserName = sourceEle.getAttribute('scmuser');
                }
                if(sourceEle.getAttribute('scmpass')!= NULL){
                         scmPassword = sourceEle.getAttribute('scmpass');
                }
            }
            if(buildDet.getElementByTagName('target')!= NULL){
               XMLdom.Element targetEle = buildDet.getElementByTagName('target');
                 if(targetEle.getAttribute('id')!= NULL){
                        deploySforgName=targetEle.getAttribute('id');
                 }
            }
            if(buildDet.getElementByTagName('senderaddress')!= NULL){
                        senderAddress = buildDet.getElementByTagName('senderaddress').nodeValue;
                }
            if(buildDet.getElementByTagName('toaddresses')!= NULL){
                         toAddresses = buildDet.getElementByTagName('toaddresses').nodeValue;
                }
            if(d.getElementByTagName('components')!= NULL){
                       XMLdom.Element rabitComp = d.getElementByTagName('components');
                       List<xmldom.Element> components = rabitComp.getElementsByTagName('component');
                       if(components.size()>0){
                            lstComponent = new list<Components>();
                            componentsList = new List<SelectOption>();
                            testCasesComponent.clear();
                        for(XMLdom.Element comp:components) 
                        { 
                            Components newComp= new Components();
                            TestComponents testcomp = new TestComponents();
                            newComp.ComponentName = comp.getAttribute('name'); 
                            newComp.ComponentFlag= ''; 
                            lstComponent.add(newComp);
                            componentsList.add(new SelectOption(comp.getAttribute('name'),comp.getAttribute('name')));
                            testcomp.CompName = comp.getAttribute('name');
                            xmldom.Element testtypes = comp.getElementByTagName('testtypes');
                           if(testtypes!=NULL){
                            xmldom.Element testtype = testtypes.getElementByTagName('type');
                               String testty = testtype.getAttribute('name');
                                if(testty.equalsIgnoreCase('Selenium')){
                                    testcomp.selenium = true;
                                    List<xmldom.Element> categorys = testtype.getElementsByTagName('category');
                                       for(XMLdom.Element tcategory:categorys){
                                          String categoryName = tcategory.getAttribute('name');
                                           if(categoryName.equalsIgnoreCase('platinum')){
                                                if(d.getElementByTagName('package')!= NULL){
                                                    testcomp.Platinum = tcategory.getElementByTagName('package').nodeValue;
                                                }
                                           }
                                           if(categoryName.equalsIgnoreCase('gold')){
                                                if(d.getElementByTagName('package')!= NULL){
                                                        testcomp.Gold = tcategory.getElementByTagName('package').nodeValue;
                                                    }
                                           }
                                           if(categoryName.equalsIgnoreCase('silver')){
                                                if(d.getElementByTagName('package')!= NULL){
                                                        testcomp.Silver = tcategory.getElementByTagName('package').nodeValue;
                                                    }
                                           }
                                           if(categoryName.equalsIgnoreCase('bronze')){
                                               if(d.getElementByTagName('package')!= NULL){
                                                        testcomp.Bronze = tcategory.getElementByTagName('package').nodeValue;
                                                    }   
                                           }
                                       }
                                }
                            testCasesComponent.add(testcomp);
                            }
                        }
                        if(testCasesComponent.size()>0){
                            Selected_comp = testCasesComponent.get(0).CompName;
                            codeCover = testCasesComponent.get(0).ApexCode;
                            if(testCasesComponent.get(0).selenium == true && Selected_comp != NULL){
                               selenium = true;
                               testDiv = true;
                               bronze = testCasesComponent.get(0).Bronze;
                               silver = testCasesComponent.get(0).Silver;
                               gold = testCasesComponent.get(0).Gold;
                               platinum= testCasesComponent.get(0).Platinum;      
                           }  
                     }  
                } 
          } 
          if(d.getElementByTagName('jira')!= NULL){
            XMLdom.Element jiraDiv = d.getElementByPath('.*/project/jira');
            if(jiraDiv!= NULL){
                 if(jiraDiv.getElementByTagName('mappedtoproject')!= NULL){
                    XMLdom.Element jiraProjectName = jiraDiv.getElementByTagName('mappedtoproject');
                    jiraSelProject = jiraProjectName.getAttribute('projkey');
                 }
                 getJiraComponents();
                 List<xmldom.Element> jiracomps= jiraDiv.getElementsByTagName('component');
                 if(jiracomps.size()>0){
                  for(XMLdom.Element compjira:jiracomps){
                       for (Integer i = 0; i < jiraComponents.size(); i++) {
                            String compNam = compjira.getAttribute('name');
                             if(compNam.equalsIgnoreCase(jiraComponents[i].ComponentName)){
                                jiraComponents[i].mappedComp = compjira.getAttribute('id');
                             }        
                       }
                  }
               }
             }     
          }                         
    }
   }
   
    public PageReference getsourceType() {
          if(sourceType.equalsIgnoreCase('git')){
                columnsTestDiv = 1;
                sourceTitle = 'Git Repository Properties';
                srcBtnStatus = false;
               }else if(sourceType.equalsIgnoreCase('sandbox')){
               columnsTestDiv = 1;
                sourceTitle = 'Retrieval Salesforce Organization Properties';
                srcBtnStatus = true;
               }else if(sourceType.equalsIgnoreCase('svn')){
               columnsTestDiv = 1;
                sourceTitle = 'SCM Configuration Settings';
                srcBtnStatus = false;
                }
        return null;
    }
    
    public void AddComponent() {  
        Components newComp= new Components();
        newComp.ComponentName=''; 
        newComp.ComponentFlag= ''; 
        lstComponent.add(newComp);
    }
    
    public void DeleteComponent() {
        String isChecked;
       for (Integer i = lstComponent.size() - 1; i >= 0 ; --i) {
             isChecked = lstComponent[i].ComponentFlag;
            if (isChecked.equalsIgnoreCase('true')) {
                  lstComponent.remove(i); 
            }
           }
    }
    
     public void SaveComponent() {
        String compName;
          componentsList = new List<SelectOption>();
          if(lstComponent.size() > 0){
           Dom.Document docComp = new Dom.Document();
           Dom.Xmlnode compNode = docComp .createRootElement('components', null, null);          
             for (Integer i = 0; i < lstComponent.size(); i++) {
                     compName= lstComponent[i].ComponentName;
                     componentsList.add(new SelectOption(compName,compName));    
                    Dom.Xmlnode childComp = compNode.addChildElement('component', null, null);   
                     childComp.setAttribute('name',compName);    
                   }
           Integer response = SaveProjectBuildDetails(docComp.toXmlString().replace('<?xml version="1.0" encoding="UTF-8"?>',''),UserInfo.getOrganizationId()+'/projects/'+ name +'_configuration.xml','./project/components');       
           parseSaveComponent(response);     
        }
    }
    
    public void parseSaveComponent(Integer stcCode){
        if(stcCode == 200){
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Components saved sucessfully');
                   ApexPages.addmessage(myMsg);
              }else{
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving components');
                   ApexPages.addmessage(myMsg);
              }      
           }
    
    public PageReference cancelProjectCreation() {
        PageReference projectPage = Page.Projects;
                projectPage.setRedirect(true);
                return projectPage;
    }
    
     public PageReference saveProjectTestCases() {
        Dom.Document docTest = new Dom.Document();
         TestComponents testcomp = new TestComponents();
        Dom.Xmlnode compNode = docTest.createRootElement('component', null, null);
        compNode.setAttribute('name',selected_comp);
        testcomp.CompName =  selected_comp; 
        Dom.Xmlnode testNode = compNode.addChildElement('testtypes', null, null);
       if(selenium == true){
             testcomp.selenium = true;
             Dom.Xmlnode childTest = testNode.addChildElement('type', null, null);
             childTest.setAttribute('name','Selenium');
             if(!platinum.equals('')){
                 Dom.Xmlnode platinumNode = childTest.addChildElement('category', null, null);
                 platinumNode.setAttribute('name','platinum');
                 platinumNode.addChildElement('package', null, null).addTextNode(Platinum);
                  testcomp.Platinum= Platinum;
             }
             if(!gold.equals('')){
                 Dom.Xmlnode platinumNode = childTest.addChildElement('category', null, null);
                 platinumNode.setAttribute('name','gold');
                 platinumNode.addChildElement('package', null, null).addTextNode(gold);
                  testcomp.Gold= gold;
             }
             if(!silver.equals('')){
                 Dom.Xmlnode platinumNode = childTest.addChildElement('category', null, null);
                 platinumNode.setAttribute('name','silver');
                 platinumNode.addChildElement('package', null, null).addTextNode(silver);
                 testcomp.Silver= silver;
             }
             if(!bronze.equals('')){
                 Dom.Xmlnode platinumNode = childTest.addChildElement('category', null, null);
                 platinumNode.setAttribute('name','bronze');
                 platinumNode.addChildElement('package', null, null).addTextNode(bronze);
                 testcomp.Bronze= bronze;
             }
       }
       if(codeCover == true){
            Dom.Xmlnode codeTest = testNode.addChildElement('type', null, null);
             codeTest.setAttribute('name','apexcodecoverage');
       }
       if(selenium == true || codeCover == true){
            testCasesComponent.add(testcomp);   
            Integer response = SaveProjectBuildDetails(docTest.toXmlString().replace('<?xml version="1.0" encoding="UTF-8"?>',''),UserInfo.getOrganizationId()+'/projects/'+ name +'_configuration.xml','./project/components/component');
                 if(response == 200){
                   testEnabled = true;  
                   saveScheduleBuildPreferences(); 
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Testcase details saved successfully.');
                   ApexPages.addmessage(myMsg);
              }else{
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving Testcase details');
                   ApexPages.addmessage(myMsg);
              } 
       }
        return null;
    }
    
     public PageReference verifyJiraCredentials() {
            if(jiraIp.equalsIgnoreCase('')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Jira Install IP empty');
                ApexPages.addmessage(myMsg);
                return null;
               }
            if(jiraPort.equalsIgnoreCase('')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Jira HTTP Port empty');
                ApexPages.addmessage(myMsg);
                return null;
               }
            if(jiraUserName.equalsIgnoreCase('')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Jira UserName empty');
                ApexPages.addmessage(myMsg);
                return null;
               }  
            if(jiraPassword.equalsIgnoreCase('')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Jira Password empty');
                ApexPages.addmessage(myMsg);
                return null;
               }     
           String resStr = testJiraCredentials_Webservice();
           if(resStr.equalsIgnoreCase('true')){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'JIRA Credentials valid');
                    ApexPages.addmessage(myMsg);
                    return null;
                 }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid JIRA Credentials');
                    ApexPages.addmessage(myMsg);
                    return null;
                 }
     }
     
   public String testJiraCredentials_Webservice(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=utf-8');
        request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/testJiraConnection\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:testJiraConnection><ip>'+ jiraIp +'</ip><port>'+ jiraPort +'</port><username>'+ jiraUserName +'</username><password>'+ jiraPassword +'</password></ws:testJiraConnection></soapenv:Body></soapenv:Envelope>';
        request.setHeader('Content-Length',String.valueOf(requestString.length()));
        String status='false';
        request.setBody(requestString); 
        if(!Test.isRunningTest()){  
            HttpResponse res = http.send(request);
             if(res.getStatusCode() == 200){
                    String responseInXml = res.getBodyDocument().toXmlString().replace('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:testJiraConnectionResponse xmlns:ns2="http://ws.service.rabit.com/"><return>', '');
                    status = responseInXml.replace('</return></ns2:testJiraConnectionResponse></S:Body></S:Envelope>','');
             }else{
                   ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Check JIRA service is running or not')); 
            }
        }
         return status;
    }
    


    public PageReference saveJiraCredentials() {
           if(jiraIp.equalsIgnoreCase('')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Jira Install IP empty');
                ApexPages.addmessage(myMsg);
                return null;
               }
            if(jiraPort.equalsIgnoreCase('')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Jira HTTP Port empty');
                ApexPages.addmessage(myMsg);
                return null;
               }
            if(jiraUserName.equalsIgnoreCase('')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Jira UserName empty');
                ApexPages.addmessage(myMsg);
                return null;
               }  
            if(jiraPassword.equalsIgnoreCase('')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Jira Password empty');
                ApexPages.addmessage(myMsg);
                return null;
               }   
           String resStr = testJiraCredentials_Webservice();
           if(resStr.equalsIgnoreCase('true')){
                    saveJiraCredentials_Webservice();
                    return null;
                 }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid JIRA Credentials');
                    ApexPages.addmessage(myMsg);
                    return null;
                 }     
    }
    
    public void saveJiraCredentials_Webservice(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=utf-8');
        request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/testJiraConnection\"');
        String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:saveJiraProperties><orgname>'+ UserInfo.getOrganizationId() +'</orgname><projectname>'+ name +'</projectname><ip>'+ jiraIp +'</ip><port>'+ jiraPort +'</port><username>'+ jiraUserName +'</username><password>'+ jiraPassword +'</password></ws:saveJiraProperties></soapenv:Body></soapenv:Envelope>';
        request.setHeader('Content-Length',String.valueOf(requestString.length()));
        request.setBody(requestString); 
        if(!Test.isRunningTest()){  
            HttpResponse res = http.send(request);
             if(res.getStatusCode() == 200){
                    parseOfSaveJiraCredentials_Webservice(res.getBodyDocument().toXmlString());
             }else{
                   ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Check JIRA service is running or not')); 
            }
        }
    }
    
     Public void parseOfSaveJiraCredentials_Webservice(String resStr){
         String responseInXml = resStr.replace('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:saveJiraPropertiesResponse xmlns:ns2="http://ws.service.rabit.com/"><return>', '');
         String status = responseInXml.replace('</return></ns2:saveJiraPropertiesResponse></S:Body></S:Envelope>','');
         if(status == 'true'){
            jiraBtnStatus = false;
            jiraFldStatus = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'JIRA Credentials valid');
            ApexPages.addmessage(myMsg);
            getJiraProjects();
         }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid JIRA Credentials');
            ApexPages.addmessage(myMsg);
         }
     }
    
    
     public void getJiraProjects() {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getJiraProjects\"');
            String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getJiraProjects><orgname>'+ UserInfo.getOrganizationId() +'</orgname><projectname>'+ name +'</projectname></ws:getJiraProjects></soapenv:Body></soapenv:Envelope>';
            request.setHeader('Content-Length',String.valueOf(requestString.length()));
            request.setBody(requestString); 
            if(!Test.isRunningTest()){
                 HttpResponse res = http.send(request);
                 if(res.getStatusCode()== 200){
                        parseOfGetJiraProjects(res.getBodyDocument().toXmlString());
            }else{
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Check JIRA service is running or not');
               ApexPages.addmessage(myMsg);
            }
            }
           
            
                
    }
   Public void parseOfGetJiraProjects(String resStr){
         String responseInXml = resStr.replace('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getJiraProjectsResponse xmlns:ns2="http://ws.service.rabit.com/"><return>', '');
         String responseInString = responseInXml.replace('</return></ns2:getJiraProjectsResponse></S:Body></S:Envelope>','');
         projects = (Map<String, Object>)JSON.deserializeUntyped(responseInString);
         jiraprojectList = new List<SelectOption>();
         jiraprojectList.add(new SelectOption('select','---select---'));
         for (String key : projects.keySet()) {
               jiraprojectList.add(new SelectOption(key,String.valueOf(projects.get(key))));
            }
   } 
    
     public PageReference getJiraComponents() {
           if(jiraSelProject.equalsIgnoreCase('select')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Select Jira Project');
                ApexPages.addmessage(myMsg);
                return null;
           }
           if(lstComponent.size() < 2){
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Create Rabit Components');
               ApexPages.addmessage(myMsg);
               return null;
           }
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=utf-8');
            request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getJiraComponents\"');
            String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getJiraComponents><orgname>'+ UserInfo.getOrganizationId() +'</orgname><projectname>'+ name +'</projectname><projectkey>'+ jiraSelProject +'</projectkey></ws:getJiraComponents></soapenv:Body></soapenv:Envelope>';
            request.setHeader('Content-Length',String.valueOf(requestString.length()));
            request.setBody(requestString);
            if(!Test.isRunningTest()){ 
                    HttpResponse res = http.send(request);
                    if(res.getStatusCode()== 200){
                         parseOfGetJiraComponents(res.getBodyDocument().toXmlString());
                    }else{
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Check JIRA service is running or not');
                       ApexPages.addmessage(myMsg);
                    }
          }
          return null;
    }
    
    public void parseOfGetJiraComponents(String resStr){
        ComponentsMap newCompMap;
        String responseInXml = resStr.replace('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getJiraComponentsResponse xmlns:ns2="http://ws.service.rabit.com/"><return>', '');
                 String responseInString = responseInXml.replace('</return></ns2:getJiraComponentsResponse></S:Body></S:Envelope>',''); 
                 components = (Map<String, Object>)JSON.deserializeUntyped(responseInString);
                 JiracomponentsList = new List<SelectOption>();
                  JiracomponentsList.add(new SelectOption('select','---select---'));
                 for (String compkey : components.keySet()) {
                       JiracomponentsList.add(new SelectOption(compkey,String.valueOf(components.get(compkey))));
                    }
                    if(components.size() < 1){
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No components found');
                       ApexPages.addmessage(myMsg);
                       }
                    jiraComponents = new list<ComponentsMap>();
                 for (Integer i = 0; i < lstComponent.size(); i++) {
                         newCompMap= new ComponentsMap();
                         newCompMap.ComponentName=lstComponent[i].ComponentName;
                         newCompMap.componentsListJira=JiracomponentsList;
                         jiraComponents.add(newCompMap);
                    } 
                     jiracompStatus = true;
    }
     public String PrepareXmlNode()
       {
             Dom.Document doc = new Dom.Document();
             Dom.Xmlnode rootNode = doc.createRootElement('builddetails', null, null);
             rootNode.addChildElement('server', null, null).addTextNode('182.18.162.12');
             rootNode.addChildElement('deploymentservers', null, null).addTextNode('182.18.162.12');
             Dom.Xmlnode scheduleNode = rootNode.addChildElement('schedule', null, null);
             if(scheduleOpt.equals('daily')){
                 if(fTime.equals('fixtime')){
                     scheduleNode.setAttribute('option','0');
                     scheduleNode.addChildElement('time', null, null).addTextNode(fixedtimeHours+fixedtimeMints);
                 }
                 if(fTime.equals('finterval')){
                     scheduleNode.setAttribute('option','1');
                     scheduleNode.addChildElement('interval', null, null).addTextNode(fixedintervelHours);
                     scheduleNode.addChildElement('starttime', null, null).addTextNode(fixedintervelatHours);
                     Integer intervalValue = Integer.valueof(fixedintervelHours.trim());
                     Integer loopInterval =0;
                     Integer newTime = Integer.valueof(fixedintervelatHours.trim());
                     Integer rem = Math.Mod(24,intervalValue);
                        if (rem != 0){
                            loopInterval = 24/intervalValue;
                        } else {
                            loopInterval = 24/intervalValue;
                        }
                    for (Integer i=0;i<=loopInterval;i++){    
                        if (newTime <= 24){
                             if (newTime < 10){
                                 scheduleNode.addChildElement('time', null, null).addTextNode(string.valueof(Integer.valueof('0'+string.valueof(newTime)))+'00');
                            }else {
                                 scheduleNode.addChildElement('time', null, null).addTextNode(string.valueof(newTime)+'00');  
                            }
                        }else{
                            newTime = (newTime - 24);
                            if (newTime < 10){
                                scheduleNode.addChildElement('time', null, null).addTextNode(string.valueof(Integer.valueof('0'+string.valueof(newTime)))+'00');
                            }else {
                                scheduleNode.addChildElement('time', null, null).addTextNode(string.valueof(newTime)+'00');
                            }
                        }
                      newTime = newTime +intervalValue;   
                    }
                 }
             }
             if(scheduleOpt.equals('weekly')){
                 scheduleNode.setAttribute('option','2');
                 for(String weekDay:weeklyDays){    
                    Dom.Xmlnode dayNode = scheduleNode.addChildElement('day', null, null).addTextNode(weekDay);
                        dayNode.setAttribute('time',weeklyHours+weeklymints);       
                 }
                 
             }
     
             Dom.Xmlnode gitSourceDetailsNode = rootNode.addChildElement('source', null, null);
                if(!sourceType.equals('sandbox')){
                    gitSourceDetailsNode.setAttribute('type',sourceType);
                    gitSourceDetailsNode.setAttribute('scmurl',scmUrl);
                    gitSourceDetailsNode.setAttribute('scmuser',scmUserName);
                    gitSourceDetailsNode.setAttribute('scmpass',encryptPassword(scmPassword));
             }
           if(sourceType.equals('sandbox')){
                    gitSourceDetailsNode.setAttribute('type','sandbox');
                    gitSourceDetailsNode.setAttribute('id',retrivalSforgName);   
                }
            Dom.Xmlnode targetDetailsNode = rootNode.addChildElement('target', null, null);
                    targetDetailsNode.setAttribute('id',deploySforgName);   
            Dom.Xmlnode emailNotificationAddressesNode = rootNode.addChildElement('emailnotificationaddresses', null, null);
            emailNotificationAddressesNode.addChildElement('senderaddress', null, null).addTextNode(senderAddress);
            emailNotificationAddressesNode.addChildElement('toaddresses', null, null).addTextNode(toAddresses);     
            return doc.toXmlString().replace('<?xml version="1.0" encoding="UTF-8"?>','');
      }
      
     public PageReference saveJiraConfiguration() {
        if(jiraSelProject.equalsIgnoreCase('select')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Select Jira Project');
            ApexPages.addmessage(myMsg);
            return null;
        }
         Dom.Document doc = new Dom.Document();
         Dom.Xmlnode rootNode = doc.createRootElement('jira', null, null);
         Dom.Xmlnode projNode = rootNode.addChildElement('mappedtoproject', null, null);
         projNode.setAttribute('projkey',jiraSelProject);
         projNode.addTextNode(String.valueOf(projects.get(jiraSelProject)));
         Dom.Xmlnode compNode;
        for (Integer i = 0; i < jiraComponents.size(); i++) {
               compNode = rootNode.addChildElement('component', null, null);
               compNode.setAttribute('id',jiraComponents[i].mappedComp); 
               compNode.setAttribute('name',jiraComponents[i].ComponentName); 
               compNode.setAttribute('mappedto',String.valueOf(components.get(jiraComponents[i].mappedComp)));  
            } 
         Integer response = SaveProjectBuildDetails(doc.toXmlString().replace('<?xml version="1.0" encoding="UTF-8"?>',''),UserInfo.getOrganizationId()+'/projects/'+ name +'_configuration.xml','./project/jira');       
         if(response == 200){
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Jira mapping saved sucessfully');
               ApexPages.addmessage(myMsg);
          }else{
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving Jira mapping');
               ApexPages.addmessage(myMsg);
          }    
        return null;
    }
    
    public PageReference saveProjectBuild() {
             if(name.equalsIgnoreCase('')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Project Name empty');
                ApexPages.addmessage(myMsg);
                return null;
             }
             if(sourceType.equalsIgnoreCase('svn') || sourceType.equalsIgnoreCase('git')){
                      if(scmUrl.equalsIgnoreCase('')){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave URL empty');
                        ApexPages.addmessage(myMsg);
                        return null;
                       }
                    if(scmUserName.equalsIgnoreCase('')){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave User Name empty');
                        ApexPages.addmessage(myMsg);
                        return null;
                       }
                    if(scmPassword.equalsIgnoreCase('')){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave SVN Password empty');
                        ApexPages.addmessage(myMsg);
                        return null;
                       }
              }
              if(sourceType.equalsIgnoreCase('sandbox')){
                  if(retrivalSforgName.equalsIgnoreCase('')){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Retrieval Salesforce Organization empty');
                        ApexPages.addmessage(myMsg);
                        return null;
                    }   
              }
              
             if(deploySforgName.equalsIgnoreCase('')){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Deployment Salesforce Organization empty');
                        ApexPages.addmessage(myMsg);
                        return null;
                    }
            Integer response = SaveProjectBuildDetails(PrepareXmlNode(),UserInfo.getOrganizationId()+'/projects/'+ name +'_configuration.xml','./project/builddetails');
             Integer response_config = SaveProjectConfigDetails();
             if(response== 200 && response_config == 200){
                buildEnabled = true;
                saveScheduleBuildPreferences();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Project saved sucessfully');
                ApexPages.addmessage(myMsg);    
                return null;
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving Project');
                ApexPages.addmessage(myMsg);
                return null;
            }    
    }
    
    public Integer SaveProjectBuildDetails(String xmlNode,String filepath,String xpath)
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
            Integer statuscode=0;
            if(!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                if(res.getStatusCode()==200){
                    statuscode=res.getStatusCode();
                }
            } 
            return statuscode ;
    }
    
    public Integer SaveProjectConfigDetails()
    {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://www.rabitforce.com:3232/buildservices?wsdl');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
            req.setHeader('SOAPAction', '\"http://ws.build.rabit.com/addCruiseProject\"');
            String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.build.rabit.com/"><soapenv:Header/><soapenv:Body><ws:addCruiseProject><projectxml>'+ PrepareConfigXmlNode() +'</projectxml></ws:addCruiseProject></soapenv:Body></soapenv:Envelope>';
            req.setHeader('Content-Length',String.valueOf(requestString.length()));
            req.setBody(requestString);   
            Integer statuscode=0;
            if(!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                if(res.getStatusCode()==200){
                    statuscode=res.getStatusCode();
                }
            } 
            return statuscode ;
    }
    
    public void getJiraCredentials(){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'text/xml;charset=utf-8');
            req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getJiraCredentials\"');
            String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getJiraCredentials><orgname>'+UserInfo.getOrganizationId()+'</orgname><projectname>'+ name +'</projectname></ws:getJiraCredentials></soapenv:Body></soapenv:Envelope>';
            req.setHeader('Content-Length',String.valueOf(requestString.length()));
            req.setBody(requestString);
            if(!Test.isRunningTest()){
                 HttpResponse res = http.send(req);
            if(res.getStatusCode()== 200 && res.getBodyDocument()!= null){
                 parseOfGetJiraCredentials(res.getBody());
                }
            }
    }
    
    public void parseOfGetJiraCredentials(String xmlRes){
                xmldom d = new xmldom(xmlRes);
            if(d.getElementByTagName('userName')!= NULL){
                    jiraUserName = d.getElementByTagName('userName').nodeValue;
            }
            if(d.getElementByTagName('password')!= NULL){
                    jiraPassword = d.getElementByTagName('password').nodeValue;
            }
            if(d.getElementByTagName('port')!= NULL){
                    jiraPort = d.getElementByTagName('port').nodeValue;
            }
            if(d.getElementByTagName('installationip')!= NULL){
                    jiraIp = d.getElementByTagName('installationip').nodeValue;
            }
            getJiraProjects();
            jiraFldStatus = true;
    }
    
     public String PrepareConfigXmlNode()
        {
             Dom.Document doc = new Dom.Document();
             Dom.Xmlnode rootNode = doc.createRootElement('project', null, null);
             rootNode.setAttribute('name',UserInfo.getOrganizationId()+'_'+name);
                     
             Dom.Xmlnode scheduleNode = rootNode.addChildElement('schedule', null, null);
                     scheduleNode.setAttribute('interval','300');
            if(scheduleOpt.equals('daily')){
                if(fTime.equals('fixtime')){
                     Dom.Xmlnode antNode = createAntBuildForShedule(scheduleNode, '', fixedtimeHours+fixedtimeMints);
                 }
                 if(fTime.equals('finterval')){
                     Integer intervalValue = Integer.valueof(fixedintervelHours.trim());
                     Integer loopInterval =0;
                     Integer newTime = Integer.valueof(fixedintervelatHours.trim());
                     Integer rem = Math.Mod(24,intervalValue);
                        if (rem != 0){
                            loopInterval = 24/intervalValue;
                        } else {
                            loopInterval = 24/intervalValue;
                        }
                    for (Integer i=0;i<=loopInterval;i++){    
                        if (newTime <= 24){
                             if (newTime < 10){
                                 Dom.Xmlnode antNode = createAntBuildForShedule(scheduleNode, '', string.valueof(Integer.valueof('0'+string.valueof(newTime)))+'00');
                            }else {
                                 Dom.Xmlnode antNode = createAntBuildForShedule(scheduleNode, '', string.valueof(newTime)+'00');
                            }
                        }else{
                            newTime = (newTime - 24);
                            if (newTime < 10){
                                Dom.Xmlnode antNode = createAntBuildForShedule(scheduleNode, '', string.valueof(Integer.valueof('0'+string.valueof(newTime)))+'00');
                            }else {
                                Dom.Xmlnode antNode = createAntBuildForShedule(scheduleNode, '', string.valueof(newTime)+'00');
                            }
                        }
                      newTime = newTime +intervalValue;   
                    }
                 }   
             }
             
             if(scheduleOpt.equals('weekly')){
                 for(String weekDay:weeklyDays){
                    Dom.Xmlnode antNode = createAntBuildForShedule(scheduleNode, weekDay, weeklyHours+weeklymints);     
                 } 
             }
              
                              
             Dom.Xmlnode publishersNode = rootNode.addChildElement('publishers', null, null);
             
             Dom.Xmlnode onsuccessNode = publishersNode.addChildElement('onsuccess', null, null);
             if(sourceType.equalsIgnoreCase('svn')){
                     Dom.Xmlnode antpublisher_publish_linecount_Node = onsuccessNode .addChildElement('antpublisher', null, null);
                     antpublisher_publish_linecount_Node.setAttribute('antWorkingDir','${rabit_sdk.dir}/change-analysis/scm');     
                     antpublisher_publish_linecount_Node.setAttribute('anthome','${anthome}');  
                     antpublisher_publish_linecount_Node.setAttribute('buildfile','${rabit_sdk.dir}/change-analysis/scm/svn-change-analysis.xml');  
                     
                     Dom.Xmlnode property_project_name = antpublisher_publish_linecount_Node.addChildElement('property', null, null);
                     property_project_name.setAttribute('name','project.name');
                     property_project_name.setAttribute('value','${project.name}');       
                     
                     Dom.Xmlnode property_srcdir = antpublisher_publish_linecount_Node.addChildElement('property', null, null);
                     property_srcdir.setAttribute('name','srcdir');
                     property_srcdir.setAttribute('value','${cchome}/projects/${project.name}');  
                     
                     Dom.Xmlnode automationdirNode = antpublisher_publish_linecount_Node.addChildElement('property', null, null);
                     automationdirNode.setAttribute('name','automationdir');
                     automationdirNode.setAttribute('value','${project_automation_location}/${project.name}'); 
                   } 
              if(sourceType.equalsIgnoreCase('git')){
                     Dom.Xmlnode antpublisher_publish_linecount_Node = onsuccessNode .addChildElement('antpublisher', null, null);
                     antpublisher_publish_linecount_Node.setAttribute('antWorkingDir','${rabit_sdk.dir}/change-analysis/scm');     
                     antpublisher_publish_linecount_Node.setAttribute('anthome','${anthome}');  
                     antpublisher_publish_linecount_Node.setAttribute('buildfile','${rabit_sdk.dir}/change-analysis/scm/git-change-analysis.xml');  
                     
                     Dom.Xmlnode property_project_name = antpublisher_publish_linecount_Node.addChildElement('property', null, null);
                     property_project_name.setAttribute('name','project.name');
                     property_project_name.setAttribute('value','${project.name}');       
                     
                     Dom.Xmlnode property_srcdir = antpublisher_publish_linecount_Node.addChildElement('property', null, null);
                     property_srcdir.setAttribute('name','srcdir');
                     property_srcdir.setAttribute('value','${cchome}/projects/${project.name}');  
                     
                     Dom.Xmlnode automationdirNode = antpublisher_publish_linecount_Node.addChildElement('property', null, null);
                     automationdirNode.setAttribute('name','automationdir');
                     automationdirNode.setAttribute('value','${project_automation_location}/${project.name}'); 
                   }        
                           
            Dom.Xmlnode artifactspublisher_Node = onsuccessNode.addChildElement('artifactspublisher', null, null);
                     artifactspublisher_Node.setAttribute('dest','${cchome}/artifcats/${project.name}');     
                     artifactspublisher_Node.setAttribute('dir','${project_automation_location}/${project.name}/dist');  
                     
            Dom.Xmlnode email_Node = onsuccessNode.addChildElement('email', null, null);
                     email_Node.setAttribute('returnaddress',senderAddress); 
                     
            Dom.Xmlnode always_Node = email_Node.addChildElement('always', null, null);
                     always_Node.setAttribute('address',UserInfo.getUserEmail());
                     
            Dom.Xmlnode onfailure_Node = publishersNode.addChildElement('onfailure', null, null);
                     
            Dom.Xmlnode onfailure_email_Node = onfailure_Node.addChildElement('email', null, null);
                     onfailure_email_Node.setAttribute('returnaddress',senderAddress); 
                     
            Dom.Xmlnode onfailure_always_Node = onfailure_email_Node.addChildElement('always', null, null);
                     onfailure_always_Node.setAttribute('address',UserInfo.getUserEmail());
                       
            return doc.toXmlString().replace('<?xml version="1.0" encoding="UTF-8"?>','');
        } 
        
      public Dom.Xmlnode createAntBuildForShedule(Dom.Xmlnode scheduleNode,String day,String timeforBuild){
           Dom.Xmlnode antNode = scheduleNode.addChildElement('ant', null, null);
                     antNode.setAttribute('anthome','${anthome}');
                     antNode.setAttribute('buildfile','${project_automation_location}/${project.name}/automation/build-salesforce.xml');
                     if(!timeforBuild.equalsIgnoreCase('')){
                        antNode.setAttribute('time',timeforBuild);
                     }
                     if(!day.equalsIgnoreCase('')){
                        antNode.setAttribute('day',day);
                     }
             Dom.Xmlnode projectProNode = antNode.addChildElement('property', null, null);
                         projectProNode.setAttribute('name','project.name');
                         projectProNode.setAttribute('value','${project.name}');
             Dom.Xmlnode sourceTypeNode = antNode.addChildElement('property', null, null);     
                         sourceTypeNode.setAttribute('name','sourcetype');       
                   if(sourceType.equalsIgnoreCase('sandbox')){  
                             sourceTypeNode.setAttribute('value','sandbox');
                         } 
                   if(!sourceType.equalsIgnoreCase('sandbox')){ 
                           sourceTypeNode.setAttribute('value','scm');
                           sourceTypeNode.setAttribute('name','vcstype'); 
                           if(sourceType.equalsIgnoreCase('git')){
                                   sourceTypeNode.setAttribute('value','git');
                                }
                           if(sourceType.equalsIgnoreCase('svn')){
                                   sourceTypeNode.setAttribute('value','svn');
                                }        
             Dom.Xmlnode scmUrlNode = antNode.addChildElement('property', null, null);
                         scmUrlNode.setAttribute('name','scm.url');  
                         scmUrlNode.setAttribute('value',scmUrl);    
             Dom.Xmlnode scmUsrNode = antNode.addChildElement('property', null, null); 
                         scmUsrNode.setAttribute('name','scm.user');  
                         scmUsrNode.setAttribute('value',scmUserName);
             Dom.Xmlnode scmpassNode = antNode.addChildElement('property', null, null);           
                         scmpassNode.setAttribute('name','scm.password');  
                         scmpassNode.setAttribute('value',encryptPassword(scmPassword));
             Dom.Xmlnode scmTypeNode = antNode.addChildElement('property', null, null);           
                         scmTypeNode.setAttribute('name','sourcetype');  
                         scmTypeNode.setAttribute('value','scm');             
                         } 
           return antNode;              
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
   public String encryptPasswordSucess(String res){
        String resStr; 
        xmldom d = new xmldom(res);
        if(d.getElementByTagName('return')!= NULL){
            resStr = d.getElementByTagName('return').nodeValue;
        }
        return resStr; 
    }
        
        
     public class Components{
          public string ComponentName{ get;set;}
          public string ComponentFlag{get;set;}
      }
      
      public class ComponentsMap{
          public string ComponentName{ get;set;}
          public List<SelectOption> componentsListJira { get; set; }
          public string mappedComp{ get;set;}
      }
      
      public class TestComponents{
         public string CompName{ get;set;}
         public Boolean selenium { get; set; }
         public Boolean ApexCode { get; set; }
         public string Gold{ get;set;}
         public string Platinum{ get;set;}
         public string Silver{ get;set;}
         public string Bronze{ get;set;}  
      }
      
      public void HideJiraTab(){
          if(projectMgmtSystem == False){
              projectMgmtSystem = False;
          }else{
              projectMgmtSystem = True;
          }
      }
}