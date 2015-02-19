global class MyTwitterRegHandler implements Auth.RegistrationHandler{
 
global User createUser(Id portalId, Auth.UserData data)
{     
    if(data.attributeMap.containsKey('sfdc_networkid')) 
    {
        // Create communities user
        Account a = [SELECT Id FROM account WHERE name='Twitter Account']; // Make sure this account exists
        
        Contact c = new Contact();
        c.accountId = a.Id;
        c.email = 'temp@CHANGE-ME.com';
        c.firstName = data.fullname.split(' ')[0];
        c.lastName  = data.fullname.split(' ')[1];
        insert(c);
 
        User u = new User();
        Profile p = [SELECT Id FROM profile WHERE name='Customer Portal Manager'];
        u.username = data.username + '@sfdc-portal-twitter.com';
        u.email = 'temp@CHANGE-ME.com';
        u.firstName = data.fullname.split(' ')[0];
        u.lastName = data.fullname.split(' ')[1];
        String alias = data.fullname;
 
        //Alias must be 8 characters or less
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
    }
 
    u.alias = alias;
    u.languagelocalekey = 'en_US';
    u.localesidkey = 'en_US';
    u.emailEncodingKey = 'UTF-8';
    u.timeZoneSidKey = 'America/Los_Angeles';
    u.profileId = p.Id;
    u.contactId = c.Id;
    return u;
} else {
    // Create Standard SFDC user
    User u = new User();
    Profile p = [SELECT Id FROM profile WHERE name='Standard User'];
    u.username = data.username + '@sfdc-twitter.com';
    u.email = 'temp@CHANGE-ME.com';
    u.firstName = data.fullname.split(' ')[0];
    u.lastName = data.fullname.split(' ')[1];
    String alias = data.fullname;
    if(alias.length() > 8)
        alias = alias.substring(0, 8);
        
    u.alias = alias;
    u.languagelocalekey = 'en_US';
    u.localesidkey = 'en_US';
    u.emailEncodingKey = 'UTF-8';
    u.timeZoneSidKey = 'America/Los_Angeles';
    u.profileId = p.Id;
    return u;
}
}
 
global void updateUser(Id userId, Id portalId, Auth.UserData data)
{
    User u = new User(id=userId);
    u.firstName = data.fullname.split(' ')[0];
    u.lastName = data.fullname.split(' ')[1];
    String alias = data.fullname;
    if(alias.length() > 8)
        alias = alias.substring(0, 8);
   
    u.alias = alias;
    update(u);
}
}