@isTest
private class PromotionControler_test {

     static testMethod void onLoadPromotionControler_test() {
        PromotionControler pc= new PromotionControler();
        PageReference PageRef = Page.promotionBuild;
        PageRef.getParameters().put('bno','13');
        PageRef.getParameters().put('proj','SalesAutomation');
        Test.setCurrentPage(PageRef); 
        pc.onLoadPromotionControler();
     }
    
    static testMethod void deployBuildSucess_test() {
        PromotionControler pc= new PromotionControler();
        pc.deployBuildSucess();
    }
    
     static testMethod void parseOfGetProjects_test() {
        PromotionControler pc= new PromotionControler();
        String resStr='<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getActiveProjectNamesResponse xmlns:ns2="http://ws.service.rabit.com/"><return>DemoProject,TestProject</return></ns2:getActiveProjectNamesResponse></S:Body></S:Envelope>';
        pc.parseOfGetProjects(resStr);
        System.assertEquals(2, pc.projectList.size());
     }
       static testMethod void closePopup_test() {
        PromotionControler pc= new PromotionControler();
        pc.closePopup();
      }
     
     static testMethod void showPromotionLog_test() {
        PromotionControler pc= new PromotionControler();
        pc.showPromotionLog();
      }
     static testMethod void getPromotionLog_test() {
        PromotionControler pc= new PromotionControler();
        pc.getPromotionLog('abcd','abah');
      }
     static testMethod void parseGetPromotionLog_test() {
        PromotionControler pc= new PromotionControler();
        pc.parseGetPromotionLog('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getPromotionLogResponse xmlns:ns2="http://ws.service.rabit.com/"><return>2013.12.24.06.22.25--TriggerWebService service invoked!!! for branch: SalesAutomation and buildNumber: 13 at : 2013.12.24.06.22.25</return></ns2:getPromotionLogResponse></S:Body></S:Envelope>');
        pc.parseGetPromotionLog('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getPromotionLogResponse xmlns:ns2="http://ws.service.rabit.com/"><return>404</return></ns2:getPromotionLogResponse></S:Body></S:Envelope>'); 
      }    
     static testMethod void parseOfGetRegSfOrgList_test() {
        PromotionControler pc= new PromotionControler();
        pc.parseOfGetRegSfOrgList('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getXmlFileContentResponse xmlns:ns2="http://ws.service.rabit.com/"><sandbox id="123456" name="test"></sandbox></ns2:getXmlFileContentResponse></S:Body></S:Envelope>');
      } 
     static testMethod void getProjectBuildSummary_test() {
        PromotionControler pc= new PromotionControler();
        pc.getProjectBuildSummary();
      } 
     static testMethod void parseBuildSummary_test() {
        PromotionControler pc= new PromotionControler();
        pc.parseBuildSummary('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getXmlFileContentResponse xmlns:ns2="http://ws.service.rabit.com/"><return><build branch="SalesAutomation" buildnumber="1" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.10.08.30.08"><buildstatus><osstatus type="salesforce">Ready</osstatus></buildstatus></build><build branch="SalesAutomation" buildnumber="2" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.10.10.14.07"><buildstatus><osstatus type="salesforce">Ready</osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="10-12-2013 18.03.59" insstarttime="10-12-2013 18.03.49" name="VM-SR793" result="completed" starttime="10-12-2013 18.03.49" type="salesforce"><installationstatus>Successful</installationstatus></server></regressionstatus></build>');
      } 
     static testMethod void parsePromoteSummary_test() {
        PromotionControler pc= new PromotionControler();
        pc.buildNo = '2'; 
        pc.parsePromoteSummary('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getXmlFileContentResponse xmlns:ns2="http://ws.service.rabit.com/"><return><build branch="SalesAutomation" buildnumber="1" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.10.08.30.08"><buildstatus><osstatus type="salesforce">Ready</osstatus></buildstatus></build><build branch="SalesAutomation" buildnumber="2" daily="true" organisation="00D90000000qUC6EAM" timeofbuild="2013.12.10.10.14.07"><buildstatus><osstatus type="salesforce">Ready</osstatus></buildstatus><regressionstatus><server deployment="daily" insendtime="10-12-2013 18.03.59" insstarttime="10-12-2013 18.03.49" name="VM-SR793" result="completed" starttime="10-12-2013 18.03.49" type="salesforce"><installationstatus>Successful</installationstatus></server></regressionstatus></build>');
      } 
        
            
      static testMethod void cancel_test() {
        PromotionControler pc= new PromotionControler();
         pc.urlProjName='DemoProject';
         String nextPage = pc.cancel().getUrl();
         System.assertEquals('/apex/rabitforce__rabitindex?proj=DemoProject',nextPage);
     }
      static testMethod void deployBuild_test() {
        PromotionControler pc= new PromotionControler();
        pc.deployBuild();
      }
      static testMethod void showCurrentPromotionLog_test() {
        PromotionControler pc= new PromotionControler();
        pc.showCurrentPromotionLog();
      }
      
      
}