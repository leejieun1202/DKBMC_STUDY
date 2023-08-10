import { LightningElement, track, wire} from 'lwc';
import CCASE_OBJECT from '@salesforce/schema/cCase__c';
import STATUS_FIELD from '@salesforce/schema/cCase__c.Status__c'
import getCase from '@salesforce/apex/cCaseController.getCase';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';

const columns = [
    { label: 'Name', fieldName: 'Name', editable: true },
    { label: 'ContactId__c', fieldName: 'ContactId__c', editable: true },
    {
        label: 'Status__c', fieldName: 'Status__c', type: 'picklistColumn', editable: true, typeAttributes: {
            placeholder: 'Choose Type', options: { fieldName: 'pickListOptions' }, 
            value: { fieldName: 'Status__c' }, // default value for picklist,
            context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
        }
    }
]

export default class CCaseListView extends LightningElement {
    columns = columns;
    @track data = [];
    @track caseData;
    @track draftValues = [];
    lastSavedData = [];
    @track pickListOptions;
    @wire(getObjectInfo, {objectApiName: CCASE_OBJECT})
    objectInfo;

    @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: STATUS_FIELD
    })
    picklistValues;

    wirePickList({ error, data }) {
        if (data) {
            this.pickListOptions = data.values;
        } else if (error) {
            console.log(error);
        }
    }
    
    @wire(getCase, { pickList: '$pickListOptions' })
    caseData(result) {
        console.log('rs',result);
        this.caseData = result;
        if (result.data) {
            this.data = JSON.parse(JSON.stringify(result.data));
 
            this.data.forEach(ele => {
                ele.pickListOptions = this.pickListOptions;
            })
 
            this.lastSavedData = JSON.parse(JSON.stringify(this.data));
 
        } else if (result.error) {
            console.log('error ',result.error.body.message);
            this.data = undefined;
        }
    };

    fetchCaseData() {
        // getCaseTest({ pickList: this.pickListOptions })
        //     .then(result => {
        //         this.caseData = result;
        //         if (result.data) {
        //             this.data = JSON.parse(JSON.stringify(result.data));

        //             this.data.forEach(ele => {
        //                 ele.pickListOptions = this.pickListOptions;
        //             });

        //             this.lastSavedData = JSON.parse(JSON.stringify(this.data));

        //         } else if (result.error) {
        //             console.log('error ', result.error.body.message);
        //             this.data = undefined;
        //         }
        //     })
        //     .catch(error => {
        //         console.log('error ', error);
        //         this.data = undefined;
        //     });
    }

    connectedCallback() {
        this.fetchCaseData();
    }


}