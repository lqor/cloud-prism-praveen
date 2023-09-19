trigger ParticipantTrigger on Participant__c (after insert) {
    if(Trigger.isInsert && Trigger.isAfter){
        ParticipantTriggerHandler.afterInsert(Trigger.new, Trigger.newMap);
    }

}