trigger HotelBooking_New on Hotel__c (before insert,before update) {

List<Hotel__c> newBookedFlights= new List<Hotel__c>{};
 
   //Loop through all records in the Trigger.new collection
   for(Hotel__c a: Trigger.new){
      //Concatenate the Name and billingState into the Description field
      System.debug('The following flight have been booked'+a);
   }

}