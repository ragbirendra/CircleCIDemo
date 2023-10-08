public class BR_FileUploaderClass {
    
    public static validationWrapper wrapper;
    public static List<Opportunity> lstOppToInsert;
    public static List<Account> lstAccToInsert;
    public static List<InsurancePolicy> lstInsuPolicyToInsert;
    public static List<Quotes__c> lstQuoteToInsert;
    public static List<Claim> lstClaimToInsert;
    public static List<Contact> lstContactToInsert;
    
    
    public static void validateOpportunityRecord(List<String> csvRowData,integer index){
        
        Opportunity opp = new Opportunity();
        wrapper.isError = false;
        opp.RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('General').getRecordTypeId();
        try{
            system.debug('Test---2');
            opp.AccountId = [Select Id from Account where name =:csvRowData[0] limit 1].Id;   
        }catch(Exception ex){
            
            wrapper.isError = true;
            String msg ='Row ('+index+') : Policy Holder Account ('+ csvRowData[0] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
        }
        try{
            opp.CloseDate              = !String.isEmpty(csvRowData[6]) ? Date.valueOf(csvRowData[6]): Null;
            opp.BRM_Expiration_Date__c = !String.isEmpty(csvRowData[7]) ? Date.valueOf(csvRowData[7]): Null;
            opp.BRM_Needed_By_Date__c  = !String.isEmpty(csvRowData[8]) ? Date.valueOf(csvRowData[8]): Null;
            opp.BRM_Effective_Date__c  = !String.isEmpty(csvRowData[9]) ? Date.valueOf(csvRowData[9]): Null;   
        }catch(Exception ex){
            
            wrapper.isError = true;
            String msg ='Row ('+index+') :Please Verify Close Date,Expiration Date,Needed By Date and Effective Date and format would be YYYY-MM-DD in CSV file'; 
            wrapper.errorMsgList.add(msg);
        }
        opp.Name = csvRowData[1];
        opp.Insurance_Type__c = csvRowData[2];
        opp.Description = csvRowData[3];
        opp.StageName = csvRowData[4];
        opp.Amount = Decimal.valueOf(!String.isEmpty(csvRowData[5]) ? csvRowData[5] : '0');
        
        opp.BRM_Renewal__c = Boolean.valueOf(csvRowData[10]);
        opp.BRM_Submission__c = csvRowData[11];
        opp.BRM_Premium__c = Decimal.valueOf(!String.isEmpty(csvRowData[12]) ? csvRowData[12] : '0');
        
        try{
            opp.BRM_Agency_Contact__c = [Select Id from Contact where lastname =:csvRowData[13] limit 1].Id;   
        }catch(Exception ex){
            
            wrapper.isError = true;
            String msg ='Row ('+index+') :Agency Contact ('+ csvRowData[13] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
        }
        
        try{
            opp.BRM_Agency_Account__c = [Select Id from Account where name =:csvRowData[14] limit 1].Id;  
        }catch(Exception ex){
           
            wrapper.isError = true;
            String msg ='Row ('+index+') :Agency Account ('+ csvRowData[14] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
        }
            Opp.OwnerId = UserInfo.getUserId(); //[select Id from User where name='Insurance Admin' limit 1].Id;  
       
        lstOppToInsert.add(opp);
       
    }
    public static void validatePHAccountRecord(List<String> csvRowData,integer index){
        
        wrapper.isError = false;
        Account acc = new Account();
        acc.RecordTypeId = '0125g000002GSLlAAO';//Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('FinServ.IndustriesIndividual').getRecordTypeId(); 
       
         try{
            acc.Name = csvRowData[0];
        }catch(Exception ex){
           
            wrapper.isError = true;
            String msg ='Row ('+index+') :Policy Holder Name should not be blank or Please contact to admin';
            wrapper.errorMsgList.add(msg);
        }
        
        acc.Rating = csvRowData[1];
        acc.BillingCity = csvRowData[2];
        acc.BillingState = csvRowData[3];
        acc.BillingStreet = csvRowData[4];
        acc.BillingPostalCode = csvRowData[5];
        acc.BillingCountry = csvRowData[6];
        acc.BRM_Status__c = csvRowData[7];
        
        if(!String.isEmpty(csvRowData[9]))
        acc.BRM_Preferred_Underwriter__c = csvRowData[9];
        
         try{
            acc.BRM_Termination_Date__c = !String.isEmpty(csvRowData[10]) ? Date.valueOf(csvRowData[10]): Null;
            acc.BRM_Appointment_Date__c = !String.isEmpty(csvRowData[11]) ? Date.valueOf(csvRowData[11]): Null; 
        }catch(Exception ex){
            
            wrapper.isError = true;
            String msg ='Row ('+index+') :Please Verify Termination Date and Appointment Date and format would be YYYY-MM-DD in CSV file'; 
            wrapper.errorMsgList.add(msg);
        }
       
        acc.BRM_Agency_Code__c = csvRowData[12];
        acc.BRM_Account_Number__c = csvRowData[13];
        
        try{
            acc.BRM_Agency__c = [Select Id from Account where name =:csvRowData[14] limit 1].Id; 
        }catch(Exception ex){
           
            wrapper.isError = true;
            String msg ='Row ('+index+') :Agency Account ('+ csvRowData[14] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
        }
        
        try{
            acc.BRM_Agency_Contact__c = [Select Id from Contact where lastname =:csvRowData[15] limit 1].Id;  
        }catch(Exception ex){
            
            wrapper.isError = true;
            String msg ='Row ('+index+') :Agency Contact ('+ csvRowData[15] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
        }
        acc.BRM_Primary_Email__c = csvRowData[16];
        acc.BRM_Mobile_Phone__c = csvRowData[17];
        
        acc.BRM_Year_In_Bus__c =  Decimal.valueOf(!String.isEmpty(csvRowData[18]) ? csvRowData[18] : '0');
        acc.BRM_Number_Of_Employee__c =  Decimal.valueOf(!String.isEmpty(csvRowData[8]) ? csvRowData[8] : '0');
        
        acc.Email__c = csvRowData[19];
        acc.Fax = csvRowData[20];
        acc.Website = csvRowData[21];
        acc.Industry = csvRowData[22];
        acc.Active__c = csvRowData[23];
        acc.OwnerId = UserInfo.getUserId();
        
        lstAccToInsert.add(acc);
    }
    public static void validateInsurancePolicyRecord(List<String> csvRowData,integer index){
        wrapper.isError = false;
        InsurancePolicy inPcy = new InsurancePolicy();
        //inPcy.RecordTypeId = Schema.getGlobalDescribe().get('InsurancePolicy').getDescribe().getRecordTypeInfosByName().get('General').getRecordTypeId();
         inPcy.UniversalPolicyNumber = csvRowData[0];
         inPcy.AuditTerm = csvRowData[1];  
          try{
            inPcy.BRM_Agency_Account__c = [Select Id from Account where name =:csvRowData[2] limit 1].Id; 
         }catch(Exception ex){
           
            wrapper.isError = true;
            String msg ='Row ('+index+') :Agency Account ('+ csvRowData[14] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
         }
         inPcy.CancellationDate = !String.isEmpty(csvRowData[3]) ? Date.valueOf(csvRowData[3]): Null;
         inPcy.CancellationReason = csvRowData[4];
         inPcy.CancellationReasonType = csvRowData[5];
         inPcy.CashSurrenderValue =  Decimal.valueOf(!String.isEmpty(csvRowData[6]) ? csvRowData[6] : '0');
         inPcy.ChangeSubtype = csvRowData[7]; 
         inPcy.ChangeType = csvRowData[8]; 
         inPcy.ContractGroupPlanId = !String.isEmpty(csvRowData[9]) ? csvRowData[9]: Null;
         
         inPcy.Discount =  Decimal.valueOf(!String.isEmpty(csvRowData[11]) ? csvRowData[11] : '0');
        
         inPcy.GrossWrittenPremium =  Decimal.valueOf(!String.isEmpty(csvRowData[15]) ? csvRowData[15] : '0');
         inPcy.HasAnyAutoCoverage = Boolean.valueOf(!String.isEmpty(csvRowData[16]) ? csvRowData[16] : '0');
         inPcy.IsLoanEligibile = Boolean.valueOf(!String.isEmpty(csvRowData[17]) ? csvRowData[17] : '0');
         inPcy.IsRenewedPolicy = Boolean.valueOf(!String.isEmpty(csvRowData[18]) ? csvRowData[18] : '0');
        
         try{
               inPcy.DateRenewed = !String.isEmpty(csvRowData[10]) ? Date.valueOf(csvRowData[10]): Null; 
               inPcy.EffectiveDate = !String.isEmpty(csvRowData[12]) ? Date.valueOf(csvRowData[12]): Null; 
               inPcy.ExpirationDate = !String.isEmpty(csvRowData[13]) ? Date.valueOf(csvRowData[13]): Null;
               inPcy.FinalRenewalDate = !String.isEmpty(csvRowData[14]) ? Date.valueOf(csvRowData[14]): Null;
               inPcy.OriginalEffectiveDate = !String.isEmpty(csvRowData[21]) ? Date.valueOf(csvRowData[21]): Null;
               inPcy.OriginalExpirationDate = !String.isEmpty(csvRowData[22]) ? Date.valueOf(csvRowData[22]): Null;
               inPcy.PaidToDate = !String.isEmpty(csvRowData[25]) ? Date.valueOf(csvRowData[25]): Null;
               inPcy.PaymentDueDate = !String.isEmpty(csvRowData[27]) ? Date.valueOf(csvRowData[27]): Null;
        }catch(Exception ex){
            
            wrapper.isError = true;
            String msg ='Row ('+index+') :Please Verify Date format, It would be YYYY-MM-DD in CSV file'; 
            wrapper.errorMsgList.add(msg);
        }
         inPcy.Name = csvRowData[19];
         inPcy.NameInsuredId =  [Select Id from Account where name =:csvRowData[20] limit 1].Id;
         
         inPcy.OriginalPolicyId = !String.isEmpty(csvRowData[23]) ? csvRowData[23]: Null;
         inPcy.OwnerId =  UserInfo.getUserId();//csvRowData[24]; 
         
         inPcy.ParentPolicyId = !String.isEmpty(csvRowData[26]) ? csvRowData[26]: Null;
         
         inPcy.PlanTier = csvRowData[28];
         inPcy.PlanType = csvRowData[29];
         inPcy.PolicyDescription = csvRowData[30];
         inPcy.PolicyName = csvRowData[31]; 
         inPcy.PolicyTerm = csvRowData[32];
         inPcy.PolicyType = csvRowData[33];
         inPcy.PremiumAmount =  Decimal.valueOf(!String.isEmpty(csvRowData[34]) ? csvRowData[34] : '0'); 
         inPcy.PremiumCalculationMethod = csvRowData[35]; 
         inPcy.PremiumFrequency = csvRowData[36]; 
         inPcy.PremiumPaymentType = csvRowData[37];
         inPcy.PreviousPremium =  Decimal.valueOf(!String.isEmpty(csvRowData[38]) ? csvRowData[38] : '0');
         inPcy.PreviousRenewalDate =!String.isEmpty(csvRowData[39]) ? Date.valueOf(csvRowData[39]): Null; 
         inPcy.PriorPolicyId = !String.isEmpty(csvRowData[40]) ? csvRowData[40]: Null;
         //inPcy.ProducerId =  UserInfo.getUserId();//csvRowData[41]; 
         
         try{
            inPcy.ProductId = [Select Id from Product2 where Name =:csvRowData[42] Limit 1].Id;//csvRowData[42];
         }catch(Exception ex){
           
            wrapper.isError = true;
            String msg ='Row ('+index+') :Product Name ('+ csvRowData[14] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
         }
         try{
            inPcy.Quotes__c = [Select Id from Quotes__c where Name =:csvRowData[43] Limit 1].Id;//csvRowData[43]; 
         }catch(Exception ex){
           
            wrapper.isError = true;
            String msg ='Row ('+index+') :Quote name ('+ csvRowData[14] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
         }
         
         inPcy.ReferencePolicyNumber = csvRowData[44];
         inPcy.RenewalChannel = csvRowData[45];
         inPcy.RenewalDate = !String.isEmpty(csvRowData[46]) ? Date.valueOf(csvRowData[46]): Null; 
         inPcy.RenewedFromPolicyId = !String.isEmpty(csvRowData[47]) ? csvRowData[47]: Null;
         inPcy.SaleDate = !String.isEmpty(csvRowData[48]) ? Date.valueOf(csvRowData[48]): Null;
         
         inPcy.ServicingOfficeCity = csvRowData[49];
         inPcy.ServicingOfficeCountry = csvRowData[50];
         inPcy.ServicingOfficeGeocodeAccuracy = csvRowData[51]; 
         inPcy.ServicingOfficeLatitude =  Decimal.valueOf(!String.isEmpty(csvRowData[52]) ? csvRowData[52] : '0');
         inPcy.ServicingOfficeLongitude =  Decimal.valueOf(!String.isEmpty(csvRowData[53]) ? csvRowData[53] : '0'); 
         inPcy.ServicingOfficePostalCode = csvRowData[54];
         inPcy.ServicingOfficeState = csvRowData[55];
         inPcy.ServicingOfficeStreet = csvRowData[56]; 
         inPcy.SourceOpportunityId = !String.isEmpty(csvRowData[57]) ? csvRowData[57]: Null;
         inPcy.SourceSystem = csvRowData[58]; 
         inPcy.SourceSystemIdentifier = csvRowData[59];
         inPcy.StandardFeeAmount =  Decimal.valueOf(!String.isEmpty(csvRowData[60]) ? csvRowData[60] : '0'); 
         inPcy.StandardPremiumAmount =  Decimal.valueOf(!String.isEmpty(csvRowData[61]) ? csvRowData[61] : '0');
         inPcy.StandardTaxAmount =  Decimal.valueOf(!String.isEmpty(csvRowData[62]) ? csvRowData[62] : '0');
         inPcy.Status = csvRowData[63]; 
         inPcy.Substatus = csvRowData[64]; 
         inPcy.TaxesSurcharges =  Decimal.valueOf(!String.isEmpty(csvRowData[65]) ? csvRowData[65] : '0'); 
         inPcy.TermFeeAmount =  Decimal.valueOf(!String.isEmpty(csvRowData[66]) ? csvRowData[66] : '0');
         inPcy.TermPremiumAmount =  Decimal.valueOf(!String.isEmpty(csvRowData[67]) ? csvRowData[67] : '0');
         inPcy.TermTaxAmount = Decimal.valueOf(!String.isEmpty(csvRowData[68]) ? csvRowData[68] : '0'); 
         inPcy.TotalCommissionAmount =  Decimal.valueOf(!String.isEmpty(csvRowData[69]) ? csvRowData[69] : '0'); 
        
         inPcy.TotalSumInsured =  Decimal.valueOf(!String.isEmpty(csvRowData[70]) ? csvRowData[70] : '0');
         //inPcy.UnderwritingEntityId = !String.isEmpty(csvRowData[71]) ? csvRowData[71]: Null;
         
        lstInsuPolicyToInsert.add(inPcy);
         
    }
    public static void validateQuoteRecord(List<String> csvRowData,integer index){
        
        wrapper.isError = false;
        Quotes__c quote = new Quotes__c();
        try{
            quote.BRM_Agency_Account__c = [Select Id from Account where name =:csvRowData[0] limit 1].Id; 
         }catch(Exception ex){
           
            wrapper.isError = true;
            String msg ='Row ('+index+') :Agency Account ('+ csvRowData[14] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
         }
        quote.BRM_Premium_Amount__c = Decimal.valueOf(!String.isEmpty(csvRowData[1]) ? csvRowData[1] : '0');
        quote.BRM_Status__c= csvRowData[2];
        quote.Insurance_Type__c= csvRowData[3];
        
        try{
            quote.Opportunity__c = [Select Id from Opportunity where name =:csvRowData[4] limit 1].Id; 
         }catch(Exception ex){
           
            wrapper.isError = true;
            String msg ='Row ('+index+') :Opportunity ('+ csvRowData[14] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
         }
        quote.OwnerId= UserInfo.getUserId();
        lstQuoteToInsert.add(quote);
    }
    public static void validateClaimRecord(List<String> csvRowData,integer index){
        
         wrapper.isError = false;
         Claim clm = new Claim();
         
         clm.Name = csvRowData[0];
          try{
            clm.AccountId = [Select Id from Account where name =:csvRowData[1] limit 1].Id; 
         }catch(Exception ex){
           
            wrapper.isError = true;
            String msg ='Row ('+index+') :Policy Account -('+ csvRowData[1] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
         }
         clm.Severity = csvRowData[2]; 
         clm.EstimatedAmount =  Decimal.valueOf(!String.isEmpty(csvRowData[3]) ? csvRowData[3] : '0');
         clm.ActualAmount =  Decimal.valueOf(!String.isEmpty(csvRowData[4]) ? csvRowData[4] : '0');
         clm.ApprovedAmount =  Decimal.valueOf(!String.isEmpty(csvRowData[5]) ? csvRowData[5] : '0'); 
         clm.Expenses__c =  Decimal.valueOf(!String.isEmpty(csvRowData[6]) ? csvRowData[6] : '0'); 
         clm.FinalizedDate = !String.isEmpty(csvRowData[7]) ? Date.valueOf(csvRowData[7]): Null;
  
         try{
            clm.PolicyNumberId = [Select Id from InsurancePolicy where name =:csvRowData[8] limit 1].Id; 
         }catch(Exception ex){
           
            wrapper.isError = true;
            String msg ='Row ('+index+') :Policy Number- ('+ csvRowData[8] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
         }
          try{
            clm.Agency_Account__c = [Select Id from Account where name =:csvRowData[9] limit 1].Id; 
         }catch(Exception ex){
           
            wrapper.isError = true;
            String msg ='Row ('+index+') :Agency Account -('+ csvRowData[9] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
         }
         clm.ClaimType = csvRowData[10]; 
         clm.LossType = csvRowData[11]; 
         clm.InitiationDate = !String.isEmpty(csvRowData[12]) ? Date.valueOf(csvRowData[12]): Null;
         clm.AssessmentDate = !String.isEmpty(csvRowData[13]) ? Date.valueOf(csvRowData[13]): Null;
         clm.Status = csvRowData[14];
         clm.ClaimReason = csvRowData[15];
        lstClaimToInsert.add(clm);
    }
    public static void validateContactRecord(List<String> csvRowData,integer index){
        //lstContactToInsert 
        wrapper.isError = false;
        Contact con = new Contact();
        con.FirstName = csvRowData[0];
        con.LastName = csvRowData[1];
        con.BRM_Primary_Email__c = csvRowData[2];
        con.BRM_Mobile_Phone__c = csvRowData[3];
        con.HomePhone = csvRowData[4];
        try{
            con.AccountId = [Select Id from Account where name =:csvRowData[5] limit 1].Id; 
         }catch(Exception ex){
           
            wrapper.isError = true;
            String msg ='Row ('+index+') : Account -('+ csvRowData[5] +') is missing from System or Please contact to admin';
            wrapper.errorMsgList.add(msg);
         }
        con.BRM_Multi_Role__c = csvRowData[6];
        lstContactToInsert.add(con);
    }
    
    
    @AuraEnabled
    public static validationWrapper validateRecordForUpload(String base64Data,String fileName){
        System.debug('fileName-------------->'+fileName);
        Boolean isValidFile = false;
        wrapper = new validationWrapper();
        wrapper.errorMsgList = new List<String>();
        boolean isValid =false;
        String data    = JSON.deserializeUntyped(base64Data).toString();
        
        lstOppToInsert = new list<Opportunity>();
        lstInsuPolicyToInsert =new List<InsurancePolicy>();
        lstAccToInsert = new List<Account>();
        lstQuoteToInsert = new List<Quotes__c>();
        lstClaimToInsert = new List<Claim>();
        lstContactToInsert =new List<Contact>();
        list<String> lstCSVLines = data.split('\n');
        for(Integer i = 1; i < lstCSVLines.size(); i++){
            
            String csvLine = lstCSVLines[i];
            String prevLine = csvLine;
            Integer startIndex;
            Integer endIndex;
            
            while(csvLine.indexOf('"') > -1){
                
                if(startIndex == null){
                    startIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
                }else{
                    if(endIndex == null){
                        endIndex = csvLine.indexOf('"');
                        csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                    }
                }
                
                if(startIndex != null && endIndex != null){
                    String sub = csvLine.substring(startIndex, endIndex);
                    sub = sub.replaceAll(',', ':comma:');
                    csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                    startIndex = null;
                    endIndex = null;
                }
            }
            
            List<String> csvRowData = new List<String>();
            for(String column : csvLine.split(',')){
                column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                csvRowData.add(column);
                
            }
            system.debug('lstOppToInsert::Before:::'+lstOppToInsert.size());
            if(fileName.containsIgnoreCase('Submission'))
               validateOpportunityRecord(csvRowData,i); 
            if(fileName.containsIgnoreCase('Account'))
                validatePHAccountRecord(csvRowData,i);
            if(fileName.containsIgnoreCase('Policy'))
                validateInsurancePolicyRecord(csvRowData,i);
            if(fileName.containsIgnoreCase('Quote'))
                validateQuoteRecord(csvRowData,i);
            if(fileName.containsIgnoreCase('Claim'))
                validateClaimRecord(csvRowData,i);
            if(fileName.containsIgnoreCase('Contact'))
                validateContactRecord(csvRowData,i);
        }
        wrapper.isError=false;
        system.debug('lstOppToInsert:::::'+lstOppToInsert.size());
        try{
        if(!wrapper.isError && lstOppToInsert.size()>0) {
            isValidFile = true;
            system.debug('Test---1.1');
            insert lstOppToInsert;
            List<String> oppNameList = new List<String>();
            for(Opportunity opp:lstOppToInsert)oppNameList.add(opp.Name);
            wrapper.objectName ='Opportunity';
            wrapper.recordList = [Select AccountId,Name,Insurance_Type__c,Description,StageName,Amount,CloseDate,BRM_Expiration_Date__c,BRM_Needed_By_Date__c,BRM_Effective_Date__c,BRM_Renewal__c,BRM_Submission__c,BRM_Premium__c,BRM_Agency_Contact__c,BRM_Agency_Account__c From Opportunity Where Name IN:oppNameList];
        }
               
           if(!wrapper.isError && lstAccToInsert.size()>0) 
           {
             isValidFile = true;
             system.debug('Test---1.2');
             insert lstAccToInsert; 
             List<String> accNameList = new List<String>();
             for(Account acc:lstAccToInsert)accNameList.add(acc.Name);
             wrapper.objectName ='Account';
             wrapper.recordList = [Select Name,Rating,BillingCity,BillingState,BillingStreet,BillingPostalCode,BillingCountry,BRM_Status__c,BRM_Number_Of_Employee__c,BRM_Preferred_Underwriter__c,BRM_Termination_Date__c,BRM_Appointment_Date__c,BRM_Agency_Code__c,BRM_Account_Number__c,BRM_Agency__c,BRM_Agency_Contact__c,BRM_Primary_Email__c,BRM_Mobile_Phone__c,BRM_Year_In_Bus__c,Email__c,Fax,Website,Industry,Active__c from Account where Name IN:accNameList];
           }
           if(!wrapper.isError && lstInsuPolicyToInsert.size()>0)
           {
             system.debug('Test---1.3');
             isValidFile = true;
             insert lstInsuPolicyToInsert;
             List<String> inPoNameList = new List<String>();
             for(InsurancePolicy inPo:lstInsuPolicyToInsert)inPoNameList.add(inPo.Name);
             wrapper.objectName ='InsurancePolicy';
             wrapper.recordList = [Select BRM_Agency_Account__c,EffectiveDate,ExpirationDate,HasAnyAutoCoverage,IsActive,IsLoanEligibile,IsRenewedPolicy,LastReferencedDate,LastViewedDate,Name,NameInsuredId,OwnerId,PolicyType,PremiumAmount,ProducerId,ProductId,Quotes__c,Status,Substatus,TotalStandardAmount from InsurancePolicy where Name IN:inPoNameList];
           } 
            if(!wrapper.isError && lstQuoteToInsert.size()>0)
           {
             system.debug('Test---1.4');
             isValidFile = true;
             insert lstQuoteToInsert;
             List<String> quoteNameList = new List<String>();
               for(Quotes__c qtes:lstQuoteToInsert)quoteNameList.add(qtes.Name);
             wrapper.objectName ='Quotes__c';
             wrapper.recordList = [Select Name,BRM_Agency_Account__c,BRM_Premium_Amount__c,BRM_Status__c,Insurance_Type__c,Opportunity__c,OwnerId from Quotes__c where CreatedDate>=:Date.TODAY()];
           } 
            if(!wrapper.isError && lstClaimToInsert.size()>0)
           {
             system.debug('Test---1.5');
             isValidFile = true;
             insert lstClaimToInsert;
             List<String> claimNameList = new List<String>();
             for(Claim clm:lstClaimToInsert)claimNameList.add(clm.Name);
             wrapper.objectName ='Claim';
             wrapper.recordList = [Select Name,AccountId,Severity,EstimatedAmount,ActualAmount,ApprovedAmount,Expenses__c,FinalizedDate,PolicyNumberId,Agency_Account__c,ClaimType,LossType,InitiationDate,AssessmentDate,Status,ClaimReason from Claim  where Name IN:claimNameList];
           }
            if(!wrapper.isError && lstContactToInsert.size()>0)
           {
             system.debug('Test---1.6');
             isValidFile = true;
             insert lstContactToInsert;
             List<String> conNameList = new List<String>();
               for(Contact con:lstContactToInsert)conNameList.add(con.LastName);
             wrapper.objectName ='Contact';
             wrapper.recordList = [Select Name,BRM_Primary_Email__c,BRM_Mobile_Phone__c,HomePhone,AccountId,BRM_Multi_Role__c from Contact where LastName IN:conNameList];
           } 
           if(!isValidFile){
            wrapper.isError = true;
            String msgLine1 ='Please Upload Valid file-';
            String msgLine2 ='Example: For Claim Record Upload -> XXXXClaimXXXX.csv , File name should contain claim.';
            String msgLine3 ='';
            wrapper.errorMsgList.add(msgLine1); 
            wrapper.errorMsgList.add(msgLine2);  
           }
        }Catch(Exception ex){
            wrapper.isError = true;
            String msg ='Insert Exception:::'+ex.getMessage();
            wrapper.errorMsgList.add(msg);
        }
        
        return wrapper;
    }
    
     public class validationWrapper {
        @AuraEnabled public boolean isError;
        @AuraEnabled public List<String> errorMsgList;
        @AuraEnabled public List<sObject> recordList;
        @AuraEnabled public String objectName;
        
    }
    
   /* @AuraEnabled
    public static List<Opportunity> saveFile(String base64Data) {
        
        String data = JSON.deserializeUntyped(base64Data).toString();
        list<Opportunity> lstCCToInsert = new list<Opportunity>();
        list<String> lstCSVLines = data.split('\n');
        List<String> oppNameList  = new List<String>();
        for(Integer i = 1; i < lstCSVLines.size(); i++){
            Opportunity opp = new Opportunity();
            String csvLine = lstCSVLines[i];
            String prevLine = csvLine;
            Integer startIndex;
            Integer endIndex;
            
            while(csvLine.indexOf('"') > -1){
                
                if(startIndex == null){
                    startIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
                }else{
                    if(endIndex == null){
                        endIndex = csvLine.indexOf('"');
                        csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                    }
                }
                
                if(startIndex != null && endIndex != null){
                    String sub = csvLine.substring(startIndex, endIndex);
                    sub = sub.replaceAll(',', ':comma:');
                    csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                    startIndex = null;
                    endIndex = null;
                }
            } 
            List<String> csvRowData = new List<String>();
            for(String column : csvLine.split(',')){
                column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                csvRowData.add(column);
            }
            
            opp.RecordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('General').getRecordTypeId();
            opp.AccountId = [Select Id from Account where name =:csvRowData[0] limit 1].Id;
            opp.Name = csvRowData[1];
            oppNameList.add(opp.Name);
            opp.Insurance_Type__c = csvRowData[2];
            opp.Description = csvRowData[3];
            opp.StageName = csvRowData[4];
            opp.Amount = Decimal.valueOf(!String.isEmpty(csvRowData[5]) ? csvRowData[5] : '0');
            opp.CloseDate = Date.valueOf(!String.isEmpty(csvRowData[6]) ? csvRowData[6] : '');
            opp.BRM_Expiration_Date__c = Date.valueOf(!String.isEmpty(csvRowData[7]) ? csvRowData[7] : ''); 
            opp.BRM_Needed_By_Date__c = Date.valueOf(!String.isEmpty(csvRowData[8]) ? csvRowData[8] : '');
            opp.BRM_Effective_Date__c = Date.valueOf(!String.isEmpty(csvRowData[9]) ? csvRowData[9] : '');
            opp.BRM_Renewal__c = Boolean.valueOf(csvRowData[10]);
            opp.BRM_Submission__c = csvRowData[11];
            opp.BRM_Premium__c = Decimal.valueOf(!String.isEmpty(csvRowData[12]) ? csvRowData[12] : '0');
            opp.BRM_Agency_Contact__c =[Select Id from Contact where lastname =:csvRowData[13] limit 1].Id;
            opp.BRM_Agency_Account__c = [Select Id from Account where name =:csvRowData[14] limit 1].Id;
            Opp.OwnerId = UserInfo.getUserId();//[select Id from User where name='Insurance Admin'].Id;
            
            lstCCToInsert.add(opp);
        }
        
        insert lstCCToInsert;
        
        return [Select AccountId,Name,Insurance_Type__c,Description,StageName,Amount,CloseDate,BRM_Expiration_Date__c,BRM_Needed_By_Date__c,BRM_Effective_Date__c,BRM_Renewal__c,BRM_Submission__c,BRM_Premium__c,BRM_Agency_Contact__c,BRM_Agency_Account__c From Opportunity Where Name IN:oppNameList];
    }*/
    
    
   
    
}