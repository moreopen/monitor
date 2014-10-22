package com.moreopen.monitor.server.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.moreopen.monitor.server.domain.MonitorData;
import com.moreopen.monitor.server.service.MonitorDataService;

@Controller
public class DataUploadController {
	
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Resource
	private MonitorDataService monitorDataService;
	
	/**
	 * request ex: action=999001002,10&action=999001003,20&action=999001004,10.02&ip=192.168.10.12
	 * action 表示一个监控项的数据，用 , 号分隔，前项表示监控项代码，后者表示对应的监控值，一个请求支持多个监控项上报
	 */
	@RequestMapping("/data/upload")
	public void upload(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String[] actions = request.getParameterValues("action");
		if (actions == null || actions.length == 0) {
			if (logger.isInfoEnabled()) {
				logger.info("no action data");
			}
			return;
		}
		String ip = request.getParameter("ip");
		String timestampStr = request.getParameter("timestamp");
		long timestamp = 0;
		if (timestampStr != null) {
			try {
				timestamp = Long.parseLong(timestampStr);
			} catch (Exception e) {
				logger.warn(String.format("invalid timestamp [%s]", timestampStr));
				timestamp = System.currentTimeMillis();
			}
		} else {
			timestamp = System.currentTimeMillis();
		}
		List<MonitorData> monitorDatas = parse(actions, ip, timestamp);
		monitorDataService.save(monitorDatas);
	}

	private List<MonitorData> parse(String[] actions, String ip, long timestamp) {
		List<MonitorData> list = new ArrayList<MonitorData>(actions.length);
		for (String action : actions) {
			String[] keyValue = action.split(",");
			if (keyValue.length != 2) {
				logger.warn("invalid action, skip and contiune");
				continue;
			}
			if (StringUtils.isBlank(keyValue[0])) {
				logger.warn("action code can't be blank, skip and continue");
				continue;
			}
			double value = 0d;
			try {
				value = Double.parseDouble(keyValue[1]);
			} catch (Exception e) {
				logger.warn(String.format("invalid monitor value [%s], use default value", keyValue[1]));
			}
			MonitorData monitorData = new MonitorData(keyValue[0].trim(), value, ip, timestamp);
			list.add(monitorData);
		}
		return list;
	}
}
