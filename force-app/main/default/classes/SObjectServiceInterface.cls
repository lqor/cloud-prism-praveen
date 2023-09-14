public virtual interface SObjectServiceInterface {
    Boolean validateObject(Sobject record);
    void formatRecord(Sobject record);
    List<sObject> filterRecords(List<sObject> records, Map<String,Object> filters);
}