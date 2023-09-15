trigger ForecastCalculation on Training__c (before insert) {
    Set<Id> restaurantIds = new Set<Id>();
    Map<Id, Restaurant__c> relatedRestaurants = new Map<Id, Restaurant__c>();
    RestaurantCommissionMetadata__mdt rcm = RestaurantCommissionMetadata__mdt.getInstance('FirstRecord');
    Decimal probablityPerParticipant = (rcm.ProbabilityToBuyPerParticipant__c)/100;

    for(Training__c training : Trigger.new){
        restaurantIds.add(training.Restaurant__c);
    }
    List<Restaurant__c> restaurants = [Select Id, CommissionRate__c, AverageMealCost__c from Restaurant__c
                                              where Id IN : restaurantIds];
    for(Restaurant__c rst : restaurants){
        relatedRestaurants.put(rst.Id, rst);
    }

    for(Training__c training : Trigger.new){
        training.NumberOfParticipants__c = 1;
        Date trainingEndDate = date.newinstance(training.EndDate__c.year(), training.EndDate__c.month(), 
                                                training.EndDate__c.day());
        Date trainingStartDate = date.newinstance(training.StartDate__c.year(), training.StartDate__c.month(), 
                                                  training.StartDate__c.day());
        Integer trainingLengthInDays = trainingStartDate.daysBetween(trainingEndDate);
        Decimal commissionRate = (relatedRestaurants.get(training.Restaurant__c).CommissionRate__c)/100;
        Decimal averageMealCost = relatedRestaurants.get(training.Restaurant__c).AverageMealCost__c;
        Decimal forecastCalculation = training.NumberOfParticipants__c * trainingLengthInDays * commissionRate * 
                                      averageMealCost * probablityPerParticipant;
        System.debug('forecastCalculation for ' + training.Name + ' =' + forecastCalculation);
    }
}