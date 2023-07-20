public class batchCase implements Database.Batchable<sObject> {

    /* 이지은 - batch로 standard Case 생성/수정/삭제시 custom Case 생성/수정/삭제 */

    List<Case> cases = new List<Case>();
    List<cCase__c> cCases = new List<cCase__c>();

    public Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Account.cAccountID__c, Contact.cContactID__c, Id, CaseNumber, ContactId, AccountId, SuppliedName, SuppliedEmail, SuppliedPhone, SuppliedCompany, Type, Status, Reason, Origin, Subject, Priority, Description,  OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, Comments, LastViewedDate, LastReferencedDate, EngineeringReqNumber__c, SLAViolation__c, Product__c, PotentialLiability__c, cCaseID__c FROM Case';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Case> casList){


        for(Case cas : casList){
                cCases.add(new cCase__c(Id = cas.cCaseID__c,
                                        CaseID__c = cas.Id,
                                        ContactId__c = cas.Contact.cContactID__c,
                                        AccountId__c = cas.Account.cAccountID__c,
                                        OwnerId = cas.OwnerId,
                                        Status__c = cas.Status,
                                        Priority__c = cas.Priority,
                                        Case_Origin__c = cas.Origin,
                                        Type__c = cas.Type,
                                        Case_Reason__c = cas.Reason,
                                        Web_Email__c = cas.SuppliedEmail,
                                        Web_Company__c = cas.SuppliedCompany,
                                        Web_Name__c = cas.SuppliedName,
                                        Web_Phone__c = cas.SuppliedPhone,
                                        Product__c = cas.Product__c,
                                        Engineering_Req_Number__c = cas.EngineeringReqNumber__c,
                                        Potential_Liability__c = cas.PotentialLiability__c,
                                        SLA_Violation__c = cas.SLAViolation__c,
                                        Subject__c = cas.Subject,
                                        Description__c = cas.Description,
                                        Internal_Comments__c = cas.Comments
                                        ));
        }
        if(cCases.size()>0){
            upsert cCases;
        }

        for(cCase__c a : cCases){
            cases.add(new Case(Id = a.CaseID__c,
                                cCaseID__c = a.Id));
        }
        if(cases.size()>0){
            update cases;
        }


        List<cCase__c> deleteList = [SELECT Id FROM cCase__c WHERE CaseID__c = null];

        if(deleteList.size()>0){
            delete deleteList;
        }


    }

    public void finish(Database.BatchableContext bc){

    }

}