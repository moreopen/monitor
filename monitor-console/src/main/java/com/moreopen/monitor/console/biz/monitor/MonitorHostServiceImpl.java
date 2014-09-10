package com.moreopen.monitor.console.biz.monitor;

import java.util.Set;

import javax.annotation.Resource;

import com.moreopen.monitor.console.dao.redis.RedisBasedMonitorSourceDao;

public class MonitorHostServiceImpl {
	
	@Resource
	private RedisBasedMonitorSourceDao monitorSourceDao;

	public Set<String> getIpListByMonitorCode(String monitorCode) {
		Set<String> ips = monitorSourceDao.get(monitorCode);
		return ips;
	}

}
