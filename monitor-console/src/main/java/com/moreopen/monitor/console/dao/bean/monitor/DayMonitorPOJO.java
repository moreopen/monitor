package com.moreopen.monitor.console.dao.bean.monitor;

import java.io.Serializable;
import java.util.Date;

/**
 * 日监控对象
 *
 */
public class DayMonitorPOJO implements Serializable{
	
	private static final long serialVersionUID = 1L;

	private Long seqId;
	
	private String projectId;
	
	private String eventId;
	
	private int cnt;
	
	private Date createTime;
	
	private Date updateTime;


	public Long getSeqId() {
		return seqId;
	}

	public void setSeqId(Long seqId) {
		this.seqId = seqId;
	}

	public String getProjectId() {
		return projectId;
	}

	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}

	public String getEventId() {
		return eventId;
	}

	public void setEventId(String eventId) {
		this.eventId = eventId;
	}


	public int getCnt() {
		return cnt;
	}

	public void setCnt(int cnt) {
		this.cnt = cnt;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	

}
