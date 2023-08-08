public with sharing class cAccountController {


    @AuraEnabled
    public static List<cContact__c> getContact(Id accountId) {
        try {
            System.debug('accountId = ' + accountId);
            return[
                SELECT Id, Name, cTitle__c, cEmail__c, cPhone__c
                FROM cContact__c
                WHERE Account_Name__c =:accountId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }

    @AuraEnabled(cacheable=true) 
    public static Integer getCount(Id countId) {
        return [SELECT count() FROM cContact__c WHERE Account_Name__c =:countId];
    }

    @AuraEnabled
    public static void saveContact(List<cContact__c> contactList){
        List<cContact__c> contactsToInsert = new List<cContact__c>();
        
        for (cContact__c newContact : contactList) {
            contactsToInsert.add(newContact);
        }
        if (!contactsToInsert.isEmpty()) {
            try {
                upsert contactsToInsert;
            } catch (Exception e) {
                System.debug('Error inserting contacts: ' + e.getMessage());
                throw new AuraHandledException('Error inserting contacts: ' + e.getMessage());
            }
            
    }
}
}