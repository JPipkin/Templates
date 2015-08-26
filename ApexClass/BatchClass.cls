global class {{ api_name }} implements Database.Batchable<SObject>, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        // Start logging messages for this run of the batch in Batch_Job_Message__c object
        // Instead of system.debug, use BatchJobHelper.AddMessage(Caller, Message)
        // it will dd message to  Batch_Job_Message__c object AND do system.debug
        BatchJobHelper.StartMessages('{{ api_name }}');

        String query = '';

        if(Test.isRunningTest())
            query += ' limit 200';

        BatchJobHelper.AddMessage('{{ api_name }}', 'query = ' + query, true);

        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<{{ sobj }}> {{ obj_var }}){

        BatchJobHelper.AddMessage('{{ api_name }}', 'execute started, {{ obj_var }}.size = ' + {{ obj_var }}.size(), true);


    }
        
    global void finish(Database.BatchableContext bc) {

        BatchJobHelper.AddMessage('{{ api_name }}', 'finish started', true);

        AsyncApexJob aaJob = [SELECT ApexClass.Name, Status, ExtendedStatus, MethodName FROM AsyncApexJob WHERE Id = :bc.getJobId()];

        if(aaJob.Status == 'Failed' || Test.isRunningTest() || (aaJob.ExtendedStatus != null && aaJob.ExtendedStatus != '')) {

            BatchJobHelper.AddMessage('{{ api_name }}', 'Failed, status = ' + aaJob.ExtendedStatus, true);

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

        // Now, insert all the messages logged for this batch job
        BatchJobHelper.writeLogs('{{ api_name }}');
    }
    
}