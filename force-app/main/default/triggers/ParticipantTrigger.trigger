trigger ParticipantTrigger on Participant__c (before insert, after insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        ParticipantTriggerHandler.beforeInsert(Trigger.new);
    }
    if(Trigger.isInsert && Trigger.isAfter){
        ParticipantTriggerHandler.afterInsert(Trigger.new, Trigger.newMap);
    }

}