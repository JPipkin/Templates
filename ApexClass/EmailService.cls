/* Class:       EmailService
 * Created On:  
 * Created by:  OpFocus Team
 * Description: Handler for sending emails in Apex. 
 *		+ If email deliverability is turned off in the organization:
 *			- if called from UI, display a message
 *			- If running test, silently continue
 8			- All other scenarios, throw original message
 *		+ Supported functionality for rollback to insert dummy contact for templates
 *			sent to users.
 */
 
global class EmailService {

	@TestVisible private static TestOptions testArgs = new TestOptions();
	public static Contact dummyContact {
		get {
			if(dummyContact==null){
				Contact[] lstC = [Select Id from Contact Limit 1];
				if(lstC == null){
					dummyContact = createContact();
				}
				else{
					if(lstC.isEmpty()){
						dummyContact = createContact();
					}
					else{
						dummyContact = lstC[0];
					}
				}
			}
			return dummyContact;
		}
	} 
	@TestVisible private static Integer transactionCount = 0;	
	private ENUM ObjectType {SINGLE, MASS}
	private static ObjectType objType = ObjectType.SINGLE;
	private static Boolean clearTargets = false;
	private static Boolean deleteContact = false;

	//callers 
	//START----------------------------------------------------
	global static void sendEmails(Object lstOfMail){
		emailHandler(lstOfMail, false, false);
	}
	global static void sendEmails(Object lstOfMail, Boolean isMass){
		emailHandler(lstOfMail, isMass, false);
	}
	global static Object rollback(Object lstOfMail, Boolean sendBack){
		List<Messaging.SingleEmailMessage> retObj = (List<Messaging.SingleEmailMessage>) emailHandler(lstOfMail, false, true);
		clearTargets = true;
		if(deleteContact){
			delete dummyContact;
		}
		if(sendBack){
			return clearReturnEmailTargetIds(retObj);
		}
		else{
			emailHandler(lstOfMail, false, true);
			return null;
		}
	}

	//callers
	//END ----------------------------------------------------

	//private hanlders
	private static Object emailHandler(Object mail, Boolean isMassEmail, Boolean isRollback){
		List<Messaging.SingleEmailMessage> lstMailSingle;
		List<Messaging.MassEmailMessage> lstMailMass;
		try{
			//cast object to specific type
			if(mail instanceof Messaging.SingleEmailMessage[]){
				lstMailSingle = (List<Messaging.SingleEmailMessage>) mail;
				//if is rollback, get dummy contact
				for(Messaging.SingleEmailMessage m :lstMailSingle){
					transactionCount++;
					if(m.getTargetObjectId() == null && isRollback){
						m.setTargetObjectId(dummyContact.Id);
					}
					else if(clearTargets){
						m.setTemplateId(null);
						m.setTargetObjectId(null);
					}
				}
			}
			else if( mail instanceof Messaging.MassEmailMessage[]){
				lstMailMass = (List<Messaging.MassEmailMessage>) mail;
				objType = ObjectType.MASS;
				//if is rollback, get dummy contact
				for(Messaging.MassEmailMessage m :lstMailMass){
					transactionCount++;
					if(m.getTargetObjectIds() == null && isRollback){
						m.setTargetObjectIds(new Id[]{dummyContact.Id});
					}
					else if(clearTargets){
						m.setTemplateId(null);
						m.setTargetObjectIds(null);
					}
				}
			}
			else if(mail instanceof Messaging.SingleEmailMessage){
				lstMailSingle = new Messaging.SingleEmailMessage[] {(Messaging.SingleEmailMessage)mail};
				//if is rollback, get dummy contact
				for(Messaging.SingleEmailMessage m :lstMailSingle){
					transactionCount++;
					if(m.getTargetObjectId() == null && isRollback){
						m.setTargetObjectId(dummyContact.Id);
					}
					else if(clearTargets){
						m.setTemplateId(null);
						m.setTargetObjectId(null);
					}
				}
			}

			//check if transaction will cause limit to be reached and then send email
			if(isMassEmail){
				if(!testArgs.skipReserve)Messaging.reserveMassEmailCapacity(lstMailMass.size());
				Messaging.sendEmail(lstMailMass);
				return lstMailMass;
			}
			else{
				if(!testArgs.skipReserve)Messaging.reserveSingleEmailCapacity(lstMailSingle.size());
				SavePoint sp = Database.setSavePoint();
				Messaging.sendEmail(lstMailSingle);
				if(!clearTargets && isRollback){
					Database.rollback(sp);
				}
				return lstMailSingle;
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
    				return null;
    			}
			}
			//other exception, throw
			throwError(ex_msg);
			return null;
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

	//creates dummy contact
	private static Contact createContact(){
		if(Limits.getLimitDMLStatements() - Limits.getDMLStatements() > 2){
			Contact newContact = new Contact(LastName='Test',FirstName='test',Email='test@test.test',AccountId=[Select Id from Account Limit 1].Id);
			insert newContact;
			deleteContact = true;
			return newContact;
		}
		else{
			throw new EmailCustomException('There are not enough DML statements left in this transaction');
			return null;
		}
	}

	//there are some properties that need to be deleted on return of email list
	private static Object clearReturnEmailTargetIds(Object mail){
		if(objType == ObjectType.SINGLE){
			List<Messaging.SingleEmailMessage> lstReturn = (List<Messaging.SingleEmailMessage>) mail;
			for(Messaging.SingleEmailMessage m :lstReturn){
				m.setTemplateId(null);
				m.setTargetObjectId(null);
			}
			return lstReturn;
		}
		else if(objType == ObjectType.MASS){
			List<Messaging.MassEmailMessage> lstReturn = (List<Messaging.MassEmailMessage>) mail;
			for(Messaging.MassEmailMessage m :lstReturn){
				m.setTargetObjectIds(null);
			}
			return lstReturn;
		}
		return null;
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