package com.moreopen.monitor.sms;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.moreopen.monitor.server.service.alarm.EmailServiceImpl;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:/applicationContext-monitor-communication.xml"})
public class EmailTest {
//	@Autowired
	private EmailServiceImpl simpleMail;
	@Test
	 public void testSendMail() {
		 List<String> toList=new ArrayList<String>();
		 toList.add("yekai@163.com");

		 String[] strings = new String[toList.size()];

		 toList.toArray(strings);
		 simpleMail.sendMail("Spring SMTP Mail Subject123", "Spring SMTP Mail Text12345", strings);
		 //mail.sendMail("标题", "内容", "收件人邮箱");
	    }
	public EmailServiceImpl getSimpleMail() {
		return simpleMail;
	}
	public void setSimpleMail(EmailServiceImpl simpleMail) {
		this.simpleMail = simpleMail;
	}
	
}