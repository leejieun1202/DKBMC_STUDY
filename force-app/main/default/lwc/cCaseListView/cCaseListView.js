import { LightningElement, track, wire} from 'lwc';
import CCASE_OBJECT from '@salesforce/schema/cCase__c';
import STATUS_FIELD from '@salesforce/schema/cCase__c.Status__c'
import getCase from '@salesforce/apex/cCaseController.getCase';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';

const columns = [
    { label: 'cCase Number', fieldName: 'caseLink', type: 'url', editable: true, typeAttributes: { label: 
        { fieldName: 'Name' }, target: '_blank' 
    }},
    { label: 'Contact Name', fieldName: 'ContactId__c', type: 'lookup', editable: true,  typeAttributes: {
        placeholder: 'Select Contact',
        uniqueId: { fieldName: 'Id' },
        target: 'ContactId__c',
        context: { fieldName: 'Id' }
    }},
    {label: 'Subject', fieldName:'Subject__c', editable: true},
    {
        label: 'Status', fieldName: 'Status__c', type: 'picklistColumn', editable: true, typeAttributes: {
            placeholder: 'Choose Type', options: { fieldName: 'pickListOptions' }, 
            value: { fieldName: 'Status__c' }, 
            context: { fieldName: 'Id' } 
        }
    },
    {label: 'Priority', fieldName:'Priority__c', editable: true},
    {label: 'Date/Time Opened', fieldName:'Date_Time_Opened__c', editable: true},
    {label: 'Case Owner Alias', fieldName:'OwnerId', type: 'lookup', editable: true}
]

// const actions = [
//     { label: 'Edit', name: 'edit' },
//     { label: 'Delete', name: 'delete' },
// ];

export default class CCaseListView extends LightningElement {
    columns = columns;
    @track data = [];
    @track caseData;
    @track draftValues = [];
    lastSavedData = [];
    @track pickListOptions;
    @wire(getObjectInfo, {objectApiName: CCASE_OBJECT})
    objectInfo;
    isShowModal = false;

    //New modal 띄우기
    navigateToNewCase(){
        this.isShowModal = true;
    }
    

    //picklist 값 저장
    @wire(getPicklistValues, {
        recordTypeId: "$objectInfo.data.defaultRecordTypeId",
        fieldApiName: STATUS_FIELD
    })
    wirePickList({ error, data }) {
        if (data) {
            this.pickListOptions = data.values;
        } else if (error) {
            console.log(error);
        }
    }
    
    //case 데이터 불러오기
    @wire(getCase, { pickList: '$pickListOptions' })
    caseData(result) {
        this.caseData = result;
        if (result.data) {
            this.data = JSON.parse(JSON.stringify(result.data));
 
            this.data.forEach(ele => {
                ele.pickListOptions = this.pickListOptions;
                ele.caseLink = '/' + ele.Id;
                if (ele.ContactId__r) {
                ele.ContactId__c = ele.ContactId__r.Name;
                } 
                ele.OwnerId = ele.Owner.Alias;
            })
 
            this.lastSavedData = JSON.parse(JSON.stringify(this.data));
 
        } else if (result.error) {
            console.error('error ',result.error);
            this.data = undefined;
        }
    };

    //레코드 업데이트
    updateDataValues(updateItem) {
        let copyData = JSON.parse(JSON.stringify(this.data));
 
        copyData.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });
 
        this.data = [...copyData];
    }
 
    //임시값 업데이트
    updateDraftValues(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = [...this.draftValues];
        copyDraftValues.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });
 
        if (draftValueChanged) {
            this.draftValues = [...copyDraftValues];
        } else {
            this.draftValues = [...copyDraftValues, updateItem];
        }
    }
 
    handleCellChange(event) {
        let draftValues = event.detail.draftValues;
        draftValues.forEach(ele=>{
            this.updateDraftValues(ele);
        })
    }
 
    handleSave(event) {
        this.showSpinner = true;
        this.saveDraftValues = this.draftValues;
 
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
 
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.showToast('Success', 'Records Updated Successfully!', 'success', 'dismissable');
            this.draftValues = [];
            return this.refresh();
        }).catch(error => {
            console.log(error);
            this.showToast('Error', 'An Error Occured!!', 'error', 'dismissable');
        }).finally(() => {
            this.showSpinner = false;
        });
    }
    
    // handleRowAction(event) {
    //     // console.log('event',event);
    //     // console.log('row',event.detail.row);
    //     const actionName = event.detail.action.name;
    //     const row = event.detail.row;
       
    
    //     switch (actionName) {
    //         case 'edit':
    //             this.editRecord(row);
    //             break;
    //         case 'delete':
    //             this.deleteRecord(row);
    //             break;
    //         default:
    //     }
    // }

    // // 레코드 수정
    // editRecord(row){
    //     this[NavigationMixin.Navigate]({
    //         type: 'standard__recordPage',
    //         attributes: {
    //             recordId: row.Id,
    //             objectApiName: 'cCase__c',
    //             actionName: 'edit'
    //         }
    //     });
    //     this.callList();
    // }

    // // 레코드 삭제
    // deleteRecord(row){
    //     deleteRecord(row.Id)
    //     .then( () => {
    //         this.showToast(
    //             'cContact "'+row.Name+'" was deleted',
    //             '',
    //             'success'
    //         );
    //         //this.dispatchEvent(new RefreshEvent());
    //         this.callList();
    //     })
        
    //     .catch((error) => {
    //         console.log('error ',error);
    //         // this.showToast('Something went wrong', error.body.message, 'error');
    //     })
    // }

    handleCancel(event) {
        this.data = JSON.parse(JSON.stringify(this.lastSavedData));
        this.draftValues = [];
    }
 
    showToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }

    async refresh() {
        await refreshApex(this.caseData);
    }

}