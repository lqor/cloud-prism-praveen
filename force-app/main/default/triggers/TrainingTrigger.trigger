trigger TrainingTrigger on Training__c (before insert, before update, after update) {
    if(Trigger.isBefore && Trigger.isInsert){
        TrainingTriggerHandler.beforeInsert(Trigger.new);
    }

    if(Trigger.isUpdate && Trigger.isBefore) {
        TrainingTriggerHandler.beforeUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
    }
}