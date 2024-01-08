public with sharing class InvoicePaymentLinkCallout {

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

    public static void sendParticipantInfo (List<Participant__c> participants, String token) {
        for(Participant__c participant : participants){
            SYSTEM.DEBUG('ENTER 1');
            String body = createBodyForParticipant(participant, token);
            SYSTEM.DEBUG('body-->' + body);
            Http http = new Http();
            HttpRequest request = new httpRequest();
            request.setMethod('POST');
            request.setEndpoint('callout:PaymentServer' + '/invoices');
            request.setHeader('Content-Type', 'application/json');
            request.setBody(body);

            HttpResponse response = http.send(request);
            SYSTEM.DEBUG('Response String--' + response.toString());
            SYSTEM.DEBUG('Response--' + response.getStatus());
            SYSTEM.DEBUG('Response Body--' + response.getBody());
        }

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
    
    private static String createBodyForParticipant(Participant__c participant, String token){
        ParticipantInfoBody participantinfobody = new ParticipantInfoBody();
        //participantinfobody.Name = participant.Name;
        //participantinfobody.Email = participant.Contact__r.Email;
        participantinfobody.participantId = participant.Id;
        participantinfobody.token = token;
        participantinfobody.price = participant.Training__r.Price__c;
        participantinfobody.tax = participant.Training__r.Tax__c;

        return JSON.serialize(participantinfobody);
    }

    public class ParticipantInfoBody{
        //public String Name;
        //public String Email;
        public String participantId;
        public String token;
        public Decimal price;
        public Decimal tax;
    }
}