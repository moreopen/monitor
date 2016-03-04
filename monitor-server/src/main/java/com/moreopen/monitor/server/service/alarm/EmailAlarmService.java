package com.moreopen.monitor.server.service.alarm;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;

import com.moreopen.monitor.server.domain.Menu;
import com.moreopen.monitor.server.domain.MonitorData;
import com.moreopen.monitor.server.service.MailService;

public class EmailAlarmService implements AlarmService, InitializingBean {
	
	private Logger logger =LoggerFactory.getLogger(getClass());
	
	private MailService mailService;
	
	private String tos;
	
	private String[] toArray;
	
	@Override
	public void afterPropertiesSet() throws Exception {
		if (StringUtils.isNotBlank(tos)) {
			toArray = tos.split(",");
		} else {
			logger.warn("=============== alarm.email.tos not configured, email alarm is disabled!");
		}
	}

	@Override
	public void alarm(Menu menu, MonitorData monitorData) {
		if (toArray == null || toArray.length == 0) {
			return;
		}
		String body = "报警: [" + menu.getName() + "] 监控曲线有异常, 服务器地址 [" + monitorData.getIp() + "]";
		mailService.sendMail(toArray, "Monitor Alert", body);
	}

	public void setMailService(MailService mailService) {
		this.mailService = mailService;
	}

	public void setTos(String tos) {
		this.tos = tos;
	}

}
