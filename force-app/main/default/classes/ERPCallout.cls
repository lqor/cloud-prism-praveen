public with sharing class ERPCallout {

    public static String sendParticipantToERP(Participant__c participant){

        String endpoint = 'https://64aa815a0c6d844abede843a.mockapi.io/api/v1/participants';
        String body = createBodyForParticipant(participant);
        SYSTEM.DEBUG('body-->' + body);
        Http http = new Http();
        HttpRequest request = new httpRequest();
        request.setMethod('POST');
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);

        HttpResponse response = http.send(request);
        return response.getBody();

    }

    public static String parseERPIdFromResponse (String responseBody){
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        String erpId = (String) responseMap.get('erpId');
        return erpId;
    }

    private static String createBodyForParticipant(Participant__c participant){
        ParticipantERP participanterp = new ParticipantERP();
        participanterp.Name = participant.Name;
        ParticipantERP.Email = participant.Contact__r.Email;
        ParticipantERP.cpf = '1234567890';

        return JSON.serialize(ParticipantERP);
    }

    public class ParticipantERP{
        public String Name;
        public String Email;
        public String cpf;
    }
}