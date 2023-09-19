public with sharing class TrainingService {
    public void calculateRestaurantCommisionOntrainings(List<Training__c> newList){
        Set<Id> restaurantIds = new Set<Id>();
        RestaurantCommissionMetadata__mdt restaurantComissionMetadata = RestaurantCommissionMetadata__mdt.getInstance('FirstRecord');
        Decimal probablityPerParticipant = (restaurantComissionMetadata.ProbabilityToBuyPerParticipant__c) / 100;
    
        for(Training__c training : newList){
            restaurantIds.add(training.Restaurant__c);
        }

        Map<Id, Restaurant__c> relatedRestaurants = new Map<Id, Restaurant__c> ([
            SELECT Id, CommissionRate__c, AverageMealCost__c 
            FROM Restaurant__c
            WHERE Id IN : restaurantIds
        ]);
    
        for(Training__c training : newList){
            training.NumberOfParticipants__c = 1;

            Date trainingEndDate = Date.newinstance(
                training.EndDate__c.year(), 
                training.EndDate__c.month(), 
                training.EndDate__c.day()
            );

            Date trainingStartDate = Date.newinstance(
                training.StartDate__c.year(), 
                training.StartDate__c.month(), 
                training.StartDate__c.day()
            );

            Integer trainingLengthInDays = trainingStartDate.daysBetween(trainingEndDate);
            Decimal commissionRate = (relatedRestaurants.get(training.Restaurant__c).CommissionRate__c)/100;
            Decimal averageMealCost = relatedRestaurants.get(training.Restaurant__c).AverageMealCost__c;

            Decimal forecastCalculation = training.NumberOfParticipants__c * trainingLengthInDays * commissionRate * 
                                          averageMealCost * probablityPerParticipant;
        }
    }

    public void updateCompletedTrainings(
        List<Training__c> newList,
        List<Training__c> oldList,
        Map<Id, Training__c> newMap,
        Map<Id, Training__c> oldMap
    ){
        Set<Id> finishedTrainingIds = new Set<Id>();
    
        for(Training__c training : newList){
            Training__c oldTraining = oldMap.get(training.Id);

            if(training.Status__c == 'Finished' && training.Status__c != oldTraining.Status__c){
                training.CompletionDate__c = Date.Today();
                finishedTrainingIds.add(training.Id);
            }
        }

        List<Participant__c> relatedparticipants = [
            SELECT Id, Status__c 
            FROM Participant__c 
            WHERE Training__c IN :finishedTrainingIds
        ];

        for(Participant__c participant : relatedparticipants){
            participant.Status__c = 'Participated';
        }

        if(!relatedparticipants.isEmpty()){
            update relatedparticipants;
        }
    }

}