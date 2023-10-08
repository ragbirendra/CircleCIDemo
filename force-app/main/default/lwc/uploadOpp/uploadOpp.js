import { LightningElement, track, api } from 'lwc';
import validateRecordForUpload from '@salesforce/apex/BR_FileUploaderClass.validateRecordForUpload';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

 
export default class UploadOpp extends NavigationMixin(LightningElement){

        @api recordid;
        @track objectName = 'Succesfully Uploaded Records Shown here.....';
        @track actualObjectName = 'Opportunity';
        @track columns = [];
        @track data;
        @track fileName = '';
        @track UploadFile = 'Upload CSV File';
        @track showLoadingSpinner = false;
        @track isTrue = false;
        selectedRecords;
        filesUploaded = [];
        file;
        fileContents;
        fileReader;
        content;
        MAX_FILE_SIZE = 1500000;
        @track isShowModal = true;
        @track isError =false;
        @track errorMessage=[];
     
   showModalBox() {  
       this.isShowModal = true;
   }

   hideModalBox() {  

       
    console.log('At Start....................')
        // Navigate to the Opportunity object's Recent list view.
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.actualObjectName,
                actionName: 'list'
            },
            state: {
                filterName: 'Recent' 
            }
        });
        this.isShowModal = false;
        console.log('At END....................')
    
   }

   handleFilesChange(event) {

       if(event.target.files.length > 0) {
           this.filesUploaded = event.target.files;
           this.fileName = event.target.files[0].name;

       }

   }

   handleSave() {

       if(this.filesUploaded.length > 0) {

           this.uploadHelper();

       }

       else {

           this.fileName = 'Please select a CSV file to upload!!';

       }

   }

 

   uploadHelper() {

       this.file = this.filesUploaded[0];
      if (this.file.size > this.MAX_FILE_SIZE) {
           window.console.log('File Size is to long');
           return ;

       }
       this.showLoadingSpinner = true;
       this.fileReader= new FileReader();
       this.fileReader.onloadend = (() => {

           this.fileContents = this.fileReader.result;
           this.validateFile();
           this.showLoadingSpinner = true;
           //this.saveToFile();

       });
       this.fileReader.readAsText(this.file);

   }
   validateFile(){
    validateRecordForUpload({ base64Data: JSON.stringify(this.fileContents), fileName: this.fileName})
    .then(result => {
        console.log('this.fileName------>:- '+this.fileName);
     window.console.log(result);
               this.showLoadingSpinner = false;
               console.log('AAAAAAAAAAAA'+result.isError);
               this.isError    = result.isError;
               this.errorMessage = result.errorMsgList;
               if(!result.isError){
               this.setColumn(result.objectName);
               this.actualObjectName = result.objectName;
               this.objectName ='Uploaded ' + result.objectName + ' Record';
               if(result.objectName == 'Opportunity'){
                this.objectName ='Uploaded Submission Record';   
               }
               this.fileName = this.fileName + ' - Uploaded Successfully';
               this.isTrue = false;
               this.data = result.recordList;
               this.dispatchEvent(

                new ShowToastEvent({
    
                    title: 'Success!!',
                    message: this.file.name + ' - Uploaded Successfully!!!',
                    variant: 'success',
    
                })
    
            );}
           
    })
    .catch(error => {
        console.log('Erroruredyyyyyy:- '+error.body.message);
        console.log('BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBb');
        this.showLoadingSpinner = false;
        this.isError =true;
        this.errorMessage.push(error.body.message);
        
    });   
   }
   setColumn(objName){
       if(objName=='Opportunity'){
           this.columns = [

            { label: 'Account Id', fieldName: 'AccountId' },
            { label: 'Name', fieldName: 'Name' },
            { label: 'Amount', fieldName: 'Amount', type: 'Currency' },
            { label: 'Insurance Type', fieldName: 'Insurance_Type__c' },
            { label: 'Description', fieldName: 'Description' },
            { label: 'Expiration Date', fieldName: 'BRM_Expiration_Date__c' },
            { label: 'Needed By Date', fieldName: 'BRM_Needed_By_Date__c' },
            { label: 'Effective Date', fieldName: 'BRM_Effective_Date__c' },
            { label: 'Renewal Date', fieldName: 'BRM_Renewal__c' },
            { label: 'Submission Date', fieldName: 'BRM_Submission__c' },
            { label: 'Premium', fieldName: 'BRM_Premium__c' },
            { label: 'Agency Contact', fieldName: 'BRM_Agency_Contact__c' },
            { label: 'Agency Account', fieldName: 'BRM_Agency_Account__c' },
            { label: 'StageName', fieldName: 'StageName' },
            { label: 'CloseDate', fieldName: 'CloseDate' }
         
         ];
       }
       if(objName=='Account'){
        this.columns = [

         
         { label: 'Name', fieldName: 'Name' },
         { label: 'BRM Status', fieldName: 'BRM_Status__c' },
         { label: 'Number of Employee', fieldName: 'BRM_Number_Of_Employee__c' },
         { label: 'Agency Code', fieldName: 'BRM_Agency_Code__c' },
         { label: 'Account Numbere', fieldName: 'BRM_Account_Number__c' },
         { label: 'Agency', fieldName: 'BRM_Agency__c' },
         { label: 'Agency Contact', fieldName: 'BRM_Agency_Contact__c' },
         { label: 'Primary Email', fieldName: 'BRM_Primary_Email__c' },
         { label: 'Mobile Phone', fieldName: 'BRM_Mobile_Phone__c' },
         { label: 'BRM Year', fieldName: 'BRM_Year_In_Bus__c' },
         { label: 'Email', fieldName: 'Email__c' },
         { label: 'Website', fieldName: 'Website' },
         { label: 'Industry', fieldName: 'Industry' },
         { label: 'Active', fieldName: 'Active__c' }
      
      ];
    }
    if(objName=='InsurancePolicy'){
        this.columns = [

         
         { label: 'Name', fieldName: 'Name' },
         { label: 'Agency Account', fieldName: 'BRM_Agency_Account__c' },
         { label: 'EffectiveDate', fieldName: 'EffectiveDate' },
         { label: 'ExpirationDate', fieldName: 'ExpirationDate' },
         { label: 'IsActive', fieldName: 'IsActive' },
         { label: 'NameInsuredId', fieldName: 'NameInsuredId' },
         { label: 'OwnerId', fieldName: 'OwnerId' },
         { label: 'PolicyType', fieldName: 'PolicyType' },
         { label: 'PremiumAmount', fieldName: 'PremiumAmount' },
         { label: 'ProducerId', fieldName: 'ProducerId' },
         { label: 'ProductId', fieldName: 'ProductId' },
         { label: 'Quotes__c', fieldName: 'Quotes__c' },
         { label: 'Status', fieldName: 'Status' },
         { label: 'Substatus', fieldName: 'Substatus' },
         { label: 'TotalStandardAmount', fieldName: 'TotalStandardAmount' }
      
      ];
    }
    if(objName=='Quotes__c'){
        this.columns = [

         
         { label: 'Name', fieldName: 'Name' },
         { label: 'BRM Agency Account', fieldName: 'BRM_Agency_Account__c' },
         { label: 'Premium Amount', fieldName: 'BRM_Premium_Amount__c' },
         { label: 'Status', fieldName: 'BRM_Status__c' },
         { label: 'Insurance Type', fieldName: 'Insurance_Type__c' },
         { label: 'Opportunity', fieldName: 'Opportunity__c' },
         { label: 'OwnerId', fieldName: 'OwnerId' }
        
      
      ];
    }
    if(objName=='Claim'){
        this.columns = [

         
         { label: 'Name', fieldName: 'Name' },
         { label: 'AccountId', fieldName: 'AccountId' },
         { label: 'Severity', fieldName: 'Severity' },
         { label: 'Estimated Amount', fieldName: 'EstimatedAmount' },
         { label: 'Actual Amount', fieldName: 'ActualAmount' },
         { label: 'Approved Amount', fieldName: 'ApprovedAmount' },
         { label: 'Expenses', fieldName: 'Expenses__c' },
         { label: 'Finalized Date', fieldName: 'FinalizedDate' },
         { label: 'Policy NumberId', fieldName: 'PolicyNumberId' },
         { label: 'Agency Account', fieldName: 'Agency_Account__c' },
         { label: 'Claim Type', fieldName: 'ClaimType' },
         { label: 'Claim Reason', fieldName: 'ClaimReason' },
         { label: 'Status', fieldName: 'Status' },
         { label: 'Assessment Date', fieldName: 'AssessmentDate' }
      
      ];
    }
    if(objName=='Contact'){
        this.columns = [

         
         { label: 'Name', fieldName: 'Name' },
         { label: 'Primary Email', fieldName: 'BRM_Primary_Email__c' },
         { label: 'Mobile Phone', fieldName: 'BRM_Mobile_Phone__c' },
         { label: 'Home Phone', fieldName: 'HomePhone' },
         { label: 'AccountId', fieldName: 'AccountId' },
         { label: 'Role', fieldName: 'BRM_Multi_Role__c' }
      ];
    }
   }
   
  /* saveToFile() {

    saveFile({ base64Data: JSON.stringify(this.fileContents), fileName: this.recordid})
    .then(result => {
     window.console.log('result ====> ');
     window.console.log(result);
     this.data = result;
     this.fileName = this.fileName + ' - Uploaded Successfully';
     this.isTrue = false;
     this.isError =false;
     this.showLoadingSpinner = false;
     this.dispatchEvent(

            new ShowToastEvent({

                title: 'Success!!',
                message: this.file.name + ' - Uploaded Successfully!!!',
                variant: 'success',

            })

        );
    })
    .catch(error => {
        console.log('Errorured:- '+error.body.message);
        this.showLoadingSpinner = false;
        this.isError =true;
        this.errorMessage.push(error.body.message);
        
    });

   }*/

}