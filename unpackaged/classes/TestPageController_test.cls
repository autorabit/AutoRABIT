@isTest
public with sharing class TestPageController_test {
        
     static testMethod void PrepareProjectXmlNode_test(){
            TestPageController s = new TestPageController();
            s.name ='aditya';
            s.noOfShownBuilds='two';
            s.isActive=true;
            s.projectMgmtSystem=true;
            string z = s.PrepareProjectXmlNode();
            System.assertEquals('<project name="aditya"><projectdetails><buildstobeshown>two</buildstobeshown><isactive>true</isactive><integrations><jira>true</jira></integrations></projectdetails></project>',z);
        }
     static testMethod void PrepareConfigXmlNode_test(){
            TestPageController s = new TestPageController(); 
            s.name ='aditya';  
            s.toAddresses='gmail.com';
            s.senderAddress='gmail.com';
            s.scmUrl='jff';
            s.scmUserName='esuil';
            s.scmPassword='hgh';
            s.sourceType='svn';
            s.scheduleOpt='daily';
            s.fTime='finterval';
            s.fixedintervelatHours='20';
            s.fixedintervelHours='10';
            string y= s.PrepareConfigXmlNode();
            System.assertEquals('<project name="00D90000000qUC6EAM_aditya"><schedule interval="300"><ant anthome="${anthome}" buildfile="${project_automation_location}/${project.name}/automation/build-salesforce.xml" time="2000"><property name="project.name" value="${project.name}" /><property name="vcstype" value="svn" /><property name="scm.url" value="jff" /><property name="scm.user" value="esuil" /><property name="scm.password" value="" /><property name="sourcetype" value="scm" /></ant><ant anthome="${anthome}" buildfile="${project_automation_location}/${project.name}/automation/build-salesforce.xml" time="600"><property name="project.name" value="${project.name}" /><property name="vcstype" value="svn" /><property name="scm.url" value="jff" /><property name="scm.user" value="esuil" /><property name="scm.password" value="" /><property name="sourcetype" value="scm" /></ant><ant anthome="${anthome}" buildfile="${project_automation_location}/${project.name}/automation/build-salesforce.xml" time="1600"><property name="project.name" value="${project.name}" /><property name="vcstype" value="svn" /><property name="scm.url" value="jff" /><property name="scm.user" value="esuil" /><property name="scm.password" value="" /><property name="sourcetype" value="scm" /></ant></schedule><publishers><onsuccess><antpublisher antWorkingDir="${rabit_sdk.dir}/change-analysis/scm" anthome="${anthome}" buildfile="${rabit_sdk.dir}/change-analysis/scm/svn-change-analysis.xml"><property name="project.name" value="${project.name}" /><property name="srcdir" value="${cchome}/projects/${project.name}" /><property name="automationdir" value="${project_automation_location}/${project.name}" /></antpublisher><artifactspublisher dest="${cchome}/artifcats/${project.name}" dir="${project_automation_location}/${project.name}/dist" /><email returnaddress="gmail.com"><always address="ramesh.g@techsophy.com" /></email></onsuccess><onfailure><email returnaddress="gmail.com"><always address="ramesh.g@techsophy.com" /></email></onfailure></publishers></project>', y);
            s.sourceType='git';
            y= s.PrepareConfigXmlNode();
            System.assertEquals('<project name="00D90000000qUC6EAM_aditya"><schedule interval="300"><ant anthome="${anthome}" buildfile="${project_automation_location}/${project.name}/automation/build-salesforce.xml" time="2000"><property name="project.name" value="${project.name}" /><property name="vcstype" value="git" /><property name="scm.url" value="jff" /><property name="scm.user" value="esuil" /><property name="scm.password" value="" /><property name="sourcetype" value="scm" /></ant><ant anthome="${anthome}" buildfile="${project_automation_location}/${project.name}/automation/build-salesforce.xml" time="600"><property name="project.name" value="${project.name}" /><property name="vcstype" value="git" /><property name="scm.url" value="jff" /><property name="scm.user" value="esuil" /><property name="scm.password" value="" /><property name="sourcetype" value="scm" /></ant><ant anthome="${anthome}" buildfile="${project_automation_location}/${project.name}/automation/build-salesforce.xml" time="1600"><property name="project.name" value="${project.name}" /><property name="vcstype" value="git" /><property name="scm.url" value="jff" /><property name="scm.user" value="esuil" /><property name="scm.password" value="" /><property name="sourcetype" value="scm" /></ant></schedule><publishers><onsuccess><antpublisher antWorkingDir="${rabit_sdk.dir}/change-analysis/scm" anthome="${anthome}" buildfile="${rabit_sdk.dir}/change-analysis/scm/git-change-analysis.xml"><property name="project.name" value="${project.name}" /><property name="srcdir" value="${cchome}/projects/${project.name}" /><property name="automationdir" value="${project_automation_location}/${project.name}" /></antpublisher><artifactspublisher dest="${cchome}/artifcats/${project.name}" dir="${project_automation_location}/${project.name}/dist" /><email returnaddress="gmail.com"><always address="ramesh.g@techsophy.com" /></email></onsuccess><onfailure><email returnaddress="gmail.com"><always address="ramesh.g@techsophy.com" /></email></onfailure></publishers></project>', y);
       }
      static testMethod void getJiraCredentials_test(){
            TestPageController s = new TestPageController(); 
            s.getJiraCredentials();
       } 
      static testMethod void SaveProjectConfigDetails_test(){
            TestPageController s = new TestPageController(); 
            s.name ='aditya';  
            s.toAddresses='gmail.com';
            s.senderAddress='gmail.com';
            s.scmUrl='jff';
            s.scmUserName='esuil';
            s.scmPassword='hgh';
            s.sourceType='svn';
            s.scheduleOpt='dialy';
            s.fTime='finterval';
            Integer statuscode = s.SaveProjectConfigDetails();
            System.assertEquals(0, statuscode);
         } 
      static testMethod void  saveProjectBuild_test(){
            TestPageController s = new TestPageController(); 
            s.scheduleOpt='daily';
            s.fTime='finterval';
            s.fixedintervelHours='10';
            s.fixedintervelatHours='20';
            s.toAddresses='gmail.com';
            s.senderAddress='gmail.com';
            s.name ='';
            s.deploySforgName='';
            s.saveProjectBuild();
            s.name ='aditya';
            s.sourceType='sandbox';
            s.retrivalSforgName='';
            s.saveProjectBuild();
            s.retrivalSforgName='gsh';
            s.saveProjectBuild();
            s.sourceType='svn';
            s.scmUrl='';
            s.saveProjectBuild();
            s.scmUrl='dfbgwsr';
            s.scmUserName='';
            s.saveProjectBuild();
            s.scmUserName='esuil';
            s.scmPassword='';
            s.saveProjectBuild();
            s.scmPassword='hgh';
            s.saveProjectBuild();
            s.deploySforgName='vinay.d@72demo.com';
            s.saveProjectBuild();
        } 
     static testMethod void saveProjectTestCases_test(){
            TestPageController s= new TestPageController();
            TestPageController.TestComponents s1 = new TestPageController.TestComponents();
            s.testCasesComponent = new list<TestPageController.TestComponents>();
            s1.ApexCode=true;
            s1.Bronze='sss';
            s1.CompName='abdc';
            s1.Gold='gold';
            s1.Platinum='platinum';
            s1.selenium=true;
            s1.Silver='silver';
            s.testCasesComponent.add(s1);
            s.selected_comp='asdf';
            s.selenium=true;
            s.platinum='s';
            s.gold='s';
            s.silver='s';
            s.bronze='s';
            s.codeCover=true;
            s.name='adad';
            s.saveProjectTestCases();
        }
     static testMethod void HideJiraTab_test(){
            TestPageController s= new TestPageController();
            s.projectMgmtSystem=true;
            s.HideJiraTab();
            s.projectMgmtSystem=false;
            s.HideJiraTab();
        }
     static testMethod void  cancelProjectCreation_test(){
            TestPageController s = new TestPageController();
            string a = s.cancelProjectCreation().getUrl();
            system.assertEquals('/apex/rabitforce__projects', a);
        }
     static testMethod void saveScheduleBuildPreferences_test(){
            TestPageController s = new TestPageController();
            s.saveScheduleBuildPreferences();
     }
    static testMethod void prepareSchedulePreferenceNode_test(){
            TestPageController s = new TestPageController();
            s.buildEnabled=true;
            s.testEnabled = true;
            s.componentSet.add('demo');
            s.categorySet.add('gold');
            s.selenium=true;
            s.prepareSchedulePreferenceNode();
     }
     static testMethod void  getsourceType_test(){
            TestPageController s = new TestPageController();
            s.sourceType='git';
            s.getsourceType();
            s.sourceType='sandbox';
            s.getsourceType();
            s.sourceType='svn';
            s.getsourceType();
        }
     static testMethod void getDataFromConfig_test(){
            TestPageController s = new TestPageController();
            s.getDataFromConfig();
        }
     static testMethod void createProject_test(){
            TestPageController s = new TestPageController();
            TestPageController.TestComponents s1 = new TestPageController.TestComponents();
            s.testCasesComponent = new list<TestPageController.TestComponents>();
            s1.ApexCode=true;
            s1.Bronze='sss';
            s1.CompName='abdc';
            s1.Gold='gold';
            s1.Platinum='platinum';
            s1.selenium=true;
            s1.Silver='silver';
            s.testCasesComponent.add(s1);
            s.name='';
            s.isActive=true;
            
            s.createProject();
        }
     static testMethod void onLoadPageController_test(){
            PageReference PageRef = Page.Testpage;
            PageRef.getParameters().put('edit','true');
            PageRef.getParameters().put('jira','true');
            PageRef.getParameters().put('projectName','SalesAutomation');
            Test.setCurrentPage(PageRef);
            TestPageController s = new TestPageController();
            s.onLoadPageController();
            PageReference PageRef1 = Page.Testpage;
            PageRef1.getParameters().put('edit','false');
            PageRef1.getParameters().put('jira','true');
            PageRef1.getParameters().put('projectName','SalesAutomation');
            Test.setCurrentPage(PageRef1);
            s.onLoadPageController();
        }
     static testMethod void verifyJiraCredentials_test(){
            TestPageController s = new TestPageController();
            s.jiraIp='';
            s.verifyJiraCredentials();
            s.jiraPort='';
            s.jiraIp='1234';
            s.verifyJiraCredentials();
            s.jiraUserName='';
            s.jiraPort='123.23.4';
            s.verifyJiraCredentials();
            s.jiraUserName='aditya';
            s.jiraPassword='';
            s.verifyJiraCredentials();
            s.jiraPassword='abcd';
            s.name='aditya';
            s.verifyJiraCredentials();
        }
      
     static testMethod void SaveComponent_test(){
            TestPageController.Components s = new TestPageController.Components();
            TestPageController tpc = new TestPageController();
            s.ComponentName = 'aditya';
            s.ComponentFlag = 'true';
            tpc.lstComponent = new list<TestPageController.Components>();
            tpc.lstComponent.add(s);
            tpc.SaveComponent();
        }
     static testMethod void parseSaveComponent_test(){
            TestPageController s = new TestPageController();
            s.parseSaveComponent(200);
            s.parseSaveComponent(0);
        }
     static testMethod void ShowTestTypesDiv_test(){
            TestPageController s = new TestPageController();
            TestPageController.TestComponents y = new TestPageController.TestComponents();  
            y.Bronze='a';
            y.CompName='b';
            y.Gold='c';
            y.Platinum='d';
            y.Silver='e';
            y.selenium=true;
            s.editMode='true';
            s.selected_comp='b';
            s.testCasesComponent = new list<TestPageController.TestComponents>();
            s.testCasesComponent.add(y);
            s.ShowTestTypesDiv();
            s.editMode='false';
            s.selenium = false;
            s.ShowTestTypesDiv();
            s.editMode='false';
            s.selenium = true;
            s.selected_comp ='Demo';
            s.ShowTestTypesDiv();
       }
    static testMethod void getscheduleOption_test(){
            TestPageController s = new TestPageController();
            s.scheduleOpt='daily';
            s.getscheduleOption();
            s.scheduleOpt='weekly';
            s.getscheduleOption();
       }
    static testMethod void getSelectedSchOptTime_test(){
            TestPageController s = new TestPageController();
            s.fTime='fixtime';
            s.getSelectedSchOptTime();
            s.fTime='finterval';
            s.getSelectedSchOptTime();
       }
    static testMethod void ShowPojectsPageDiv(){
            TestPageController s = new TestPageController();
            s.ShowPojectsPageDiv();
       }
    static testMethod void getJiraProjects_test(){
            TestPageController s = new TestPageController();
            s.getJiraProjects();
       }
    static testMethod void parseOfCreateProject_test(){
            TestPageController s = new TestPageController();
            s.testEnabled=true;
            s.selenium=true;
            TestPageController.TestComponents s1 = new TestPageController.TestComponents();
            s.testCasesComponent = new list<TestPageController.TestComponents>();
            s1.ApexCode=true;
            s1.Bronze='sss';
            s1.CompName='abdc';
            s1.Gold='gold';
            s1.Platinum='platinum';
            s1.selenium=true;
            s1.Silver='silver';
            s.testCasesComponent.add(s1);
            s.parseOfCreateProject(200, 200);
            s.parseOfCreateProject(0, 0);
       }
    static testMethod void PrepareXmlNode_test(){
            TestPageController s = new TestPageController();
            s.scmUserName='ffj';
            s.scmPassword='bdfuhbuye';
            s.scmUrl='bdfuibhdfui';
            s.retrivalSforgName='agag';
            s.deploySforgName='dvdv';
            s.toAddresses='gmail.com';
            s.senderAddress='gmail.com';
            s.scheduleOpt='daily';
            s.fixedintervelHours='10';
            s.fixedintervelatHours='20';
            s.fTime='finterval';
            s.sourceType='sandbox';
            s.PrepareXmlNode();
            s.sourceType='sforg';
            s.PrepareXmlNode();
            s.scheduleOpt='weekly';
            s.PrepareXmlNode();
       }
    static testMethod void DeleteComponent_test(){
            TestPageController s = new TestPageController();     
            TestPageController.Components tpc  = new TestPageController.Components(); 
            tpc.ComponentName = 'aditya';
            tpc.ComponentFlag = 'true';
            s.lstComponent = new list<TestPageController.Components>();
            s.lstComponent.add(tpc);
            s.DeleteComponent();
       }
    static testMethod void saveJiraConfiguration_test(){
            TestPageController s = new TestPageController();
            s.jiraSelProject='select';
            s.saveJiraConfiguration();
            s.projects = (Map<String, Object>)JSON.deserializeUntyped('{"DEMO":"Demonstration Project","DEM":"DemoProject"}');
            s.jiraSelProject='DEMO';
            TestPageController.ComponentsMap cmp = new TestPageController.ComponentsMap();
            cmp.ComponentName='abcd';
            cmp.mappedComp='id';
            s.jiraComponents = new list<TestPageController.ComponentsMap>();
            s.jiraComponents.add(cmp);
            s.components = (Map<String, Object>)JSON.deserializeUntyped('{"10001":"test2","10000":"test1"}');
            //s.saveJiraConfiguration();
          
       }
    static testMethod void getJiraComponents_test(){
            TestPageController s = new TestPageController();
            TestPageController.Components sl = new TestPageController.Components();
            TestPageController.Components sk = new TestPageController.Components();
            TestPageController.Components si = new TestPageController.Components();
            s.jiraSelProject='select';
            s.getJiraComponents();
            s.jiraSelProject='deed';
            sl.ComponentName = 'aditya';
            sl.ComponentFlag = 'true';
            s.lstComponent = new list<TestPageController.Components>();
            s.lstComponent.add(sl);
            s.getJiraComponents();
            sk.ComponentName = 'aditya';
            sk.ComponentFlag = 'true';
            si.ComponentName = 'aditya';
            si.ComponentFlag = 'true';
            s.lstComponent.add(sk);
            s.lstComponent.add(si);
            s.getJiraComponents();
       }
    static testMethod void parseCongfigXml_test(){
            TestPageController s = new TestPageController();
            TestPageController.ComponentsMap cmp = new TestPageController.ComponentsMap();
            TestPageController.TestComponents s1 = new TestPageController.TestComponents();
            cmp.ComponentName='abcd';
            cmp.mappedComp='xyz';
            s.testCasesComponent = new list<TestPageController.TestComponents>();
            s1.ApexCode=true;
            s1.Bronze='sss';
            s1.CompName='abdc';
            s1.Gold='gold';
            s1.Platinum='platinum';
            s1.selenium=true;
            s1.Silver='silver';
            s.testCasesComponent.add(s1);
            s.jiraComponents = new list<TestPageController.ComponentsMap>();
            s.jiraComponents.add(cmp);
            s.parseCongfigXml('<project name="SalesAutomation"><projectdetails><buildstobeshown>5</buildstobeshown><isactive>true</isactive><integrations><jira>true</jira></integrations></projectdetails><jira><mappedtoproject projkey="DEMO">Demonstration Project</mappedtoproject><component id="10001" mappedto="test2" name="Registration" /><component id="10000" mappedto="test1" name="SalesExecutive" /></jira><builddetails><server>182.18.162.12</server><deploymentservers>182.18.162.12</deploymentservers><schedule option="0"><time>2100</time></schedule><source id="0397508515151381556117109310811301367157101287" type="sandbox" /><target id="0397508515151381556117109310811301367157101375" /><emailnotificationaddresses><senderaddress>buildmaster@lemtom.com</senderaddress><toaddresses>ramesh.g@lemtom.com</toaddresses></emailnotificationaddresses></builddetails><components><component name="SalesExcutive" /><component name="Registration"><testtypes><type name="Selenium"><category name="platinum"><package>com.techsophy.app</package></category></type></testtypes></component></components></project>');
            
       }
    static testMethod void parseOfGetJiraComponents_test(){
            TestPageController s = new TestPageController();
            TestPageController.Components tpc  = new TestPageController.Components(); 
            tpc.ComponentName = 'aditya';
            tpc.ComponentFlag = 'true';
            s.lstComponent = new list<TestPageController.Components>();
            s.lstComponent.add(tpc);            
            s.parseOfGetJiraComponents('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getJiraComponentsResponse xmlns:ns2="http://ws.service.rabit.com/"><return>{}</return></ns2:getJiraComponentsResponse></S:Body></S:Envelope>'); 
       }
    static testMethod void parseOfGetJiraProjects_test(){
            TestPageController s = new TestPageController();
            s.parseOfGetJiraProjects('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getJiraProjectsResponse xmlns:ns2="http://ws.service.rabit.com/"><return>{}</return></ns2:getJiraProjectsResponse></S:Body></S:Envelope');
       }
    static testMethod void parseOfGetJiraCredentials_test(){
            TestPageController s = new TestPageController();
            s.parseOfGetJiraCredentials('<?xml version="1.0" ?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getJiraCredentialsResponse xmlns:ns2="http://ws.service.rabit.com/"><return><userName>jira</userName><password>jira</password><port>8090</port><installationip>182.18.162.12</installationip></return></ns2:getJiraCredentialsResponse></S:Body></S:Envelope>');
       }
    static testMethod void AddComponent_test(){
            TestPageController s = new TestPageController();   
            TestPageController.Components tpc  = new TestPageController.Components(); 
            tpc.ComponentName = 'aditya';
            tpc.ComponentFlag = 'true';
            s.lstComponent = new list<TestPageController.Components>();
            s.lstComponent.add(tpc);
            s.AddComponent();
       }
    static testMethod void parseOfGetRegSfOrgList_test(){
            TestPageController s = new TestPageController();    
            s.parseOfGetRegSfOrgList('<project name="SalesAutomation"><projectdetails><buildstobeshown>5</buildstobeshown><isactive>true</isactive><integrations><jira>true</jira></integrations></projectdetails><builddetails><server>182.18.162.12</server><deploymentservers>182.18.162.12</deploymentservers><schedule option="0"><time>2100</time></schedule><source name="Developer" type="sforg" /><target name="Integration" /><emailnotificationaddresses><senderaddress>buildmaster@lemtom.com</senderaddress><toaddresses>ramesh.g@lemtom.com</toaddresses></emailnotificationaddresses></builddetails><components><component name="SalesExecutive" /><component name="Registration"><testtypes><type name="Selenium"><category name="platinum"><package>com.techsophy.app</package></category></type><type name="apexcodecoverage" /></testtypes></component></components><jira><mappedtoproject projkey="DEMO">Demonstration Project</mappedtoproject><component id="10000" mappedto="test1" name="Registration" /><component id="10001" mappedto="test2" name="SalesExecutive" /></jira></project>');
            
       }
    static testMethod void encryptPassword_test(){
            TestPageController s = new TestPageController();   
            s.encryptPassword('abcd');   
       }
    static testMethod void decryptPassword_test(){
            TestPageController s = new TestPageController();   
            s.decryptPassword('abcd');
            
       }
    static testMethod void saveJiraCredentials_test(){
            TestPageController s = new TestPageController();   
            s.jiraIp='';
            s.saveJiraCredentials();
            s.jiraIp='eee';
            s.jiraPort='';
            s.saveJiraCredentials();
            s.jiraIp='eee';
            s.jiraPort='dfgf';
            s.jiraUserName='';
            s.saveJiraCredentials();
            s.jiraIp='eee';
            s.jiraPort='dfgf';
            s.jiraUserName='dfssv';
            s.jiraPassword='';
            s.saveJiraCredentials();
            s.jiraIp='eee';
            s.jiraPort='dfgf';
            s.jiraUserName='dfssv';
            s.jiraPassword='fdsgserg';
            s.saveJiraCredentials();
            
       }
    static testMethod void saveJiraCredentials_Webservice_test(){
            TestPageController s = new TestPageController();   
            s.saveJiraCredentials_Webservice();
            
       }   
    static testMethod void parseOfSaveJiraCredentials_Webservice_test(){
            TestPageController s = new TestPageController();   
            s.parseOfSaveJiraCredentials_Webservice('?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:saveJiraPropertiesResponse xmlns:ns2="http://ws.service.rabit.com/"><return>true</return></ns2:saveJiraPropertiesResponse></S:Body></S:Envelope>');
            
       }      
     static testMethod void encryptPasswordSucess_test(){
        TestPageController s = new TestPageController();
         String pf=s.encryptPasswordSucess('<return>sdhsbdsdsdsdsdsd</return>');
    }
    static testMethod void decryptPasswordSucess_test(){
        TestPageController s = new TestPageController();
         String pf=s.decryptPasswordSucess('<return>demotest</return>');
    }   
    static testMethod void getWeeklyDays_test(){
        TestPageController s = new TestPageController();
        s.getWeeklyDays();
    }
    static testMethod void setWeeklyDays_test(){
        TestPageController s = new TestPageController();
        List<String> days= new List<String>();
        days.add('sunday');
        days.add('monday');
        s.setWeeklyDays(days);
    }
}