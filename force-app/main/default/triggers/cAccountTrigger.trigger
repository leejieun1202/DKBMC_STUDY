trigger cAccountTrigger on cAccount__c (after insert, after update, before delete) {

    /* 이지은 - Trigger로 custom Account 생성/수정/삭제시 standard Account 생성/수정/삭제 */

    List<Account> accounts = new List<Account>();
    List<cAccount__c> cAccounts = new List<cAccount__c>();

    switch on Trigger.OperationType {
        when AFTER_INSERT {
            insertAccount();
        }

        when AFTER_UPDATE {
            updateAccount();
        }

        when BEFORE_DELETE{
            deleteAccount();
        }
    }  
    
    /* 생성 */
    public static void insertAccount(){
        
            //parentID 넣어주기
            Set<Id> parentIdSet = new Set<Id>();
            
            for(cAccount__c a : Trigger.new){
                parentIdSet.add(a.Id);
            }
        
            List<cAccount__c> targerList = [SELECT Id, Name, Parent_Account__r.AccountID__c FROM cAccount__c WHERE Id IN :parentIdSet];
            Map<String, String> pIds = new Map<String,String>();
            
            for(cAccount__c a : targerList){
                pIds.put(a.Id, a.Parent_Account__r.AccountID__c);
            }

            for(cAccount__c a : Trigger.new){
                if(a.AccountID__c == null)
                accounts.add(new Account(cAccountID__c = a.Id,
                                        AccountNumber = a.cAccountNumber__c,
                                        Active__c = a.cActive__c,
                                        AnnualRevenue = a.cAnnualRevenue__c,
                                        BillingCity = a.cBillingCity__c,
                                        BillingCountry = a.cBillingCountry__c,
                                        BillingPostalCode = a.cBillingStateProvince__c,
                                        BillingState = a.cBillingStateProvince__c,
                                        BillingStreet = a.cBilling_Street__c,
                                        CustomerPriority__c = a.cCustomerPriority__c,
                                        Description = a.cDescription__c,
                                        Fax = a.cFax__c,
                                        Industry = a.cIndustry__c,
                                        Name = a.Name,
                                        NumberOfEmployees = Integer.ValueOf(a.cNumberOfEmployees__c),
                                        NumberofLocations__c = Integer.ValueOf(a.cNumber_of_Locations__c),
                                        Ownership = a.cOwnership__c,
                                        ParentId = pIds?.get(a.Id),
                                        Phone = a.cPhone__c,
                                        Rating = a.cRating__c,
                                        SLAExpirationDate__c = a.cSLA_Expiration_Date__c,
                                        SLASerialNumber__c = a.cSLA_Serial_Number__c,
                                        SLA__c = a.cSLA__c,
                                        ShippingCity = a.cShippingCity__c,
                                        ShippingCountry = a.cShippingCountry__c,
                                        ShippingPostalCode = a.cShippingZip_PostalCode__c,
                                        ShippingState = a.cShippingStateProvince__c,
                                        ShippingStreet = a.cShippingStreet__c,
                                        Sic = a.cSic__c,
                                        Site = a.cAccountSite__c,
                                        TickerSymbol = a.cTicker_Symbol__c,
                                        Type = a.cType__c,
                                        UpsellOpportunity__c = a.cUpsell_Opportunity__c,
                                        Website = a.cWebsite__c));

            }
            if(accounts.size()>0){
                insert accounts;
            }

            //Account 생성 후 cAccount에 AccountID 넣어줘서 Account와 연결
            for(Account a : accounts){
                cAccounts.add(new cAccount__c(Id = a.cAccountID__c,
                                            AccountID__c = a.Id));
            }
            if(cAccounts.size()>0){
                update cAccounts;
            }
            

        
    }

    /* 수정 */
    public static void updateAccount(){
        
        Set<Id> parentIdSet = new Set<Id>();
            
        for(cAccount__c a : Trigger.new){
            parentIdSet.add(a.Id);
        }
        
        List<cAccount__c> targerList = [SELECT Id, Name, Parent_Account__r.AccountID__c FROM cAccount__c WHERE Id IN :parentIdSet];
            Map<String, String> pIds = new Map<String,String>();
            
            for(cAccount__c a : targerList){
                pIds.put(a.Id, a.Parent_Account__r.AccountID__c);
            }
        
        for(cAccount__c a : Trigger.new){
            if(a.AccountID__c != null)
            accounts.add(new Account(Id = a.AccountID__c,
                                    AccountNumber = a.cAccountNumber__c,
                                    Active__c = a.cActive__c,
                                    AnnualRevenue = a.cAnnualRevenue__c,
                                    BillingCity = a.cBillingCity__c,
                                    BillingCountry = a.cBillingCountry__c,
                                    BillingPostalCode = a.cBillingStateProvince__c,
                                    BillingState = a.cBillingStateProvince__c,
                                    BillingStreet = a.cBilling_Street__c,
                                    CustomerPriority__c = a.cCustomerPriority__c,
                                    Description = a.cDescription__c,
                                    Fax = a.cFax__c,
                                    Industry = a.cIndustry__c,
                                    Name = a.Name,
                                    NumberOfEmployees = Integer.ValueOf(a.cNumberOfEmployees__c),
                                    NumberofLocations__c = Integer.ValueOf(a.cNumber_of_Locations__c),
                                    Ownership = a.cOwnership__c,
                                    ParentId = pIds?.get(a.Id),
                                    Phone = a.cPhone__c,
                                    Rating = a.cRating__c,
                                    SLAExpirationDate__c = a.cSLA_Expiration_Date__c,
                                    SLASerialNumber__c = a.cSLA_Serial_Number__c,
                                    SLA__c = a.cSLA__c,
                                    ShippingCity = a.cShippingCity__c,
                                    ShippingCountry = a.cShippingCountry__c,
                                    ShippingPostalCode = a.cShippingZip_PostalCode__c,
                                    ShippingState = a.cShippingStateProvince__c,
                                    ShippingStreet = a.cShippingStreet__c,
                                    Sic = a.cSic__c,
                                    Site = a.cAccountSite__c,
                                    TickerSymbol = a.cTicker_Symbol__c,
                                    Type = a.cType__c,
                                    UpsellOpportunity__c = a.cUpsell_Opportunity__c,
                                    Website = a.cWebsite__c));

        }
        update accounts;
        
    }
    
    /* 삭제 */
    public static void deleteAccount(){

        Set<String> deleteSet = new Set<String>();
        
        for(cAccount__c a : Trigger.old){
            deleteSet.add(a.Id);
        }

        List<Account> deleteList = [select Id from Account where cAccountID__c IN :deleteSet];

        if(deleteList.size()>0){
            delete deleteList;
        }
    }
}    
            
     
     
            
        