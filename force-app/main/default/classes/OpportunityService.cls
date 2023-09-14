public class OpportunityService implements SObjectServiceInterface{
    public Boolean validateObject(Sobject record){
        if(!(record instanceof Opportunity)){
            return false;
        }
        Opportunity opportunity = (Opportunity) record;
        return (opportunity.Name != null && opportunity.CloseDate != null && opportunity.StageName != null);
    }
    
    public void formatRecord(Sobject record){
        if(record instanceof Opportunity){
            Opportunity opportunity = (Opportunity) record;
            List<String> words = opportunity.Name.split(' ');
            for(Integer i = 0; i < words.size(); i++){
                words[i] = words[i].capitalize();
            }
            opportunity.Name = String.join(words, ' ');
            system.debug('opportunity.Name----' + opportunity.Name);
        }  
    }
    public List<Opportunity> filterRecords(List<sObject> records, Map<String, Object> filters){
        List<Opportunity> retrivedOpportunities = new List<Opportunity>();
        return retrivedOpportunities;
    }

}