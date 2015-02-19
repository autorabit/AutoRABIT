public class DashboadController {

     public List<JiraIssue> jiraIssueLst { get; set; }
     public String projectName { get; set; }
     public String buildNo{ get; set; }
     public String jiraProjKey { get; set; }
     
     public List<GaugeData> gaugeDataDash { get; set; }
     public List<BuildData> lineChartDataDash { get; set; }
     
      public void onloadProjectDashBoard()
        {  
            if(System.currentPagereference().getParameters().get('proj')!= null && System.currentPagereference().getParameters().get('bno')!= null){
                projectName = System.currentPagereference().getParameters().get('proj');
                buildNo = System.currentPagereference().getParameters().get('bno');
                getProjectDashBoardData();
                jiraProjKey = System.currentPagereference().getParameters().get('key');
                if(jiraProjKey!= null && System.currentPagereference().getParameters().get('proj')!= null){
                    getMappedJiraProjectIssuesData();
                }
            }
        }
     
     public void getProjectDashBoardData()
        {      
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
            req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getXmlFileContent\"');
            String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getXmlFileContent><orgname>' +UserInfo.getOrganizationId()+ '</orgname><filepath>data//'+ projectName +'//dashboard.xml</filepath></ws:getXmlFileContent></soapenv:Body></soapenv:Envelope>';
            req.setHeader('Content-Length',String.valueOf(requestString.length()));
            req.setBody(requestString);
            if (!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                if(res.getStatusCode()== 200){
                    parseProjectDashBoardData(res.getBodyDocument().toXmlString());
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'please check the network connection');
                    ApexPages.addmessage(myMsg);
                }
            }
        }
        
     public void parseProjectDashBoardData(String responseText){
     	   if(responseText!= null){
              xmldom d = new xmldom(responseText);
              XMLdom.Element trendEle= d.getElementByTagName('trenddata');
              List<XMLdom.Element> buildsEles= d.getElementsByTagName('build');
              lineChartDataDash = new List<BuildData>();
              gaugeDataDash = new List<gaugeData>();
              for(XMLdom.Element buildEle: buildsEles){
                  BuildData bd= new BuildData(); 
                  if(buildEle.getAttribute('number')!= NULL ){
                      bd.buildNo = Integer.valueOf(buildEle.getAttribute('number')); 
                  }
                  if(buildEle.getAttribute('sucessper')!= NULL ){
                      bd.sucessRate= Integer.valueOf(buildEle.getAttribute('sucessper')); 
                  }
                  if(buildEle.getAttribute('number').equalsIgnoreCase(buildNo))  {
                      GaugeData gd= new GaugeData();
                      gd.name = buildEle.getAttribute('sucessper')+' % Sucess';
                      gd.size = Integer.valueOf(buildEle.getAttribute('sucessper'));
                     gaugeDataDash.add(gd); 
                  }  
                  lineChartDataDash.add(bd);  
              }
          }
     }
     
     public void getMappedJiraProjectIssuesData()
        {      
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
            req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getTaskManagementSummary\"');
            String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getTaskManagementSummary><orgname>'+ UserInfo.getOrganizationId() +'</orgname><projectname>'+ projectName +'</projectname><projectkey>'+ jiraProjKey +'</projectkey></ws:getTaskManagementSummary></soapenv:Body></soapenv:Envelope>';
            req.setHeader('Content-Length',String.valueOf(requestString.length()));
            req.setBody(requestString);
            if (!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                if(res.getStatusCode()== 200){
                    parsegetMappedJiraProjectIssuesData(res.getBodyDocument().toXmlString());
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'please check the network connection');
                    ApexPages.addmessage(myMsg);
                }
            }
        }
        
      public void parsegetMappedJiraProjectIssuesData(String responseText){
      	       if(responseText!= null){
                  xmldom d = new xmldom(responseText);
                  XMLdom.Element issuessummaryEle= d.getElementByTagName('issuessummary');
                  if(issuessummaryEle != null){
                      jiraIssueLst = new List<JiraIssue>();
                      JiraIssue ji= new JiraIssue();
                      ji.totissues = Integer.valueOf(issuessummaryEle.getAttribute('totalissues'));
                      ji.openIssues = Integer.valueOf(issuessummaryEle.getAttribute('openissues'));
                      ji.InprogressIssues = Integer.valueOf(issuessummaryEle.getAttribute('inprogressissues'));
                      ji.closedIssues = Integer.valueOf(issuessummaryEle.getAttribute('closedissues'));
                      List<XMLdom.Element> issuesEles= issuessummaryEle.getElementsByTagName('issue');
                      for(XMLdom.Element issueEle:issuesEles){
                          if(issueEle!= null){
                              if(issueEle.getAttribute('status').equalsIgnoreCase('Open')){
                                  if(issueEle.getAttribute('type').equalsIgnoreCase('Task')){
                                      ji.openTaskIssues +=1;
                                  }
                                  if(issueEle.getAttribute('type').equalsIgnoreCase('Bug')){
                                      ji.openBugIssues +=1;
                                  }
                                  if(issueEle.getAttribute('type').equalsIgnoreCase('Story')){
                                      ji.openStoryIssues +=1;
                                  }
                                  if(issueEle.getAttribute('type').equalsIgnoreCase('Improvement')){
                                      ji.openImprovmentIssues +=1;
                                  }
                                  if(issueEle.getAttribute('type').equalsIgnoreCase('New Feature')){
                                      ji.openNewfeatureIssues +=1;
                                  }
                                  if(issueEle.getAttribute('type').equalsIgnoreCase('Epic')){
                                      ji.openEpicIssues +=1;
                                  }
                                  if(issueEle.getAttribute('priority').equalsIgnoreCase('Blocker')){
                                      ji.openBlockerIssues += 1;
                                  }
                                  if(issueEle.getAttribute('priority').equalsIgnoreCase('Critical')){
                                      ji.openCriticalIssues +=1;
                                  }
                                  if(issueEle.getAttribute('priority').equalsIgnoreCase('Major')){
                                      ji.openMajorIssues +=1;
                                  }
                                  if(issueEle.getAttribute('priority').equalsIgnoreCase('Minor')){
                                      ji.openMinorIssues +=1;
                                  }
                                  if(issueEle.getAttribute('priority').equalsIgnoreCase('Trivial')){
                                      ji.openTrivialIssues +=1;
                                  }
                              }
                              if(issueEle.getAttribute('status').equalsIgnoreCase('In Progress')){
                                  if(issueEle.getAttribute('type').equalsIgnoreCase('Task')){
                                      ji.inProgressTaskIssues +=1;
                                    }
                                    if(issueEle.getAttribute('type').equalsIgnoreCase('Bug')){
                                      ji.inProgressBugIssues +=1;
                                    }
                                    if(issueEle.getAttribute('type').equalsIgnoreCase('Story')){
                                      ji.inProgressStoryIssues +=1;
                                    }
                                    if(issueEle.getAttribute('type').equalsIgnoreCase('Improvement')){
                                      ji.inProgressImprovmentIssues +=1;
                                    }
                                    if(issueEle.getAttribute('type').equalsIgnoreCase('New Feature')){
                                      ji.inProgressNewfeatureIssues +=1;
                                    }
                                    if(issueEle.getAttribute('type').equalsIgnoreCase('Epic')){
                                      ji.inProgressEpicIssues +=1;
                                    }
                                    if(issueEle.getAttribute('priority').equalsIgnoreCase('Blocker')){
                                      ji.inProgressBlockerIssues += 1;
                                    }
                                    if(issueEle.getAttribute('priority').equalsIgnoreCase('Critical')){
                                      ji.inProgressCriticalIssues +=1;
                                    }
                                    if(issueEle.getAttribute('priority').equalsIgnoreCase('Major')){
                                      ji.inProgressMajorIssues +=1;
                                    }
                                    if(issueEle.getAttribute('priority').equalsIgnoreCase('Minor')){
                                      ji.inProgressMinorIssues +=1;
                                    }
                                    if(issueEle.getAttribute('priority').equalsIgnoreCase('Trivial')){
                                      ji.inProgressTrivialIssues +=1;
                                    }
                              }
                              if(issueEle.getAttribute('status').equalsIgnoreCase('Closed')){
                                  if(issueEle.getAttribute('type').equalsIgnoreCase('Task')){
                                      ji.closedTaskIssues +=1;
                                    }
                                    if(issueEle.getAttribute('type').equalsIgnoreCase('Bug')){
                                      ji.closedBugIssues +=1;
                                    }
                                    if(issueEle.getAttribute('type').equalsIgnoreCase('Story')){
                                      ji.closedStoryIssues +=1;
                                    }
                                    if(issueEle.getAttribute('type').equalsIgnoreCase('Improvement')){
                                      ji.closedImprovmentIssues +=1;
                                    }
                                    if(issueEle.getAttribute('type').equalsIgnoreCase('New Feature')){
                                      ji.closedNewfeatureIssues +=1;
                                    }
                                    if(issueEle.getAttribute('type').equalsIgnoreCase('Epic')){
                                      ji.closedEpicIssues +=1;
                                    }
                                    if(issueEle.getAttribute('priority').equalsIgnoreCase('Blocker')){
                                      ji.closedBlockerIssues += 1;
                                    }
                                    if(issueEle.getAttribute('priority').equalsIgnoreCase('Critical')){
                                      ji.closedCriticalIssues +=1;
                                    }
                                    if(issueEle.getAttribute('priority').equalsIgnoreCase('Major')){
                                      ji.closedMajorIssues +=1;
                                    }
                                    if(issueEle.getAttribute('priority').equalsIgnoreCase('Minor')){
                                      ji.closedMinorIssues +=1;
                                    }
                                    if(issueEle.getAttribute('priority').equalsIgnoreCase('Trivial')){
                                      ji.closedTrivialIssues +=1;
                                    }
                              } 

                         }
                      }
                     jiraIssueLst.add(ji); 
                  }
              }
        }      
 
      public class GaugeData {
         public String name { get; set; }
         public Integer size { get; set; }
      }
      
      public class BuildData{
           public Integer buildNo{ get; set; }
           public Integer sucessRate{ get; set; }
      }
      
      public class JiraIssue{
          public Integer totissues { get; set; }
          public Integer openIssues { get; set; }
          public Integer InprogressIssues { get; set; }
          public Integer closedIssues { get; set; }
          
          public Integer openBlockerIssues { get; set; }
          public Integer openCriticalIssues { get; set; }
          public Integer openMajorIssues { get; set; }
          public Integer openMinorIssues { get; set; }
          public Integer openTrivialIssues { get; set; }
          public Integer openBugIssues { get; set; }
          public Integer openNewfeatureIssues{ get; set; }
          public Integer openTaskIssues { get; set; }
          public Integer openImprovmentIssues { get; set; }
          public Integer openEpicIssues { get; set; }
          public Integer openStoryIssues { get; set; }
          
          public Integer inProgressBlockerIssues { get; set; }
          public Integer inProgressCriticalIssues { get; set; }
          public Integer inProgressMajorIssues { get; set; }
          public Integer inProgressMinorIssues { get; set; }
          public Integer inProgressTrivialIssues { get; set; }
          public Integer inProgressBugIssues { get; set; }
          public Integer inProgressNewfeatureIssues{ get; set; }
          public Integer inProgressTaskIssues { get; set; }
          public Integer inProgressImprovmentIssues { get; set; }
          public Integer inProgressEpicIssues { get; set; }
          public Integer inProgressStoryIssues { get; set; }
          
          public Integer closedBlockerIssues { get; set; }
          public Integer closedCriticalIssues { get; set; }
          public Integer closedMajorIssues { get; set; }
          public Integer closedMinorIssues { get; set; }
          public Integer closedTrivialIssues { get; set; }
          public Integer closedBugIssues { get; set; }
          public Integer closedNewfeatureIssues{ get; set; }
          public Integer closedTaskIssues { get; set; }
          public Integer closedImprovmentIssues { get; set; }
          public Integer closedEpicIssues { get; set; }
          public Integer closedStoryIssues { get; set; }
          
      public JiraIssue()
      {
            this.totissues = 0;
            this.openIssues = 0;
            this.InprogressIssues = 0;
            this.closedIssues = 0;
           
            this.openBlockerIssues = 0;
            this.openCriticalIssues = 0;
            this.openMajorIssues = 0;
            this.openMinorIssues = 0;
            this.openTrivialIssues = 0;
            this.openBugIssues = 0;
            this.openNewfeatureIssues= 0;
            this.openTaskIssues = 0;
            this.openImprovmentIssues = 0;
            this.openEpicIssues = 0;
            this.openStoryIssues = 0;
            
            this.inProgressBlockerIssues = 0;
            this.inProgressCriticalIssues = 0;
            this.inProgressMajorIssues = 0;
            this.inProgressMinorIssues = 0;
            this.inProgressTrivialIssues = 0;
            this.inProgressBugIssues = 0;
            this.inProgressNewfeatureIssues= 0;
            this.inProgressTaskIssues = 0;
            this.inProgressImprovmentIssues = 0;
            this.inProgressEpicIssues = 0;
            this.inProgressStoryIssues = 0;
            
            this.closedBlockerIssues = 0;
            this.closedCriticalIssues = 0;
            this.closedMajorIssues = 0;
            this.closedMinorIssues = 0;
            this.closedTrivialIssues = 0;
            this.closedBugIssues = 0;
            this.closedNewfeatureIssues= 0;
            this.closedTaskIssues = 0;
            this.closedImprovmentIssues = 0;
            this.closedEpicIssues = 0;
            this.closedStoryIssues = 0;
          } 
      } 
}