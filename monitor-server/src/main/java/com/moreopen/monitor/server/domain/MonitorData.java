package com.moreopen.monitor.server.domain;

public class MonitorData {
	
	/**
	 * 监控项代码
	 */
	private String monitorCode;
	
	/**
	 * 监控值
	 */
	private double value;
	
	/**
	 * 打点应用服务器 ip
	 */
	private String ip;
	
	/**
	 * 打点时间
	 */
	private long timestamp;
	
	public MonitorData(String code, double value, String ip, long timestamp) {
		this.monitorCode = code;
		this.value = value;
		this.ip = ip;
		this.timestamp = timestamp;
	}

	public String getMonitorCode() {
		return monitorCode;
	}

	public void setMonitorCode(String monitorCode) {
		this.monitorCode = monitorCode;
	}

	public double getValue() {
		return value;
	}

	public void setValue(double value) {
		this.value = value;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public long getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(long timestamp) {
		this.timestamp = timestamp;
	}
	
}
