trigger cContactTrigger on cContact__c (before insert, after insert, before update, after update, before delete) {

    /* 이지은 - Trigger로 custom Contact 생성/수정/삭제시 standard Contact 생성/수정/삭제 */

    List<Contact> contacts = new List<Contact>();
    List<cContact__c> cContacts = new List<cContact__c>();


    switch on Trigger.OperationType {

        when BEFORE_INSERT {
            updateName();
        }

        when AFTER_INSERT {
            insertContact();
        }

        when BEFORE_UPDATE {
            updateName();
        }

        when AFTER_UPDATE {
            updateContact();
        }

        when BEFORE_DELETE{
            deleteContact();
        }
    }


    /* 생성 */
    public static void insertContact(){

        //Account Name 넣어주기
        Set<Id> accNameSet = new Set<Id>();

        for(cContact__c a : Trigger.new){
            accNameSet.add(a.Id);
        }

        List<cContact__c> accNameList = [SELECT Id, Name,Account_Name__r.AccountID__c FROM cContact__c WHERE Id IN :accNameSet];
        Map<String, String> acc = new Map<String, String>();

        for(cContact__c a : accNameList){
            acc.put(a.Id, a.Account_Name__r.AccountID__c);
        }

        //Reports To 넣어주기
        Set<Id> reportSet = new Set<Id>();
        
        for(cContact__c a : Trigger.new){
            reportSet.add(a.Id);
        }

        List<cContact__c> reportList = [SELECT Id, Name, Reports_To__r.ContactID__c FROM cContact__c WHERE Id IN :reportSet];
        Map<String, String> rpt = new Map<String, String>();

        for(cContact__c a : reportList){
            rpt.put(a.Id, a.Reports_To__r.ContactID__c);
        }

        for(cContact__c a : Trigger.new){
            if(a.ContactID__c == null)
            contacts.add(new Contact(cContactID__c = a.Id,
                                    AccountId = acc?.get(a.Id),
                                    AssistantName = a.cAssistant__c,
                                    AssistantPhone = a.cAsst_Phone__c,
                                    Birthdate = a.cBirthdate__c,
                                    Department = a.cDepartment__c,
                                    Description = a.cDescription__c,
                                    Email = a.cEmail__c,
                                    Fax = a.cFax__c,
                                    FirstName = a.cFirst_Name__c,
                                    HomePhone = a.cHome_Phone__c,
                                    Languages__c = a.cLanguages__c,
                                    LastName = a.cLast_Name__c,
                                    LeadSource = a.cLead_Source__c,
                                    Level__c = a.cLevel__c,
                                    MailingCity = a.cMailing_City__c,
                                    MailingCountry = a.cMailing_Country__c,
                                    MailingPostalCode = a.cMailing_Zip_Postal_Code__c,
                                    MailingState = a.cMailing_State_Province__c,
                                    MailingStreet = a.cMailing_Street__c,
                                    MobilePhone = a.cMobilePhone__c,
                                    OtherCity = a.cOther_City__c,
                                    OtherCountry = a.cOther_Country__c,
                                    OtherPhone = a.cOther_Phone__c,
                                    OtherPostalCode = a.cOther_Zip_Postal_Code__c,
                                    OtherState = a.cOther_State_Province__c,
                                    OtherStreet = a.cOther_Street__c,
                                    Phone = a.cPhone__c,
                                    ReportsToId = rpt?.get(a.Id),
                                    Salutation = a.cSalutation__c,
                                    Title = a.cTitle__c
                                    ));
        }

        if(contacts.size()>0){
            insert contacts;
        }

        //Contact 생성 후 cContact에 ContactID 넣어줘서 Contact와 연결
        for(Contact a : contacts){
            cContacts.add(new cContact__c(Id = a.cContactID__c,
                                        ContactID__c = a.Id));
        }

        if(cContacts.size()>0){
            update cContacts;
        }
    }

    //Name 합쳐주기
    public static void updateName(){

        for(cContact__c a : Trigger.new){
            a.Name = a.cLast_Name__c + ' ' + a.cFirst_Name__c;
        }

    }

    /* 수정 */
    public static void updateContact(){

        //Account Name 넣어주기
        Set<Id> accNameSet = new Set<Id>();

        for(cContact__c a : Trigger.new){
            accNameSet.add(a.Id);
        }

        List<cContact__c> accNameList = [SELECT Id, Name,Account_Name__r.AccountID__c FROM cContact__c WHERE Id IN :accNameSet];
        Map<String, String> acc = new Map<String, String>();

        for(cContact__c a : accNameList){
            acc.put(a.Id, a.Account_Name__r.AccountID__c);
        }

        //Reports To 넣어주기
        Set<Id> reportSet = new Set<Id>();
        
        for(cContact__c a : Trigger.new){
            reportSet.add(a.Id);
        }

        List<cContact__c> reportList = [SELECT Id, Name, Reports_To__r.ContactID__c FROM cContact__c WHERE Id IN :reportSet];
        Map<String, String> rpt = new Map<String, String>();

        for(cContact__c a : reportList){
            rpt.put(a.Id, a.Reports_To__r.ContactID__c);
        }

        for(cContact__c a : Trigger.new){
            if(a.ContactID__c != null)
            contacts.add(new Contact(Id = a.ContactID__c,
                                    AccountId = acc?.get(a.Id),
                                    AssistantName = a.cAssistant__c,
                                    AssistantPhone = a.cAsst_Phone__c,
                                    Birthdate = a.cBirthdate__c,
                                    Department = a.cDepartment__c,
                                    Description = a.cDescription__c,
                                    Email = a.cEmail__c,
                                    Fax = a.cFax__c,
                                    FirstName = a.cFirst_Name__c,
                                    HomePhone = a.cHome_Phone__c,
                                    Languages__c = a.cLanguages__c,
                                    LastName = a.cLast_Name__c,
                                    LeadSource = a.cLead_Source__c,
                                    Level__c = a.cLevel__c,
                                    MailingCity = a.cMailing_City__c,
                                    MailingCountry = a.cMailing_Country__c,
                                    MailingPostalCode = a.cMailing_Zip_Postal_Code__c,
                                    MailingState = a.cMailing_State_Province__c,
                                    MailingStreet = a.cMailing_Street__c,
                                    MobilePhone = a.cMobilePhone__c,
                                    OtherCity = a.cOther_City__c,
                                    OtherCountry = a.cOther_Country__c,
                                    OtherPhone = a.cOther_Phone__c,
                                    OtherPostalCode = a.cOther_Zip_Postal_Code__c,
                                    OtherState = a.cOther_State_Province__c,
                                    OtherStreet = a.cOther_Street__c,
                                    Phone = a.cPhone__c,
                                    ReportsToId = rpt?.get(a.Id),
                                    Salutation = a.cSalutation__c,
                                    Title = a.cTitle__c
                                    ));
        }
        if(contacts.size()>0){
            update contacts;
        }

        
    }



    /* 삭제 */
    public static void deleteContact(){

        Set<String> deleteSet = new Set<String>();
        
        for(cContact__c a : Trigger.old){
            deleteSet.add(a.Id);
        }

        List<Contact> deleteList = new List<Contact>();

        for(Contact a : [select Id from Contact where cContactID__c IN :deleteSet]){
            deleteList.add(a);
        }
        if(deleteList.size()>0){
            delete deleteList;
        }    
    }


}