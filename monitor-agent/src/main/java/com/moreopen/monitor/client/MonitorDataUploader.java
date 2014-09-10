package com.moreopen.monitor.client;

public interface MonitorDataUploader {
	
	void setValue(String key, Number value, MonitorDataType monitorDataType);

	void upload();

}
