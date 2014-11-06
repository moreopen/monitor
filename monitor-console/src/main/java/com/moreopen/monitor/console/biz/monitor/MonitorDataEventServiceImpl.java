package com.moreopen.monitor.console.biz.monitor;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.Assert;

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

	/**
	 * 按天取得该月份某个监控项的监控数据
	 * @param month 指定的月份:yyyy-MM
	 * @param menuCode 监控项
	 */
	public List<MonitorDataEventPOJO> getDataPerDayInMonth(String month,String menuCode) {
		Assert.isTrue(StringUtils.isNotBlank(month));
		List<Date> dates = DateTools.getAllDays(month);
		List<Date>[] datesArr = split(dates);
		List<MonitorDataEventPOJO> result = new ArrayList<MonitorDataEventPOJO>();
		for (Date date : datesArr[0]) {
			MonitorDataEventPOJO monitorData = monitorDataDAO.getDataPerDay(menuCode, date);
			if (monitorData == null) {
				monitorData = defaultMonitorData(menuCode, date, 0);
			}
			result.add(monitorData);
		}
		for (Date date : datesArr[1]) {
			result.add(defaultMonitorData(menuCode, date, 0));
		}
		return result;
	}

	private MonitorDataEventPOJO defaultMonitorData(String menuCode, Date date, double value) {
		MonitorDataEventPOJO monitorData = new MonitorDataEventPOJO();
		monitorData.setFigure(value);
		monitorData.setMenuCode(menuCode);
		monitorData.setDay(DateTools.simpleDateFormat(date));
		return monitorData;
	}

	/**
	 * 根据当前日期作分隔
	 * @param dates : 某月包含的日期
	 * @return List<Date>[2], 第一个元素存放 past dates (当前日期之前), 第二个元素存放 next dates （当前日期之后且包含当前日期）
	 */
	@SuppressWarnings("unchecked")
	private List<Date>[] split(List<Date> dates) {
		List<Date> pastDates = new ArrayList<Date>();
		List<Date> nextDates = new ArrayList<Date>();
		List<Date>[] datesArr = new List[] {pastDates, nextDates};
		long todayBeginTime = DateUtils.truncate(Calendar.getInstance().getTime(), Calendar.DAY_OF_MONTH).getTime();
		for (Date date : dates) {
			if (date.getTime() < todayBeginTime) {
				pastDates.add(date);
			} else {
				nextDates.add(date);
			}
		}
		return datesArr;
	}

	
}
