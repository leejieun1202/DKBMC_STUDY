import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RefreshEvent } from 'lightning/refresh';
import deleteCase from '@salesforce/apex/cCaseController.deleteCase';

export default class CCaseDelete extends NavigationMixin(LightningElement) {
    @api recordId;
    @api cCase__c;
    @track error;

    handleDialogClose(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'cCase__c',
                actionName: 'view'
            },
        });
    }

    handleDelete(){
        deleteCase({caseId : this.recordId})
        .then(result => {
            if (result === 'success') {
                this.showToast('Success', 'cCase was deleted', 'success');
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'cCase__c',
                        actionName: 'list'
                    },
                    state: {
                        filterName: '00B5i00000QYUQZEA5'
                    },
                });
            } else {
                console.log('error');
            }
        })
        .catch((error) => {
            this.error = error;
            this.result = undefined;
        })

        
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}