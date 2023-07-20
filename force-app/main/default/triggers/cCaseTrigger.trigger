trigger cCaseTrigger on cCase__c (after insert, after update, before delete) {
    /* 이지은 - Trigger로 custom Case 생성/수정/삭제시 standard Case 생성/수정/삭제 */

    List<Case> cases = new List<Case>();
    List<cCase__c> cCases = new List<cCase__c>();

    switch on Trigger.OperationType {
        when AFTER_INSERT {
            insertCase();
        }

        when AFTER_UPDATE {
            updateCase();
        }

        when BEFORE_DELETE{
            deleteCase();
        }
    }  

    /* 생성 */
    public static void insertCase(){

        try {

            //Contact Name 넣어주기
            Set<Id> conNameSet = new set<Id>();

            for(cCase__c a : Trigger.new){
                conNameSet.add(a.Id);
            }

            List<cCase__c> conNameList = [SELECT ContactId__r.ContactID__c FROM cCase__c WHERE Id IN :conNameSet];
            Map<String,Id> insertConName = new Map<String,Id>();

            for(cCase__c a : conNameList){
                insertConName.put(a.Id,a.ContactId__r.ContactID__c);
            }
                
            //Account Name 넣어주기
            Set<Id> accNameSet = new set<Id>();

            for(cCase__c a : Trigger.new){
                accNameSet.add(a.Id);
            }

            List<cCase__c> accNameList = [SELECT AccountId__r.AccountID__c FROM cCase__c WHERE Id IN :accNameSet];
            Map<String,Id> insertAccName = new Map<String,Id>();

            for(cCase__c a : accNameList){
                insertAccName.put(a.Id, a.AccountId__r.AccountID__c);
            }


            for(cCase__c a : Trigger.new){
                if(a.CaseID__c == null)
                cases.add(new Case(cCaseID__c = a.Id,
                                    ContactId = insertConName?.get(a.Id),
                                    OwnerId = a.OwnerId,
                                    Status = a.Status__c,
                                    Priority = a.Priority__c,
                                    Origin = a.Case_Origin__c,
                                    AccountId = insertAccName?.get(a.Id),
                                    Type = a.Type__c,
                                    Reason = a.Case_Reason__c,
                                    SuppliedEmail = a.Web_Email__c,
                                    SuppliedCompany = a.Web_Company__c,
                                    SuppliedName = a.Web_Name__c,
                                    SuppliedPhone = a.Web_Phone__c,
                                    Product__c = a.Product__c,
                                    EngineeringReqNumber__c = a.Engineering_Req_Number__c,
                                    PotentialLiability__c = a.Potential_Liability__c,
                                    SLAViolation__c = a.SLA_Violation__c,
                                    Subject = a.Subject__c,
                                    Description = a.Description__c,
                                    Comments = a.Internal_Comments__c));
            }
            if(cases.size()>0){
                insert cases;
            }
            
            //Case 생성 후 cCase에 CaseID 넣어줘서 Case와 연결
            for(Case a : cases){
                cCases.add(new cCase__c(Id = a.cCaseID__c,
                                    CaseID__c = a.Id));
            }

            if(cCases.size()>0){
                update cCases;
            }


        } catch (Exception e) {
            System.debug('getMessage' + e.getMessage());
            System.debug('getStackTraceString' + e.getStackTraceString());
        }

    }

    /* 수정 */
    public static void updateCase(){

        try {

            //Contact Name 넣어주기
            Set<Id> conNameSet = new set<Id>();

            for(cCase__c a : Trigger.new){
                conNameSet.add(a.Id);
            }

            List<cCase__c> conNameList = [SELECT ContactId__r.ContactID__c FROM cCase__c WHERE Id IN :conNameSet];
            Map<String,Id> insertConName = new Map<String,Id>();

            for(cCase__c a : conNameList){
                insertConName.put(a.Id,a.ContactId__r.ContactID__c);
            }
                
            //Account Name 넣어주기
            Set<Id> accNameSet = new set<Id>();

            for(cCase__c a : Trigger.new){
                accNameSet.add(a.Id);
            }

            List<cCase__c> accNameList = [SELECT AccountId__r.AccountID__c FROM cCase__c WHERE Id IN :accNameSet];
            Map<String,Id> insertAccName = new Map<String,Id>();

            for(cCase__c a : accNameList){
                insertAccName.put(a.Id, a.AccountId__r.AccountID__c);
            }

            for(cCase__c a : Trigger.new){
                if(a.CaseID__c != null)
                cases.add(new Case(Id = a.CaseID__c,
                                    cCaseID__c = a.Id,
                                    ContactId = insertConName?.get(a.Id),
                                    OwnerId = a.OwnerId,
                                    Status = a.Status__c,
                                    Priority = a.Priority__c,
                                    Origin = a.Case_Origin__c,
                                    AccountId = insertAccName?.get(a.Id),
                                    Type = a.Type__c,
                                    Reason = a.Case_Reason__c,
                                    SuppliedEmail = a.Web_Email__c,
                                    SuppliedCompany = a.Web_Company__c,
                                    SuppliedName = a.Web_Name__c,
                                    SuppliedPhone = a.Web_Phone__c,
                                    Product__c = a.Product__c,
                                    EngineeringReqNumber__c = a.Engineering_Req_Number__c,
                                    PotentialLiability__c = a.Potential_Liability__c,
                                    SLAViolation__c = a.SLA_Violation__c,
                                    Subject = a.Subject__c,
                                    Description = a.Description__c,
                                    Comments = a.Internal_Comments__c));
            }
            if(cases.size()>0){
                update cases;
            }
            

        } catch (Exception e) {
            System.debug('getMessage' + e.getMessage());
            System.debug('getStackTraceString' + e.getStackTraceString());
        }
    }
    
    /* 삭제 */
    public static void deleteCase(){

        try {
            
            Set<String> deleteSet = new Set<String>();
    
            for(cCase__c a : Trigger.old){
                deleteSet.add(a.Id);
            }
    
            List<Case> deleteList = new List<Case>();
    
            for(Case a : [select Id from Case where cCaseID__c IN :deleteSet]){
                deleteList.add(a);
            }
            if(deleteList.size()>0){
                delete deleteList;
            }    

        } catch (Exception e) {
            System.debug('getMessage' + e.getMessage());
            System.debug('getStackTraceString' + e.getStackTraceString());
        }

    }
}