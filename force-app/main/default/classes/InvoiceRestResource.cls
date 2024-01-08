@RestResource(urlMapping='/invoices/*')
global with sharing class InvoiceRestResource {
    @HttpPost
    global static void createInvoice(String invoiceId, String participantId, String paymentId,
                                        String paymentLink, String status, String description,
                                        Integer price, Integer tax ){
        
        Payment_Invoice__c invoice = new Payment_Invoice__c(
            Invoice_ID__c = invoiceId, Participant__c = participantId, Payment_ID__c = paymentId,
            Payment_Link__c = paymentLink, Status__c = status, Description__c = description,
            Price__c = price, Tax__c = tax
        );
        upsert invoice Invoice_ID__c;

        if(invoice.Status__c == 'Created'){
            sendPaymentEmail(invoiceId);
        }
    }

    global static void sendPaymentEmail (Id invoiceId){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Payment_Invoice__c invoice = [Select Id, Payment_Link__c, Participant__r.Name , Participant__r.Contact__r.Email 
                                      from Payment_Invoice__c where Id = : invoiceId];
        Messaging.SingleEmailMessage email = constructPaymentEmail(invoice);
        emails.add(email);

        if(!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }

    private static Messaging.SingleEmailMessage constructPaymentEmail (Payment_Invoice__c invoice){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String body = createEmailBody(invoice);
        email.setSubject('Payment Reminder');
        email.setPlainTextBody(body);
        email.setToAddresses(new List<String> {invoice.Participant__r.Contact__r.Email});
        return email;
    }


    private static String createEmailBody (Payment_Invoice__c invoice){
        String body = 'Dear ' + invoice.Participant__r.Name + ',\n\n';
        body += 'To complete your registration, please make a payment by clicking on the link below:'+ '\n\n';
        body += invoice.Payment_Link__c+ '\n\n';
        body += 'Best Regards,\n';
        body += 'Cloud Prism';
        return body;
    }

}