public with sharing class TrainingTriggerHandler {
    public static void beforeInsert(List<Training__c> newList) {
        TrainingService service = new TrainingService();
        service.calculateRestaurantCommisionOntrainings(newList);
    }

    public static void beforeUpdate(
        List<Training__c> newList,
        List<Training__c> oldList,
        Map<Id, Training__c> newMap,
        Map<Id, Training__c> oldMap
    ) {
        TrainingService service = new TrainingService();
        service.updateCompletedTrainings(newList, oldList, newMap, oldMap);
    }
        
}