package com.moreopen.monitor.server.service;

import java.util.List;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.scheduling.concurrent.CustomizableThreadFactory;
import org.springframework.stereotype.Component;

import com.moreopen.monitor.server.dao.jdbc.JdbcTemplateBasedMonitorDataDao;
import com.moreopen.monitor.server.dao.redis.RedisBasedMonitorSourceDao;
import com.moreopen.monitor.server.domain.Alarm;
import com.moreopen.monitor.server.domain.Menu;
import com.moreopen.monitor.server.domain.MonitorData;
import com.moreopen.monitor.server.service.alarm.AlarmService;

@Component
public class MonitorDataService implements InitializingBean {
	
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	private Executor executor = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors() + 1, new CustomizableThreadFactory("MonitorData-save-"));
	
	@Resource
	private JdbcTemplateBasedMonitorDataDao monitorDataDao;
	
	@Resource
	private RedisBasedMonitorSourceDao monitorSourceDao; 
	
	@Resource(name = "alarmServiceChain")
	private AlarmService alarmServiceChain;

	/**
	 * @param monitorDatas 上报的监控数据
	 * @param ip 上报监控数据的应用方 ip
	 */
	public void save(final List<MonitorData> monitorDatas) {
		executor.execute(new Runnable() {
			@Override
			public void run() {
				for (MonitorData monitorData : monitorDatas) {
					try {
						monitorDataDao.add(monitorData);
						monitorSourceDao.update(monitorData.getMonitorCode(), monitorData.getIp());
						checkAlarm(monitorData);
					} catch (Exception e) {
						logger.error(String.format("add MonitorData failed, code [%s], value [%f], ip [%s]", 
								monitorData.getMonitorCode(), monitorData.getValue(), monitorData.getIp()), e
						);
					}
				}
			}
		});
	}

	//XXX 注意，此检查是针对单个应用服务器的监控数据检查，并没有汇总检查（所以设置监控值的时候需要考虑此因素，理论上认为每个服务器的上报的监控值都比较接近）
	protected void checkAlarm(MonitorData monitorData) {
		boolean doAlarm = false;
		boolean saveMenu = false;
		Menu menu = null;
		try {
			String monitorCode = monitorData.getMonitorCode();
			menu = monitorSourceDao.getMenu(monitorCode);
			if (menu == null) {
				menu = monitorDataDao.getMenu(monitorCode);
				if (menu == null) {
					logger.warn(String.format("can't find monitor menu by code [%s]", monitorCode));
					return;
				} else {
					if (logger.isInfoEnabled()) {
						logger.info(String.format("loaded menu [%s] from db", monitorCode));
					}
					saveMenu = true;
				}
			}
			Alarm alarm = menu.getAlarm();
			if (alarm == null) {
				return;
			}
			
			if (alarm.getAlarmValue() != null) {
				if ("lt".equals(alarm.getAlarmValueType())) {
					doAlarm =  monitorData.getValue() < alarm.getAlarmValue();
				} else {
					doAlarm = monitorData.getValue() > alarm.getAlarmValue();
				}
			}
			//如果已经触发报警，则忽略百分比报警设置
			if (!doAlarm && alarm.getAlarmPercent() != null) {
				Double lastData = menu.getLastData(monitorData.getIp());
				if (lastData != null) {//已经设置过值，则比较百分比
					if ("desc".equals(alarm.getAlarmPercentSort())) {
						if (monitorData.getValue() < lastData) {
							doAlarm = "lt".equals(alarm.getAlarmPercentType()) 
									? (lastData - monitorData.getValue()) / lastData * 100 < alarm.getAlarmPercent() 
											: (lastData - monitorData.getValue()) / lastData * 100 > alarm.getAlarmPercent(); 
						}
					} else {
						if (monitorData.getValue() > lastData) {
							doAlarm = "lt".equals(alarm.getAlarmPercentType()) 
									? (monitorData.getValue() - lastData) / lastData * 100 < alarm.getAlarmPercent() 
											: (monitorData.getValue() - lastData) / lastData * 100 > alarm.getAlarmPercent();
						}
					}
				}
			}
			if (alarm.getAlarmPercent() != null) {
				//set last data
				menu.setLastData(monitorData.getIp(), monitorData.getValue());
				saveMenu = true;
			}
			if (doAlarm) {
				//发送报警
				alarmServiceChain.alarm(menu, monitorData);
			}
		} catch (Exception e) {
			logger.error("exception : ", e);
			
		} finally {
			if (saveMenu && menu != null) {
				monitorSourceDao.saveMenu(menu);
			}
		}
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		System.out.println("============== init MonitorDataService");
	}

}
