import { LightningElement, api, track, wire } from 'lwc';
import getContact from '@salesforce/apex/cAccountController.getContact';
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/cAccount__c.Name';
import { NavigationMixin } from "lightning/navigation";
import getCount from '@salesforce/apex/cAccountController.getCount';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const fields = [NAME_FIELD];

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const columns = [
    { label: 'cContact Name', fieldName: 'nameUrl', type: 'url', typeAttributes: {label: { fieldName: 'name' }, target: '_blank'} },
    { label: 'cTitle', fieldName: 'cTitle__c'},
    { label: 'cEmail', fieldName: 'cEmail__c'},
    { label: 'cPhone', fieldName: 'cPhone__c'},
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];

export default class CAccountViewAll extends NavigationMixin(LightningElement) {
    @api recordId;
    @api cAccount__c;
    @track contactList;
    columns = columns;
    @wire(getRecord, { recordId: '$recordId', fields })
    cAccount__c;
    @wire(getCount, {countId: '$recordId'}) 
    count;

    get name(){
        return getFieldValue(this.cAccount__c.data, NAME_FIELD);
    }

    connectedCallback(){
        // console.log('recordId = ', this.recordId);
        this.callList();
    }

    callList(){
        getContact({accountId : this.recordId})
        .then((data) => {
            // console.log('data', data);
            // this.contactList = data;
            this.contactList = data.map(row=>{
                return{...row, nameUrl: '/' + row.Id, name:row.Name }})
            // console.log('contactList = ',this.contactList);
            this.error = undefined;
        })
        .catch((error) => {
            this.error = error;
            this.data = undefined;
        })
    }
    
    //새로고침
    handelRefresh(){
        this.callList();
    }

    //레코드별 수정, 삭제
    handleRowAction(event) {
        // console.log('event',event);
        // console.log('row',event.detail.row);
        const actionName = event.detail.action.name;
        const row = event.detail.row;
       
    
        switch (actionName) {
            case 'edit':
                this.editRecord(row);
                break;
            case 'delete':
                this.deleteRecord(row);
                break;
            default:
        }
    }

    // 레코드 수정
    editRecord(row){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                objectApiName: 'cContact__c',
                actionName: 'edit'
            }
        });
        this.callList();
    }

    // 레코드 삭제
    deleteRecord(row){
        deleteRecord(row.Id)
        .then( () => {
            this.showToast(
                'cContact "'+row.Name+'" was deleted',
                '',
                'success'
            );
            //this.dispatchEvent(new RefreshEvent());
            this.callList();
        })
        
        .catch((error) => {
            console.log('error ',error);
            // this.showToast('Something went wrong', error.body.message, 'error');
        })
    }


    navTocAccount(){
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
    
    navTocAccountRecord(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'cAccount__c',
                actionName: 'view'
            },
        });

    }

    newcContact(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'cContact__c',
                actionName: 'new'
            },
        });
    }
    
    // 알림
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

}