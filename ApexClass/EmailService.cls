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

	@TestVisible private static List<Messaging.SingleEmailMessage> lstMail;
	@TestVisible private static Boolean isMassEmail;


	//constructors 
	//START----------------------------------------------------
	global static void sendEmails(List<Messaging.SingleEmailMessage> lstOfMail){
		lstMail = lstOfMail;
		isMassEmail = false;
		emailHandler();
	}
	global static void sendEmails(List<Messaging.SingleEmailMessage> lstOfMail, Boolean isMass){
		lstMail = lstOfMail;
		isMassEmail = isMass;
		emailHandler();
	}
	global static void sendEmails(Messaging.SingleEmailMessage singleEmail){
		lstMail = new Messaging.SingleEmailMessage[] {singleEmail};
		isMassEmail = false;
		emailHandler();
	}
	//constructors
	//END ----------------------------------------------------

	//Handler
	private static void emailHandler(){
		//check if transaction will cause limit to be reached and then send email
		try{
			if(isMassEmail){
				Messaging.reserveMassEmailCapacity(lstMail.size());
			}
			else{
				Messaging.reserveSingleEmailCapacity(lstMail.size());
			}
			Messaging.sendEmail(lstMail);
		}
		catch(Exception ex){
			String ex_msg = ex.getMessage();
			if(ex.getTypeName() == 'System.HandledException'){
				throwError('<u><br/><br/>The daily '+ (isMassEmail?'mass email ':'single email ') +
					'limit for the org would be exceeded by this request<br/><br/></u>');
				return;
			}
			if(ex_msg.containsIgnoreCase('Single email is not enabled for your organization')){
				if(!Test.isRunningTest()){
					//Email deliverability is turned off
    				throwError('<u><br/><br/>Email deliverability has been turned off for this organization.<br/><br/></u>'.toUpperCase());
    				return;
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

}