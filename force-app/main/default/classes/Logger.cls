public with sharing class Logger {

    public void log(Exception e){
        Error_Log__c log = new Error_Log__c();
        //log.Name = e.getMessage();
        log.StackTrace__c = e.getStackTraceString();
        log.Type__c = e.getTypeName();
        log.Method__c = e.getStackTraceString().substringbefore('(').substringafter('.');
        log.Line__c = e.getStackTraceString().substringafter(':').substringbefore(')');
        log.Exception_Message__c = e.getMessage();

        insert log;
    }
}