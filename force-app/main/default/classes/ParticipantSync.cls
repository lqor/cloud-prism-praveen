public with sharing class ParticipantSync {

    @InvocableMethod(label = 'ERPCallout from Participants')
    public static void sendParticipant (List<Id> participantIds){
        List<Participant__c> participants = queryParticipantsByIds(participantIds);

        for(Participant__c participant : participants){
            String responseBody = ERPCallout.sendParticipantToERP(participant);
            String erpId = ERPCallout.parseERPIdFromResponse(responseBody);
            SYSTEM.DEBUG('reponseBody-->' + responseBody);
            SYSTEM.DEBUG('erpId-->' + erpId);
            participant.ErpId__c = erpId;
        }
        update participants;
    } 

    public static List<Participant__c> queryParticipantsByIds (List<Id> participantIds){
        return [SELECT Id, Name, ErpId__c, Contact__r.Email from Participant__c
                WHERE Id IN : participantIds];
    }
}