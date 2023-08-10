import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

export default class CCaseCloseModal extends NavigationMixin(LightningElement) {
    @api recordId;
    @track closedDefault;

    connectedCallback(){
        this.closedDefault = 'Closed';
    }

    closeModal(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'cCase__c',
                actionName: 'view'
            },
        });
    }
}