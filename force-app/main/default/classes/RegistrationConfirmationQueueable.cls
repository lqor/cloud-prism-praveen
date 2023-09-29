public with sharing class RegistrationConfirmationQueueable implements Queueable, Database.AllowsCallouts {
    Set<Id> participantIds = new Set<Id>();
    public RegistrationConfirmationQueueable(Set<Id> participantIds){
        this.participantIds = participantIds;
    }
    public void execute(QueueableContext context){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        List<Participant__c> participants = queryParticipants(participantIds);
        PaymentLinkCallout.requestPaymentLink(participants);
        
        for(Participant__c participant : participants){
            Messaging.SingleEmailMessage email = constructConfirmationEmail(participant);
            emails.add(email);
        }

        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }
        PaymentLinkCallout.sendPaymentEmail(participants);
    }

    private Messaging.SingleEmailMessage constructConfirmationEmail(Participant__c participant){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String body = createEmailBody(participant);
        email.setSubject('Registration Confirmation');
        email.setToAddresses(new List<String>{participant.Contact__r.Email});
        email.setPlainTextBody(body);
        return email;
    }

    private String createEmailBody(Participant__c participant){
        String body = 'Dear ' + participant.Name + ',\n\n';
        body += 'This email is a confirmation that you are successfully registered for course ';
        body += participant.Training__r.Name + '.\n';
        body += 'We look forward to seeing you in the course!' + '\n\n';
        body += 'Best Regards,\n';
        body += 'Your Training Reminder';
        return body;
    }

    private List<Participant__c> queryParticipants(Set<Id> participantIds){
        return [
            SELECT Id, Name, Contact__r.Email, Training__r.Name
            FROM Participant__c
            WHERE Id IN : participantIds
        ];
    }
}