@isTest
public with sharing class DataloaderLoginController_test {

	static testMethod void onLoadPage_test() {
		DataloaderLoginController dc=new DataloaderLoginController();
		dc.onLoadPage();
		
	}
	static testMethod void ShowMetaDataDiffPage_test() {
		DataloaderLoginController dc=new DataloaderLoginController();
		dc.ShowMetaDataDiffPage();
		
	}
	static testMethod void getsurlValue_test() {
		DataloaderLoginController dc=new DataloaderLoginController();
		dc.getsurlValue();
		
	}
	static testMethod void getdurlValue_test() {
		DataloaderLoginController dc=new DataloaderLoginController();
		dc.getdurlValue();
		
	}
	static testMethod void loginToSourceOrg_test() {
		DataloaderLoginController dc=new DataloaderLoginController();
		dc.sourceCon =false;
		dc.loginToSourceOrg();
        dc.sourceCon =true;
        dc.loginToSourceOrg();
	}
	static testMethod void loginToDestination_test() {
		DataloaderLoginController dc=new DataloaderLoginController();
		dc.sourceCon=true;
		dc.destCon=false;
		dc.loginToDestination();
        dc.destCon=true;
		dc.loginToDestination();
	}
	static testMethod void checkLoginDetailsOfSalesforce_test() {
		DataloaderLoginController dc=new DataloaderLoginController();
		dc.checkLoginDetailsOfSalesforce('bvduyh','fnui','nrgtno','bvduyh','fnui','nrgtno','bfdub');
		
	}
	static testMethod void parseCheckLoginDetailsOfSalesforce_test() {
		DataloaderLoginController dc=new DataloaderLoginController();
		dc.parseCheckLoginDetailsOfSalesforce('<return>Connection already exist</return>','fnui','nrgtno');
		dc.parseCheckLoginDetailsOfSalesforce('<return><username>fnui</username><orgid>12345</orgid></return>','fnui','s');
        dc.parseCheckLoginDetailsOfSalesforce('<return><username>fnui</username><orgid>12345</orgid></return>','fnui','t');
	}
	static testMethod void logoutcancel_test() {
		DataloaderLoginController dc=new DataloaderLoginController();
		dc.logoutcancel('bvduyh','fnui');
		
	}
	

}