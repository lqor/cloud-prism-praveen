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

    public void checkDuplicateParticipants(List<Participant__c> newList){
        Set<Id> contactIds = new Set<Id>();
        Map<Id, Participant__c> contactHasDuplicateParticipant = new Map<Id, Participant__c>();
        for(Participant__c participant : newList){
            contactIds.add(participant.Contact__c);   
        }
        
        List<Participant__c> existingParticipants = [
            SELECT Id, Contact__c, Contact__r.CanBookForOthers__c 
            FROM Participant__c 
            WHERE Contact__r.CanBookForOthers__c = False and Contact__c IN : contactIds
        ];

        for(Participant__c existingParticipant : existingParticipants){
            contactHasDuplicateParticipant.put(existingParticipant.Contact__c, existingParticipant);
        }
        System.debug('contactHasDuplicateParticipant--->' + contactHasDuplicateParticipant);

        for(Participant__c participant : newList){
            if(contactHasDuplicateParticipant.keyset().contains(participant.Contact__c)){
                participant.addError('Duplicate participant exists with the same associated contact');
            }
        }
    }
}