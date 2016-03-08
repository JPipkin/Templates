/* Class:       TestEmailService
 * Created On:  
 * Created by:  OpFocus Team
 * Description: 
 */

@isTest
public class TestEmailService {
	 private static Boolean emailTurnedOff = false;

	//test methods
	static void prepare(){
		try{
			Messaging.reserveSingleEmailCapacity(1);
		}
		catch(Exception e){
			if(e.getMessage().containsIgnoreCase('The organization is not permitted to send email')){
				emailTurnedOff = true;
			}
			system.debug('=====> is email turned off: ' + emailTurnedOff);
		}
	}

	static testMethod void myTest1() {
		prepare();
		List<Messaging.SingleEmailMessage> mailList = (List<Messaging.SingleEmailMessage>) buildEmailList(false,200,null);
			
		system.debug('=====> is email turned off: ' + emailTurnedOff);
		if(emailTurnedOff){
			try{
				EmailService.sendEmails(mailList);
				system.assert(false);
			}catch(Exception e1){
				String msg = e1.getMessage();
				system.debug('=====> error: ' + msg);
				system.assert(msg.containsIgnoreCase('Email deliverability has been turned off'));
			}
			EmailService.TestOptions opt = new EmailService.TestOptions();
			try{
				opt.skipReserve = true;
				EmailService.testArgs = opt;
				EmailService.sendEmails(mailList);
				system.assert(true);
			}catch(Exception e1){
				system.assert(false);
			}
			opt.overrideTestContext = true;
			EmailService.testArgs = opt;
			try{
				EmailService.sendEmails(mailList);
				system.assert(false);
			}
			catch(Exception e2){
				String msg = e2.getMessage();
				system.debug('=====> error: ' + msg);
				system.assert(msg.containsIgnoreCase('Email deliverability has been turned off'));
			}
		}
		else{
			try{
				EmailService.sendEmails(mailList);
				system.assert(false);
			}catch(Exception e1){
				String msg = e1.getMessage();
				system.debug('=====> error: ' + msg);
				system.assert(msg.containsIgnoreCase('The daily single email limit'));
			}
			EmailService.TestOptions opt = new EmailService.TestOptions();
			opt.overwriteException = true;
			opt.newExceptionMsg = 'Single Email is not enabled for your organization';
			opt.overrideTestContext = true;
			EmailService.testArgs = opt;
			try{
				EmailService.sendEmails(mailList);
				system.assert(true);
			}
			catch(Exception e2){
				String msg = e2.getMessage();
				system.debug('=====> error: ' + msg);
				system.assert(msg.containsIgnoreCase('Email deliverability has been turned off'));
			}
			opt.overrideTestContext = false;
			EmailService.testArgs = opt;
			try{
				EmailService.sendEmails(mailList);
				system.assert(true);
			}
			catch(Exception e2){
				system.assert(false);
			}
		}
	}
	
	static testMethod void myTest2() {
		prepare();
		
		//EmailTemplate em = new EmailTemplate(Name='Test1234321',DeveloperName = 'hiuoefhfeh', body='test',
		//	FolderId =[Select Id from Folder where Type = 'Email Template' Limit 1].Id, TemplateType = 'Text');
		//insert em;
		List<id> lstIds = new List<Id>();
		for(User u :[Select Id from User where isActive=true Limit 10]){
			lstIds.add(u.Id);
		}
		List<Messaging.MassEmailMessage> mailList = (List<Messaging.MassEmailMessage>) buildEmailList(true, 0, lstIds);
			
		if(emailTurnedOff){
			try{
				EmailService.sendEmails(mailList,true);
				system.assert(false);
			}catch(Exception e1){
				String msg = e1.getMessage();
				system.debug('=====> error: ' + msg);
				system.assert(msg.containsIgnoreCase('Email deliverability has been turned off'));
			}
			EmailService.TestOptions opt = new EmailService.TestOptions();
			try{
				opt.skipReserve = true;
				EmailService.testArgs = opt;
				EmailService.sendEmails(mailList,true);
				system.assert(true);
			}catch(Exception e1){
				system.debug('=====> error: ' + e1.getMessage());
				system.assert(false);
			}
			opt.overrideTestContext = true;
			EmailService.testArgs = opt;
			
			EmailService.sendEmails(mailList,true);
				
		}
	}

	static testMethod void myTest3(){
		prepare();

		List<Messaging.SingleEmailMessage> mailList = (List<Messaging.SingleEmailMessage>) buildEmailList(false,1,null);
		if(emailTurnedOff){
			try{
				EmailService.TestOptions opt = new EmailService.TestOptions();
				opt.isHandledException = true;
				EmailService.testArgs = opt;
				EmailService.sendEmails(mailList[0]);
				system.assert(false);
			}catch(Exception e1){
				String msg = e1.getMessage();
				system.debug('=====> error: ' + msg);
				system.assert(msg.containsIgnoreCase('The daily single email limit'));
			}
		}

	}

	static testMethod void myTest4(){
		prepare();
		List<Messaging.SingleEmailMessage> mailList = (List<Messaging.SingleEmailMessage>) buildEmailList(false,2,null);
			
		system.debug('=====> is email turned off: ' + emailTurnedOff);
		if(!emailTurnedOff){
			EmailService.TestOptions opt = new EmailService.TestOptions();
			try{
				EmailService.sendEmails(mailList);
				system.assert(true);
			}catch(Exception e1){
				system.assert(false);
			}
			
		}
	}

	static testMethod void myTest5(){
		prepare();
		List<Messaging.SingleEmailMessage> mailList = (List<Messaging.SingleEmailMessage>) buildEmailList(false,1,null);
			
		system.debug('=====> is email turned off: ' + emailTurnedOff);
		if(!emailTurnedOff){
			EmailService.TestOptions opt = new EmailService.TestOptions();
			try{
				EmailService.sendEmails(mailList[0]);
				system.assert(true);
			}catch(Exception e1){
				system.assert(false);
			}
			
		}

		List<id> lstIds = new List<Id>();
		for(User u :[Select Id from User where isActive=true Limit 10]){
			lstIds.add(u.Id);
		}
		List<Messaging.MassEmailMessage> mailList2 = (List<Messaging.MassEmailMessage>) buildEmailList(true, 0, lstIds);

		if(!emailTurnedOff){
			try{
				EmailService.sendEmails(mailList2,true);
				system.assert(true);
			}catch(Exception e1){
				system.assert(false);
			}
		}

	}

	private static Object buildEmailList(Boolean isMass, Integer numRecords,List<Id> targetIds){
		List<Messaging.SingleEmailMessage> lstSingle = new List<Messaging.SingleEmailMessage>();
		List<Messaging.MassEmailMessage> lstMass = new List<Messaging.MassEmailMessage>();

		if(!isMass){
			for(Integer i = 0; i < numRecords; i++){
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setToAddresses(new String[] {'test@email.service'});
				mail.setSubject('Test');
				mail.setHtmlBody('Test 123');
				lstSingle.add(mail);
			}
			return lstSingle;
		}
		else{
			Messaging.MassEmailMessage emails = new Messaging.MassEmailMessage();
			emails.setTargetObjectIds(targetIds);
			//emails.setSubject('Test');
			emails.setTemplateId([Select Id from EmailTemplate limit 1].Id);
			emails.setSaveAsActivity(false);
			lstMass.add(emails);

			return lstMass;
		}
	}
	
}