/* Class:       {{ api_name }}
 * Created On:  
 * Created by:  OpFocus Team
 * Description: Class to Schedule Apex
 */

global class {{ api_name }} implements Schedulable {

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
		DateTime dt = system.now().addMinutes(1);
		String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
		Id jobid = System.schedule('{{ api_name }} Manual', timeForScheduler, new {{ api_name }}());
    }



	global void execute(SchedulableContext sc) {
		executeLogic();
	}

	
	/*webservice static void {{ api_name }}buttonMethod(){
       
		executeLogic();
	}*/

	global static void executeLogic(){
        try{ 
            // --- Add logic here
            //database.executebatch(new MyBatchClass());
        }
        catch(Exception ex){
            
        }
	}
}