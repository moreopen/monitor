package com.moreopen.monitor.server.service.alarm;

import java.util.concurrent.TimeUnit;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;

import com.moreopen.monitor.server.domain.Menu;
import com.moreopen.monitor.server.domain.MonitorData;

public class ZXBasedAlarmService implements AlarmService {
	
	private Logger logger = LoggerFactory.getLogger(getClass()); 
	
	@Value("${zx.push.url}")
	private String zxPushUrl;
	
	@Value("${message.alarm.template}")
	private String messageAlarmTemplate;	 
	
	@Override
	public void alarm(Menu menu, MonitorData monitorData) {
		String body = "报警: [" + menu.getName() + "] 监控曲线有异常, 服务器地址 [" + monitorData.getIp() + "]";
		String message = String.format(messageAlarmTemplate, body, RandomStringUtils.randomAlphanumeric(4) + System.currentTimeMillis());
		send(message);
	}

	private void send(String message) {
		HttpClient httpClient = null;
		HttpPost httpPost = null;
		try {
			httpClient = new DefaultHttpClient();
			HttpParams httpParams = httpClient.getParams();
			HttpConnectionParams.setConnectionTimeout(httpParams, 5000);
			HttpConnectionParams.setSoTimeout(httpParams, 5000);
			httpPost = new HttpPost(zxPushUrl);
			httpPost.setEntity(new StringEntity(message, "UTF-8"));
			httpPost.setHeader("Content-Type", "application/json");
			if (logger.isDebugEnabled()) {
				logger.debug("HTTP request entity: {}", message);
			}
			HttpResponse response = httpClient.execute(httpPost);
			int responseStatusCode = response.getStatusLine().getStatusCode();
			if (responseStatusCode == 200) {
				if (logger.isInfoEnabled()) {
					logger.info(String.format("Send alarm message [%s] SUCCESS", message));
				}
			} else {
				logger.error("Send data Failure. HTTP response status code:{}", responseStatusCode);
			}
		} catch (Exception e) {
			logger.error("An error occurred while sending data to ZX Server.", e);
		} finally {
			if (httpPost != null) {
				httpPost.abort();
				//close connection at once
				httpClient.getConnectionManager().closeIdleConnections(0, TimeUnit.MILLISECONDS);
			}
		}
	
	}

	public void setZxPushUrl(String zxPushUrl) {
		this.zxPushUrl = zxPushUrl;
	}

	public void setMessageAlarmTemplate(String messageAlarmTemplate) {
		this.messageAlarmTemplate = messageAlarmTemplate;
	}

}
