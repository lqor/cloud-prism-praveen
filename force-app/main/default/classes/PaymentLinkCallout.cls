public with sharing class PaymentLinkCallout {

    public static void requestPaymentLink (List<Participant__c> participants){
        List<Participant__c> participantsToUpdate = new List<Participant__c>();
        String url = 'https://735ef563-176d-431c-85ce-2cc07056ef03.mock.pstmn.io/payments/link';

        for(Participant__c participant : participants){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint(url);

            HttpResponse response = new Httpresponse();
            response = http.send(request);

            String responseBody = response.getBody();

            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            Map<String, Object> payer = (Map<String, Object>) responseMap.get('payer');

            participant.PaymentLink__c = (String) payer.get('link');
        }

        update participants;
    }

    public static void sendPaymentEmail (List<Participant__c> participants){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for(Participant__c participant : participants){
            Messaging.SingleEmailMessage email = constructPaymentEmail(participant);
            emails.add(email);
        }

        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }
    }

    private static Messaging.SingleEmailMessage constructPaymentEmail (Participant__c participant){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String body = createEmailBody(participant);
        email.setSubject('Payment Reminder');
        email.setPlainTextBody(body);
        email.setToAddresses(new List<String> {participant.Contact__r.email});
        return email;
    }

    private static String createEmailBody(Participant__c participant){
        String body = 'Dear ' + participant.Name + ',\n\n';
        body += 'To complete your registration, please make a payment by clicking on the link below:'+ '\n\n';
        body += participant.PaymentLink__c + '\n\n';
        body += 'Best Regards,\n';
        body += 'Cloud Prism';
        return body;
    }
}