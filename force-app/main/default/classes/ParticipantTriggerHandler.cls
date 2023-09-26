public with sharing class ParticipantTriggerHandler {
    public static void beforeInsert(List<Participant__c> newList){
        ParticipantService service = new ParticipantService();
        service.checkDuplicateParticipants(newList);
    }

    public static void afterInsert(List<Participant__c> newList, Map<Id,Participant__c> newMap){
        ParticipantService service = new ParticipantService();
        service.recalculateCommissionOnTrainings(newList, newMap);
        RegistrationConfirmationQueueable que = new RegistrationConfirmationQueueable(newMap.keyset());
        System.enqueueJob(que);
    }
}