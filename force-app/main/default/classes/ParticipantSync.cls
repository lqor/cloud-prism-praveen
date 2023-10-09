public with sharing class ParticipantSync {

    @InvocableMethod(label = 'ERPCallout from Participants')
    public static void sendParticipant (List<Id> participantIds){
        List<Participant__c> participants = queryParticipantsByIds(participantIds);

        ParticipantService participantService = new ParticipantService();
        participantService.sendParticipantToERP(participants);
        update participants;
    } 

    public static List<Participant__c> queryParticipantsByIds (List<Id> participantIds){
        return [SELECT Id, Name, ErpId__c, Contact__r.Email from Participant__c
                WHERE Id IN : participantIds];
    }
}