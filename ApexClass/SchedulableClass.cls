global class {{ api_name }} implements Schedulable {

	global void execute(SchedulableContext sc) {

        // Start logging messages for this run of the batch in Batch_Job_Message__c object
        // Instead of system.debug, use BatchJobHelper.AddMessage(Caller, Message)
        // it will dd message to  Batch_Job_Message__c object AND do system.debug
        BatchJobHelper.StartMessages('{{ api_name }}');

		executeLogic();
	}

	
	webservice static void {{ api_name }}buttonMethod(){
        BatchJobHelper.AddMessage('{{ api_name }}', 'buttonMethod started');
		executeLogic();
	}

	global static void executeLogic(){
        BatchJobHelper.AddMessage('{{ api_name }}', 'executeLogic started');
		//MyBatchClass b = new MyBatchClass();
		//database.executebatch(b);
	}
}