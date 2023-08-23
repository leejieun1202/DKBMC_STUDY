import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";

export default class CCaseNew extends NavigationMixin(LightningElement) {
    @api recordId;
    saveAndNew = false;

    //modal 닫기
    handleDialogClose(){
        setTimeout(() => {
            location.reload();
        }, 100);
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
    
    handleSuccess(event){

        if(!this.saveAndNew){
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.id,
                    objectApiName: 'cCase__c',
                    actionName: 'view'
                },
            });
        }
            
        this.showToast(event.detail.fields.Name.value);
        this.handleReset();
    }

    showToast(recordName){
        const event = new ShowToastEvent({
            title: 'Success',
            message: 'Case "' + recordName + '" was created',
            variant: 'success'
        });
        this.dispatchEvent(event);
    }
}