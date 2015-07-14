@isTest
public class {{ api_name }} {
 
    @testSetup static void buildData(){
        Account a = TestData.buildAccount(1);
        insert a;
 
        Opportunity o = TestData.buildStandardOpportunity(a.id,'Windows');
        insert o;
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