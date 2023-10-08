/*
<!--
- @author  Coforge POC  
- @date    31 OCT 2022
- @group 
-
- @description
- This is use to Initiate Submission as LWC Controller
- @log
- =======================================================================================
- Date            Developer                               Description       
- =======================================================================================
- 31 OCT 2022    Amit Behere                            Initial Creation 
-->
*/
public class FSE_Initiate_Submission_Controller {
    
    public static String bussinessAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
    public static String policyHolderAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Policy_Holder').getRecordTypeId();
    public static String newIndividualRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('NewIndividual').getRecordTypeId();
        //public static String personrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();

    
    public static String newIndustriesIndividualRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('IndustriesIndividual').getRecordTypeId();

    public static String genrealOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('General').getRecordTypeId();
    public static validationWrapper wrapper;
    
    //This Method is used to get the Initiate Submission Data for the LWC
    @AuraEnabled 
    public static void getInitiateSubmissionData(){
        try{ 
            
        }catch(Exception e){
            System.debug('Exception in getInitiateSubmissionData '+e); 
        }
    }
    //This Method is used to validate acc,opp,contact and location date
    
    @AuraEnabled
    public static validationWrapper validateInitiateSubmissionData(String submissionData){
        wrapper = new validationWrapper();
        wrapper.isError = false;
        wrapper.errorMsgList = new List<String>();
        
        Map<String, Object> submissionDataMap = (Map<String, Object>) JSON.deserializeUntyped(submissionData);
        System.debug('submissionDataMap>>> '+submissionDataMap);
        
        InitiateSubmissionWrapper initiateSubmissionWrapperObj = (InitiateSubmissionWrapper )JSON.deserialize(submissionData, InitiateSubmissionWrapper.class); 

        System.debug('initiateSubmissionWrapperObj>>> '+initiateSubmissionWrapperObj);
        List<Account> accList = initiateSubmissionWrapperObj.accList;
        List<Opportunity> oppList =  initiateSubmissionWrapperObj.oppList;
        List<Contact> conList =  initiateSubmissionWrapperObj.conList;
        List<Location__c> loccList = initiateSubmissionWrapperObj.locList;
        System.debug('loccList>>> '+loccList); 
        
       
        accList[0].RecordTypeId = newIndividualRecordTypeId;
        accList[0].BRM_Status__c = 'Customer';
        

        try{
            upsert accList;  
           }catch(Exception ex){
            system.debug('test-1');
              wrapper.isError = true;
              String msg ='Error While Inserting Account Data: '+ex.getMessage();
              wrapper.errorMsgList.add(msg);
           }
           system.debug('accList[0].Id:::'+accList[0].Id);
        if(accList[0].Id ==null)
        {
            wrapper.isError = true;
            system.debug('test-2');
            String msg ='Account is not successfully inserted, So Opportunity,Contact and Location could not be created';
            wrapper.errorMsgList.add(msg);  
            return wrapper;
        }
        oppList[0].AccountId = accList[0].Id;
        if(accList[0].BRM_Agency__c==null){
            wrapper.isError = true;
            system.debug('test-3');
            String msg ='Agency could not be blank on Account';
            wrapper.errorMsgList.add(msg);
             
        }
        oppList[0].BRM_Agency_Account__c = accList[0].BRM_Agency__c;
       
        try{
            insert oppList;
           }catch(Exception ex){
             
              wrapper.isError = true;
              system.debug('test-4');
              String msg ='Error While Inserting Opp Data: '+ex.getMessage();
              wrapper.errorMsgList.add(msg);
           }
        conList[0].AccountId = accList[0].Id;
        
        for(Integer i=0;i<conList.size();i++){
            conList[i].AccountId = accList[0].Id;
            conList[i].BRM_Agency_Account__c = accList[0].BRM_Agency__c; 
            //conList[i].RecordTypeId = newIndustriesIndividualRecordTypeId;
        }
        try{
            insert conList;
           }catch(Exception ex){
             system.debug('test-5');
              wrapper.isError = true;
              String msg ='Error While Inserting Contact Data: '+ex.getMessage();
              wrapper.errorMsgList.add(msg);
           }
       
         for(Integer i=0;i<loccList.size();i++){
            loccList[i].BRM_Submission__c = oppList[0].Id;
        }
         
        try{
            insert loccList;
           }catch(Exception ex){
              system.debug('test-6');
              wrapper.isError = true;
              String msg ='Error While Inserting Location Data: '+ex.getMessage();
              wrapper.errorMsgList.add(msg);
           }
        system.debug('IsError------------>'+wrapper.isError);
        return wrapper;
    }
    //This Method is used to get the Initiate Submission Data for the LWC
    @AuraEnabled 
    public static InitiateSubmissionWrapper createInitiateSubmissionData(String submissionData){
        try{ 
            Map<String, Object> submissionDataMap = (Map<String, Object>) JSON.deserializeUntyped(submissionData);
            System.debug('submissionDataMap>>> '+submissionDataMap);
            
            InitiateSubmissionWrapper initiateSubmissionWrapperObj = (InitiateSubmissionWrapper )JSON.deserialize(submissionData, InitiateSubmissionWrapper.class); 
            System.debug('initiateSubmissionWrapperObj>>> '+initiateSubmissionWrapperObj);
            List<Account> accList = initiateSubmissionWrapperObj.accList;
            List<Opportunity> oppList =  initiateSubmissionWrapperObj.oppList;
            List<Contact> conList =  initiateSubmissionWrapperObj.conList;
            //List<Schema.Location> loccList = initiateSubmissionWrapperObj.locList;
            List<Location__c> loccList = initiateSubmissionWrapperObj.locList;
            System.debug('loccList>>> '+loccList); 
            
           
            accList[0].RecordTypeId = newIndividualRecordTypeId;
            accList[0].BRM_Status__c = 'Customer';
            upsert accList;
            System.debug('accList>>> '+accList); 
            oppList[0].AccountId = accList[0].Id;
            oppList[0].BRM_Agency_Account__c = accList[0].BRM_Agency__c;
            insert oppList;
           
            conList[0].AccountId = accList[0].Id;
            
            for(Integer i=0;i<conList.size();i++){
                conList[i].AccountId = accList[0].Id;
                conList[i].BRM_Agency_Account__c = accList[0].BRM_Agency__c; 
                //conList[i].RecordTypeId = newIndustriesIndividualRecordTypeId;
            }
            insert conList;
            
            system.debug('Updated Con List>>>  '+conList);
            
            System.debug('oppListoppList >>>>> '+oppList);
            //loccList[0].BRM_Submission__c = oppList[0].Id;
             for(Integer i=0;i<loccList.size();i++){
                loccList[i].BRM_Submission__c = oppList[0].Id;
            }
            insert loccList; 
            
            return new InitiateSubmissionWrapper(accList,oppList,conList,loccList);
            
        }catch(Exception e){
            System.debug('Exception in createInitiateSubmissionData '+e); 
            System.debug('Line No>>>> '+e.getLineNumber()); 
            return null;
        }
    }
    
    public static List<Schema.PicklistEntry> getPicklistValues(Schema.sObjectField field) {
        // Get all picklist values
        List<Schema.PicklistEntry> entries = field.getDescribe().getPickListValues();
        // Only return active picklist values
        List<Schema.PicklistEntry> activeEntries = new List<Schema.PicklistEntry>();
        for (Schema.PicklistEntry entry : entries) {
            System.debug('entry>> '+entry);
            if (entry.isActive()) {
                activeEntries.add(entry);
            }
        }
        return activeEntries;
    } 
    
    
     //Create the Houshold Account for Customer Account and Link the Customer Account to the  Household Account
    public static void createHouseHoldAccountAndLinkCustomerToHoushold(Account custAccObj){
        try{
            
            Account houseHoldAccObj = new Account();
            houseHoldAccObj.Name = custAccObj.Name +' Household';
            //insert houseHoldAccObj;
        }catch(Exception e){
            System.debug('Exception in createHouseHoldAccountAndLinkCustomerToHoushold'+e); 
            System.debug('Line NO>>> '+e.getLineNumber());
        }
    }
    
    
    //Following class is used as a wrapper class
    public class InitiateSubmissionWrapper{
        @AuraEnabled 
        public List<Account> accList;
        @AuraEnabled 
        public List<Opportunity> oppList;
        @AuraEnabled 
        public List<Contact> conList;
        @AuraEnabled  
       // public List<Schema.Location> locList;
        public List<Location__c> locList;
       // public InitiateSubmissionWrapper(List<Account> accList, List<Opportunity> oppList, List<Contact> conList,List<Schema.Location> locList){
         public InitiateSubmissionWrapper(List<Account> accList, List<Opportunity> oppList, List<Contact> conList,List<Location__c> locList){
            this.accList = accList;
            this.oppList = oppList;
            this.conList = conList;
            this.locList = locList;
        }
        
    }
    public class validationWrapper {
        @AuraEnabled public boolean isError;
        @AuraEnabled public List<String> errorMsgList;
        
    }
}