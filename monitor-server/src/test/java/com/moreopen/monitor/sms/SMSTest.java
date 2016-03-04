package com.moreopen.monitor.sms;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.moreopen.monitor.server.service.SMSServiceImpl;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:/applicationContext-monitor-communication.xml"})
public class SMSTest {
	
	@Autowired
	private SMSServiceImpl smsService;
	
	@Test
	 public void testSendMail() {
		
//		try {
//			smsService.sendSms("13671880451", "test");
//		} catch (Exception e) {
//			e.printStackTrace();
//	    }
	}
}