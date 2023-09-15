trigger UpdateParticipantStatus on Training__c (before update, after update) {
    Map<Id, Training__c> trainings = new Map<Id, Training__c>();
    List<Training__c> trainingsUpdate = new List<Training__c>();

    for(Training__c training : Trigger.new){
        Training__c oldTraining = Trigger.oldMap.get(training.Id);
        if(training.Status__c == 'Finished' && training.Status__c != oldTraining.Status__c){
            trainings.put(training.Id, training);
        }
    }
    if(!trainings.isEmpty()){
        if(Trigger.isBefore){
            for(Training__c tr : Trigger.new){
                if(trainings.values().contains(tr)){
                    tr.CompletionDate__c = Date.Today();
                }
                System.debug('tr.CompletionDate__c--->' + tr.CompletionDate__c);
            }
        }
        if(Trigger.isAfter){
            List<Participant__c> relatedparticipants = [Select Id, Status__c from Participant__c where Training__c
                                                        IN : trainings.keyset()];
    
            if(!relatedparticipants.isEmpty()){
                for(Participant__c pr : relatedparticipants){
                    pr.Status__c = 'Participated';
                }
                update relatedparticipants;
            }
        }
    }

}