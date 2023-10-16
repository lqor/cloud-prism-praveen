@RestResource(urlMapping='/trainings/*')
global with sharing class TrainingRestService {
    @HttpGet
    global Static List<Training__c> getTraining(){
        RestRequest request = RestContext.request;
        String trainingId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);

        return [
            SELECT Id, Name, TrainingDuration__c, Status__c, TrainerContact__r.Name, StartDate__c, EndDate__c,
                   NumberOfParticipants__c
            FROM Training__c
            WHERE Id = :trainingId
        ];
    }

    @HttpPost
    global static String createTraining(String name, DateTime startdate, DateTime enddate,
                                        String restaurant, String status ){
        
        Training__c training = new Training__c(
            Name = name, StartDate__c = startdate, EndDate__c = enddate,
            Restaurant__c = restaurant, Status__c = status
        );
        insert training;
        return training.Id;
    }

}