global class {{ api_name }} implements Schedulable {

    // use this methid to schedule this job
    public static void setup() {
        //String cronText = '0 0 22  ? * * *'; 
        //String jobName = '{{ api_name }} 10pm';
        //if(Test.isRunningtest()) 
        //  jobName += 'test';
        //system.schedule(jobName, cronText , new '{{ api_name }}());
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

		executeLogic();
	}

	
	webservice static void {{ api_name }}buttonMethod(){
        BatchJobHelper.StartMessages('{{ api_name }}');
        BatchJobHelper.AddMessage('{{ api_name }}', 'buttonMethod started');
		executeLogic();
	}

	global static void executeLogic(){
        BatchJobHelper.AddMessage('{{ api_name }}', 'executeLogic started');
		//MyBatchClass b = new MyBatchClass();
		//database.executebatch(b);
	}
}