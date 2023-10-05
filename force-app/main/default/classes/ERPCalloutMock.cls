@isTest
public with sharing class ERPCalloutMock implements HttpCalloutMock{
    public static final String ERP_ID = '999';

    public Static HttpResponse respond(HttpRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"erpId":"' + ERP_ID + '"}');
        response.setStatusCode(200);

        return response;
    }
}