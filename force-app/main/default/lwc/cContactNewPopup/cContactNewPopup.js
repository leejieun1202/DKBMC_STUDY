// JavaScript code for the LWC component
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveContact from '@salesforce/apex/cAccountController.saveContact';

export default class CContactNewPopup extends LightningElement {
    @track contactList = [{ id: 1, LastName: '', FirstName: '', title: '', email: '', phone: '' }];

    handleChange(event) {
        const { dataId, dataIndex } = event.target.dataset;
        const value = event.target.value;
        console.log(value,'val');
        this.contactList[dataIndex][dataId] = value;
    }

    addRow() {
        const id = this.contactList.length + 1;
        this.contactList.push({ id, LastName: '', FirstName: '', title: '', email: '', phone: '' });
    }

    removeRow(event) {
        const { dataIndex } = event.target.dataset;
        this.contactList.splice(dataIndex, 1);
    }

    handleSave() {
        saveContact({ contactList: this.contactList })
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Contacts saved successfully!',
                        variant: 'success'
                    })
                );
                // Do any further processing if needed
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error saving contacts',
                        variant: 'error'
                    })
                );
                // Handle any error conditions
            });
    }
}
