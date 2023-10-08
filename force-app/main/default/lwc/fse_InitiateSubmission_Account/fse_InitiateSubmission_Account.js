import { LightningElement,api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; // for toast notification
 

export default class Fse_InitiateSubmission_Account extends LightningElement {
 @track data = {};//Storing Policy Holder Account Data
 //@track agencyAccData = {};//Storing Agency Account Data
 @api accData = {};
 
 
connectedCallback(){
     if(this.accData != undefined && this.accData !=null){
         this.data =Object.assign({}, this.accData);
         
     }
}
 //To get te Policy Holder Account Details
 getPolicyHolderAccountData(event){
   
    try { 
        console.log("event.target.name>>>>>>>> "+event.target.name);
        console.log("event.target.value>>>>>>>> "+event.target.value);
    if(event.target.value){
        this.data[event.target.name] = event.target.value;
        console.log(">>>>>>>> "+JSON.stringify(this.data));
    } 
} catch (error) {
    console.log("error>>>>>>>> "+error);
}

 }

 /*
//To get te Agency Account Details
 getAgencyAccountData(event){
    try {  
    if(event.target.value){
        this.agencyAccData[event.target.name] = event.target.value;
        console.log(">>>>>>>> "+JSON.stringify(this.agencyAccData));
    } 
} catch (error) {
    console.log("error>>>>>>>> "+error);
}


 }*/

 @api
 sendAccountData(){ 
       return this.data;
 }
 @api
 validateAccountRequiredData(){
     let validField = [];
     for (var element of this.template.querySelectorAll('lightning-input-field[data-idx="policyHolderName"]')) {
        validField = [...validField, element.reportValidity()];
    }
     for (var element of this.template.querySelectorAll('lightning-input-field[data-idx="policyHolderName"]')) {
        validField = [...validField, element.reportValidity()];
    }
    for (var element of this.template.querySelectorAll('lightning-input-field[data-idx="BRM_Agency__c"]')) {
        validField = [...validField, element.reportValidity()];
    }
    for (var element of this.template.querySelectorAll('lightning-input-field[data-idx="BRM_Agency_Contact__c"]')) {
        validField = [...validField, element.reportValidity()];
    }
    for (var element of this.template.querySelectorAll('lightning-input-field[data-idx="AccountSource"]')) {
        validField = [...validField, element.reportValidity()];
    }
    if (validField.join('.').includes('false')) {
        this.isRequiredFieldMissing = true;
        console.log("Please Complete all required Field ---->"+this.isRequiredFieldMissing);
    } 
    else{
        this.isRequiredFieldMissing = false;
    }
     return this.isRequiredFieldMissing;
 }
   
 
}