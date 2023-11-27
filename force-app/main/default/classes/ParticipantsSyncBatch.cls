global with sharing class ParticipantsSyncBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name, Status__c, ErpId__c, Contact__c, Contact__r.Email FROM Participant__c';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Participant__c> participants){
        ParticipantService participantService = new ParticipantService();
        try{
            participantService.sendParticipantToERP(participants);
            update participants;
        }catch(Exception e){
            Logger.log(Exception e);
        }
        
    }

    global void finish(Database.BatchableContext BC){

    }

}