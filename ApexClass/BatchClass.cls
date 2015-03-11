global class {{ api_name }} implements Database.Batchable<SObject>, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = '';

        if(Test.isRunningTest())
            query += ' limit 200';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<{{ sobj }}> {{ obj_var }}){


    }
        
    global void finish(Database.BatchableContext bc) {


        AsyncApexJob aaJob = [SELECT ApexClass.Name, Status, ExtendedStatus, MethodName FROM AsyncApexJob WHERE Id = :bc.getJobId()];

        if(aaJob.Status == 'Failed' || (aaJob.ExtendedStatus != null && aaJob.ExtendedStatus != '')){

            Messaging.SingleEmailMessage semResult = new Messaging.SingleEmailMessage();
            semResult.setToAddresses(new String[] {'sf.onlinescherrors.group@nextsteplivinginc.com'});
            
            semResult.setSubject('Error in {{api_name}}');
            String fbody = 'The batch job, {{ api_name }}, failed to run.';
            fbody += '\n\nERROR: ' + aaJob.ExtendedStatus;
            fbody += '\n\n' + URL.getSalesforceBaseUrl().toExternalForm() + '/apexpages/setup/listAsyncApexJobs.apexp?retURL=%2Fui%2Fsetup%2FSetup%3Fsetupid%3DJobs&setupid=AsyncApexJobs';
            semResult.setPlainTextBody(fbody);
            try
            {
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { semResult });
            }
            catch(Exception e)
            {
              system.debug(e);
            }

        }
    }
    
}