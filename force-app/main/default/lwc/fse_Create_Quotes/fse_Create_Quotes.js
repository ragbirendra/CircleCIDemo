import { LightningElement,track,api } from 'lwc';
import createQuotes from "@salesforce/apex/FSE_Create_Quotes_Controller.createQuotes";
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Fse_Create_Quotes extends LightningElement {
    @api recordId;
    @track isModalOpen = true;
    @track loadSpinners = false;

    showModalBox() {  
        this.isModalOpen = true;
    }

    hideModalBox() {  
        this.isModalOpen = false;
        this.dispatchEvent(new CloseActionScreenEvent());

        //Firing this event to close the Quick Action From AURA
        const closeModel = new CustomEvent("closeQuickAction", {  detail:"Closing Action Model"
        });
          // Fire the custom event
          this.dispatchEvent(closeModel);
    }
    createQuotes() { 
        this.loadSpinners = true;
        createQuotes({
            opprtunityId:this.recordId
        })
        .then((result) => {
            if (result != undefined && result != null) {
            this.loadSpinners=false;
            this.hideModalBox(); 
            const toastEvent = new ShowToastEvent({
                title: "Quotes created Successfully",
                message: "Record ID: " + result.Id,
                variant: "success"
            });
            this.dispatchEvent(toastEvent);
            }
        })
        .catch((error) => {
        console.log("Error in createQuotes");
        console.log(error);
        this.loadSpinners=false;
        });
        }
}