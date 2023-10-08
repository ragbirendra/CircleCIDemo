public with sharing class BR_FileUploaderClassV1 {
    
    @AuraEnabled
    public static List<Opportunity> saveFile(String base64Data) {        
        String data    = JSON.deserializeUntyped(base64Data).toString();
        list<Opportunity> lstCCToInsert = new list<Opportunity>();
        list<String> lstCSVLines = data.split('\n');
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
            /*opp.Name                     = csvRowData[0];
opp.Amount                   = Decimal.valueOf(!String.isEmpty(csvRowData[1]) ? csvRowData[1] : '0');
opp.StageName                = csvRowData[2];
opp.CloseDate                = System.today();*/
            
            opp.RecordTypeId = '0125g000002GSL6AAO';//auto
            opp.AccountId = csvRowData[0];//'0015g00000xyB93AAE';//name
            opp.Name = csvRowData[1];
            opp.Insurance_Type__c = csvRowData[2];
            opp.Description = csvRowData[3];
            opp.StageName = csvRowData[4];
            opp.Amount = Decimal.valueOf(!String.isEmpty(csvRowData[5]) ? csvRowData[5] : '0');
            opp.CloseDate = Date.valueOf(Date.parse(!String.isEmpty(csvRowData[6]) ? csvRowData[6] : ''));
            opp.BRM_Expiration_Date__c = Date.parse(!String.isEmpty(csvRowData[7]) ? csvRowData[7] : ''); 
            opp.BRM_Needed_By_Date__c = Date.parse(!String.isEmpty(csvRowData[8]) ? csvRowData[8] : '');
            opp.BRM_Effective_Date__c = Date.parse(!String.isEmpty(csvRowData[9]) ? csvRowData[9] : '');
            //opp.BRM_Renewal__c = Boolean.valueOf(csvRowData[10]);
            opp.BRM_Submission__c = csvRowData[11];
            opp.BRM_Premium__c = Decimal.valueOf(!String.isEmpty(csvRowData[12]) ? csvRowData[12] : '0');
           //opp.BRM_Agency_Contact__c = csvRowData[13]; //name
           //opp.BRM_Agency_Account__c = csvRowData[14];//name
           //Opp.OwnerId = csvRowData[15];Name;
            lstCCToInsert.add(opp);
        }
        insert lstCCToInsert;
        return [Select Id, Name, Amount, StageName,CloseDate From Opportunity Where CreatedDate>=:Date.TODAY()];
    }
    
    public static Opportunity doMapping(Opportunity opp, List<String> csvRowData ){
        
        opp.RecordTypeId = '0125g000002GSL6AAO';
        opp.AccountId = csvRowData[0];
        opp.Name = csvRowData[1];
        opp.Insurance_Type__c = csvRowData[2];
        opp.Description = csvRowData[3];
        opp.StageName = csvRowData[4];
        opp.Amount = Decimal.valueOf(!String.isEmpty(csvRowData[5]) ? csvRowData[5] : '0');
        opp.CloseDate = Date.parse(!String.isEmpty(csvRowData[6]) ? csvRowData[6] : '');
        opp.BRM_Expiration_Date__c = Date.parse(!String.isEmpty(csvRowData[7]) ? csvRowData[7] : ''); 
        opp.BRM_Needed_By_Date__c = Date.parse(!String.isEmpty(csvRowData[8]) ? csvRowData[8] : '');
        opp.BRM_Effective_Date__c = Date.parse(!String.isEmpty(csvRowData[9]) ? csvRowData[9] : '');
        //opp.BRM_Renewal__c = Boolean.valueOf(csvRowData[10]);
        opp.BRM_Submission__c = csvRowData[11];
        opp.BRM_Premium__c = Decimal.valueOf(!String.isEmpty(csvRowData[12]) ? csvRowData[12] : '0');
        opp.BRM_Agency_Contact__c = csvRowData[13];
        opp.BRM_Agency_Account__c = csvRowData[14];
        //opp.OwnerId = csvRowData[15];
        
        System.debug('Opp >' + opp);
        return opp;
    }
    
}