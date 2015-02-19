@isTest
public with sharing class ProjectListofControler_test {
	
    static testMethod void onLoadProjects_test(){
       ProjectsListofControler p = new ProjectsListofControler();
       p.onLoadProjects();
    }
    
    static testMethod void ShowNewPage_test(){
        ProjectsListofControler p = new ProjectsListofControler();
        String nextPage = p.ShowNewPage().getUrl();
        System.assertEquals('/apex/rabitforce__createproject',nextPage);
    }
    
    static testMethod void mainTestGetProjects_test(){
        ProjectsListofControler p = new ProjectsListofControler();
        ProjectsListofControler.Project[] pf=p.mainTestGetProjects();
        System.assertNotEquals(0,pf.size());
    }
    
    static testMethod void ShowProjectDetails_test(){
        ProjectsListofControler p = new ProjectsListofControler();
        p.projectParam='DemoProject';
        String nextPage = p.ShowProjectDetails().getUrl();
        System.assertEquals('/apex/rabitforce__testpage?edit=true&projectName=DemoProject',nextPage);
    }
    
    static testMethod void parseProjects_test(){
        String str ='<projects><project configfile="test123_configuration.xml" isactive="true" name="test123" /><project configfile="Iteration1_configuration.xml" isactive="true" name="Iteration1" /><project configfile="demo123_configuration.xml" isactive="true" name="demo123" /><project configfile="DemoTest_configuration.xml" isactive="true" name="DemoTest" /><project configfile="test1_configuration.xml" isactive="true" name="test1" /></projects>';
         XmlStreamReader reader = new XmlStreamReader(str);
         ProjectsListofControler p = new ProjectsListofControler();
         ProjectsListofControler.Project[] projects = p.parseProjects(reader);
         System.assertEquals(5,projects.size());
    }
}