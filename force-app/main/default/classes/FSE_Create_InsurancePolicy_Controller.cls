/*
<!--
- @author  Coforge POC  
- @date    27 OCT 2022
- @group 
-
- @description
- This is use to Create the Insurance Policy as LWC Controller
- @log
- =======================================================================================
- Date            Developer                               Description       
- =======================================================================================
- 27 OCT 2022     Amit Behere                            Initial Creation 
-->
*/
public class FSE_Create_InsurancePolicy_Controller {
        public static String finiacialAccInsuranceRecType = Schema.SObjectType.FinServ__FinancialAccount__c.getRecordTypeInfosByDeveloperName().get('InsurancePolicy').getRecordTypeId();

     //This Method is used to Create Insurance Policy for the given Quotes.
    @AuraEnabled 
    public static InsurancePolicy createInsurancePolicy(String quoteId){
        try{
            List<Quotes__c> quotesList = [SELECT Id, BRM_Premium_Amount__c,Insurance_Type__c, Opportunity__c, Opportunity__r.Account.Name,  Opportunity__r.BRM_Agency_Contact__c, Opportunity__r.BRM_Effective_Date__c,Opportunity__r.BRM_Expiration_Date__c, Opportunity__r.BRM_Agency_Contact__r.Name,Opportunity__r.BRM_Agency_Account__c,Opportunity__r.BRM_Agency_Account__r.Name, BRM_Agency_Account__c, Opportunity__r.AccountId,Opportunity__r.CloseDate FROM Quotes__c WHERE Id =: quoteId ];
			
			
            
            Producer producerObj = linkInsurancPolicyToAgencyAccountUsingProducer(quotesList);
			
			List<Product2> prodIns = [Select id,Name FROM Product2 WHERE Name =: quotesList[0].Insurance_Type__c];
			List<String> frequency = new List<String>{'Monthly','Quarterly','Semi Annual(twice a year)','Annually'};
            
            InsurancePolicy insurancPolicyObj = new InsurancePolicy();
            insurancPolicyObj.Quotes__c = quoteId;
            insurancPolicyObj.NameInsuredId = quotesList[0].Opportunity__r.AccountId;
            insurancPolicyObj.Name = 'BRM-Quote-Policy-'+Integer.valueof((Math.random() * 100));
            insurancPolicyObj.PremiumAmount = quotesList[0].BRM_Premium_Amount__c;
            insurancPolicyObj.EffectiveDate = quotesList[0].Opportunity__r.BRM_Effective_Date__c;
            insurancPolicyObj.ExpirationDate = quotesList[0].Opportunity__r.BRM_Expiration_Date__c;

            insurancPolicyObj.ProducerId = producerObj.Id;
            insurancPolicyObj.BRM_Agency_Account__c = quotesList[0].Opportunity__r.BRM_Agency_Account__c;
            insurancPolicyObj.PolicyType = quotesList[0].Insurance_Type__c;
			insurancPolicyObj.PolicyTerm = 'Annual';
			insurancPolicyObj.SourceOpportunityId = quotesList[0].Opportunity__c;
			
			insurancPolicyObj.PolicyName = quotesList[0].Insurance_Type__c + ' Policy';
			insurancPolicyObj.ProductId = prodIns[0].Id;
			insurancPolicyObj.Status = 'Offered';
			insurancPolicyObj.Substatus = 'Final';
			insurancPolicyObj.SaleDate = quotesList[0].Opportunity__r.CloseDate;
			insurancPolicyObj.PlanTier = (quotesList[0].BRM_Premium_Amount__c > 0 && quotesList[0].BRM_Premium_Amount__c < 100000) ? 'Bronze' : (quotesList[0].BRM_Premium_Amount__c >= 100000 && quotesList[0].BRM_Premium_Amount__c < 200000)?'Silver' : (quotesList[0].BRM_Premium_Amount__c >= 200000 && quotesList[0].BRM_Premium_Amount__c < 500000)?'Gold':'Platinum';
			
			//Generate Frequency
			insurancPolicyObj.PremiumFrequency = frequency.get(Integer.valueof((Math.random() * 4)));   
			insurancPolicyObj.AuditTerm = frequency.get(Integer.valueof((Math.random() * 4)));
            
            //Temporarily add Agent contact on Policy needs to be remove quotesList[0].Opportunity__r.BRM_Agency_Contact__c
			insurancPolicyObj.Agency_Contact__c = quotesList[0].Opportunity__r.BRM_Agency_Contact__c;
			
			//Agency_Contact__c = Producer.Contact.Name
            
            Date myDate = Date.today();
            insurancPolicyObj.ExpirationDate = myDate.addYears(1);
            insert insurancPolicyObj;
            
            updateStatusOnAccount(insurancPolicyObj.NameInsuredId);
            createFinancialAccount(insurancPolicyObj,quotesList[0].Opportunity__r.Account.Name);
            updateOpportunity(quotesList[0].Opportunity__c);
            return insurancPolicyObj;
        }catch(Exception e){
            System.debug('Exception in createInsurancePolicy'+e);
                  System.debug('Line NO>>> '+e.getLineNumber());
            return null;
        }
    }
    
    
    //Update the on Customer Account to set the status value to Policy Holder
    public static void updateStatusOnAccount(String accId){
        try{
            Account accObj = new Account();
            accObj.Id = accId;
            accObj.BRM_Status__c = 'Policy Holder';
            update accObj;
         }catch(Exception e){
            System.debug('Exception in updateStatusOnAccount'+e); 
                   System.debug('Line NO>>> '+e.getLineNumber());
        }
    }
    
    
   
    //Link Insuranc Policy To Agency Account Using Producer Lookup on Insurance Policy
    public static Producer linkInsurancPolicyToAgencyAccountUsingProducer(List<Quotes__c> quotesList){
        try{
            //List<Opportunity> oopList = [SELECT Id,BRM_Agency_Contact__c,BRM_Agency_Contact__r.Name FROM Opportunity WHERE Id =: quotesList[0].Opportunity__c];
			List<Producer> prodIns = [Select id, ContactId From Producer WHERE ContactId =: quotesList[0].Opportunity__r.BRM_Agency_Account__c];
            Producer producerObj  = new Producer();
            if(prodIns!=null && prodIns.size()>0){
                producerObj = prodIns[0];  
            }else{
                
                producerObj.Name = 'Producer '+quotesList[0].Opportunity__r.BRM_Agency_Contact__r.Name;
                producerObj.AccountId = quotesList[0].Opportunity__r.BRM_Agency_Account__c ; //Put Agency Account
                producerObj.ContactId = quotesList[0].Opportunity__r.BRM_Agency_Contact__c;
                // producerObj.InternalUserId = UserInfo.getUserId();   //Put Agency Broker Contact as Internal User we are taking as login user who is creating the policy

                insert producerObj;
            }
            return producerObj;
        }catch(Exception e){
            System.debug('Exception in createHouseHoldAccountAndLinkCustomerToHoushold'+e); 
            System.debug('Line NO>>> '+e.getLineNumber());
            return null;
        }
    }
    
    //Create Financial Account
      public static void createFinancialAccount(InsurancePolicy custInsurancePolicy, String custAccName){
        try{
            FinServ__FinancialAccount__c financialObj = new FinServ__FinancialAccount__c();
            financialObj.Name = custAccName+'-Financial';
            financialObj.RecordTypeId = finiacialAccInsuranceRecType;
            financialObj.FinServ__PrimaryOwner__c = custInsurancePolicy.NameInsuredId;
            financialObj.FinServ__Status__c = 'Open';
            financialObj.FinServ__PolicyTerm__c = '1 Year';
            financialObj.FinServ__FinancialAccountType__c = 'Fixed Annuity';
            financialObj.FinServ__Premium__c = custInsurancePolicy.PremiumAmount;
            financialObj.FinServ__Ownership__c = 'Individual';
            financialObj.FinServ__InsurancePolicy__c = custInsurancePolicy.Id;
            financialObj.FinServ__InsuredAmount__c = custInsurancePolicy.PremiumAmount > 100? custInsurancePolicy.PremiumAmount-100: custInsurancePolicy.PremiumAmount - 50;
           
            insert financialObj;
        }catch(Exception e){
            System.debug('Exception in createFinancialAccount'+e); 
            System.debug('Line NO>>> '+e.getLineNumber());
             
        }
    }
	
	//Close Submission once policy is generated
    public static void updateOpportunity(String oppId){
        try{
            Opportunity oppObj = new Opportunity();
            oppObj.Id = oppId;
            oppObj.StageName = 'Closed Won';
            update oppObj;
         }catch(Exception e){
            System.debug('Exception in updateStatusOnAccount'+e); 
                   System.debug('Line NO>>> '+e.getLineNumber());
        }
    }
    
}