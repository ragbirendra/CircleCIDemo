import { LightningElement,track, api } from 'lwc';

export default class Fse_InitiateSubmission_Opportunity extends LightningElement {
    @track data = {};
    @api oppData = {};


    connectedCallback(){
        if(this.oppData != undefined && this.oppData !=null){
            this.data =Object.assign({}, this.oppData);
        }
   }

    getOpportunityData(event){
       try {
           
       
       console.log(">>>>>>>> "+event.target.name);
       console.log(">>>>>>>> "+event.target.value);
   
       if(event.target.value){
        this.data[event.target.name] = event.target.value;
       }
       console.log(">>>>>>>> "+JSON.stringify(this.data));
   } catch (error) {
       console.log("error>>>>>>>> "+error);
   }
   
    }
   
    @api
    sendOpportunityData(){ 
          return this.data;
    }
}