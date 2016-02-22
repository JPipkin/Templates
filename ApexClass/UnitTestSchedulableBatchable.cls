/* Class:       {{ api_name }}
 * Created On:  {{ today }}
 * Created by:  OpFocus Team
 * Description: 
 */

@isTest
public class {{ api_name }} {
 
    @testSetup static void buildData(){
        
    }
 
    //test methods
 
    static testMethod void myTest1() {
       
        //Test.startTest();

        //DateTime dt= system.now().addMinutes(1);
        //String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
        //Id job_id = System.schedule('{{ api_name }}', timeForScheduler, new {{ schd_class }}());       

        //{{ schd_class }}.setup();
        //{{ schd_class }}.manual();
        //{{ schd_class }}.{{ schd_class }}buttonMethod();

        //Test.stopTest();
   
    }
   
 
    /*static testMethod void myTest2() {
 
        test.startTest();
        ID batchid = database.executeBatch(new {{ batch_class }}());
        test.stopTest();
       
    }*/
}