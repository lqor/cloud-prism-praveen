public with sharing class ParticipantSync {
    @InvocableMethod
    public static List<String> sendParticipant(List<Id> participantIds) {
        // Query participants
        List<Participant__c> participants = queryParticipantsByIds(participantIds);

        // Send participants to external system
        for(Participant__c participant : participants) {
            String responseBody = ERPCallout.sendParticipantToERP(participant);
            System.debug('Response body: ' + responseBody);
            // String erpId = ERPCallout.parseERPIdFromResponse(responseBody);
            // participant.ERP_ID__c = erpId;
        }

        // Update particiapnts
        update participants;

        return new List<String> { 'Success' };
    } 

    public static List<Participant__c> queryParticipantsByIds(List<Id> participantIds) {
        return [SELECT Id, Name, ERP_ID__c, Contact__r.Email, Phone__c FROM Participant__c WHERE Id IN :participantIds];
    }
}