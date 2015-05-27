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
import com.moreopen.monitor.server.domain.MonitorData;

@Component
public class MonitorDataService implements InitializingBean {
	
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	private Executor executor = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors() + 1, new CustomizableThreadFactory("MonitorData-save-"));
	
	@Resource
	private JdbcTemplateBasedMonitorDataDao monitorDataDao;
	
	@Resource
	private RedisBasedMonitorSourceDao monitorSourceDao; 

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
					} catch (Exception e) {
						logger.error(String.format("add MonitorData failed, code [%s], value [%f], ip [%s]", 
								monitorData.getMonitorCode(), monitorData.getValue(), monitorData.getIp()), e
						);
					}
				}
			}
		});
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		System.out.println("============== init MonitorDataService");
	}

}
