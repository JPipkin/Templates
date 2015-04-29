@isTest
public class {{ api_name }} {
 
    @testSetup static void buildData(){
        Account a = TestData.buildAccount();
        insert a;
 
        Opportunity o = TestData.buildStandardOpportunity(a.id,'Windows');
        insert o;
    }
 
    //test methods
 
    static testMethod void myTest1() {
       
        Test.startTest();
        DateTime dt= system.now().addMinutes(1);
        String timeForScheduler = dt.format('s m H d M E yyyy');
        Id job_id = System.schedule('{{ api_name }}', timeForScheduler, new {{ schd_class }}());       
        Test.stopTest();
   
    }
   
 
    static testMethod void myTest2() {
 
        test.startTest();
        ID batchid = database.executeBatch(new {{ batch_class }}());
        test.stopTest();
       
    }
}