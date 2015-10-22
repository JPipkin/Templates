global class {{ api_name }} implements Schedulable, Database.Batchable<SObject>, Database.Stateful {

    // -------------------------------------------------------------------------------------
    // ---------------- Schedulable Part ---------------------------------------------------
    // -------------------------------------------------------------------------------------

    // use this method to schedule this job
    public static void setup() {
        //String cronText = '0 0 22  ? * * *'; 
        //String jobName = '{{ api_name }} 10pm';
        //if(Test.isRunningtest()) 
        //  jobName += 'test';
        //system.schedule(jobName, cronText , new {{ api_name }}());
    }

    // use this methid to run this job once manually
    public static void manual() {

        // first delete the job if it already exists
        BatchJobHelper.DeleteJobs('{{ api_name }} Manual') ;
        DateTime dt = system.now().addMinutes(1);
        String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
        Id jobid = System.schedule('{{ api_name }} Manual', timeForScheduler, new {{ api_name }}());
    }



    global void execute(SchedulableContext sc) {

        // Start logging messages for this run of the batch in Batch_Job_Message__c object
        // Instead of system.debug, use BatchJobHelper.AddMessage(Caller, Message)
        // it will dd message to  Batch_Job_Message__c object AND do system.debug
        BatchJobHelper.StartMessages('{{ api_name }}');

        executeSchdLogic();
    }

    
    /*webservice static void {{ api_name }}buttonMethod(){
        BatchJobHelper.StartMessages('{{ api_name }}');
        BatchJobHelper.AddMessage('{{ api_name }}', 'buttonMethod started', true);
        executeSchdLogic();
    }*/

    global static void executeSchdLogic(){
        try
        {
            BatchJobHelper.AddMessage('{{ api_name }}', 'executeLogic started', true);

            database.executebatch(new {{ api_name }}());

            // insert log messages at the end of your process
            BatchJobHelper.writeLogs('{{ api_name }}');
        }
        catch(Exception ex)
        {
            BatchJobHelper.exceptionHandler('{{ api_name }}', ex);
        }
    }

    // -------------------------------------------------------------------------------------
    // ---------------- Schedulable Part ---------------------------------------------------
    // -------------------------------------------------------------------------------------



    // -------------------------------------------------------------------------------------
    // ---------------- Batchable Part ---------------------------------------------------
    global Integer numSuccess = 0;
    global String dmlFailures = null;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        try
        {
            // Start logging messages for this run of the batch in Batch_Job_Message__c object
            // Instead of system.debug, use BatchJobHelper.AddMessage(Caller, Message)
            // it will dd message to  Batch_Job_Message__c object AND do system.debug
            BatchJobHelper.addmessage('{{ api_name }}', 'Batch Started', true);

            String query = '';

            if(Test.isRunningTest())
                query += ' limit 200';

            BatchJobHelper.AddMessage('{{ api_name }}', 'query = ' + query, true);

            return Database.getQueryLocator(query);
        }
        catch(Exception ex)
        {
            BatchJobHelper.exceptionHandler('{{ api_name }}', ex);
            return Database.getQueryLocator('Select Id from {{ sobj }} where Id = null');
        }

    }
    
    global void execute(Database.BatchableContext bc, List<{{ sobj }}> {{ obj_var }}){

        try
        {
            BatchJobHelper.AddMessage('{{ api_name }}', 'execute started, {{ obj_var }}.size = ' + {{ obj_var }}.size(), true);

            // ---------------------- ADD YOUR LOGIC HERE ----------------------------------------------
            
            //Integer i = 0;
            //Database.SaveResult[] srList = database.insert(objectList, false) ;
            //Database.SaveResult[] srList = database.update(objectList, false) ;
            //for (Database.SaveResult sr : srList) {
            //    if (sr.isSuccess()) 
            //        numSuccess++;
            //    else {
            //        // Operation failed, so get all errors                
            //        for(Database.Error err : sr.getErrors()) {
            //            // for inserts
            //            String errMsg = 'Error creating Object (' + objectList[i].Name + '): ' + err.getStatusCode() + ': ' + err.getMessage() + ', ' +
            //                                        'fields that affected this error: ' + err.getFields();
            //            // for updates
            //            String errMsg = 'Error updating Object (' + objectList[i].Id + '): ' + err.getStatusCode() + ': ' + err.getMessage() + ', ' +
            //                                        'fields that affected this error: ' + err.getFields();
            //            dmlFailures += '\n' + errMsg;
            //            BatchJobHelper.AddMessage('{{ api_name }}', errMsg, true);
            //        }
            //    }// some failures
            //    i++;
            //}


            BatchJobHelper.AddMessage('{{ api_name }}', 'Batch Done', true);

            // Now, insert all the messages logged for this batch job
            BatchJobHelper.writeLogs('{{ api_name }}');
        }
        catch(Exception ex)
        {
            BatchJobHelper.exceptionHandler('{{ api_name }}', ex);
        }


    }
        
    global void finish(Database.BatchableContext bc) {

        BatchJobHelper.AddMessage('{{ api_name }}', 'finish started, number of successful updates = ' + numSuccess, true);

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
        if(dmlFailures != null || Test.isRunningTest())
        {
            Messaging.SingleEmailMessage semResult = new Messaging.SingleEmailMessage();
            semResult.setToAddresses(new String[] {'sf.onlinescherrors.group@nextsteplivinginc.com'});
            
            semResult.setSubject('DML failures in {{ api_name }}');
            String fbody = 'The batch job, {{ api_name }}, had the follwing DML failures :';
            fbody += '\n\n' + dmlFailures;
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
    // -------------------------------------------------------------------------------------
    // ---------------- Batchable Part ---------------------------------------------------
    // -------------------------------------------------------------------------------------
    
}