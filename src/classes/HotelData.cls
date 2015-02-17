Public class HotelData
{
       public List<Hotel__c> getHotelData()
       {
       List<Hotel__c> fl = [Select Id,Check_In__c,Check_Out__c from Hotel__c];
       return fl;
       }
}