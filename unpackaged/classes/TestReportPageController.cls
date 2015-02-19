public class TestReportPageController {
    
    public list<TestReport> failuresTestList{get;set;}
    public list<TestReport> successTestList{get;set;}
    public list<TestReport> errorTestList{get;set;}
    public list<TestResult> testResultList{get;set;}
    public String projectName{get;set;}
    public String buildNo{get;set;}
    
    public PageReference goToRabitHomePage() {
       PageReference homePage = Page.RabitIndex;
        homePage.setRedirect(true);
        return homePage;
    }

    public void onloadTestReportPage() {
       
       if(System.currentPagereference().getParameters().get('proj')!= null && System.currentPagereference().getParameters().get('bno')!= null){ 
           projectName = System.currentPagereference().getParameters().get('proj');
           buildNo = System.currentPagereference().getParameters().get('bno');
           getsTestResultFile();
        }
    }
    
     public void getsTestResultFile()
        {      
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
                req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getXmlFileContent\"');
                String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getXmlFileContent><orgname>' +UserInfo.getOrganizationId()+ '</orgname><filepath>data//'+ projectName +'//'+ buildNo +'//'+projectName+'_'+ buildNo +'_windows.xml</filepath></ws:getXmlFileContent></soapenv:Body></soapenv:Envelope>';
                req.setHeader('Content-Length',String.valueOf(requestString.length()));
                req.setBody(requestString);
                if (!Test.isRunningTest()){
                    HttpResponse res = http.send(req);
                    if(res.getStatusCode()== 200){
                        parseGetsTestResultFile(res.getBodyDocument().toXmlString());
                    }else{
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'please check the network connection');
                        ApexPages.addmessage(myMsg);
                    }
                } 
        }
   public void parseGetsTestResultFile(String resStr){
   	   xmldom d = new xmldom(resStr);
       XMLdom.Element testtypesummaryEle= d.getElementByTagName('testtypesummary');
       XMLdom.Element serverEle = d.getElementByTagName('server');
       if(testtypesummaryEle!= NULL){
           XMLdom.Element testtypeEle= d.getElementByTagName('testtype');
           testResultList = new list<TestResult>();
           if(testtypeEle.getAttribute('name').equalsIgnoreCase('Selenium')){
                TestResult tst = new TestResult();
              if(testtypeEle.getAttribute('tests')!= NULL){
                  tst.tr_totalTest =testtypeEle.getAttribute('tests');
              }
              if(testtypeEle.getAttribute('errors')!= NULL){
                  tst.tr_ErrorTest = testtypeEle.getAttribute('errors');
              } 
              if(testtypeEle.getAttribute('failures')!= NULL){
                  tst.tr_failureTest = testtypeEle.getAttribute('failures');
              } 
              if(testtypeEle.getAttribute('success')!= NULL){
                  tst.tr_sucessTest= testtypeEle.getAttribute('success');
              } 
              testResultList.add(tst); 
           } 
       }
        if(serverEle!= NULL){
            failuresTestList = new list<TestReport>();
            successTestList = new list<TestReport>();
            errorTestList = new list<TestReport>();
            List<XMLdom.Element> componentEles=serverEle.getElementsByTagName('component'); 
            for(XMLdom.Element compEle:componentEles){
                List<XMLdom.Element> testcaseEles=compEle.getElementsByTagName('testcase');
                for(XMLdom.Element testEle:testcaseEles){
                    TestReport tr = new TestReport();
                    tr.componentName =compEle.getAttribute('name');
                    tr.packageName =testEle.getAttribute('classname');
                    tr.testCaseName=testEle.getAttribute('name');
                    if(testEle.getElementByTagName('failure')!= NULL){
                         XMLdom.Element failureEle = testEle.getElementByTagName('failure');
                         tr.details=failureEle.nodeValue;
                         failuresTestList.add(tr);    
                    }else if(testEle.getElementByTagName('error')!= NULL){
                        XMLdom.Element failureEle = testEle.getElementByTagName('error');
                         tr.details=failureEle.getAttribute('message');
                         errorTestList.add(tr); 
                    }else{
                         successTestList.add(tr); 
                    }
                }
            }
        }
   }
     public class TestReport{
         public String componentName { get; set; }
         public String packageName { get; set; }
         public String testCaseName{ get; set; }
         public String details{ get; set; }
     }
     
     public class TestResult{
         public String tr_totalTest{ get; set; }
         public String tr_sucessTest{ get; set; }
         public String tr_failureTest{ get; set; }
         public String tr_ErrorTest{ get; set; }
     }
     
}