trigger newFlightBooking on Flights__c (before insert,before update) {

List<Flights__c> newBookedFlights= new List<Flights__c>{};
 
   //Loop through all records in the Trigger.new collection
   for(Flights__c a: Trigger.new){
      //Concatenate the Name and billingState into the Description field
      System.debug('The following flight have been booked'+a);
   }

}