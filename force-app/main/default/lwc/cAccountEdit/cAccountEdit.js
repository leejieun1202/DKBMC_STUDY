import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/cAccount__c.Name';

const fields = [NAME_FIELD];

export default class CAccountEdit extends NavigationMixin(LightningElement) {

    @api recordId;
    @api cAccount__c;
    @wire(getRecord, { recordId: '$recordId', fields })
    cAccount__c;

    //Edit 폼 상단에 AccountName 띄우기
    get name(){
        return getFieldValue(this.cAccount__c.data, NAME_FIELD);
    }

    saveAndNew = false;

    handleSave() {
        this.saveAndNew = false;
    }

    handleSaveAndNew() {
        this.saveAndNew = true;
    }

    //필드 리셋
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


    //onsuccess로 save와 save&new 구분, 등록 toast 띄워주기
    handleSuccess(event){

        if(this.saveAndNew){
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.id,
                    objectApiName: 'cAccount__c',
                    actionName: 'new'
                },
            });
        } else{
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.id,
                    objectApiName: 'cAccount__c',
                    actionName: 'view'
                },
            });
        }
        
        this.showToast(event.detail.fields.Name.value);
        this.handleReset();
    }

    showToast(recordName){
        const event = new ShowToastEvent({
            title: 'Account "' + recordName + '" was saved',
            variant: 'success'
        });
        this.dispatchEvent(event);
    }
    
    //cancle과 X 눌렀을 때 new 폼 닫기 
    handleDialogClose(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'cAccount__c',
                actionName: 'list'
            },
            state: {
                filterName: '00B5i00000QYMX8EAP'
            },
        });
    }
}