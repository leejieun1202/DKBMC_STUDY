import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import getContact from '@salesforce/apex/cAccountController.getContact';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



export default class CAccountRelatedContact extends NavigationMixin(LightningElement) {

    @api recordId;
    @track record = {data : []};
    delName;
    isShowModal = false;


    connectedCallback(){
        this.callList();
    }

    //페이지 불러오기
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

    //수정
    navigateToEditContact(event){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.dataset.msg,
                objectApiName: 'cContact__c',
                actionName: 'edit'
            },
        });
    }

    //다중 NEW 모달 띄우기
    navigateToNewContact(){
        this.isShowModal = true;
    }

    //삭제
    navigateToDelContact(event){
        this.delName = event.target.dataset.nm;
        deleteRecord(event.target.dataset.msg)
        .then(() => {

            const evt = new ShowToastEvent({
                title: 'cContact "' + this.delName + '" was deleted',
                variant: 'success'
            });
            this.dispatchEvent(evt);
            this.callList();  
        }).catch(error => {
            const evt = new ShowToastEvent({
                title: 'Error deleting record',
                message: error.body.message,
                variant: 'error'
            })
            this.dispatchEvent(evt);
        });
        
    }

    //VIEW ALL 띄우기
    handleViewAll(){
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__cAccountViewAllAura'
            },
            state: {
                c__id: this.recordId
            }
        });
    }
}