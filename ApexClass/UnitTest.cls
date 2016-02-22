/* Class:       {{ api_name }}
 * Created On:  {{ today }}
 * Created by:  OpFocus Team
 * Description: 
 */

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
		
	}
	
	static testMethod void myTest2() {
		
	}
	
}