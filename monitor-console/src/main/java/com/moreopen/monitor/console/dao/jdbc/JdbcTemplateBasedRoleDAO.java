package com.moreopen.monitor.console.dao.jdbc;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.moreopen.monitor.console.dao.bean.menu.RolePOJO;
import com.moreopen.monitor.console.dao.bean.menu.RoleResourcePOJO;
import com.moreopen.monitor.console.utils.DateTools;

@Component
public class JdbcTemplateBasedRoleDAO {
	
	private static final String INSERT_ROLE_RESOURCE = "insert into monitor_role_resource(role_id, menu_id, create_time, create_userid, update_time, update_userid, status) "
			+ "values(?, ?, ?, ?, ?, ?, ?)";

	private static final String DELETE_BY_ROLE = "delete from monitor_role_resource where role_id = ?";
	
	private static final String DELETE_BY_MENU = "delete from monitor_role_resource where menu_id = ?";
	
	private static final String QUERY_ROLES = "select temp.*, monitor_user.user_name as updateUserName from" 
			+ " (select monitor_role.role_id, monitor_role.role_name, GROUP_CONCAT(t.menu_name) as resourceNames, "
			+ " monitor_role.create_time as create_time, monitor_role.update_time as update_time, monitor_user.user_name as createUserName, "
			+ " monitor_role.update_userid, monitor_role.status as status "
			+ "from monitor_role left join ("
				+ "	select monitor_role_resource.menu_id, monitor_role_resource.role_id, monitor_menu.menu_name" 
				+ "	from monitor_role_resource, monitor_menu"
				+ "	where monitor_role_resource.menu_id=monitor_menu.id ) as t on monitor_role.role_id = t.role_id"
				+ " left join monitor_user on monitor_role.create_userid = monitor_user.user_id group by monitor_role.role_id) as temp"
				+ " left join monitor_user on temp.update_userid=monitor_user.user_id"
				+ " where temp.status = ? limit ?, ?";

	/**
	 * <select id="selectByMap" parameterClass="java.util.Map" resultMap="resourceRolePOJOResult">
		select 
			rr.role_id as ROLE_ID,
			rr.resource_id as RESOURCE_ID,
			rr.create_time as CREATE_TIME,
			rr.CREATE_USERID as CREATE_USERID,
			rr.UPDATE_USERID as UPDATE_USERID,
			rr.UPDATE_TIME as UPDATE_TIME,
			r.resource_name as RESOURCE_NAME,
			r.resource_url as RESOURCE_URL,
			rr.status as STATUS
		from 
			monitor_role_resource as rr 
		LEFT JOIN 
			monitor_resource as r 
		on 
			rr.resource_id =r.resource_id
		<dynamic prepend="where">
			<isNotNull prepend="and" property="roleId">
				rr.role_id=#roleId#
			</isNotNull>
			<isNotNull prepend="and" property="status">
				rr.status=#status#
			</isNotNull>
		</dynamic>
	</select>
	 */
	private static final String QUERY_RESOURCES_BY_ROLE = 
			"select distinct monitor_role_resource.*, monitor_menu.menu_name from monitor_role_resource"
					+ " left join monitor_menu on monitor_role_resource.menu_id = monitor_menu.id" 
						+ " where monitor_role_resource.role_id = ? and monitor_role_resource.status = ? and monitor_role_resource.menu_id is not null" ;

	
	/**
	 * SELECT 
				monitor_role.ROLE_ID as ROLE_ID,
				monitor_role.ROLE_NAME as ROLE_NAME,
				monitor_role.CREATE_USERID as CREATE_USERID,
				monitor_role.CREATE_TIME as CREATE_TIME,
				monitor_role.UPDATE_USERID as UPDATE_USERID,
				monitor_role.UPDATE_TIME as UPDATE_TIME,
				monitor_role.STATUS as STATUS,
				GROUP_CONCAT(t.RESOURCE_NAME) as resourceNames,
				monitor_user.user_name as createUserName,
				date_format(monitor_role.CREATE_TIME,'%Y-%m-%d %T') as createTimeFormat,
				date_format(monitor_role.UPDATE_TIME,'%Y-%m-%d %T') as updateTimeFormat
			FROM monitor_role 
			LEFT JOIN
				(
					select monitor_role_resource.resource_id,monitor_role_resource.role_id,monitor_resource.resource_name 
					from monitor_role_resource,monitor_resource 
					where monitor_role_resource.resource_id=monitor_resource.resource_id 
				) as t
			on monitor_role.role_id =t.role_id 
			left join monitor_user
			on monitor_role.CREATE_USERID=monitor_user.user_id
				GROUP BY role_id
		)as temp left join monitor_user
		on temp.UPDATE_USERID=monitor_user.user_id
	 */
	
	@Resource
	private JdbcTemplate jdbcTemplate;

	public void removeMenusByRoleId(Integer roleId) {
		this.jdbcTemplate.update(DELETE_BY_ROLE, new Object[] {roleId});
		
	}
	
	public void removeMenus(Integer menuId) {
		this.jdbcTemplate.update(DELETE_BY_MENU, new Object[] {menuId});
	}

	public void insert(RoleResourcePOJO rr) {
		this.jdbcTemplate.update(
				INSERT_ROLE_RESOURCE,
				new Object[] { rr.getRoleId(), rr.getMenuId(),
						rr.getCreateTime(), rr.getCreateUserId(),
						rr.getUpdateTime(), rr.getUpdateUserId(),
						rr.getStatus() }
		);
		
	}

	public List<RolePOJO> getRoles(Integer start, Integer size, Integer status) {
		return this.jdbcTemplate.query(QUERY_ROLES, new Object[] {status, start, size}, new RowMapper<RolePOJO>() {
			@Override
			public RolePOJO mapRow(ResultSet rs, int index) throws SQLException {
				RolePOJO role = new RolePOJO();
				role.setRoleId(rs.getInt("role_id"));
				role.setRoleName(rs.getString("role_name"));
				role.setResourceNames(rs.getString("resourceNames"));
				role.setCreateTime(rs.getTimestamp("create_time"));
				role.setCreateUserName(rs.getString("createUserName"));
				role.setUpdateTime(rs.getTimestamp("update_time"));
				role.setUpdateUserName(rs.getString("updateUserName"));
				role.setCreateTimeFormat(DateTools.formatTimeStamp(role.getCreateTime()));
				role.setUpdateTimeFormat(DateTools.formatTimeStamp(role.getUpdateTime()));
				return role;
			}
			
		});
	}

	public List<RoleResourcePOJO> getResourcesByRoleId(int status, int roleId) {
		return this.jdbcTemplate.query(QUERY_RESOURCES_BY_ROLE, new Object[] {roleId, status}, new RowMapper<RoleResourcePOJO>() {
			@Override
			public RoleResourcePOJO mapRow(ResultSet rs, int index) throws SQLException {
				RoleResourcePOJO roleResourcePOJO = new RoleResourcePOJO();
				roleResourcePOJO.setRoleId(rs.getInt("role_id"));
				roleResourcePOJO.setMenuId(rs.getInt("menu_id"));
				roleResourcePOJO.setCreateTime(rs.getTimestamp("create_time"));
				roleResourcePOJO.setUpdateTime(rs.getTimestamp("update_time"));
				roleResourcePOJO.setMenuName(rs.getString("menu_name"));
				return roleResourcePOJO;
			}});
	}

}
