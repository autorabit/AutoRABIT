Public class FlightData
{
       public List<Flights__c> getData()
       {
       List<Flights__c> fl = [Select Id,Adults__c,Amount__c from Flights__c];
       return fl;
       }
}