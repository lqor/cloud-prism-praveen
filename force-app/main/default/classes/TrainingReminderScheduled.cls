global with sharing class TrainingReminderScheduled implements Schedulable{

    public static final Set<String> ALLOWED_STATUS = new Set<String>{'Scheduled','In Progress'};
    global void execute (SchedulableContext sc){
        DateTime startDateInThreeDays = createStartDateTimeInThreeDays();
        DateTime endDateInThreeDays = createEndDateTimeInThreeDays();
        List<Training__c> trainings = queryTrainingsWithparticipantsByDate(startDateInThreeDays, endDateInThreeDays);
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for(Training__c training : trainings){
            if(training.TrainerContact__c != null){
                emails.add(createEmailFromtraining(training));
            }
            if(!training.Participants__r.isEmpty()){
                    emails.add(createEmailToParticipants(training));
            }
        }

        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }

    }

    private DateTIme createStartDateTimeInThreeDays() {
        return DateTime.newInstance(Date.Today().addDays(3), Time.newInstance(0,0,0,0));
    }

    private DateTIme createEndDateTimeInThreeDays() {
        return DateTime.newInstance(Date.Today().addDays(3), Time.newInstance(23,59,59,0));
    }

    public List<Training__c> queryTrainingsWithparticipantsByDate(DateTime startDate, DateTime endDate){
        return [
            SELECT Id, Name, TrainerContact__c, TrainerContact__r.Name, TrainerContact__r.Email, StartDate__c, EndDate__c,
            (Select Id, Name, Contact__r.Email from Participants__r)
            FROM Training__c
            WHERE StartDate__c > :startDate AND EndDate__c <= :endDate AND Status__c IN : ALLOWED_STATUS
        ];
    }

    private Messaging.SingleEmailMessage createEmailFromtraining (Training__c training){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String body = createEmailBody(training);
        email.setSubject('Trainer Reminder');
        email.setToAddresses(new List<String>{training.TrainerContact__r.email});
        email.setTargetObjectId(training.TrainerContact__c);
        email.setPlainTextBody(body);
        return email;
    }

    private String createEmailBody(Training__c training){
        String body = 'Dear ' + training.TrainerContact__r.Name + ',\n\n';
        body += 'You have a training scheduled for ' + training.StartDate__c.format('dd.mm.yyyy') + ' - ' + 
                training.EndDate__c.format('dd.mm.yyyy');
        body += 'Participants:\n';
        for(Participant__c participant : training.Participants__r){
            body+=participant.Name + '\n';
        }
        body += '\n\n';
        body += 'Best Regards,\n';
        body += 'Your Training Reminder';

        return body;
    }

    private Messaging.SingleEmailMessage createEmailToParticipants (Training__c training){
        List<String> participantEmails = new LIst<String>();
        for(Participant__c participant : training.Participants__r){
            participantEmails.add(participant.Contact__r.Email);
        }
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String body = createEmailBodyParticipant(training);
        email.setSubject('Participant Reminder');
        email.setToAddresses(participantEmails);
        email.setPlainTextBody(body);
        return email;
    }

    private String createEmailBodyParticipant(Training__c training){
        String body = 'Dear Participant,' + '\n\n';
        body += 'This is an automatic reminder for the upcoming training ' + training.Name + 
                'that will take place from ' + training.StartDate__c.format('dd.mm.yyyy') + ' until ' + 
                 training.EndDate__c.format('dd.mm.yyyy');
        body += '\n\n';
        body += 'Best Regards, \n';
        body += 'Cloud Prism';
        return body;
    }
}