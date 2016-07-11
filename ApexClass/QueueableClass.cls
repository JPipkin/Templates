/* Class:       {{ api_name }}
 * Created On:  
 * Created by:  J. Pipkin (OpFocus, Inc)
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