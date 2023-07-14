public class batchAccount implements Database.Batchable<sObject>{

    /* 이지은 - batch로 standard Account 생성/수정/삭제시 custom Account 생성/수정/삭제 */

    List<cAccount__c> insertList = new List<cAccount__c>();
    List<cAccount__c> updateList = new List<cAccount__c>();
    List<Account> accounts = new List<Account>();

    public Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, cAccountID__c,ParentId, Parent.cAccountID__c, Type, BillingStreet,BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude,BillingAddress, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingAddress, Phone, Fax, AccountNumber, Website, Sic, Industry, AnnualRevenue, NumberOfEmployees, Ownership, TickerSymbol, Description, Rating, Site, OwnerId, CreatedDate, CreatedById, LastModifiedDate,LastModifiedById, CustomerPriority__c, SLA__c, Active__c, NumberofLocations__c, UpsellOpportunity__c, SLASerialNumber__c, SLAExpirationDate__c FROM Account';
        return Database.getQueryLocator(query);
    } 

    public void execute(Database.BatchableContext bc, List<Account> accList){

        try {
            /* 생성 */
            for(Account acc : accList){
                if(acc.cAccountID__c == null)
                insertList.add(new cAccount__c(Name = acc.Name,
                                            AccountID__c = acc.Id,
                                            Parent_Account__c = acc.Parent.cAccountID__c,
                                            cAccountNumber__c = acc.AccountNumber,
                                            cAccountSite__c = acc.Site,
                                            cActive__c = acc.Active__c,
                                            cAnnualRevenue__c = acc.AnnualRevenue,
                                            cBillingCity__c = acc.BillingCity,
                                            cBillingCountry__c = acc.BillingCountry,
                                            cBillingStateProvince__c = acc.BillingState,
                                            cBillingZip_PostalCode__c = acc.BillingPostalCode,
                                            cBilling_Street__c = acc.BillingStreet,
                                            cCustomerPriority__c = acc.CustomerPriority__c,
                                            cDescription__c = acc.Description,
                                            cFax__c = acc.Fax,
                                            cIndustry__c = acc.Industry,
                                            cNumberOfEmployees__c = Integer.ValueOf(acc.NumberOfEmployees),
                                            cNumber_of_Locations__c = Integer.ValueOf(acc.NumberofLocations__c),
                                            cOwnership__c = acc.Ownership,
                                            cPhone__c = acc.Phone,
                                            cRating__c = acc.Rating,
                                            cSLA_Expiration_Date__c = acc.SLAExpirationDate__c,
                                            cSLA_Serial_Number__c = acc.SLASerialNumber__c,
                                            cSLA__c = acc.SLA__c,
                                            cShippingCity__c = acc.ShippingCity,
                                            cShippingCountry__c = acc.ShippingCountry,
                                            cShippingStateProvince__c = acc.ShippingState,
                                            cShippingStreet__c = acc.ShippingStreet,
                                            cShippingZip_PostalCode__c = acc.ShippingPostalCode,
                                            cSic__c = acc.Sic,
                                            cTicker_Symbol__c = acc.TickerSymbol,
                                            cType__c = acc.Type,
                                            cUpsell_Opportunity__c = acc.UpsellOpportunity__c,
                                            cWebsite__c = acc.Website));
            }
            if(insertList.size()>0){
                insert insertList;
            }

            //Account에 cAccountID 넣어주기
            for(cAccount__c ca : insertList){
                accounts.add(new Account(Id = ca.AccountID__c,
                                        cAccountID__c = ca.Id));
            }
            if(accounts.size()>0){
                update accounts;
            }

            /* 수정 */
            for(Account acc : accList){
                if(acc.cAccountID__c != null){
                    updateList.add(new cAccount__c(Id = acc.cAccountID__c, 
                                                    Name = acc.Name,
                                                    Parent_Account__c = acc.Parent.cAccountID__c,
                                                    cAccountNumber__c = acc.AccountNumber,
                                                    cAccountSite__c = acc.Site,
                                                    cActive__c = acc.Active__c,
                                                    cAnnualRevenue__c = acc.AnnualRevenue,
                                                    cBillingCity__c = acc.BillingCity,
                                                    cBillingCountry__c = acc.BillingCountry,
                                                    cBillingStateProvince__c = acc.BillingState,
                                                    cBillingZip_PostalCode__c = acc.BillingPostalCode,
                                                    cBilling_Street__c = acc.BillingStreet,
                                                    cCustomerPriority__c = acc.CustomerPriority__c,
                                                    cDescription__c = acc.Description,
                                                    cFax__c = acc.Fax,
                                                    cIndustry__c = acc.Industry,
                                                    cNumberOfEmployees__c = Integer.ValueOf(acc.NumberOfEmployees),
                                                    cNumber_of_Locations__c = Integer.ValueOf(acc.NumberofLocations__c),
                                                    cOwnership__c = acc.Ownership,
                                                    cPhone__c = acc.Phone,
                                                    cRating__c = acc.Rating,
                                                    cSLA_Expiration_Date__c = acc.SLAExpirationDate__c,
                                                    cSLA_Serial_Number__c = acc.SLASerialNumber__c,
                                                    cSLA__c = acc.SLA__c,
                                                    cShippingCity__c = acc.ShippingCity,
                                                    cShippingCountry__c = acc.ShippingCountry,
                                                    cShippingStateProvince__c = acc.ShippingState,
                                                    cShippingStreet__c = acc.ShippingStreet,
                                                    cShippingZip_PostalCode__c = acc.ShippingPostalCode,
                                                    cSic__c = acc.Sic,
                                                    cTicker_Symbol__c = acc.TickerSymbol,
                                                    cType__c = acc.Type,
                                                    cUpsell_Opportunity__c = acc.UpsellOpportunity__c,
                                                    cWebsite__c = acc.Website));
                }
            }
            if(updateList.size()>0){
                update updateList;
            }

            /* 삭제 */
            List<cAccount__c> deleteList = [select Id from cAccount__c where AccountID__c = null];
            
            if(deleteList.size()>0){
                delete deleteList;
            }
            
        } catch (Exception e) {
            System.debug('getMessage' + e.getMessage());
            System.debug('getStackTraceString' + e.getStackTraceString());
        }

       
    }

    public void finish(Database.BatchableContext bc){

    }
}