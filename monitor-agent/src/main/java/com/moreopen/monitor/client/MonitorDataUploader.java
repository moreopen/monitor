package com.moreopen.monitor.client;

public interface MonitorDataUploader {
	
	void setValue(String key, Number value, MonitorDataType monitorDataType);

	void upload();

	/**
	 * 递增设置 ratio 监控值
	 */
	void setRatioValue(String key, int value, Ratio ratio);
	
	/**
	 * 直接上报指定监控项对应的监控值
	 * 频率由应用方决定，此方法只负责上报数据
	 */
	void upload(String key, Number value);

}
