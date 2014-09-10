package com.moreopen.monitor.sms;

import java.util.NoSuchElementException;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.moreopen.monitor.server.service.alarm.SMSServiceImpl;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:/applicationContext-monitor-communication.xml"})
public class SMSTest {
	@Autowired
	private SMSServiceImpl smsService;
	@Test
	 public void testSendMail() {
		
		try {
			smsService.sendSms("13671880451", "test");
		} catch (NoSuchElementException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		 //mail.sendMail("标题", "内容", "收件人邮箱");
	    }
}