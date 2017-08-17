/* Class:       {{ api_name }}
 * Created On:  
 * Created by:  J. Pipkin (OpFocus, Inc)
 * Description: Class to schedule a batch class
 */

global class {{ api_name }} implements Schedulable, Database.Batchable<SObject>, Database.Stateful {

    // -------------------------------------------------------------------------------------
    // ---------------- Schedulable Part ---------------------------------------------------
    // -------------------------------------------------------------------------------------

    // use this method to schedule this job
    public static void schedule() {
        //String cronText = '0 0 22  ? * * *'; 
        //String jobName = '{{ api_name }} 10pm';
        //if(Test.isRunningtest()) 
        //  jobName += 'test';
        //system.schedule(jobName, cronText , new {{ api_name }}());
    }

    // use this methid to run this job once manually
    public static void manual() {
        database.executebatch(new {{ api_name }}()); 
    }



    global void execute(SchedulableContext sc) {
        manual();
    }

    // -------------------------------------------------------------------------------------
    // ---------------- Schedulable Part ---------------------------------------------------
    // -------------------------------------------------------------------------------------



    // -------------------------------------------------------------------------------------
    // ---------------- Batchable Part ---------------------------------------------------
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        try{
            String query = '';

            if(Test.isRunningTest())
                query += ' limit 200';

            return Database.getQueryLocator(query);
        }
        catch(Exception ex){
            return Database.getQueryLocator('Select Id from {{ sobj }} where Id = null');
        }

    }
    
    global void execute(Database.BatchableContext bc, List<{{ sobj }}> {{ obj_var }}){

        try{
            
        }
        catch(Exception ex){
            
        }
    }
        
    global void finish(Database.BatchableContext bc) {}
    // -------------------------------------------------------------------------------------
    // ---------------- Batchable Part ---------------------------------------------------
    // -------------------------------------------------------------------------------------
    
}