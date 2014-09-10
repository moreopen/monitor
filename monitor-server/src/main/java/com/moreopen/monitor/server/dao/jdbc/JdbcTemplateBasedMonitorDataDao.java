package com.moreopen.monitor.server.dao.jdbc;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import com.moreopen.monitor.server.domain.MonitorData;

/**
 * 注意：监控数据表根据日期来建，一天对应一张表, 所以插入 sql 中的表名是动态变化的
 */

@Component
public class JdbcTemplateBasedMonitorDataDao {
	
	private static final String INSERT = "insert into monitor_data_event_%s(menu_code, figure, ipport, event_create_time) values (?, ?, ?, ?)";
	
	@Autowired
	private JdbcTemplate jdbcTemplate;

	public void add(MonitorData monitorData) {
		Date date = new Date(monitorData.getTimestamp());
		String dateAsString = new SimpleDateFormat("yyyyMMdd").format(date);
		jdbcTemplate.update(String.format(INSERT, dateAsString), new Object[] {
				monitorData.getMonitorCode(), 
				monitorData.getValue(), 
				monitorData.getIp(), 
				new Date(monitorData.getTimestamp())
			}
		);
	}
	
	public static void main(String[] args) {
		System.out.println(String.format(INSERT, "2014-09-05"));
	}

}
