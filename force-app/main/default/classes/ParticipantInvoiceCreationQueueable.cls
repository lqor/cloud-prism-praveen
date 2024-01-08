public with sharing class ParticipantInvoiceCreationQueueable implements Queueable, Database.AllowsCallouts {
    Set<Id> participantIds = new Set<Id>();
    public ParticipantInvoiceCreationQueueable(Set<Id> participantIds) {
        this.participantIds = participantIds;
    }

    public void execute(QueueableContext context){
        List<Participant__c> participants = queryParticipants(participantIds);
        String token = InvoicePaymentLinkCallout.sendAuthenticationInfo();
        SYSTEM.DEBUG('TOKEN--'+ token);
        InvoicePaymentLinkCallout.sendParticipantInfo(participants, token);
    }


    private List<Participant__c> queryParticipants(Set<Id> participantIds){
        return [
            SELECT Id, Name, Contact__r.Email, Training__r.Name, Training__r.Price__c, Training__r.Tax__c
            FROM Participant__c
            WHERE Id IN : participantIds
        ];
    }
}