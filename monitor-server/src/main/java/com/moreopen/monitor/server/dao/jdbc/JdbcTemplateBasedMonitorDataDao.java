package com.moreopen.monitor.server.dao.jdbc;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.moreopen.monitor.server.domain.Alarm;
import com.moreopen.monitor.server.domain.Menu;
import com.moreopen.monitor.server.domain.MonitorData;
import com.moreopen.monitor.server.util.JsonUtils;

/**
 * 注意：监控数据表根据日期来建，一天对应一张表, 所以插入 sql 中的表名是动态变化的
 */

@Component
public class JdbcTemplateBasedMonitorDataDao {
	
	private static final String INSERT = "insert into monitor_data_event_%s(menu_code, figure, ipport, event_create_time) values (?, ?, ?, ?)";
	
	private static final String QUERY_MENU = "select menu_code, menu_name, alarm from monitor_menu where menu_code = ?";
	
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

	public Menu getMenu(String monitorCode) {
		List<Menu> list = this.jdbcTemplate.query(
				QUERY_MENU, 
				new Object[] {
					monitorCode
				}, 
				new RowMapper<Menu>() {
					@Override
					public Menu mapRow(ResultSet rs, int index) throws SQLException {
						Menu menu = new Menu();
						menu.setCode(rs.getString("menu_code"));
						menu.setName(rs.getString("menu_name"));
						String alarm = rs.getString("alarm");
						if (StringUtils.isNotBlank(alarm)) {
							menu.setAlarm(JsonUtils.json2Bean(alarm, Alarm.class));
						}
						return menu;
					}
				}
		);
		if (CollectionUtils.isEmpty(list)) {
			return null;
		}
		return list.get(0);
	}

}
