@isTest
public with sharing class PaymentLinkCalloutMock implements HttpCalloutMock{

    public Static HttpResponse respond(HttpRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStaticResource('GetPayeeResource');
        response.setStatusCode(200);

        return response;
    }
}