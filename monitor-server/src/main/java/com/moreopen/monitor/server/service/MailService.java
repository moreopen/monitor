package com.moreopen.monitor.server.service;

import java.util.Properties;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSenderImpl;

public class MailService implements InitializingBean {
	
	private Logger log = Logger.getLogger(MailService.class);

	private JavaMailSenderImpl sender = new JavaMailSenderImpl();
	
	private String mailSender;
	
	private String mailSenderPass;	
	
	private String mailSenderServer;
	
	@Override
	public void afterPropertiesSet() throws Exception {
		sender.setHost(mailSenderServer);
		sender.setUsername(mailSender);  
		sender.setPassword(mailSenderPass);  
	}
	
	public boolean sendMail(String[] sendTo, String subject, String content) {
		
		SimpleMailMessage mailMessage = new SimpleMailMessage();
		mailMessage.setTo(sendTo);  
		mailMessage.setFrom(mailSender);  
		mailMessage.setSubject(subject);  
		mailMessage.setText(content);  
		    
		Properties prop = new Properties();  
		prop.put(" mail.smtp.auth ", " true ");  
		prop.put(" mail.smtp.timeout ", " 25000 ");  
		sender.setJavaMailProperties(prop);  
		// 发送邮件  
		try{
			sender.send(mailMessage);
		} catch (MailException e) {
			log.error(e);
		}
        return true;
	}

	public void setMailSenderPass(String mailSenderPass) {
		this.mailSenderPass = mailSenderPass;
	}

	public void setMailSenderServer(String mailSenderServer) {
		this.mailSenderServer = mailSenderServer;
	}

	public void setMailSender(String mailSender) {
		this.mailSender = mailSender;
	}
	
}
