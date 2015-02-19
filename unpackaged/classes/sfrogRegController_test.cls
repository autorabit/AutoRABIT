@isTest
public with sharing class sfrogRegController_test {
    
    static testMethod void onLoadSforgReg_test(){
        sforgRegController sf=new sforgRegController();
        sf.onLoadSforgReg();
        
        PageReference PageRef = Page.sforgregistration;
        PageRef.getParameters().put('sforgName','DEMO');
        Test.setCurrentPage(PageRef);
        sf.onLoadSforgReg(); 
    }
     static testMethod void encryptPassword_test(){
         sforgRegController sf=new sforgRegController();
         sf.encryptPassword('ramesh');
     }
    static testMethod void decryptPassword_test(){
         sforgRegController sf=new sforgRegController();
         sf.decryptPassword('ajaajbddym');
     }
    static testMethod void getSfOrgDetails_test(){
        sforgRegController sf=new sforgRegController();
        sf.getSfOrgDetails('check-sfrog');
    }
    static testMethod void getUrlVale_test(){
         sforgRegController sf=new sforgRegController();
         sf.getUrlVale();
    }
    static testMethod void getSfOrgRegXmlNode_test(){
         sforgRegController sf=new sforgRegController();
         sf.guid='121321577514770315131111361201144911431498';
         sf.sforgName='sforgName';
         sf.sforgType='sfrogType';
         sf.environment='Environment';
         sf.sforgUName='sfrogUName';
         sf.sforgPassword='sfrogPassword';
         sf.sforgStoken='sfrogStoken';
         sf.sforgPckgName='sfrogPckgName';
         String y = sf.getSfOrgRegXmlNode();
         System.assertEquals('<sandbox id="121321577514770315131111361201144911431498" name="sforgName" type="sfrogType"><url>Environment</url><username>sfrogUName</username><password></password><stoken>sfrogStoken</stoken><packageName>sfrogPckgName</packageName></sandbox>',y);
    }
    static testMethod void verifySFCredentials_test(){
         sforgRegController sf=new sforgRegController();
         sf.sforgName='sforgName';
         sf.sforgType='sfrogType';
         sf.environment='Environment';
         sf.sforgUName='sfrogUName';
         sf.sforgPassword='sfrogPassword';
         sf.sforgStoken='sfrogStoken';
         sf.sforgPckgName='sfrogPckgName';
         Pagereference pf=sf.verifySFCredentials();
    }
    static testMethod void cancelSfOrgReg_test(){
        sforgRegController sf=new sforgRegController();
        sf.cancelSfOrgReg();    
    }
    static testMethod void saveSfOrgReg_test(){
        sforgRegController sf=new sforgRegController();
         sf.guid='sforgName';
         sf.sforgName='sforgName';
         sf.sforgType='sfrogType';
         sf.environment='Environment';
         sf.sforgUName='sfrogUName';
         sf.sforgPassword='sfrogPassword';
         sf.sforgStoken='sfrogStoken';
         sf.sforgPckgName='sfrogPckgName';
         Pagereference pf=sf.saveSfOrgReg();    
    }
    static testMethod void setSforgRegistrationDetails_test(){
        sforgRegController sf=new sforgRegController();
        sf.setSforgRegistrationDetails('<sandbox name="sforgName" type="sfrogType"><url>Environment</url><username>sfrogUName</username><password>sfrogPassword</password><stoken>sfrogStoken</stoken><packageName>sfrogPckgName</packageName></sandbox>');
    }
    static testMethod void SaveSfOrgDetails_test(){
        sforgRegController sf=new sforgRegController();
        sf.SaveSfOrgDetails('xmlNode', 'filepath', 'xpath');
    }
     static testMethod void checkValidations_test_sfrogName(){
        sforgRegController sf=new sforgRegController();
        sf.sforgName='';
         sf.sforgType='sfrogType';
         sf.environment='Environment';
         sf.sforgUName='sfrogUName';
         sf.sforgPassword='sfrogPassword';
         sf.sforgStoken='sfrogStoken';
         sf.sforgPckgName='sfrogPckgName';
        System.assertEquals(false, sf.checkValidations());
    }
    static testMethod void checkValidations_test_sfrogUName(){
        sforgRegController sf=new sforgRegController();
        sf.sforgName='sforgName';
         sf.sforgType='sforgType';
         sf.environment='environment';
         sf.sforgUName='';
         sf.sforgPassword='sfrogPassword';
         sf.sforgStoken='sfrogStoken';
         sf.sforgPckgName='sfrogPckgName';
        System.assertEquals(false, sf.checkValidations());
    }
    static testMethod void checkValidations_test_sfrogPassword(){
        sforgRegController sf=new sforgRegController();
        sf.sforgName='sforgName';
         sf.sforgType='sforgType';
         sf.environment='environment';
         sf.sforgUName='sforgUName';
         sf.sforgPassword='';
         sf.sforgStoken='sfrogStoken';
         sf.sforgPckgName='sfrogPckgName';
        System.assertEquals(false, sf.checkValidations());
    }
     static testMethod void checkValidations_test_sfrogStoken(){
        sforgRegController sf=new sforgRegController();
        sf.sforgName='sforgName';
         sf.sforgType='sforgType';
         sf.environment='environment';
         sf.sforgUName='sforgUName';
         sf.sforgPassword='sforgPassword';
         sf.sforgStoken='';
         sf.sforgPckgName='sfrogPckgName';
        System.assertEquals(false, sf.checkValidations());
    }
    static testMethod void checkValidations_test_sfrogPckgName(){
        sforgRegController sf=new sforgRegController();
        sf.sforgName='sforgName';
         sf.sforgType='sforgType';
         sf.environment='environment';
         sf.sforgUName='sforgUName';
         sf.sforgPassword='sforgPassword';
         sf.sforgStoken='sforgStoken';
         sf.sforgPckgName='';
        System.assertEquals(false, sf.checkValidations());
    }
    static testMethod void parseOfCheckSalesforceCredentials_test(){
        sforgRegController sf=new sforgRegController();
         Pagereference pf=sf.parseOfCheckSalesforceCredentials(200);
        Pagereference pf1=sf.parseOfCheckSalesforceCredentials(0);
    }
    static testMethod void parseOfSaveSfOrgReg_test(){
        sforgRegController sf=new sforgRegController();
         Pagereference pf=sf.parseOfSaveSfOrgReg(200);
    }
    static testMethod void encryptPasswordSucess_test(){
        sforgRegController sf=new sforgRegController();
         String pf=sf.encryptPasswordSucess('<return>sdhsbdsdsdsdsdsd</return>');
    }
    static testMethod void decryptPasswordSucess_test(){
        sforgRegController sf=new sforgRegController();
         String pf=sf.decryptPasswordSucess('<return>demotest</return>');
    }
}