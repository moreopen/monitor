package com.moreopen.monitor.console.dao.jdbc;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.moreopen.monitor.console.dao.bean.monitor.MonitorDataEventPOJO;
import com.moreopen.monitor.console.utils.DateTools;

/**
 * 注意：监控数据表根据日期来建，一天对应一张表, 所以查询 sql 中的表名是动态变化的
 */
@Component
public class JdbcTemplatedBasedMonitorDataDAO {
	
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	private static final String QUERY_MONITOR_DATA = "select id, menu_code, "
			+ "date_format(event_create_time,'%Y-%m-%d %T') as create_time, date_format(event_create_time,'%Y-%m-%d') as day, date_format(event_create_time,'%T') as time, "
			+ "figure, ipport, event_create_time as event_create_time ";
	private static final String FROM_CLAUSE = "from monitor_data_event_%s where menu_code = ? ";
	
	private static final String QUERY_MONITOR_DATA_PER_DAY = "select sum(figure) as figure, menu_code from monitor_data_event_%s where menu_code = ? group by menu_code";
	
	
	public List<MonitorDataEventPOJO> findBy(String host, Date startDate, String menuCode) {
		return getOneDayDataByEventIdItemIdDate(host, startDate, null, menuCode);
	}
	
	public List<MonitorDataEventPOJO> getOneDayDataByEventIdItemIdDate(String host, Date startDate, Date endDate, String menuCode) {
		
		List<Object> paras = new ArrayList<Object>(3);
		paras.add(menuCode);
		String paraString = FROM_CLAUSE;
		if (StringUtils.isNotBlank(host)) {
			paraString = paraString + " and ipport = ?";
			paras.add(host);
		}
		
		paraString = paraString + " and event_create_time > ?";
		paras.add(startDate);
		String dateAsString = DateTools.abbreviatedDateFormat(startDate);
		
		if (endDate != null) {
			paraString = paraString + " and event_create_time <= ?";
			paras.add(endDate);
		}
		String queryString = QUERY_MONITOR_DATA + String.format(paraString, dateAsString);
		return jdbcTemplate.query(queryString, paras.toArray(), new RowMapper<MonitorDataEventPOJO> () {
			@Override
			public MonitorDataEventPOJO mapRow(ResultSet rs, int rowNum) throws SQLException {
				return buildMonitorDataEvent(rs);
			}
		});
	}
	
	private MonitorDataEventPOJO buildMonitorDataEvent(ResultSet rs) throws SQLException {
		MonitorDataEventPOJO config = new MonitorDataEventPOJO();
		config.setId(rs.getInt("id"));
		config.setMenuCode(rs.getString("menu_code"));
		config.setCreateTime(rs.getTimestamp("create_time"));
		config.setDay(rs.getString("day"));
		config.setTime(rs.getString("time"));
		config.setFigure(rs.getDouble("figure"));
		config.setIpport(rs.getString("ipport"));
		config.setEventCreateTime(rs.getTimestamp("event_create_time"));
		return config;
	}

	public MonitorDataEventPOJO getDataPerDay(final String menuCode, final Date date) {
		try {
			String queryString = QUERY_MONITOR_DATA_PER_DAY;
			queryString = String.format(queryString, DateTools.abbreviatedDateFormat(date));
			List<MonitorDataEventPOJO> list = jdbcTemplate.query(queryString, new Object[] {menuCode}, new RowMapper<MonitorDataEventPOJO> () {
				@Override
				public MonitorDataEventPOJO mapRow(ResultSet rs, int rowNum) throws SQLException {
					MonitorDataEventPOJO monitorData = new MonitorDataEventPOJO();
					monitorData.setFigure(rs.getDouble("figure"));
					monitorData.setMenuCode(menuCode);
					monitorData.setDay(DateTools.simpleDateFormat(date));
					return monitorData;
				}
			});
			return CollectionUtils.isNotEmpty(list) ? list.get(0) : null;
		} catch (Exception e) {
			logger.error("error:", e);
			return null;
		}
	}	
	

}
