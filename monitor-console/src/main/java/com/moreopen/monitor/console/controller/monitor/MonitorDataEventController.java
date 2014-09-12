package com.moreopen.monitor.console.controller.monitor;

import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.moreopen.monitor.console.biz.monitor.MonitorDataEventServiceImpl;
import com.moreopen.monitor.console.controller.BaseController;
import com.moreopen.monitor.console.dao.bean.monitor.MonitorDataEventPOJO;
import com.moreopen.monitor.console.utils.DateTools;
import com.moreopen.monitor.console.utils.JsonUtils;

@Controller
public class MonitorDataEventController  extends BaseController {
	
	@Autowired
	private MonitorDataEventServiceImpl monitorDataEventServiceImpl;
	
	/**
	 * 获取一天内所有的数据
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/dataEvent/getOneDayData",method = POST)
	public void getOneDayData(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String date = request.getParameter("date");
		String ip = request.getParameter("ip");
		String menuCode = request.getParameter("menuCode");
		List<MonitorDataEventPOJO> list = monitorDataEventServiceImpl.getOneDayDataByEventIdItemIdDate(date, ip, menuCode);
		
		outputResult2Client(response, JsonUtils.bean2Json(list));
		
	}
	/**
	 * 不断的获取数据，主要用于页面“持续的显示今天的”数据
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/dataEvent/getDataForEver",method = POST)
	public void getData(HttpServletRequest request,HttpServletResponse response) throws IOException {

		String menuCode = request.getParameter("menuCode");
		String eventCreateTime = request.getParameter("eventCreateTime");
		String ip = request.getParameter("ip");
		Long longEventCreateTime = null;
		if ((eventCreateTime != null) && (!eventCreateTime.equals(""))) {
			longEventCreateTime = Long.parseLong(eventCreateTime);
		} else {
			longEventCreateTime = DateTools.getTodayBegin();
		}
		
		List<MonitorDataEventPOJO> averageTimeList = monitorDataEventServiceImpl
				.getListByEventIdItemIdEventCreateTimeIp(longEventCreateTime, ip, menuCode);
		
		outputResult2Client(response, JsonUtils.bean2Json(averageTimeList));
		
	}
}
