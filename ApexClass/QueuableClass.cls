global class {{ api_name }} implements Queueable {

	global void execute(QueueableContext context) {
        try
        {
            // Start logging messages for this run of the batch in Batch_Job_Message__c object
            // Instead of system.debug, use BatchJobHelper.AddMessage(Caller, Message)
            // it will dd message to  Batch_Job_Message__c object AND do system.debug
            BatchJobHelper.StartMessages('{{ api_name }}');

            executeLogic();
        }
        catch(Exception ex)
        {
            BatchJobHelper.exceptionHandler('{{ api_name }}', ex);
        }
	}

    public void executeLogic()
    {
    }
}