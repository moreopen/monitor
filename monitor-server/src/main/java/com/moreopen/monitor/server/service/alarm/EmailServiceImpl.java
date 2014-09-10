package com.moreopen.monitor.server.service.alarm;

import org.springframework.mail.MailException;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;

/**
 * 发email
 *
 */
public class EmailServiceImpl {

	private MailSender mailSender;
	
    private SimpleMailMessage simpleMailMessage;

    public void sendMail(String subject, String content, String[] to) throws MailException {
        simpleMailMessage.setSubject(subject); 
        simpleMailMessage.setTo(to);           
        simpleMailMessage.setText(content);  
        mailSender.send(simpleMailMessage);
    }
    public void setSimpleMailMessage(SimpleMailMessage simpleMailMessage) {
        this.simpleMailMessage = simpleMailMessage;
    }
    public void setMailSender(MailSender mailSender) {
        this.mailSender = mailSender;
    }
}
