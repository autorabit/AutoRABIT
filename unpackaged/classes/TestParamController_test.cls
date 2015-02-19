@isTest
public with sharing class TestParamController_test {
    
    static testMethod void onLoadController_test(){
        TestParamController tc =new TestParamController();
        tc.onLoadController();
        System.assert(tc.isActive);
    }

    static testMethod void SaveProject_test(){
        TestParamController tc =new TestParamController();
        Integer hres=tc.SaveProject('xmlNode', 'filepath', 'xpath');
        System.assertEquals(0,hres);
    }
    
    static testMethod void cancelProjectCreation_test(){
        TestParamController tc =new TestParamController();
        Pagereference pf=tc.cancelProjectCreation();
        System.assertEquals('/apex/rabitforce__projects',pf.getUrl());
    }

    static testMethod void middleProjectCreation_test(){
        TestParamController tc =new TestParamController();
        tc.name='pavan';
        tc.projectMgmtSystem=true;
        Pagereference pf=tc.middleProjectCreation();
        System.assertEquals('/apex/rabitforce__testpage?jira=true&projectName=pavan',pf.getUrl());
    }
    static testMethod void PrepareProjectXmlNode_test(){
        TestParamController tc =new TestParamController();
        tc.name='use_one';
        tc.noOfShownBuilds=20;
        tc.isActive=true;
        tc.jira='jira';
        tc.projectMgmtSystem=true;
        System.assertEquals('<configuration><project name="use_one"><projectdetails><buildstobeshown>20</buildstobeshown><isactive>true</isactive><integrations><jira>true</jira></integrations></projectdetails></project></configuration>',tc.PrepareProjectXmlNode());
    }
    static testMethod void createProject_test(){
        TestParamController tc =new TestParamController();
        tc.name='use_one';
        Pagereference pf=tc.createProject();   
    }
     static testMethod void createProject_test_another(){
        TestParamController tc =new TestParamController();
        tc.name='';
        Pagereference pf=tc.createProject();   
    }
   
}