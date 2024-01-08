public with sharing class PaymentInvoiceStatusQueueable implements Queueable, Database.AllowsCallouts {
    String refund_id;
    String token;
    Integer delay;
    public PaymentInvoiceStatusQueueable(String refund_id, String token, Integer delay) {
        this.refund_id = refund_id;
        this.token = token;
        this.delay = 2;
    }

    public void execute(QueueableContext context){
        String status = RefundRequestCallout.getPaymentInvoiceStatus(refund_id, token);
        if(Status == 'Refunded'){
            // send out email
        }else if(delay <= 10){
            delay = delay + 2;
            System.enqueueJob(new PaymentInvoiceStatusQueueable(refund_id, token, delay), delay);
        }
    }

}
