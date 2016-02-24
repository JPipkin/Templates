/* Class:       {{ api_name }}
 * Created On:  
 * Created by:  OpFocus Team
 * Description: 
 */
 
global class {{ api_name }} implements Queueable {

	global void execute(QueueableContext context) {
        try{
            executeLogic();
        }
        catch(Exception ex){
            
        }
	}

    public void executeLogic(){
    }
}