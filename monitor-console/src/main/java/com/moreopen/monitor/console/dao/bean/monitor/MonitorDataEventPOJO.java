package com.moreopen.monitor.console.dao.bean.monitor;

import java.util.Date;

public class MonitorDataEventPOJO {
	
	private Integer id;

	private String menuCode;
	
	private Double figure;
	
	private Date eventCreateTime;//事件创建时间

	private Date createTime;//入库时间

	private String ipport;
	
	private String day;//仅仅是日期，比如2012-12-12
	
	private String time;//仅仅是时分秒，比如14:25:01
	
	public Date getEventCreateTime() {
		return eventCreateTime;
	}
	public void setEventCreateTime(Date eventCreateTime) {
		this.eventCreateTime = eventCreateTime;
	}
	public String getDay() {
		return day;
	}
	public void setDay(String day) {
		this.day = day;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Double getFigure() {
		return figure;
	}
	public void setFigure(Double figure) {
		this.figure = figure;
	}

	public String getIpport() {
		return ipport;
	}
	public void setIpport(String ipport) {
		this.ipport = ipport;
	}
	public String getMenuCode() {
		return menuCode;
	}
	public void setMenuCode(String menuCode) {
		this.menuCode = menuCode;
	}
	

}
