/* Class:       {{ api_name }}
 * Created On:  
 * Created by:  J. Pipkin (OpFocus, Inc)
 * Description: 
 */

 
global class {{ api_name }} implements Database.Batchable<SObject>, Database.Stateful {

    global Integer numSuccess = 0;
    global String dmlFailures = null;

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
        
    global void finish(Database.BatchableContext bc) {

        AsyncApexJob aaJob = [SELECT ApexClass.Name, Status, ExtendedStatus, MethodName FROM AsyncApexJob WHERE Id = :bc.getJobId()];

        if(aaJob.Status == 'Failed' || Test.isRunningTest() || (aaJob.ExtendedStatus != null && aaJob.ExtendedStatus != '')) {

            Messaging.SingleEmailMessage semResult = new Messaging.SingleEmailMessage();
            semResult.setToAddresses(new String[]);
            
            semResult.setSubject('Error in {{api_name}}');
            String fbody = 'The batch job, {{ api_name }}, failed to run.';
            fbody += '\n\nERROR: ' + aaJob.ExtendedStatus;
            fbody += '\n\n' + URL.getSalesforceBaseUrl().toExternalForm() + '/apexpages/setup/listAsyncApexJobs.apexp?retURL=%2Fui%2Fsetup%2FSetup%3Fsetupid%3DJobs&setupid=AsyncApexJobs';
            semResult.setPlainTextBody(fbody);
            try{
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { semResult });
            }
            catch(Exception e)
              system.debug(e);
            }

        }
        if(dmlFailures != null || Test.isRunningTest())
        {
            Messaging.SingleEmailMessage semResult = new Messaging.SingleEmailMessage();
            semResult.setToAddresses(new String[] );
            
            semResult.setSubject('DML failures in {{ api_name }}');
            String fbody = 'The batch job, {{ api_name }}, had the follwing DML failures :';
            fbody += '\n\n' + dmlFailures;
            semResult.setPlainTextBody(fbody);
            try{
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { semResult });
            }
            catch(Exception e){
              system.debug(e);
            }
        }

    }
    
}