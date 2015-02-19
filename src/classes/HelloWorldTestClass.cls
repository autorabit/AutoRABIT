@isTest 
Public class HelloWorldTestClass {
    public static testMethod void create() {
    Hotel__c h= new Hotel__c(Name='Hotel1',City__c='Oakland',Rooms__c='5');
    ISO_Codes__c I = new ISO_Codes__c(Name='Dallas',Abbrevation__c='DA');
            // Insert book
       insert h;
       insert i;
       Hotel__c h1;
       h1 = [SELECT Name FROM Hotel__c ];
       System.debug('Price after trigger fired: ' +h1.Name);
       ISO_Codes__c I1;
       I1=[Select Name From ISO_Codes__c where Name='California'];
       System.debug('Price after trigger fired: ' +I1.Name);
    }
  /* public static testMethod void get()
    { Hotel__c h;
       // Retrieve the new book
       h = [SELECT Name FROM Hotel__c ];
       System.debug('Price after trigger fired: ' +h.Name);

      
    }*/
}