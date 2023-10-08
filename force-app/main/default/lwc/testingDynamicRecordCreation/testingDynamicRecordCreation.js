import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class TestingDynamicRecordCreation extends LightningElement {
    
    keyIndex = 0;
    @track itemList = [
        {
            row_id: 0
        }
    ];

    addRow() {
        ++this.keyIndex;
        var newItem = [{ row_id: this.keyIndex }];
        this.itemList = this.itemList.concat(newItem);
    }

    removeRow(event) {
        try {
            
        
        if (this.itemList.length >= 2) {
            this.itemList = this.itemList.filter(function (element) {
                return parseInt(element.row_id) !== parseInt(event.target.accessKey);
            });
        }
    } catch (error) {
        console.log("error>>>> "+error);
    }
    }

    handleSubmit() {
        console.log("this.itemList>>>> "+JSON.stringify(this.itemList));
        var isVal = true;
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            isVal = isVal && element.reportValidity();
        });
        if (isVal) {
            this.template.querySelectorAll('lightning-record-edit-form').forEach(element => {
                element.submit();
            });
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contacts successfully created',
                    variant: 'success',
                }),
            );
            // Navigate to the Account home page
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Contact',
                    actionName: 'home',
                },
            });
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: 'Please enter all the required fields',
                    variant: 'error',
                }),
            );
        }
    }



    ///My methods
    getpolicyHolderContactData(event){
        try {
            console.log('bw: id = ' + event.target.dataset.index);
        var index = event.target.dataset.index;
        console.log(">>>>>>>> "+event.target.name);
        console.log(">>>>>>>> "+event.target.value);
    
        if(event.target.value){
            //this.data[event.target.name] = event.target.value;
            this.itemList[index][event.target.name] = event.target.value;
        }
       // console.log(">>>>>>>> "+JSON.stringify(this.data));
    } catch (error) {
        console.log("error>>>>>>>> "+error);
    }
    
     }
}