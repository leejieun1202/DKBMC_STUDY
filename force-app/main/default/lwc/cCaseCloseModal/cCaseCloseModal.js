import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";


export default class CCaseCloseModal extends NavigationMixin(LightningElement) {
    @api recordId;
    @track closedDefault;

    connectedCallback(){
        this.closedDefault = 'Closed';
    }

    //status Closed로 변경
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

    //modal 닫기
    handleDialogClose(){
        this.closeModal();
    }
}