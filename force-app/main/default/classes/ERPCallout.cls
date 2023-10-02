public with sharing class ERPCallout {

    public virtual class ERPCalloutException extends Exception {}
    public class ParticipantSyncedException extends ParticipantSyncException {}

    public static String sendParticipantToERP(Participant__c participant) {
        if(participant == null) {
            throw new ParticipantSyncedException('Participant is null');
        }

        String endpoint = 'https://64aa815a0c6d844abede843a.mockapi.io/api/v1/participants';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        System.debug('participant: ' + participant);
        System.debug('participant: ' + JSON.serialize(participant));
        String body = createBodyForParticipant(participant);
        System.debug('body: ' + body);
        req.setBody(body);

        Http http = new Http();
        HTTPResponse response = http.send(req); 

        System.debug('getStatusCode: ' + response.getStatusCode());
        return response.getBody();
    }

    private static String createBodyForParticipant(Participant__c participant) {
        ParticipantERP participantERP = new ParticipantERP();
        participantERP.Name = participant.Name;
        participantERP.Email = participant.Contact__r.Email;
        participantERP.cpf = '12345678901';

        return JSON.serialize(participantERP);
    }

    class ParticipantERP {
        public String Name;
        public String Email;
        public String Phone;
        public String cpf;
    }


}