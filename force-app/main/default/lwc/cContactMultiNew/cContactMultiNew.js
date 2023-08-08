import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
import saveContact from '@salesforce/apex/cAccountController.saveContact';
import LAST_NAME_FIELD from '@salesforce/schema/cContact__c.cLast_Name__c';
import FIRST_NAME_FIELD from '@salesforce/schema/cContact__c.cFirst_Name__c';
import TITLE_FIELD from '@salesforce/schema/cContact__c.cTitle__c';
import EMAIL_FIELD from '@salesforce/schema/cContact__c.cEmail__c';
import PHONE_FIELD from '@salesforce/schema/cContact__c.cPhone__c';
import getContact from '@salesforce/apex/cAccountController.getContact';

export default class CContactMultiNew extends NavigationMixin(LightningElement) {
    @api recordId;
    @track contactList = [{ id:this.recordId, LastName: '', FirstName: '', title: '', email: '', phone: '' , Account_Name__c: this.recordId}];

    //페이지 로드 시 contactList 변수 정의
    connectedCallback() {
        this.contactList = [{ LastName: '', FirstName: '', title: '', email: '', phone: '' , Account_Name__c: this.recordId}];
    }

    //레코드 추가
    addRow(){
        let newItem = {Account_Name__c: this.recordId}; 
        this.contactList.push(newItem);
    }

    //레코드 삭제
    removeRow(event) {
        var rowIndex = event.currentTarget.dataset.index;
        if(this.contactList.length > 1) {
            this.contactList.splice(rowIndex, 1);
        } 
    }

    //모달창 닫기
    handleDialogClose(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'cContact__c',
                actionName: 'view'
            },
        });
    }

    //리스트 불러오기
    callList(){
        getContact({accountId : this.recordId})
        .then(result => {
            console.log('result => ', result);
            this.record.data = result;
        })
        .catch(error => {
            console.log('error', error);
        })
    }

    //레코드 값 변화 저장
    handleChange(event) {

        const rowIndex = event.currentTarget.dataset.index;
        const fieldName = event.currentTarget.name;
        const value = event.currentTarget.value;

        this.contactList[rowIndex][fieldName] = value;


        if (fieldName === 'lastname') {
            this.contactList[rowIndex][LAST_NAME_FIELD.fieldApiName] = value;
        } else if (fieldName === 'firstname') {
            this.contactList[rowIndex][FIRST_NAME_FIELD.fieldApiName] = value;
        } else if (fieldName === 'title') {
            this.contactList[rowIndex][TITLE_FIELD.fieldApiName] = value;
        } else if (fieldName === 'email') {
            this.contactList[rowIndex][EMAIL_FIELD.fieldApiName] = value;
        } else if (fieldName === 'phone') {
            this.contactList[rowIndex][PHONE_FIELD.fieldApiName] = value;
        } 

       
    }

    //다중 레코드 저장
    handleSave(){
        
        saveContact({ contactList: JSON.stringify(this.contactList) })
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contacts saved successfully!',
                    variant: 'success'
                })
            );
            this.handleDialogClose();
            this.callList();
        })
        .catch(error => {
            console.log('Error message:', error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error saving contacts',
                    variant: 'error'
                })
            );
        });
    }
       

    

}