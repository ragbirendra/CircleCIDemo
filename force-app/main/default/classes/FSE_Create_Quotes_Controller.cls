/*
<!--
- @author  Coforge POC  
- @date    27 OCT 2022
- @group 
-
- @description
- This is use to Create the Quotes as LWC Controller
- @log
- =======================================================================================
- Date            Developer                               Description       
- =======================================================================================
- 27 OCT 2022     Amit Behere                            Initial Creation 
-->
*/
public class FSE_Create_Quotes_Controller {
    
    
    //This Method is used to Create Quotes for the given Opportunity.
    @AuraEnabled 
    public static Quotes__c createQuotes(String opprtunityId){
        try{
            List<Opportunity> oppDetailList = [SELECT Id, BRM_Agency_Account__c,Insurance_Type__c FROM Opportunity WHERE Id =: opprtunityId ];
            Quotes__c quoteObj = new Quotes__c();
            quoteObj.Opportunity__c = opprtunityId;
            quoteObj.BRM_Agency_Account__c = oppDetailList[0].BRM_Agency_Account__c;
            quoteObj.Insurance_Type__c = oppDetailList[0].Insurance_Type__c;
            quoteObj.BRM_Premium_Amount__c = Integer.valueof((Math.random() * 200000));
            insert quoteObj;
            
            return quoteObj;
        }catch(Exception e){
            System.debug('Exception '+e);
            return null;
        }
    }
    
}