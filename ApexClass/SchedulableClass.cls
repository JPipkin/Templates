global class {{ api_name }} implements Schedulable {

	global void execute(SchedulableContext sc) {
		executeLogic();
	}

	
	webservice static void {{ api_name }}buttonMethod(){
		executeLogic();
	}

	global void executeLogic(){
		//MyBatchClass b = new MyBatchClass();
		//database.executebatch(b);
	}
}