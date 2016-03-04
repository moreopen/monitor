package com.moreopen.monitor.server.service.alarm;

import java.util.ArrayList;
import java.util.List;

import com.moreopen.monitor.server.domain.Menu;
import com.moreopen.monitor.server.domain.MonitorData;

public class AlarmServiceChain implements AlarmService {
	
	private List<AlarmService> list = new ArrayList<AlarmService>();

	@Override
	public void alarm(Menu menu, MonitorData monitorData) {
		for (AlarmService alarmService : list) {
			alarmService.alarm(menu, monitorData);
		}
	}

	public void setList(List<AlarmService> list) {
		this.list = list;
	}

}
