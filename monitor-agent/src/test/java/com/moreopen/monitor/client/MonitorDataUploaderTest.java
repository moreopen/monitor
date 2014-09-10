package com.moreopen.monitor.client;

import org.junit.Before;
import org.junit.Test;

public class MonitorDataUploaderTest {
	
	private DefaultMonitorDataUploader monitorDataUploader;
	
	private String key0 = "999001000";
	
	private String key1 = "999001002";
	
	private String key2 = "999001001";
	
	private String url = "http://127.0.0.1:9090/monitor/data/upload";
	
	@Before
	public void before() throws Exception {
		monitorDataUploader = new DefaultMonitorDataUploader();
		monitorDataUploader.setMonitorUrl(url);
		monitorDataUploader.setHost("10.4.170.48");
		monitorDataUploader.afterPropertiesSet();
	}

	@Test
	public void test() {
		for (int i = 0; i < 10000; i++) {
			monitorDataUploader.setValue(key0, 1, MonitorDataType.INCREMENT);
			monitorDataUploader.setValue(key1, 2.01, MonitorDataType.AVERAGE);
			monitorDataUploader.setValue(key2, 3.6, MonitorDataType.MAX);
			if (i % 200 == 0) { 
				System.out.println("set value ====== " + i);
			}
			try {
				Thread.sleep(1000*1);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		while(true);
	}

}
