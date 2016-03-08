/* Class:       EmailService
 * Created On:  
 * Created by:  OpFocus Team
 * Description: Custom handler for sending emails in Apex. 
 *		+ If email deliverability is turned off in the organization:
 *			- if called from UI, display a message
 *			- If running test, silently continue
 8			- All other scenarios, throw original message
 */
 
global class EmailService {

	@TestVisible private static TestOptions testArgs = new TestOptions();

	//constructors 
	//START----------------------------------------------------
	global static void sendEmails(Object lstOfMail){
		emailHandler(lstOfMail, false);
	}
	global static void sendEmails(Object lstOfMail, Boolean isMass){
		emailHandler(lstOfMail, isMass);
	}
	
	//constructors
	//END ----------------------------------------------------

	//Handler
	private static void emailHandler(Object mail, Boolean isMassEmail){
		//check if transaction will cause limit to be reached and then send email
		List<Messaging.SingleEmailMessage> lstMailSingle;
		List<Messaging.MassEmailMessage> lstMailMass;
		if(mail instanceof Messaging.SingleEmailMessage[]){
			lstMailSingle = (List<Messaging.SingleEmailMessage>) mail;
		}
		else if( mail instanceof Messaging.MassEmailMessage[]){
			lstMailMass = (List<Messaging.MassEmailMessage>) mail;
		}
		else if(mail instanceof Messaging.SingleEmailMessage){
			lstMailSingle = new Messaging.SingleEmailMessage[] {(Messaging.SingleEmailMessage)mail};
		}
		try{
			if(isMassEmail){
				if(!testArgs.skipReserve)Messaging.reserveMassEmailCapacity(lstMailMass.size());
				Messaging.sendEmail(lstMailMass);
			}
			else{
				if(!testArgs.skipReserve)Messaging.reserveSingleEmailCapacity(lstMailSingle.size());
				Messaging.sendEmail(lstMailSingle);
			}
			
		}
		catch(Exception ex){
			String ex_msg;
			String ex_type;
			if(testArgs.overwriteException){
				ex_msg = testArgs.newExceptionMsg;
				ex_type = null;
			}
			else{
				ex_msg = ex.getMessage();	
				ex_type = ex.getTypeName();
			} 
			if(ex_type == 'System.HandledException' || testArgs.isHandledException){
				throwError('<u><br/><br/>The daily '+ (isMassEmail?'mass email ':'single email ') +
					'limit for the org would be exceeded by this request<br/><br/></u>');

			}
			if(ex_msg.containsIgnoreCase('Single email is not enabled for your organization') ||
				ex_msg.containsIgnoreCase('The organization is not permitted to send email')){
				if(!Test.isRunningTest() || testArgs.overrideTestContext){
					//Email deliverability is turned off
    				throwError('<u><br/><br/>Email deliverability has been turned off for this organization.<br/><br/></u>'.toUpperCase());
    			}
    			else{
    				//don't throw any error if context is test
    				return;
    			}
			}
			//other exception, throw
			throwError(ex_msg);
		}
			
	}

	private static void throwError(String msg){
		if(msg.containsIgnoreCase('The organization is not permitted to send email')){
			msg = 'Email deliverability has been turned off for this organization.'.toUpperCase();
		}
		if(Trigger.isExecuting){
			if(Trigger.isDelete){
				Trigger.old[0].addError(msg);
			}
			else{
				Trigger.new[0].addError(msg);
			}
		}else{
			throw new EmailCustomException(msg);
		}
	}

	public class EmailCustomException extends Exception{}

	@TestVisible
	private class TestOptions{
		@TestVisible Boolean isHandledException = false;
		@TestVisible Boolean skipReserve = false;
		@TestVisible Boolean overrideTestContext = false;
		@TestVisible Boolean overwriteException = false;
		@TestVisible String newExceptionMsg;
	}

}