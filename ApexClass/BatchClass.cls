/* Class:       {{ api_name }}
 * Created On:  
 * Created by:  J. Pipkin (OpFocus, Inc)
 * Description: 
 */

 
global class {{ api_name }} implements Database.Batchable<SObject>, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        try{
            String query = '';

            if(Test.isRunningTest())
                query += ' limit 200';

            return Database.getQueryLocator(query);
        }
        catch(Exception ex){
            return Database.getQueryLocator('Select Id from {{ sobj }} where Id = null');
        }

    }
    
    global void execute(Database.BatchableContext bc, List<{{ sobj }}> {{ obj_var }}){

        try{
            
        }
        catch(Exception ex){
            
        }
    }
        
    global void finish(Database.BatchableContext bc) {}
    
}