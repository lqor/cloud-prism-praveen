public with sharing class RefundRequestCallout {

    public static String sendAuthenticationInfo (){
        Http http = new Http();
        HttpRequest request = new httpRequest();
        String body = createBodyForAuthentication();
        request.setMethod('POST');
        request.setEndpoint('callout:PaymentServer' + '/auth');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);

        HttpResponse response = http.send(request);
        String responseBody = response.getBody();
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            String token = (String) responseMap.get('token');
            return token;
    }

    public static String sendPaymentInvoiceInfo (List<Payment_Invoice__c> paymentInvoices, String token) {
        String refund_id;
        for(Payment_Invoice__c paymentInvoice : paymentInvoices){
            String body = createBodyForPaymentInvoice(paymentInvoice, token);
            Http http = new Http();
            HttpRequest request = new httpRequest();
            request.setMethod('POST');
            request.setEndpoint('callout:PaymentServer' + '/refunds/');
            request.setHeader('Content-Type', 'application/json');
            request.setBody(body);

            HttpResponse response = http.send(request);
            SYSTEM.DEBUG('Response String--' + response.toString());
            SYSTEM.DEBUG('Response--' + response.getStatus());
            SYSTEM.DEBUG('Response Body--' + response.getBody());
            String responseBody = response.getBody();
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            refund_id = (String) responseMap.get('refund_id');
        }
        return refund_id;
    }

    public static String getPaymentInvoiceStatus (String refund_id, String token){

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint('callout:PaymentServer' + '/refunds/?refund_id=' + refund_id + '&token=' + token);

            HttpResponse response = new Httpresponse();
            response = http.send(request);

            String responseBody = response.getBody();
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            String status = (String) responseMap.get('status');
            String amount = (String) responseMap.get('amount');
            return status;

    }

    private static String createBodyForAuthentication(){
        AuthenticationBody authBody = new AuthenticationBody();
        authBody.username = '{!$Credential.Username}';
        authBody.password = '{!$Credential.Password}';
        authBody.security_token = 'eJtld7Mhif1KuQWTIB2qriQAO';
        authBody.client_id = '3MVG9HB6vm3GZZR822PI9uhrzLpZ9WtR1oBxqHg9aLXGVRFmVCssazU.07r8B8Dqh49UdRPvvyaNhrTzgyEgD';
        authBody.client_secret = 'E2815297B6ABC392F22DD431488D8CF1C19372105103A9D6E8F5F3C00CA97441';

        return JSON.serialize(authBody);

    }

    public class AuthenticationBody{
        public String username;
        public String password;
        public String security_token;
        public String client_id;
        public String client_secret;
    }

    private static String createBodyForPaymentInvoice(Payment_Invoice__c paymentInvoice, String token){
        PaymentInvoiceInfoBody paymentinvoiceinfobody = new PaymentInvoiceInfoBody();
        paymentinvoiceinfobody.paymentInvoiceId = paymentInvoice.Id;
        paymentinvoiceinfobody.token = token;

        return JSON.serialize(paymentinvoiceinfobody);
    }

    public class PaymentInvoiceInfoBody{
        public String paymentInvoiceId;
        public String token;
    }
}