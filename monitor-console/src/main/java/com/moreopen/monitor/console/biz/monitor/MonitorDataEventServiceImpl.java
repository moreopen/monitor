package com.moreopen.monitor.console.biz.monitor;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.moreopen.monitor.console.dao.bean.monitor.MonitorDataEventPOJO;
import com.moreopen.monitor.console.dao.jdbc.JdbcTemplatedBasedMonitorDataDAO;
import com.moreopen.monitor.console.utils.DateTools;


/**
 */
public class MonitorDataEventServiceImpl {
	
	@Autowired
	private JdbcTemplatedBasedMonitorDataDAO monitorDataDAO;

	
	/**根据 监控事件、监控项、时间发生时间 来查找列表
	 * @param eventId
	 * @param itemId
	 * @param date
	 * @return
	 */
	public List<MonitorDataEventPOJO> getListByEventIdItemIdEventCreateTimeIp(Long eventCreateTime,String ip, String menuCode) {
		
		Date dateFromTimeStamp = null;
		if (eventCreateTime != null) {
			dateFromTimeStamp = DateTools.getDateFromTimeStamp(eventCreateTime
					+ "");
		}

		List<MonitorDataEventPOJO> list = monitorDataDAO.findBy(ip, dateFromTimeStamp, menuCode);
		return list;
	}

	/**
	 * 根据 eventId、itemId、获取一天内所有数据
	 * @param eventId
	 * @param itemId
	 * @param ip
	 * @param startMillionSeconds
	 * @param endMillionSeconds
	 * @return
	 */
	public List<MonitorDataEventPOJO> getOneDayDataByEventIdItemIdDate(String date,String ip, String menuCode) {
		
		Date startMillionSeconds=DateTools.getDate(date+" 00:00:00");
		Date endMillionSeconds=DateTools.getDate(date+" 23:59:59");
		List<MonitorDataEventPOJO> list=monitorDataDAO.getOneDayDataByEventIdItemIdDate(ip, startMillionSeconds, endMillionSeconds, menuCode);
		return list;
	}
	
}
