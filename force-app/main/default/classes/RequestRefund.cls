public with sharing class RequestRefund {

    @InvocableMethod(label = 'Request Refund')
    public static void sendInvoiceId (List<Id> paymentInvoiceIds){
        List<Payment_Invoice__c> paymentInvoices = querypaymentInvoicesByIds(paymentInvoiceIds);

        String token = RefundRequestCallout.sendAuthenticationInfo();
        String refund_id = RefundRequestCallout.sendPaymentInvoiceInfo(paymentInvoices, token);
        Integer delay = 2;
        PaymentInvoiceStatusQueueable invoicestatusque = new PaymentInvoiceStatusQueueable(refund_id, token, delay);
        System.enqueueJob(invoicestatusque);
    } 

    public static List<Payment_Invoice__c> querypaymentInvoicesByIds (List<Id> paymentInvoiceIds){
        return [SELECT Id, Invoice_ID__c, Price__c, Status__c, Tax__c from Payment_Invoice__c
                WHERE Id IN : paymentInvoiceIds];
    }
}