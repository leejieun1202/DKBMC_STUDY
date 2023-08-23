import getCaseTest from '@salesforce/apex/cCaseController.getCaseTest';
import { LightningElement,api, track } from 'lwc';

export default class CCaseRecordPage extends LightningElement {
    @api recordId;
    @track caseList;
    isShowEdit = false;
    isShowClose = false;
    isShowDelete = false;

    connectedCallback(){
        this.callList();
    }

    //데이터 불러오기
    callList(){
        getCaseTest({caseId : this.recordId})
        .then((data) => {
            this.caseList = data;
            this.error = undefined;
        })
        .catch((error) =>{
            this.error = error;
            this.data = undefined;
        })
    }

    //edit modal 띄우기
    navigateToEdit(){
        this.isShowEdit = true;
    }

    //close modal 띄우기
    navigateToClose(){
        this.isShowClose = true;
    }

    //delete modal 띄우기
    navigateToDelete(){
        this.isShowDelete = true;
    }
}