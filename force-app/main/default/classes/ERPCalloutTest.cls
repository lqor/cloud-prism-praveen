@isTest
public with sharing class ERPCalloutTest {
    @isTest
    public static void sendParticipantToERPTest(){
        Test.setMock(HttpCalloutMock.class, new ERPCalloutMock());
        Participant__c participant = new Participant__c();

        Test.startTest();
        String responseBody = ERPCallout.sendParticipantToERP(participant);
        Test.stopTest();

        Assert.isTrue(responseBody.contains(ERPCalloutMock.ERP_ID));
    }

    @isTest
    public static void doERPCalloutforEmptyparticipant(){
        Test.setMock(HttpCalloutMock.class, new ERPCalloutMock());

        try{
            Test.starttest();
            String responseBody = ERPCallout.sendParticipantToERP(null);
            Test.stopTest();

            Assert.fail();
        } catch(Exception e) {
            Assert.isTrue(true);
        }

    }
}