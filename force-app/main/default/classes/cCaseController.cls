public with sharing class cCaseController {
    
    @AuraEnabled(cacheable=true)
    public static List<cCase__c> getCase(){
        try {
            return [SELECT Id, Name, ContactId__c, ContactId__r.Name, Subject__c, Status__c, Priority__c, Date_Time_Opened__c, Owner.Alias 
                    FROM cCase__c];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<cCase__c> getCaseTest(Id caseId){
        try {
            return [SELECT Id, Name, ContactId__c, ContactId__r.Name, Subject__c, Status__c, Priority__c, Date_Time_Opened__c, Owner.Alias 
                    FROM cCase__c WHERE Id =:caseId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String deleteCase(Id caseId){
        try {
            delete new cCase__c(Id = caseId);
            return 'success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}