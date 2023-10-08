import { LightningElement, track, api } from 'lwc';
import validateRecordForUpload from '@salesforce/apex/BR_FileUploaderClass.validateRecordForUpload';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

 
export default class UploadOpp extends NavigationMixin(LightningElement){

        @api recordid;
        @track showLoadingSpinner = false;
        @track isTrue = false;
        @track isShowModal = true;
        @track isError =false;
        @track errorMessage=[];
        value='';
        AccountHeader ='Name,Rating,BillingCity,BillingState,BillingStreet,BillingPostalCode,BillingCountry,BRM_Status__c,BRM_Number_Of_Employee__c,BRM_Preferred_Underwriter__c,BRM_Termination_Date__c,BRM_Appointment_Date__c,BRM_Agency_Code__c,BRM_Account_Number__c,BRM_Agency__c,BRM_Agency_Contact__c,BRM_Primary_Email__c,BRM_Mobile_Phone__c,BRM_Year_In_Bus__c,Email__c,Fax,Website,Industry,Active__c';
        AccountRow ='Test2,Hot,London,England,London,W5 XYZ,United Kingdom,Customer,86000,,,,,BDATAB-Test2,Test,Test,test2@shell.com,+44 (0) 20 7934 1234,17,test2@shell.com,44 4345 1516,https://www.shell.com,Oil and Gas,TRUE';
        
        ContactHeader ='FirstName,LastName,BRM_Primary_Email__c,BRM_Mobile_Phone__c,HomePhone,AccountId,BRM_Multi_Role__c';
        ContactRow ='Test123,Test-Con,test@test.com,2075154500,2075154500,Test,Admin';

        OpportunityHeader ='Name,Insurance_Type__c,Description,StageName,Amount,CloseDate,BRM_Expiration_Date__c,BRM_Needed_By_Date__c,BRM_Effective_Date__c,BRM_Renewal__c,BRM_Submission__c,BRM_Premium__c,BRM_Agency_Contact__c,BRM_Agency_Account__c,OwnerId';
        OpportunityRow ='Test,Test-Opp,Health,DesTest,Initiate Transfer,186000,12-12-2023,12-12-2023,12-12-2023,12-12-2023,FALSE,Submission Details,186000,Test,Test,Insurance Admin';

        InsurancePolicyHeader ='UniversalPolicyNumber,AuditTerm,BRM_Agency_Account__c,CancellationDate,CancellationReason,CancellationReasonType,CashSurrenderValue,ChangeSubtype,ChangeType,ContractGroupPlanId,DateRenewed,Discount,EffectiveDate,ExpirationDate,FinalRenewalDate,GrossWrittenPremium,HasAnyAutoCoverage,IsLoanEligibile,IsRenewedPolicy,Name,NameInsuredId,OriginalEffectiveDate,OriginalExpirationDate,OriginalPolicyId,OwnerId,PaidToDate,ParentPolicyId,PaymentDueDate,PlanTier,PlanType,PolicyDescription,PolicyName,PolicyTerm,PolicyType,PremiumAmount,PremiumCalculationMethod,PremiumFrequency,PremiumPaymentType,PreviousPremium,PreviousRenewalDate,PriorPolicyId,ProducerId,ProductId,Quotes__c,ReferencePolicyNumber,RenewalChannel,RenewalDate,RenewedFromPolicyId,SaleDate,ServicingOfficeCity,ServicingOfficeCountry,ServicingOfficeGeocodeAccuracy,ServicingOfficeLatitude,ServicingOfficeLongitude,ServicingOfficePostalCode,ServicingOfficeState,ServicingOfficeStreet,SourceOpportunityId,SourceSystem,SourceSystemIdentifier,StandardFeeAmount,StandardPremiumAmount,StandardTaxAmount,Status,Substatus,TaxesSurcharges,TermFeeAmount,TermPremiumAmount,TermTaxAmount,TotalCommissionAmount,TotalSumInsured,UnderwritingEntityId';
        InsurancePolicyRow =',,Test,,,,,,,,,,27-01-2023,27-01-2023,,,FALSE,FALSE,FALSE,BRM-Quote-Test,Test,,,,,,,,,,,,,Health,195300,,,,,,,,Health,Q-0170,,,,,,,,,,,,,,,,,,,,Initial,Draft,,,,,,,';

        QuoteHeader ='BRM_Agency_Account__c,BRM_Premium_Amount__c,BRM_Status__c,Insurance_Type__c,Opportunity__c,OwnerId';
        QuoteRow ='Test,195300,Approved,Health,Test-Opp,,';

        ClaimHeader ='Name,AccountId,Severity,EstimatedAmount,ActualAmount,ApprovedAmount,Expenses__c,FinalizedDate,PolicyNumberId,Agency_Account__c,ClaimType,LossType,InitiationDate,AssessmentDate,Status,ClaimReason';
        ClaimRow ='Test-Claim,Test,Medium,100,90,80,10,28-01-2023,BRM-Quote-Test,Test,Worker Compensation,Permanent Disablement,28-01-2023,27-01-2023,Closed,Worker Compensation';
        
        @track selectedOption;

       changeHandler(event) {
    
    
        this.selectedOption = event.target.value;
          
        
         }

       get options() {
        return [
            { label: 'Policy Holder Account', value: 'Account' },
            { label: 'Policy Holder Contact', value: 'Contact' },
            { label: 'Submission', value: 'Opportunity' },
            { label: 'Policy', value: 'InsurancePolicy' },
            { label: 'Quote', value: 'Quote' },
            { label: 'Claim', value: 'Claim' }
            
            
        ];
      }

    handleChange(event) {
        this.value = event.detail.value;
    }
     
   showModalBox() {  
       this.isShowModal = true;
   }

   hideModalBox() {  

       
    console.log('At Start....................')
        this.isShowModal = false;
        console.log('At END....................')
    
   }

   downloadDataTemplateCsv(event) {
    var csv;
    if(this.selectedOption=='Account')csv=this.AccountHeader + '\n' + this.AccountRow;
    if(this.selectedOption=='Contact')csv=this.AccountHeader + '\n' + this.AccountRow;
    if(this.selectedOption=='Opportunity')csv=this.AccountHeader + '\n' + this.AccountRow;
    if(this.selectedOption=='InsurancePolicy')csv=this.AccountHeader + '\n' + this.AccountRow;
    if(this.selectedOption=='Quote')csv=this.AccountHeader + '\n' + this.AccountRow;
    if(this.selectedOption=='Claim')csv=this.AccountHeader + '\n' + this.AccountRow;
    var hiddenElement = document.createElement('a');
    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
    hiddenElement.target = '_self'; // 
    if(this.selectedOption=='Opportunity'){hiddenElement.download = 'Submission'+'.csv';}
    else{
        hiddenElement.download = this.selectedOption+'.csv';
    }
    
    document.body.appendChild(hiddenElement);
    hiddenElement.click();

   }


 


}