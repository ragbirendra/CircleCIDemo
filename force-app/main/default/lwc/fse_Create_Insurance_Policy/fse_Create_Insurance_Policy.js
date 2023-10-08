import { LightningElement,track,api, wire } from 'lwc';
import createPolicyInsurance from "@salesforce/apex/FSE_Create_InsurancePolicy_Controller.createInsurancePolicy";
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import {getRecord, getFieldValue} from 'lightning/uiRecordApi';
//import CURRENTRECORDID from '@salesforce/Quotes__c/Id'; 
import QUOTES_STATUS_FIELD from '@salesforce/schema/Quotes__c.BRM_Status__c';
const FIELDS= [QUOTES_STATUS_FIELD];

export default class Fse_Create_Insurance_Policy extends LightningElement {
    @api recordId;
    @track isModalOpen = true;
    @track loadSpinners = false;

    ///quotesId = CURRENTRECORDID;
 
    @wire(getRecord,{recordId: '$recordId', fields: FIELDS}) quotesObj;
 

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
    createPolicyInsurance() { 
        this.loadSpinners = true;
        createPolicyInsurance({
            quoteId:this.recordId
        })
        .then((result) => {
            if (result != undefined && result != null) {
            this.loadSpinners=false;
            this.hideModalBox();
            const toastEvent = new ShowToastEvent({
                title: "Insurance Policy created Successfully",
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

checkQuotes(){
    var quoteStatus = getFieldValue(this.quotesObj.data, QUOTES_STATUS_FIELD);
    if(quoteStatus == "Approved"){
        this.createPolicyInsurance();
    }else{
        const toastEvent = new ShowToastEvent({
            title: "Insurance Policy Colud not be Genrated", 
            message: "Quote Status should be Approved",
            variant: "error"
        });
        this.dispatchEvent(toastEvent);
        }
    }

        
}