public class ContactService implements SObjectServiceInterface{
    public Boolean validateObject(Sobject record){
        if(!(record instanceof Contact)){
            return false;
        }
        Contact contact = (Contact) record;
        return contact.LastName != null;
    }
    
    public void formatRecord(Sobject record){
        if(record instanceof Contact){
            Contact contact = (Contact) record;
            contact.LastName = contact.LastName.Capitalize();
            contact.FirstName = contact.FirstName.Capitalize();
            system.debug('contact.LastName---' + contact.LastName);
            system.debug('contact.FirstName---' + contact.FirstName);
        }  
    }
    
    public List<Contact> filterRecords(List<sObject> records, Map<String, Object> filters){
        List<Contact> retrivedContacts = new List<Contact>();
        return retrivedContacts;
    }

}