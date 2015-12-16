package com.moreopen.monitor.server.domain;

public class Alarm {

	private String alarmPercentType;
	private Double alarmPercent;
	private String alarmPercentSort; 
	
	private String alarmValueType;
	private Long alarmValue;
	
	public Alarm() {}

	public Alarm(Long alarmValue, String alarmValueType, Double alarmPercent, String alarmPercentType, String alarmPercentSort) {
		this.alarmValue = alarmValue;
		this.alarmValueType = alarmValueType;
		this.alarmPercent = alarmPercent;
		this.alarmPercentType = alarmPercentType;
		this.alarmPercentSort = alarmPercentSort;

	}

	public String getAlarmPercentType() {
		return alarmPercentType;
	}

	public void setAlarmPercentType(String alarmPercentType) {
		this.alarmPercentType = alarmPercentType;
	}

	public Double getAlarmPercent() {
		return alarmPercent;
	}

	public void setAlarmPercent(Double alarmPercent) {
		this.alarmPercent = alarmPercent;
	}

	public String getAlarmValueType() {
		return alarmValueType;
	}

	public void setAlarmValueType(String alarmValueType) {
		this.alarmValueType = alarmValueType;
	}

	public Long getAlarmValue() {
		return alarmValue;
	}

	public void setAlarmValue(Long alarmValue) {
		this.alarmValue = alarmValue;
	}

	public String getAlarmPercentSort() {
		return alarmPercentSort;
	}

	public void setAlarmPercentSort(String alarmPercentSort) {
		this.alarmPercentSort = alarmPercentSort;
	}

}
