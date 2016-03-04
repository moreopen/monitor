package com.moreopen.monitor.server.service;

import static com.moreopen.monitor.server.constant.MonitorConstant.charSet;
import static com.moreopen.monitor.server.constant.MonitorErrorConstant.ALARM_SENDSMS_ERROR;

import java.util.HashMap;
import java.util.Map;
import java.util.NoSuchElementException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import com.moreopen.monitor.server.exception.ServiceException;
import com.moreopen.monitor.server.util.HttpUtils;

/**
 * 发短信
 * 
 */
public class SMSServiceImpl {

	// String url="http://sms.y.sdo.com/services/sms/send";
	@Value("${sms.url}")
	private String url;
	
	@Autowired
	private ServiceException serviceException;

	/**
	 * 发送短信
	 * 
	 * @param userName
	 * @param phone
	 * @param message
	 * @return
	 * @throws NoSuchElementException
	 * @throws IllegalStateException
	 * @throws ServiceException
	 * @throws Exception
	 */
	public String sendSms(String phone, String message)
			throws NoSuchElementException, IllegalStateException,
			ServiceException {
		Map<String, String> getParams = new HashMap<String, String>();
		getParams.put("templateId", "10000212");
		getParams.put("pid", "200000000181");
		getParams.put("phone", phone);
		getParams.put("sms", message);

		String res = "";
		try {
			res = HttpUtils.getParams(url, getParams, charSet);
		} catch (Exception e) {
			serviceException.setError(ALARM_SENDSMS_ERROR,
					"alarm sendsms error", e.getStackTrace().toString());
			serviceException.toString();
			throw serviceException;
		}
		return res;
	}
}
