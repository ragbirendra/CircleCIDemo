//Batch class inorder to update Current year Target Records with Monthly Achieved Policy Counts and Monthly Achieved Policy Premium Amounts
global class UpdateAcheivedPlcyContWithPreMAmtBtch implements Database.Batchable<sObject>,Schedulable{
public Static Set<String> agencyLst;
public Static Set<String> agentLst;
public Static Map<String, Map<String,Integer>> contTargetDatesMap;
public Static Map<String,Map<String,Decimal>> contTargetDatesPremAmt;


global Database.QueryLocator start(Database.BatchableContext bc){
    // query which fetchs the current year Monthly Target records with Agency and Agent fields not equal to null
    String query = 'SELECT ID,CreatedDate,Insurance_Type__c,Agency__c,Agent__c,Start_Date__c,End_Date__c,Achievement_by_Count__c,Achievement_by_Premium__c FROM Target__c where Agency__c != null AND Agent__c != null AND Frequency__c = \'Monthly\' and createddate = This_Year';
    return Database.getQueryLocator(query);
}

global void execute(Database.BatchableContext bc,List<Target__c> scope){ 
    agencyLst =new Set<String>();
    agentLst = new Set<String>();
    contTargetDatesMap = new Map<String, Map<String,Integer>>();
    contTargetDatesPremAmt =  new Map<String,Map<String,Decimal>>();
    List<Target__c> targetsToUpdate = new List<Target__c>();
    try{
        //Loop to prepare list of Agent,Agency from processed Target records
        for(Target__c tarRec : scope){
            agentLst.add(tarRec.Agent__c);
            agencyLst.add(tarRec.Agency__c);
        }
        // Loop to Fetch the Insurance Policy Records related to the Agencys and Agents List refering to effective date
        for(InsurancePolicy insurPlcyRec : [SELECT id,BRM_Agency_Account__c,Agency_Contact__c,PremiumAmount,EffectiveDate from InsurancePolicy WHERE BRM_Agency_Account__c IN: agencyLst AND Agency_Contact__c IN: agentLst and EffectiveDate = This_Year ]){
            System.debug('>>>>Policy Effective Date'+insurPlcyRec.EffectiveDate);
            DateTime dt = insurPlcyRec.EffectiveDate;
             Datetime GMTDate = Datetime.newInstanceGmt(
                            dt.year(),
                            dt.month(),
                            dt.day(),
                            dt.hour(),
                            dt.minute(),
                            dt.second());
            Integer monthNum = GMTDate.Date().month();//default UTC Timezone
            System.debug('>>>>Policy Effective Month'+monthNum);
            //Unique key to Identify the Target Records with Policy Record
            String uniqKey = insurPlcyRec.BRM_Agency_Account__c +'_'+ insurPlcyRec.Agency_Contact__c; 
            
            // if-else block to prepare Map with key as 'Agency_Agent' and values with collection of Map key as "Agency_Agent_MonthOfYear",Value as 'Count of policies'
            if(!contTargetDatesMap.containsKey(uniqKey)){
                System.debug('>>>>01K::'+uniqKey + '_' + monthNum+'>>>>02K:::'+monthNum);
                contTargetDatesMap.put(uniqKey, new Map<String,Integer>{ uniqKey + '_' + monthNum =>  1 });            
            }
            else{
                Map<String,Integer>  monthPolicyCountMap = contTargetDatesMap.get(uniqKey);  
                // loop for Monthly target records to calculate the number of policy
                for(String monthInt : monthPolicyCountMap.keySet()){
                    if(!monthPolicyCountMap.containsKey(uniqKey + '_' + monthNum)){
                        System.debug('>>>>01::'+uniqKey + '_' + monthNum+'>>>>02:::'+monthNum);
                        monthPolicyCountMap.put(uniqKey + '_' + monthNum, 1);
                    }  
                    else{
                        System.debug('>>>>03::'+uniqKey + '_' + monthNum+'>>>>04:::'+monthPolicyCountMap.get(uniqKey + '_' + monthNum) + 1);
                        if(monthInt == uniqKey + '_' + monthNum){
                            monthPolicyCountMap.put(uniqKey + '_' + monthNum, monthPolicyCountMap.get(uniqKey + '_' + monthNum) + 1);
                        }                    
                    } 
                }
                System.debug('>>>>01MM::'+uniqKey+'>>>>02MM:::'+monthPolicyCountMap);
                contTargetDatesMap.put(uniqKey,monthPolicyCountMap);   //Map which holds final count of Policies for each month
            }
            
            // if-else block to prepare Map with key as Agency_Agent and values with collection of Map Key as "Agency_Agent_MonthOfYear" and value as Total Policy Premium Amount
            if(!contTargetDatesPremAmt.containsKey(uniqKey)){
                System.debug('>>>>01A::'+uniqKey + '_' + monthNum+'>>>>02A:::'+monthNum);
                contTargetDatesPremAmt.put(uniqKey, new Map<String,Decimal>{ uniqKey + '_' + monthNum => insurPlcyRec.PremiumAmount });            
            }
            else{
                Map<String,Decimal>  plcyMnthPreAmtMap = contTargetDatesPremAmt.get(uniqKey); 
                //Loop for calculating the Monthly total Achieved Premium Amounts        
                for(String monthInt : plcyMnthPreAmtMap.keySet()){
                    if(!plcyMnthPreAmtMap.containsKey(uniqKey + '_' + monthNum)){
                        System.debug('>>>>05::'+uniqKey + '_' + monthNum+'>>>>06:::'+insurPlcyRec.PremiumAmount);
                        plcyMnthPreAmtMap.put(uniqKey + '_' + monthNum, insurPlcyRec.PremiumAmount);
                    }  
                    else{
                        System.debug('>>>>07::'+uniqKey + '_' + monthNum+'>>>>08:::'+plcyMnthPreAmtMap.get(uniqKey + '_' + monthNum) + insurPlcyRec.PremiumAmount);
                        if(monthInt == uniqKey + '_' + monthNum){
                            plcyMnthPreAmtMap.put(uniqKey + '_' + monthNum, plcyMnthPreAmtMap.get(uniqKey + '_' + monthNum) + insurPlcyRec.PremiumAmount);                   
                        }
                    } 
                } 
                contTargetDatesPremAmt.put(uniqKey,plcyMnthPreAmtMap);  // Map holds the final Monthly Policy Premium Amounts of all Target Records
            }  
        }
        
        
        //Loop on Target Records to update the Monthly Achieved Total Policy count and Monthly Achieved Total Premium Amounts
        for(Target__c trgtRec : scope){
            String monthTargtNum = trgtRec.Agency__c +'_'+trgtRec.Agent__c +'_'+ trgtRec.Start_Date__c.month();
            trgtRec.Achievement_by_Count__c=0.0;
            trgtRec.Achievement_by_Premium__c=0; 
            
            // if block for updating the Achievement_by_Count__c Field with Monthly Policy count
            if(contTargetDatesMap.containsKey(trgtRec.Agency__c +'_'+trgtRec.Agent__c)){
                Map<String,Integer> monthContMap = contTargetDatesMap.get(trgtRec.Agency__c +'_' + trgtRec.Agent__c);
                for(String monthKey : monthContMap.keySet()){  
                    if(monthContMap.get(monthTargtNum) != null ){            
                       trgtRec.Achievement_by_Count__c = monthContMap.get(monthTargtNum);                
                     }
                                               
                }
            }        
            // if block for updating the Achievement_by_Premium__c Field with Monthly Policies total premium amounts on respective target records
            if(contTargetDatesPremAmt.containsKey(trgtRec.Agency__c +'_'+trgtRec.Agent__c)){
                Map<String,Decimal> monthPremAmtMap = contTargetDatesPremAmt.get(trgtRec.Agency__c +'_'+trgtRec.Agent__c);
                for(String monthPreKey : monthPremAmtMap.keySet()){
                     if(monthPremAmtMap.get(monthTargtNum) != null ){             
                         trgtRec.Achievement_by_Premium__c = monthPremAmtMap.get(monthTargtNum);                                        
                     }                           
                }
            } 
            targetsToUpdate.add(trgtRec);   // Final List of Target records to be updated             
         }
         
         //IF block to update the Target records processed
         if(targetsToUpdate != null && targetsToUpdate.size()>0){
             UPDATE targetsToUpdate;   
         }
     }catch(Exception ex){ // Exception block
         System.debug('>>>>Exceptn::'+ex.getMessage());   
     }
} 

global void finish(Database.BatchableContext bc){
}

global void execute(SchedulableContext SC) {
    UpdateAcheivedPlcyContWithPreMAmtBtch updAchPlcyPremAmt = new  UpdateAcheivedPlcyContWithPreMAmtBtch();
    Database.executeBatch(updAchPlcyPremAmt);
}

}