package com.moreopen.monitor.client;

import org.apache.commons.lang.math.RandomUtils;
import org.junit.Before;
import org.junit.Test;

public class MonitorDataUploaderTest {
	
	private DefaultMonitorDataUploader monitorDataUploader;
	
	private String key0 = "999001000";
	
	private String key1 = "999001002";
	
	private String key2 = "999001001";
	
	private String key4MsgReceived = "999016000000";
	
	private String key4MsgSent = "999016000001";
	
	private String key4Login = "999002000000";
	
	private String key4LoginAveTime = "999002000001";
	
	private String key4LoginMaxTime = "999002000003";
	
//	private String url = "http://127.0.0.1:9090/monitor/data/upload";
	
	private String url = "http://192.168.11.102:9090/monitor/data/upload";
	
	@Before
	public void before() throws Exception {
		monitorDataUploader = new DefaultMonitorDataUploader();
		monitorDataUploader.setMonitorUrl(url);
		monitorDataUploader.setHost("10.4.170.48");
		monitorDataUploader.setUploadInterval(120);
		monitorDataUploader.afterPropertiesSet();
	}

	@Test
	public void test() {
		for (int i = 0; i < 1000000; i++) {
			monitorDataUploader.setValue(key0, 1 * RandomUtils.nextInt(20), MonitorDataType.INCREMENT);
			monitorDataUploader.setValue(key1, 2.01 * RandomUtils.nextInt(20), MonitorDataType.AVERAGE);
			monitorDataUploader.setValue(key2, 3.6 * RandomUtils.nextInt(20), MonitorDataType.MAX);
			
			monitorDataUploader.setValue(key4MsgReceived, 10 * RandomUtils.nextInt(50), MonitorDataType.INCREMENT);
			monitorDataUploader.setValue(key4MsgSent, 10 * RandomUtils.nextInt(50), MonitorDataType.INCREMENT);
			
			monitorDataUploader.setValue(key4Login, 5 * RandomUtils.nextInt(20), MonitorDataType.INCREMENT);
			monitorDataUploader.setValue(key4LoginAveTime, 10 * RandomUtils.nextInt(20), MonitorDataType.AVERAGE);
			monitorDataUploader.setValue(key4LoginMaxTime, 10 * RandomUtils.nextInt(20), MonitorDataType.MAX);
			
			if (i % 1000 == 0) {
				System.out.println("set value ====== " + i);
			}
			try {
				Thread.sleep(10*1);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		while(true);
	}

}
