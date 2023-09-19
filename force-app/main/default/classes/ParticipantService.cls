public with sharing class ParticipantService {
    public void recalculateCommissionOnTrainings(List<Participant__c> newList, Map<Id, Participant__c> newMap){
        Set<Id> trainingIds = new Set<Id>();
        List<Training__c> trainingsWithParticipants = new List<Training__c>();
        TrainingService trainingService = new TrainingService();
        for(Participant__c participant : newList){
            trainingIds.add(participant.Training__c);
        }

        trainingsWithParticipants = [
            SELECT Id, NumberOfParticipants__c, StartDate__c, EndDate__c, Restaurant__c 
            FROM Training__c
            WHERE ID IN : trainingIds
        ];
        
        trainingService.calculateRestaurantCommisionOntrainings(trainingsWithParticipants);
    }
    
}