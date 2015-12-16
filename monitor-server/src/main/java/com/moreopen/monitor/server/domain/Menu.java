package com.moreopen.monitor.server.domain;

import java.util.HashMap;
import java.util.Map;

public class Menu {
	
	private String code;
	
	private String name;
	
	private Alarm alarm;
	
	private Map<String, Double> ip2Data= new HashMap<String, Double>();

	public Alarm getAlarm() {
		return alarm;
	}

	public void setAlarm(Alarm alarm) {
		this.alarm = alarm;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Double getLastData(String ip) {
		return ip2Data.get(ip);
	}

	public void setLastData(String ip, Double value) {
		ip2Data.put(ip, value);
	}

	public Map<String, Double> getIp2Data() {
		return ip2Data;
	}

	public void setIp2Data(Map<String, Double> ip2Data) {
		this.ip2Data = ip2Data;
	}

}
