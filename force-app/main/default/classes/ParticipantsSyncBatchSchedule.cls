global with sharing class ParticipantsSyncBatchSchedule implements Schedulable{

    global void execute(SchedulableContext SC){
        ParticipantsSyncBatch participantsSyncBatch = new ParticipantsSyncBatch();
        Database.executeBatch(participantsSyncBatch);
    }
}