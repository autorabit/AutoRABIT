public class DataloaderLoginController {

    public Boolean destinationBtn { get; set; }
    
    public Boolean sourceBtn { get; set; }

    public Boolean enableConnect{ get; set; }
    
    public Boolean dButtonEnable{ get; set; }

    public String durl { get; set; }
    
    public String sButtonText{ get; set; }
    
    public String dButtonText{ get; set; }

    public String denvironment { get; set; }

    public String dsecuritytoken { get; set; }

    public String dpassword { get; set; }

    public String dusername { get; set; }

    public String ConnFailMsg { get; set; }

    public String ConnSuccessMsg { get; set; }

    public String surl { get; set; }
    
    public String dorgid {get;set;}
        
    public String sorgid {get;set;}
    
    public string globalTimestamp{get;set;}

    public String senvironment { get; set; }

    public String ssecuritytoken { get; set; }

    public String spassword { get; set; }

    public String susername { get; set; }

    public Boolean outputid { get; set; }
    
    public Boolean sourceCon{ get; set; }
    
    public Boolean destCon{ get; set; }
    
    DateTime dateTimeNow = dateTime.now();
    
    public  String unixTime = ''+dateTimeNow.getTime()/1000;
    
    public PageReference ShowMetaDataDiffPage() {
        PageReference metaDiffPage = Page.metadatadiff;
        metaDiffPage.getParameters().put('uToken',sorgid+'_'+globalTimestamp);
        metaDiffPage.getParameters().put('dOrgId',dorgid);
        metaDiffPage.setRedirect(true);
        return metaDiffPage;
    }

    public void getsurlValue(){
        surl = senvironment; 
    }
            
    public void getdurlValue(){
        durl = denvironment; 
    }
    
    public void onLoadPage() {
        surl ='https://login.salesforce.com';
        susername='rabitforce@test.com';
        spassword ='sophy@345';
        ssecuritytoken ='J8hr0hos836hdbXznWMPouqpu';
       
        durl ='https://login.salesforce.com';
        dusername='rabitforce@dataloader.com';
        dpassword ='sophy@345';
        dsecuritytoken ='62UtPq8eUOoc28euTdGbPfpY';
        
        enableConnect=true;
        dButtonEnable = true;
        outputid=true;
        sourceCon = false;
        destCon = false;
        destinationBtn = true;
        
        sButtonText ='Login';
        dButtonText ='Login';
    }
    
    public void loginToSourceOrg() { 
        if(!sourceCon){
             globalTimestamp=unixTime;
             sourceCon = checkLoginDetailsOfSalesforce(senvironment,susername,spassword,ssecuritytoken,'s',unixTime,'');
             if(sourceCon){
                dButtonEnable = false;
                sButtonText ='Logout';
             }              
        }else{
            Integer st_code = logoutcancel(sorgid+'_'+globalTimestamp,'');
            if(st_code == 200){
                sourceCon = false;
                sButtonText ='Login';
             }
        }  
    }
    
    public void loginToDestination() {
        if(!destCon){
             destCon = checkLoginDetailsOfSalesforce(denvironment,dusername,dpassword,dsecuritytoken,'t',globalTimestamp,sorgid);
             if(sourceCon && destCon){
                enableConnect=false;
                dButtonText ='Logout';
             }
        }else{
            Integer st_code = logoutcancel('',dorgid);
            if(st_code == 200){
                sourceCon = false;
                sButtonText ='Login';
             }
        }   
    }
    
     public boolean checkLoginDetailsOfSalesforce(String host,String username,String password,String stoken,String contype,String timestamp,String srcorgid){
                http p =new http ();
                httprequest request= new httprequest();
                request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
                request.setMethod('POST');
                request.setHeader('Content-Type', 'text/xml;charset=utf-8');
                request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/loginToSalesForce\"');
                String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:loginToSalesForce><orgName>'+UserInfo.getOrganizationId()+'</orgName><host>'+ host +'/services/Soap/u/27.0</host><user>'+ username +'</user><password>'+ password+'</password><stoken>'+ stoken+'</stoken><contype>'+contype+'</contype><timestamp>'+ timestamp +'</timestamp><srcorgid>'+ srcorgid +'</srcorgid></ws:loginToSalesForce></soapenv:Body></soapenv:Envelope>';
                request.setHeader('Content-Length',String.valueOf(requestString.length()));
                request.setBody(requestString); 
                Boolean status=false;
                if(!Test.isRunningTest()) {
                    httpresponse res=p.send(request);
                    if(res.getStatusCode()== 200){
                        status = parseCheckLoginDetailsOfSalesforce(res.getBodyDocument().toXmlString(),username,contype);
                    } 
                }else{
                    status = true;
                }
                return status;
            }
      public Boolean parseCheckLoginDetailsOfSalesforce(String StrResponse,String username,String contype){
            Boolean status = false;  
            xmldom d = new xmldom(StrResponse);
            if(d.getElementByTagName('return').nodeValue.equalsIgnoreCase('Connection already exist')){
                 ConnSuccessMsg ='';
                 ConnFailMsg ='Connection is already exist.Please try after sometime';
                 status = false;
            }else{
                 ConnSuccessMsg ='connection established successfully';
                     if(d.getElementByTagName('username')!= NULL){
                            if(username == d.getElementByTagName('username').nodeValue){
                                status=true;
                            }
                        }
                     if(contype=='s') {
                         sorgid = d.getElementByTagName('orgid').nodeValue;
                     }
                     if(contype=='t') {
                         dorgid = d.getElementByTagName('orgid').nodeValue;
                     }  
                }
             return status ;  
      }      
      public Integer logoutcancel(string utoken, String orgid){
                Http http = new Http();
                HttpRequest request= new HttpRequest();
                request.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
                request.setMethod('POST');
                request.setHeader('Content-Type', 'text/xml;charset=utf-8');
                request.setHeader('SOAPAction', '\"http://ws.service.rabit.com/logoutFromSalesForce\"');
                string requeststring='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:logoutFromSalesForce><source>'+utoken+'</source><target>'+orgid+'</target></ws:logoutFromSalesForce></soapenv:Body></soapenv:Envelope>';          
                request.setHeader('Content-Length',String.valueOf(requeststring.length()));
                request.setBody(requeststring);
                Integer status =0;
                if(!Test.isRunningTest()) {   
                    HttpResponse res = http.send(request);
                    if(res.getStatusCode()== 200){
                        status = res.getStatusCode();
                    }else{
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while logout from Salesforce');
                        ApexPages.addmessage(myMsg);
                    }
                }else{
                    status = 200;
                }
                return status;
        }       
}