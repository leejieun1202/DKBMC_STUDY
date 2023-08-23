import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CCaseEdit extends NavigationMixin(LightningElement) {
    @api recordId;
    saveAndNew = false;

    //modal 닫기
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

    handleSaveAndNew() {
        this.saveAndNew = true;
    }

    handleReset() {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
                inputFields.forEach(field => {
                field.reset();
                });
            }
    }

    handleSuccess(){
        this.showToast('Case wase saved','','success');
        if(this.saveAndNew){
            this.handleDialogClose();
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    objectApiName: 'cCase__c',
                    actionName: 'new'
                },
            });
        }else{
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

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}