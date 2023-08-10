public with sharing class cCaseController {
    
    @AuraEnabled(cacheable=true)
    public static List<cCase__c> getCase(){
        try {
            return [SELECT Id, Name, ContactId__c, Subject__c, Status__c, Priority__c, Date_Time_Opened__c, OwnerId 
                    FROM cCase__c];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<cCase__c> getCaseTest(){
        try {
            return [SELECT Id, Name, ContactId__c, Subject__c, Status__c, Priority__c, Date_Time_Opened__c, OwnerId 
                    FROM cCase__c];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}