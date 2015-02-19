@isTest
public class BuildsManagement_test {
    
    static testMethod void getProjects_test() {
        BuildsManagement bm = new BuildsManagement();
        String retVal = bm.getProjects();
        String expectedResult = '<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getActiveProjectNamesResponse xmlns:ns2="http://ws.service.rabit.com/"><return>DemoProject,TestProject,</return></ns2:getActiveProjectNamesResponse></S:Body></S:Envelope>';
        System.assertEquals(retVal, expectedResult);
     }
     
     static testMethod void parseResponseofGetProjects_test() {
         BuildsManagement bm = new BuildsManagement();
         bm.parseResponseofGetProjects();
         System.assertEquals(2,bm.projectList.size());
     } 
     
     static testMethod void showDashBoard_test() {
         BuildsManagement bm = new BuildsManagement();
         bm.selectedProject='DemoProject';
         bm.proBno='3';
         String nextPage = bm.showDashBoard().getUrl();
         System.assertEquals('/apex/rabitforce__dashboard?bno=3&proj=DemoProject',nextPage);
     } 
     
     static testMethod void TestReportPage_test() {
         BuildsManagement bm = new BuildsManagement();
         bm.selectedProject='DemoProject';
         bm.proBno='3';
         String nextPage = bm.TestReportPage().getUrl();
         System.assertEquals('/apex/rabitforce__testreportpage?bno=3&proj=DemoProject',nextPage);
     } 
     
     static testMethod void promotionBuild_test() {
         BuildsManagement bm = new BuildsManagement();
         bm.selectedProject='DemoProject';
         bm.proBno='3';
         bm.promotionBuild();
        // System.assertEquals('/apex/rabitforce__promotionbuild?bno=3&proj=DemoProject',nextPage);
     }
     
     static testMethod void parseBuildSummary_test() {
        BuildsManagement bm = new BuildsManagement();
        bm.parseBuildSummary('<build branch="SalesAutomation" buildnumber="5" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.11.04.47.45"><buildstatus><osstatus type="salesforce">ready</osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="11-12-2013 10.19.16" insstarttime="11-12-2013 10.18.56" name="VM-SR793" result="completed" starttime="11-12-2013 10.18.56" type="salesforce"><installationstatus>Successful</installationstatus></server><summary><os failures="1" type="windows"><testtype failures="1" name="Selenium"><browser failures="1" type="firefox" /></testtype></os></summary></regressionstatus></build');
        System.assertEquals(1, bm.listOfBuilds.size()); 
        bm.parseBuildSummary('<build branch="SalesAutomation" buildnumber="5" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.11.04.47.45"><buildstatus><osstatus type="salesforce">failed</osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="11-12-2013 10.19.16" insstarttime="11-12-2013 10.18.56" name="VM-SR793" result="completed" starttime="11-12-2013 10.18.56" type="salesforce"><installationstatus>Successful</installationstatus></server><summary><os failures="1" type="windows"><testtype failures="1" name="Selenium"><browser failures="1" type="firefox" /></testtype></os></summary></regressionstatus></build');
        bm.parseBuildSummary('<build branch="SalesAutomation" buildnumber="5" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.11.04.47.45"><buildstatus><osstatus type="salesforce"></osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="11-12-2013 10.19.16" insstarttime="11-12-2013 10.18.56" name="VM-SR793" result="completed" starttime="11-12-2013 10.18.56" type="salesforce"><installationstatus>Successful</installationstatus></server><summary><os failures="1" type="windows"><testtype failures="1" name="Selenium"><browser failures="1" type="firefox" /></testtype></os></summary></regressionstatus></build');
        bm.parseBuildSummary('<build branch="SalesAutomation" buildnumber="5" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.11.04.47.45"><buildstatus><osstatus type="salesforce">ready</osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="11-12-2013 10.19.16" insstarttime="11-12-2013 10.18.56" name="VM-SR793" result="completed" starttime="11-12-2013 10.18.56" type="salesforce"><installationstatus>Successful</installationstatus></server><summary><os failures="1" type="windows"><testtype failures="1" name="Selenium"><browser failures="1" type="firefox" /></testtype></os></summary></regressionstatus></build');
        bm.parseBuildSummary('<build branch="SalesAutomation" buildnumber="5" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.11.04.47.45"><buildstatus><osstatus type="salesforce">ready</osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="11-12-2013 10.19.16" insstarttime="11-12-2013 10.18.56" name="VM-SR793" result="completed" starttime="11-12-2013 10.18.56" type="salesforce"><installationstatus>failed</installationstatus></server><summary><os failures="1" type="windows"><testtype failures="1" name="Selenium"><browser failures="1" type="firefox" /></testtype></os></summary></regressionstatus></build');
        bm.parseBuildSummary('<build branch="SalesAutomation" buildnumber="5" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.11.04.47.45"><buildstatus><osstatus type="salesforce">ready</osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="11-12-2013 10.19.16" insstarttime="11-12-2013 10.18.56" name="VM-SR793" result="completed" starttime="11-12-2013 10.18.56" type="salesforce"><installationstatus>inprogress</installationstatus></server><summary><os failures="1" type="windows"><testtype failures="1" name="Selenium"><browser failures="1" type="firefox" /></testtype></os></summary></regressionstatus></build');
        bm.parseBuildSummary('<build branch="SalesAutomation" buildnumber="5" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.11.04.47.45"><buildstatus><osstatus type="salesforce">ready</osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="11-12-2013 10.19.16" insstarttime="11-12-2013 10.18.56" name="VM-SR793" result="completed" starttime="11-12-2013 10.18.56" type="salesforce"><installationstatus></installationstatus></server><summary><os failures="1" type="windows"><testtype failures="1" name="Selenium"><browser failures="1" type="firefox" /></testtype></os></summary></regressionstatus></build');
        bm.parseBuildSummary('<build branch="SalesAutomation" buildnumber="5" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.11.04.47.45"><buildstatus><osstatus type="salesforce">ready</osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="11-12-2013 10.19.16" insstarttime="11-12-2013 10.18.56" name="VM-SR793" result="completed" starttime="11-12-2013 10.18.56" type="salesforce"><installationstatus>inprogress</installationstatus></server><summary><os failures="1" type="windows"><testtype failures="1" name="Selenium"><browser failures="1" type="firefox" /></testtype></os></summary></regressionstatus></build');
        bm.parseBuildSummary('<build branch="SalesAutomation" buildnumber="5" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.11.04.47.45"><buildstatus><osstatus type="salesforce">ready</osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="11-12-2013 10.19.16" insstarttime="11-12-2013 10.18.56" name="VM-SR793" result="completed" starttime="11-12-2013 10.18.56" type="salesforce"><installationstatus>inprogress</installationstatus></server><summary><os failures="0" type="windows"><testtype failures="1" name="Selenium"><browser failures="1" type="firefox" /></testtype></os></summary></regressionstatus></build');
        bm.parseBuildSummary('<build branch="SalesAutomation" buildnumber="5" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.11.04.47.45"><buildstatus><osstatus type="salesforce">Ready</osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="11-12-2013 10.19.16" insstarttime="11-12-2013 10.18.56" name="VM-SR793" result="completed" starttime="11-12-2013 10.18.56" type="salesforce"><installationstatus>Successful</installationstatus></server></regressionstatus></build>');
        bm.parseBuildSummary('<build branch="SalesAutomation" buildnumber="5" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.11.04.47.45"><buildstatus><osstatus type="salesforce">Ready</osstatus></buildstatus></build>');
        bm.parseBuildSummary('<build branch="SalesAutomation" buildnumber="5" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.11.04.47.45"><buildstatus><osstatus type="salesforce">ready</osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="11-12-2013 10.19.16" insstarttime="11-12-2013 10.18.56" name="VM-SR793" result="completed" starttime="11-12-2013 10.18.56" type="salesforce"><installationstatus>inprogress</installationstatus></server><summary><os failures=" " type="windows"><testtype failures="1" name="Selenium"><browser failures=" " type="firefox" /></testtype></os></summary></regressionstatus></build');
        bm.parseBuildSummary('<build branch="SalesAutomation" buildnumber="5" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.11.04.47.45"><buildstatus><osstatus type="salesforce">ready</osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="11-12-2013 10.19.16" insstarttime="11-12-2013 10.18.56" name="VM-SR793" result="completed" starttime="11-12-2013 10.18.56" type="salesforce"><installationstatus>inprogress</installationstatus></server><summary><os failures="" type="windows"></os></summary></regressionstatus></build');
    }
    
    static testMethod void getProjectBuildSummary_test() {
         BuildsManagement bm = new BuildsManagement();
         bm.selectedProject='DemoProject';
         bm.getProjectBuildSummary();
         }
        
     static testMethod void webserviceCallForTriggerBuild_test() {
        BuildsManagement bm = new BuildsManagement();
        bm.selectedProject='DemoProject';
        bm.webserviceCallForTriggerBuild();
            
     }  
     static testMethod void onloadPage_test(){
         BuildsManagement bm = new BuildsManagement();
         bm.selectedProject = 'DemoProject';
         BuildsManagement.BuildSummary s1 = new BuildsManagement.BuildSummary();
         bm.reOrderOfBuilds = new list<BuildsManagement.BuildSummary>();
         s1.buildDTime='324'; 
         s1.buildNumber='324'; 
         s1.buildStatus='324'; 
         s1.installationStatus='324'; 
         s1.failedUITests='324'; 
         s1.buildPass=true; 
         s1.buildFail=true; 
         s1.buildInProgress=true; 
         s1.installPass=true; 
         s1.installFail=true; 
         s1.installInProgress=true; 
         s1.installEmpty=true; 
         s1.testsPass=true; 
         s1.testsFail=true; 
         s1.testsInProgress=true; 
         s1.testsEmpty=true; 
         bm.reOrderOfBuilds.add(s1);
         bm.onloadPage();
     }
    
     static testMethod void parseResponseOfTriggerBuild_test(){
        BuildsManagement bm = new BuildsManagement();
        bm.parseResponseOfTriggerBuild('response in build queue');
        bm.parseResponseOfTriggerBuild('response');
     }
     static testMethod void getProjectBuildSummary_test_another(){
        BuildsManagement bm = new BuildsManagement();
        bm.selectedProject=NULL;
        bm.getProjectBuildSummary();
     }
     static testMethod void enableBuildPref_test(){
        BuildsManagement bm = new BuildsManagement();  
        bm.enableBuildPref();
  
     }
     static testMethod void closePopup_test(){
        BuildsManagement bm = new BuildsManagement();  
        bm.closePopup();
  
     }
     static testMethod void showPopup_test(){
        BuildsManagement bm = new BuildsManagement();  
        bm.showPopup();
  
     }
     static testMethod void parseCongfigXml_test(){
        BuildsManagement bm = new BuildsManagement();  
        bm.parseCongfigXml('<project name="SalesAutomation"><projectdetails><buildstobeshown>5</buildstobeshown><isactive>true</isactive><integrations><jira>true</jira></integrations></projectdetails><components><component name="SalesExecutive" /><component name="Registration"><testtypes><type name="Selenium"><category name="platinum"><package>com.techsophy.app</package></category></type><type name="apexcodecoverage" /></testtypes></component></components><jira><mappedtoproject projkey="DEMO">Demonstration Project</mappedtoproject><component id="10001" mappedto="test2" name="Registration" /><component id="10000" mappedto="test1" name="SalesExecutive" /></jira><builddetails><server>182.18.162.12</server><deploymentservers>182.18.162.12</deploymentservers><schedule option="0"><time>2100</time></schedule><source id="0397508515151381556117109310811301367157101287" type="sandbox" /><target id="0397508515151381556117109310811301367157101375" /><emailnotificationaddresses><senderaddress>buildmaster@lemtom.com</senderaddress><toaddresses>ramesh.g@lemtom.com</toaddresses></emailnotificationaddresses></builddetails></project>');
        bm.parseCongfigXml('<project name="SalesAutomation"><projectdetails><buildstobeshown>5</buildstobeshown><isactive>true</isactive><integrations><jira>false</jira></integrations></projectdetails><components><component name="SalesExecutive" /><component name="Registration"><testtypes><type name="Selenium"><category name="platinum"><package>com.techsophy.app</package></category></type><type name="apexcodecoverage" /></testtypes></component></components><builddetails><server>182.18.162.12</server><deploymentservers>182.18.162.12</deploymentservers><schedule option="0"><time>2100</time></schedule><source id="0397508515151381556117109310811301367157101287" type="sandbox" /><target id="0397508515151381556117109310811301367157101375" /><emailnotificationaddresses><senderaddress>buildmaster@lemtom.com</senderaddress><toaddresses>ramesh.g@lemtom.com</toaddresses></emailnotificationaddresses></builddetails></project>'); 
  
     }
     static testMethod void redirectPopup_test(){
        BuildsManagement bm = new BuildsManagement(); 
        BuildsManagement.BuildSummary s1 = new BuildsManagement.BuildSummary();
         BuildsManagement.Components s2 = new BuildsManagement.Components();
         BuildsManagement.Categories s3 = new BuildsManagement.Categories();
         BuildsManagement.TestTypes s4 = new BuildsManagement.TestTypes();
         bm.listOfBuilds = new list<BuildsManagement.BuildSummary>(); 
         bm.compList = new list<BuildsManagement.Components>(); 
         bm.categList = new list<BuildsManagement.Categories>(); 
         bm.ttList = new list<BuildsManagement.TestTypes>(); 
         s1.buildDTime='324'; 
         s1.buildNumber='324'; 
         s1.buildStatus='324'; 
         s1.installationStatus='324'; 
         s1.failedUITests='324'; 
         s1.buildPass=true; 
         s1.buildFail=true; 
         s1.buildInProgress=true; 
         s1.installPass=true; 
         s1.installFail=true; 
         s1.installInProgress=true; 
         s1.installEmpty=true; 
         s1.testsPass=true; 
         s1.testsFail=true; 
         s1.testsInProgress=true; 
         s1.testsEmpty=true; 
         bm.listOfBuilds.add(s1); 
         bm.build='bbfsd';
         bm.serverIp='rbhjbf';
         bm.installBuild='ndfkn';
         bm.testRun='bfvb';
         s2.flag='true';
         s2.name='fiojo';
         s3.flag='true';
         s3.name='fiojo';
         s4.flag='true';
         s4.name='fiojo';
         bm.compList.add(s2); 
         bm.categList.add(s3); 
         bm.ttList.add(s4); 
        bm.redirectPopup();
  
     }
  
     static testMethod void saveBuildPreferences_test(){
        BuildsManagement bm = new BuildsManagement();  
        bm.selectedProject='abdc';
           BuildsManagement.BuildSummary s1 = new BuildsManagement.BuildSummary();
         BuildsManagement.Components s2 = new BuildsManagement.Components();
         BuildsManagement.Categories s3 = new BuildsManagement.Categories();
         BuildsManagement.TestTypes s4 = new BuildsManagement.TestTypes();
         bm.listOfBuilds = new list<BuildsManagement.BuildSummary>(); 
         bm.compList = new list<BuildsManagement.Components>(); 
         bm.categList = new list<BuildsManagement.Categories>(); 
         bm.ttList = new list<BuildsManagement.TestTypes>(); 
         s1.buildDTime='324'; 
         s1.buildNumber='324'; 
         s1.buildStatus='324'; 
         s1.installationStatus='324'; 
         s1.failedUITests='324'; 
         s1.buildPass=true; 
         s1.buildFail=true; 
         s1.buildInProgress=true; 
         s1.installPass=true; 
         s1.installFail=true; 
         s1.installInProgress=true; 
         s1.installEmpty=true; 
         s1.testsPass=true; 
         s1.testsFail=true; 
         s1.testsInProgress=true; 
         s1.testsEmpty=true; 
         bm.listOfBuilds.add(s1); 
         bm.build='bbfsd';
         bm.serverIp='rbhjbf';
         bm.installBuild='ndfkn';
         bm.testRun='bfvb';
         s2.flag='true';
         s2.name='fiojo';
         s3.flag='true';
         s3.name='fiojo';
         s4.flag='true';
         s4.name='fiojo';
         bm.compList.add(s2); 
         bm.categList.add(s3); 
         bm.ttList.add(s4); 
        bm.saveBuildPreferences();
  
     }
     static testMethod void hashCode_test(){
        BuildsManagement bm = new BuildsManagement();  
        bm.hashCode();
  
     }
  
  
}