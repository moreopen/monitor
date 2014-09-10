package com.moreopen.monitor.console.biz.menu;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import com.moreopen.monitor.console.constant.MonitorConstant;
import com.moreopen.monitor.console.dao.bean.menu.RolePOJO;
import com.moreopen.monitor.console.dao.bean.menu.RoleResourcePOJO;
import com.moreopen.monitor.console.dao.impl.menu.RoleDAOImpl;
import com.moreopen.monitor.console.dao.impl.menu.UserRoleDAOImpl;
import com.moreopen.monitor.console.dao.jdbc.JdbcTemplateBasedRoleDAO;

public class RoleServiceImpl {
	
	@Autowired
	private RoleDAOImpl roleDAOImpl;
	
	@Autowired
	private UserRoleDAOImpl userRoleDAOImpl;
	
	@Autowired
	private JdbcTemplateBasedRoleDAO jdbcTemplateBasedRoleDAO;
	
	public RolePOJO addRole(String roleName, Integer userId) {
		RolePOJO role = new RolePOJO();
		role.setRoleName(roleName);
		role.setCreateTime(new Date());
		role.setCreateUserId(userId);
		role.setStatus(MonitorConstant.available);
		role.setUpdateTime(new Date());
		role.setUpdateUserId(userId);
		roleDAOImpl.insert(role);

		return role;
	}
	
	public List<RolePOJO> queryListByPage(Integer status, int page, int rows) {
		int startPostion = page * rows;
		int pageSize = rows;
		List<RolePOJO> list = jdbcTemplateBasedRoleDAO.getRoles(startPostion, pageSize, status);
		return list;
	}
	
	public Integer countByStatus(Integer status) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("status", status);
		Integer size = roleDAOImpl.countBy(RolePOJO.class, map);
		return size;
	}

	/**
	 * 根据roleId修改角色名字
	 * @param roleId
	 * @param roleName
	 */
	public void updateRoleNameById(Integer roleId, String roleName) {
		RolePOJO role = new RolePOJO();
		role.setRoleId(roleId);
		role.setRoleName(roleName);
		roleDAOImpl.update(role);
	}
	/**
	 * 删除角色 及其对应用的所有关联
	 * @param roleId
	 */
	public void deleteRoleByRoleId(Integer roleId) {

		// 同时删除 用户角色表中对应的数据
		userRoleDAOImpl.deleteUserRoleByRoleId(roleId);

		jdbcTemplateBasedRoleDAO.removeMenusByRoleId(roleId);

		roleDAOImpl.removeById(RolePOJO.class, roleId);
	}

	public List<RolePOJO> queryAllRole(Integer status, int page, int rows) {

		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("status", status);
		Integer startPostion = page * rows;
		Integer pageSize = rows;
		map.put("startPostion", startPostion);
		map.put("pageSize", pageSize);
		
		return roleDAOImpl.queryAllRole(RolePOJO.class, map);
	}
	
	public List<RolePOJO> queryListByName(String roleName) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("roleName", roleName);
		List<RolePOJO> list = roleDAOImpl.findBy(RolePOJO.class, map);
		return list;
	}
	
	public List<RolePOJO> queryByRoleName(Integer status, String roleName) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("status", status);
		if (roleName != null) {
			map.put("roleName", roleName);
		}
		List<RolePOJO> list = roleDAOImpl.findBy(RolePOJO.class, map);
		return list;
	}

	public void updateRoleMenus(String roleId, String menuIds, String userId) {
		jdbcTemplateBasedRoleDAO.removeMenusByRoleId(Integer.valueOf(roleId));//首先删掉所有已经分配的菜单
		if (StringUtils.isNotBlank(menuIds)) {
			String resourceIdArray[] = menuIds.split(",");//然后重新分配资源
			if (resourceIdArray.length != 0) {
				for (String s : resourceIdArray) {
					addRoleMenu(Integer.valueOf(roleId), Integer.valueOf(userId), Integer.valueOf(s));
				}
			}
		}
		
	}

	public void addRoleMenu(int roleId, int userId, int menuId) {
		Date date = new Date();
		RoleResourcePOJO rr=new RoleResourcePOJO();
		rr.setCreateTime(date);
		rr.setCreateUserId(Integer.valueOf(userId));
		rr.setMenuId(menuId);
		rr.setRoleId(roleId);
		rr.setStatus(MonitorConstant.available);
		rr.setUpdateTime(date);
		rr.setUpdateUserId(userId);
		jdbcTemplateBasedRoleDAO.insert(rr);
	}

	public List<RoleResourcePOJO> getResourcesByRoleId(int status, int roleId) {
		return jdbcTemplateBasedRoleDAO.getResourcesByRoleId(status, roleId);
	}

}
