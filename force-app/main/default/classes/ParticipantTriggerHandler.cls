public with sharing class ParticipantTriggerHandler {
    public static void afterInsert(List<Training__c> newList, Map<Id,Participant__c> newMap){
        ParticipantService service = new ParticipantService();
        service.recalculateCommissionOnTrainings(newList, newMap);
    }
}