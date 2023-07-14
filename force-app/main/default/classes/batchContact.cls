public class batchContact implements Database.Batchable<sObject> {

    /* 이지은 - batch로 standard Contact 생성/수정/삭제시 custom Contact 생성/수정/삭제 */

    List<cContact__c> insertList = new List<cContact__c>();
    List<cContact__c> updateList = new List<cContact__c>();
    List<Contact> contacts = new List<Contact>();

    public Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Account.cAccountID__c, ReportsTo.cContactID__c, Id, AccountId, LastName, FirstName, Salutation, Name, OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry, OtherAddress, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingAddress, Phone, Fax, MobilePhone, HomePhone, OtherPhone, AssistantPhone, ReportsToId, Email, Title, Department, AssistantName, LeadSource, Birthdate, Description, OwnerId, CreatedDate, CreatedById, LastModifiedDate, Level__c, Languages__c, cContactID__c FROM Contact';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Contact> conList){
    
      
        /* 생성 */
        for(Contact con : conList){
            if(con.cContactID__c == null)
                insertList.add(new cContact__c(Name = con.Name,
                                               ContactID__c = con.Id,
                                               Account_Name__c = con.Account.cAccountID__c,
                                              cLast_Name__c = con.LastName,
                                              cFirst_Name__c = con.FirstName,
                                              Reports_To__c = con.ReportsTo.cContactID__c,
                                              cAssistant__c = con.AssistantName,
                                              cAsst_Phone__c = con.AssistantPhone,
                                              cBirthdate__c = con.Birthdate,
                                              cDepartment__c = con.Department,
                                              cDescription__c = con.Description,
                                              cEmail__c = con.Email,
                                              cFax__c = con.Fax,
                                              cHome_Phone__c = con.HomePhone,
                                              cLanguages__c = con.Languages__c,
                                              cLead_Source__c = con.LeadSource,
                                              cLevel__c = con.Level__c,
                                              cMailing_City__c = con.MailingCity,
                                              cMailing_Country__c = con.MailingCountry,
                                              cMailing_State_Province__c = con.MailingState,
                                              cMailing_Street__c = con.MailingStreet,
                                              cMailing_Zip_Postal_Code__c = con.MailingPostalCode,
                                              cMobilePhone__c = con.MobilePhone,
                                              cOther_City__c = con.OtherCity,
                                              cOther_Country__c = con.OtherCountry,
                                              cOther_Phone__c = con.OtherPhone,
                                              cOther_State_Province__c = con.OtherState,
                                              cOther_Street__c = con.OtherStreet,
                                              cOther_Zip_Postal_Code__c = con.OtherPostalCode,
                                              cPhone__c = con.Phone,
                                              cSalutation__c = con.Salutation,
                                              cTitle__c = con.Title));

         } 
        if(insertList.size()>0){
            insert insertList;
        }
        
        //cContact 생성 후 Contact에 cContactID__c 넣어줘서 cContact와 연결
        for(cContact__c a : insertList){
            contacts.add(new Contact(Id = a.ContactID__c,
                                     cContactID__c = a.Id));
        }
        if(contacts.size()>0){
            update contacts;
        }
        
        /* 수정 */
        for(Contact con : conList){
            if(con.cContactID__c != null){
				updateList.add(new cContact__c(Id = con.cContactID__c,
                                              Name = con.Name,
                                              Account_Name__c = con.Account.cAccountID__c,
                                              cLast_Name__c = con.LastName,
                                              cFirst_Name__c = con.FirstName,
                                              Reports_To__c = con.ReportsTo.cContactID__c,
                                              cAssistant__c = con.AssistantName,
                                              cAsst_Phone__c = con.AssistantPhone,
                                              cBirthdate__c = con.Birthdate,
                                              cDepartment__c = con.Department,
                                              cDescription__c = con.Description,
                                              cEmail__c = con.Email,
                                              cFax__c = con.Fax,
                                              cHome_Phone__c = con.HomePhone,
                                              cLanguages__c = con.Languages__c,
                                              cLead_Source__c = con.LeadSource,
                                              cLevel__c = con.Level__c,
                                              cMailing_City__c = con.MailingCity,
                                              cMailing_Country__c = con.MailingCountry,
                                              cMailing_State_Province__c = con.MailingState,
                                              cMailing_Street__c = con.MailingStreet,
                                              cMailing_Zip_Postal_Code__c = con.MailingPostalCode,
                                              cMobilePhone__c = con.MobilePhone,
                                              cOther_City__c = con.OtherCity,
                                              cOther_Country__c = con.OtherCountry,
                                              cOther_Phone__c = con.OtherPhone,
                                              cOther_State_Province__c = con.OtherState,
                                              cOther_Street__c = con.OtherStreet,
                                              cOther_Zip_Postal_Code__c = con.OtherPostalCode,
                                              cPhone__c = con.Phone,
                                              cSalutation__c = con.Salutation,
                                              cTitle__c = con.Title));   
            }
        }
        if(updateList.size()>0){
            update updateList;
        }
        
         /* 삭제 */
        List<cContact__c> deleteList = [select Id from cContact__c where ContactID__c = null];
        
        if(deleteList.size()>0){
            delete deleteList;
        }
    }
    
    public void finish(Database.BatchableContext bc){

    }

}