package com.moreopen.monitor.server.service.alarm;

import com.moreopen.monitor.server.domain.Menu;
import com.moreopen.monitor.server.domain.MonitorData;

public interface AlarmService {

	void alarm(Menu menu, MonitorData monitorData);

}
