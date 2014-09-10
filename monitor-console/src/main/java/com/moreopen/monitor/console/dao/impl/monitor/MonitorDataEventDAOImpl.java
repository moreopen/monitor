package com.moreopen.monitor.console.dao.impl.monitor;

import com.moreopen.monitor.console.dao.bean.monitor.MonitorDataEventPOJO;
import com.moreopen.monitor.console.dao.impl.IBatisGenericDAOImpl;

public class MonitorDataEventDAOImpl extends IBatisGenericDAOImpl{
	public static final String POSTFIX_GETONEDAYEVENTIDITEMIDDATABYPAGE = ".getOneDayEventIdItemIdDataByPage";
	public static final String POSTFIX_GETONEDAYDATABYEVENTIDITEMIDDATE = ".getOneDayDataByEventIdItemIdDate";
	
	public MonitorDataEventDAOImpl() {
		sqlMapNamespace=MonitorDataEventPOJO.class.getName();
	}
}
