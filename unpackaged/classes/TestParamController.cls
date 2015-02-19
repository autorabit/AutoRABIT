public class TestParamController {

    public Boolean projectMgmtSystem { get; set; }

    public Boolean testCaseMgmtSystem { get; set; }

    public Boolean defectTracker { get; set; }

    public Boolean isActive { get; set; }

    public Integer noOfShownBuilds { get; set; }

    public String name { get; set; }

    public String jira { get; set; }
    
     public PageReference onLoadController ()
       {
            isActive = true;
            noOfShownBuilds = 5;
            return null;
       }

    public PageReference cancelProjectCreation() {
         PageReference projectPage = Page.Projects;
                projectPage.setRedirect(true);
                return projectPage;
    }
    
    public String PrepareProjectXmlNode()
  {
    Dom.Document doc = new Dom.Document();
    Dom.Xmlnode rootNode = doc.createRootElement('configuration', null, null);
    Dom.Xmlnode projectNode = rootNode.addChildElement('project', null, null);
        projectNode.setAttribute('name',name);
    Dom.Xmlnode projectdetailsNode = projectNode.addChildElement('projectdetails', null, null);
    projectdetailsNode.addChildElement('buildstobeshown', null, null).addTextNode(noOfShownBuilds+'');
    projectdetailsNode.addChildElement('isactive', null, null).addTextNode(isActive+'');
    Dom.Xmlnode integrationsNode = projectdetailsNode.addChildElement('integrations', null, null);
    integrationsNode.addChildElement('jira', null, null).addTextNode(projectMgmtSystem+'');     
    return doc.toXmlString().replace('<?xml version="1.0" encoding="UTF-8"?>','');
}
    
    public PageReference createProject() {
             if(name.equalsIgnoreCase('')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You can not leave Project Name empty');
                ApexPages.addmessage(myMsg);
                return null;
             }  
            Integer res_saveproject = SaveProject(PrepareProjectXmlNode(),UserInfo.getOrganizationId()+'/projects/'+ name +'_configuration.xml','');
            Integer res_saveProjectMetaInfo = SaveProject('<project configfile="'+ name +'_configuration.xml" isactive="'+ isActive +'" name="'+name+'"/>',UserInfo.getOrganizationId()+'/projects/projectmetainfo.xml','./project[@name="'+name+'"]');
             
            if(res_saveproject == 200 && res_saveProjectMetaInfo == 200){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Project saved sucessfully');
                ApexPages.addmessage(myMsg);    
                return middleProjectCreation();
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while saving Project');
                ApexPages.addmessage(myMsg);
                return null;
            } 
    } 
    
     public PageReference middleProjectCreation() {
        PageReference projectBuildPage = Page.testpage;
        projectBuildPage.setRedirect(true);
        projectBuildPage.getParameters().put('projectName',name);
        projectBuildPage.getParameters().put('jira',projectMgmtSystem+'');
        return projectBuildPage;
     }
    
    public Integer SaveProject(String xmlNode,String filepath,String xpath){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
            req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/saveXMLData\"');
            String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:saveXMLData><xmlnode>'+ xmlNode +'</xmlnode><filepath>'+ filepath +'</filepath><xpathStr>'+ xpath +'</xpathStr></ws:saveXMLData></soapenv:Body></soapenv:Envelope>';
            req.setHeader('Content-Length',String.valueOf(requestString.length()));
            req.setBody(requestString);  
            Integer statuscode=0;
            if (!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                if(res.getStatusCode()== 200){
                    statuscode=res.getStatusCode();
                }
            }
            return statuscode ;
    } 
}