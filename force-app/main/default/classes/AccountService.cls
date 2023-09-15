public class AccountService implements SObjectServiceInterface{
    public Boolean validateObject(Sobject record){
        if(!(record instanceof Account)){
            return false;
        }
        
        Account account = (Account) record;
        return account.Name != null;
    }
    
    public void formatRecord(Sobject record){
        if(record instanceof Account){
            Account account = (Account) record;
            account.Name = account.Name.normalizeSpace();
            List<String> words = account.Name.split(' ');
            for(Integer i = 0; i < words.size(); i++){
                words[i] = words[i].capitalize();
            }
            account.Name = String.join(words, ' ');
            system.debug('account Name---' + account.Name);
        }    
    }
    
    public List<Account> filterRecords(List<sObject> records, Map<String, Object> filters){  
        List<Account> retrivedAccounts = new List<Account>();
        if(records instanceof List<Account>){
            List<Account> accounts = (List<Account>) records;
            Integer i = 0;
            String query = 'Select Id, Name, Industry, AnnualRevenue from Account where ';
                for(String str : filters.keyset()){
                	if(filters.get(str) instanceof String){
                    query = query + str + '=' + '\'' + filters.get(str) + '\'';
                	}
                	if(filters.get(str) instanceof Integer){
                    query = query + str + '>=' + filters.get(str);
                	}
                    if(i < filters.keyset().size()-1){
                        query = query + ' ' + 'and ';
                        i++;
                    }
            	} 
            retrivedAccounts = Database.query(query);
            System.debug('retrivedAccounts---' + retrivedAccounts);
        }
        return retrivedAccounts;
    }

}