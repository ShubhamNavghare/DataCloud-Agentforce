/**
 * Each Account can have multiple Contacts, but only one Contact per Account 
 * can have the custom field IsLatest__c set to true. 
 * Write a trigger that runs after a Contact is inserted. 
 * The trigger should check if no other Contact under 
 * the same Account has IsLatest__c = true, and if so, set it to true for the 
 * newly inserted Contact.
 */

public with sharing class ContactTriggerHandler {
    
    public static void handleIsLatest(List<Contact> newContacts) {
        set<Id> accIds = new set<Id>();
        for(Contact con: newContacts) {    
            if(con.AccountId != null){
                accIds.add(con.AccountId);      
            }
        }
        if(accIds.isEmpty()) return;

        set<Id> accIdswithLatest = new set<Id>();
        List<Contact> conList = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accIds AND IsLatest__c = true];
        for(Contact con: conList){
            accIdswithLatest.add(con.AccountId);
        }

        Map<Id, Contact> acctoConMap = new Map<Id, Contact>();

        for(Contact con: newContacts){
            if(con.AccountId != null
            && !accIdswithLatest.contains(con.AccountId)
            && !acctoConMap.containsKey(con.AccountId)){
                acctoConMap.put(con.AccountId, con);    
            }    
        }

        List<Contact> conToUpdate = new List<Contact>();
        for(Contact con: acctoConMap.values()){
            conToUpdate.add(new Contact(
                Id = con.Id,
                IsLatest__c = true
            ));
        }

        if(!conToUpdate.isEmpty()){
            update conToUpdate;
        }
    }
}