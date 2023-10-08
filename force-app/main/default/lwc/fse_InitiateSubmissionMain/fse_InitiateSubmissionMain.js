import { LightningElement,api, track } from 'lwc';
import validateInitiateSubmissionData from "@salesforce/apex/FSE_Initiate_Submission_Controller.validateInitiateSubmissionData";
import createSubmission from "@salesforce/apex/FSE_Initiate_Submission_Controller.createInitiateSubmissionData";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Fse_InitiateSubmissionMain extends NavigationMixin(
    LightningElement
  ) {
@api accountData = {};
@track isRequiredFieldMissing = false;
@api opportunityData = {};
@api contactData = [];
@api locationData = [];

@track currentPage = 1;
@track isPageOne = false;
@track isPageTwo = false;
@track isPageThree = false;
@track isPageFour = false;
@track disabledPrevious = false;
@track isTemp = true;
@track totalPage = 4;
@track loadSpinners = true;
@track isError =false;
@track errorMessage=[];
connectedCallback(){
   this.showRequiredPage();
}

//To move to Next Page
moveToNextPage(){
    
   
    if(this.currentPage == 1){
        this.getAccountData();
    }else if(this.currentPage == 2){
        this.getOpportunityData();
    }
    else if(this.currentPage == 3){
        this.getContactData();
       // this.submitData();
    }
    else if(this.currentPage == 4){
        this.loadSpinners = true;
        this.getLocationData();
        this.validateInitiateSubmission();
       // this.submitData();
    }
    if((this.currentPage < this.totalPage) && !this.isRequiredFieldMissing){
        this.currentPage = this.currentPage + 1;
        this.showRequiredPage();
    }
    if((this.currentPage < this.totalPage) && this.isRequiredFieldMissing){
        this.currentPage = this.currentPage ;
        this.showRequiredPage();
        
    }
    
   
}
//To move to Previous Page
moveToPreviousPage(){ 
    this.currentPage = this.currentPage - 1;
    this.showRequiredPage();
    

}
 
//Display the Page 
showRequiredPage(){
    if(this.currentPage == 1){
        this.isPageOne = true;
        this.isPageTwo = false;
        this.isPageThree = false;
        this.disabledPrevious = true; 
         
    }else if(this.currentPage == 2){
        this.isPageOne = false;
        this.isPageTwo = true;
        this.isPageThree = false;
        this.disabledPrevious = false;
    }else if(this.currentPage == 3){
        this.isPageOne = false;
        this.isPageTwo = false;
        this.isPageThree = true; 
        this.isPageFour = false;
        //this.disabledPrevious = false;
        
    }
    else if(this.currentPage == 4){
        this.isPageOne = false;
        this.isPageTwo = false;
        this.isPageThree = false; 
        this.isPageFour = true;
        this.disabledPrevious = false;
        
    }
    this.loadSpinners = false;
}
validateInitiateSubmission(){
    
    var allData ={};
    allData['accList']=[this.accountData];
    allData['oppList']=[this.opportunityData];
    allData['conList']= this.contactData;
    allData['locList']=this.locationData;

    validateInitiateSubmissionData({submissionData:JSON.stringify(allData)})
    .then(result => {
             console.log('this.isError---->'+this.isError);
             console.log('result.isError---->'+result.isError);
            if(result.isError){
                this.loadSpinners = false;
                this.isError    = result.isError;
                this.errorMessage = result.errorMsgList;
            }else{
                this.loadSpinners = false;
                this.showToast("Success", "Record Submitted Successfully", "success");
                this.navigateDetails(result.intSubmission.oppList[0].Id);
            }
               
           
    })
    .catch((error) => {
        this.isError =true;
        this.loadSpinners =false;
        console.log('-------------->>>>'+error.body.message);
        this.errorMessage.push(error.body.message);
        
    })
   }

submitData(){
    //this.loadSpinners = true;
    //alert("Development is in Progress");
var allData ={};

allData['accList']=[this.accountData];
allData['oppList']=[this.opportunityData];
//allData['conList']=[this.contactData];
allData['conList']= this.contactData;
allData['locList']=this.locationData;

    createSubmission({
        submissionData:JSON.stringify(allData)
    })
    .then((result) => {
    console.log("Calling Apex Controller");
    console.log(result);
    if (result != undefined && result != null) {
        console.log("result>>>> "+result);
        this.loadSpinners = false;
        this.showToast("Success", "Record Submitted Successfully", "success");
        this.navigateDetails(result.oppList[0].Id);
    }else{
        this.showToast("Error", "Something went wrong!", "error");
        this.loadSpinners = false;
    }
     
    })
    .catch((error) => {
    console.log("Error in submitData");
    console.log(error);
    this.showToast("Error", "Something went wrong!", "error");
    this.loadSpinners = false;
    });
}
 
//to get the data of account from child LWC c-fse-_-initiate-submission-_-account
getAccountData(){ 
   
   this.accountData =  this.template.querySelector('c-fse-_-initiate-submission-_-account').sendAccountData();
   console.log("dataadataa   Name:::>>> "+this.accountData.Name);
   if((this.accountData.Name=='undefined' ||this.accountData.Name=='' )|| this.accountData.Name==null ){
    this.isRequiredFieldMissing = true;
   }
   this.isRequiredFieldMissing = this.template.querySelector('c-fse-_-initiate-submission-_-account').validateAccountRequiredData();
   console.log("dataadataa>>> "+JSON.stringify(this.accountData));
   console.log("isRequiredFieldMissing>>> "+this.isRequiredFieldMissing);

}
//to get the data of Opportunity from child LWC c-fse-_-initiate-submission-_-opportunity
getOpportunityData(){ 
    this.opportunityData =  this.template.querySelector('c-fse-_-initiate-submission-_-opportunity').sendOpportunityData();
    console.log("dataadataa>>> "+JSON.stringify(this.opportunityData));
 
 }
 //to get the data of Contact from child LWC c-fse-_-initiate-submission-_-contact
getContactData(){ 
    this.contactData =  this.template.querySelector('c-fse-_-initiate-submission-_-contact').sendContactData();
    console.log("dataadataa>>> "+JSON.stringify(this.contactData));
 
 }

  //to get the data of Location from child LWC c-fse-_-initiate-submission-_-location
getLocationData(){ 
    this.locationData =  this.template.querySelector('c-fse-_-initiate-submission-_-location').sendLocationData();
    console.log("dataadataa>>> "+JSON.stringify(this.locationData));
 
 }


 navigateDetails(recordId){ 
     
    try {
        this[NavigationMixin.Navigate]({
            type:'standard__webPage',
            attributes:{
                url:"/detail/"+recordId
            }
        });
    } catch (error) {
        console.log("error>>>> "+error);
    }
   
}

 //to show toast message
showToast(title, message, variant) {
    const event = new ShowToastEvent({
        title: title,
        variant:   variant,
        message:message
    });
    this.dispatchEvent(event);
}
}