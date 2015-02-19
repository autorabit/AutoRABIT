@isTest
public with sharing class DashboadController_test {
   static testMethod void onloadProjectDashBoard_test() {
       	PageReference PageRef = Page.dashboard;
        PageRef.getParameters().put('bno','13');
        PageRef.getParameters().put('key','DEMO');
        PageRef.getParameters().put('proj','SalesAutomation');
    	Test.setCurrentPage(PageRef);
        DashboadController d = new DashboadController();
        d.onloadProjectDashBoard();
      }
  static testMethod void getProjectDashBoardData_test() {
        DashboadController d = new DashboadController(); 
  		d.getProjectDashBoardData();
 	  }
  static testMethod void parsegetMappedJiraProjectIssuesData_test() {
        DashboadController d = new DashboadController(); 
  		d.parsegetMappedJiraProjectIssuesData('<?xml version="1.0" encoding="UTF-8"?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:getTaskManagementSummaryResponse xmlns:ns2="http://ws.service.rabit.com/"><return><issuessummary closedissues="0" inprogressissues="1" openissues="5" totalissues="6"><issue priority="Blocker" status="Open" type="Task" /><issue priority="Critical" status="Open" type="Bug" /><issue priority="Major" status="Open" type="Story" /><issue priority="Minor" status="Open" type="Improvement" /><issue priority="Trivial" status="Open" type="New Feature" /><issue priority="Major" status="Open" type="Epic" /><issue priority="Blocker" status="In Progress" type="Task" /><issue priority="Critical" status="In Progress" type="Bug" /><issue priority="Major" status="In Progress" type="Story" /><issue priority="Minor" status="In Progress" type="Improvement" /><issue priority="Trivial" status="In Progress" type="New Feature" /><issue priority="Major" status="In Progress" type="Epic" /><issue priority="Blocker" status="Closed" type="Task" /><issue priority="Critical" status="Closed" type="Bug" /><issue priority="Major" status="Closed" type="Story" /><issue priority="Minor" status="Closed" type="Improvement" /><issue priority="Trivial" status="Closed" type="New Feature" /><issue priority="Major" status="Closed" type="Epic" /></issuessummary></return></ns2:getTaskManagementSummaryResponse></S:Body></S:Envelope>');
      }
  static testMethod void parseProjectDashBoardData_test() {
        DashboadController d = new DashboadController(); 
        d.buildNo='5';
  		d.parseProjectDashBoardData('<return><trenddata><build number="3" sucessper="14.0" /><build number="5" sucessper="85.0" /><build number="6" sucessper="55.0" /><build number="7" sucessper="85.0" /><build number="8" sucessper="71.0" /><build number="9" sucessper="68.0" /><build number="10" sucessper="85.0" /><build number="13" sucessper="85.0" /><build number="11" sucessper="85.0" /><build number="12" sucessper="85.0" /></trenddata></return>');
 	  }  
  static testMethod void getMappedJiraProjectIssuesData_test() {
        DashboadController d = new DashboadController(); 
  		d.getMappedJiraProjectIssuesData();
 	  }  	  
}