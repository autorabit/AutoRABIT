public class ProjectsListofControler{
     
    public String projectParam { get; set; }
    public List<Project> projects { get; set; }
    public static boolean isApexTest = false; 
    public Pagereference ShowNewPage() 
        {
            PageReference addProjectPage = Page.CreateProject;
            addProjectPage.setRedirect(true);
            return addProjectPage;
        }
        
    public Pagereference onLoadProjects(){
       projects = getProjects();
         return null;
    }

       
   public Project[] getProjects()
        {         
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('http://www.rabitforce.com:3232/rabitservices?wsdl');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'text/xml; charset=utf-8');   
                req.setHeader('SOAPAction', '\"http://ws.service.rabit.com/getprojectmetainfo\"');
                String requestString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.service.rabit.com/"><soapenv:Header/><soapenv:Body><ws:getProjectMetaInfo><arg0>' +UserInfo.getOrganizationId()+ '</arg0></ws:getProjectMetaInfo></soapenv:Body></soapenv:Envelope>';
                req.setHeader('Content-Length',String.valueOf(requestString.length()));
                req.setBody(requestString);
                Project[] projects;  
                if(!Test.isRunningTest()) {   
                    HttpResponse res = http.send(req);
                    if(res.getStatusCode()== 200){
                        projects = parseProjects(res.getXmlStreamReader()); 
                    }else{
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'please check the network connection');
                        ApexPages.addmessage(myMsg);
                    }  
                }else{
                    projects = new Project[0];   
                    Project project = new Project();
                    project.name = 'DemoProject';
                    project.isActive = true;
                    projects.add(project);
                }
             return projects;
        }
        
        public Project[] parseProjects(XmlStreamReader reader) {
             Project[] projects = new Project[0];
             while(reader.hasNext()) {
                 if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if ('project' == reader.getLocalName()) { 
                        Project project = parseProject(reader);
                        projects.add(project);
                    }
                 }
                reader.next();
             }
            return projects;
        }

  
   public Project parseProject(XmlStreamReader reader) {
     Project project = new Project();
     project.name = reader.getAttributeValue(null, 'name');
     project.isActive= Boolean.valueOf(reader.getAttributeValue(null, 'isactive'));
     while(reader.hasNext()) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
           break;
        } else if (reader.getEventType() == XmlTag.CHARACTERS) {
           project.name = reader.getText();
           project.isActive= Boolean.valueOf(reader.getText().trim());
        }
        reader.next();
     }
     return project;
   }
   
    public PageReference ShowProjectDetails() 
        {
            PageReference projectDetails = Page.testpage;
            projectDetails.getParameters().put('projectName',projectParam);
            projectDetails.getParameters().put('edit','true');
            projectDetails.setRedirect(true);
            return projectDetails;     
        }
        
     public Project[] mainTestGetProjects(){
        isApexTest = true;
        return getProjects();
    }    
        
    public class Project{
        public Boolean isActive { get; set; }
        public String name { get; set; }
    }
}