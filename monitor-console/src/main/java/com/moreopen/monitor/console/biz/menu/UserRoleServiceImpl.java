package com.moreopen.monitor.console.biz.menu;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import com.moreopen.monitor.console.dao.bean.menu.UserRolePOJO;
import com.moreopen.monitor.console.dao.impl.menu.UserRoleDAOImpl;

public class UserRoleServiceImpl {

	@Autowired
	private UserRoleDAOImpl userRoleDAOImpl;

	@SuppressWarnings("rawtypes")
	public List<UserRolePOJO> query(Map map) {
		return userRoleDAOImpl.findBy(UserRolePOJO.class, map);
	}

	public void removeById(Integer userId) {
		userRoleDAOImpl.removeById(UserRolePOJO.class, userId);
	}

	public void insert(UserRolePOJO userRolePOJO) {
		userRoleDAOImpl.insert(userRolePOJO);
	}

	public void deleteUserRoleByUserId(Integer userId) {
		userRoleDAOImpl.deleteUserRoleByUserId(userId);
	}

	public void deleteUserRoleByRoleId(Integer roleId) {
		userRoleDAOImpl.deleteUserRoleByRoleId(roleId);
	}

	public List<UserRolePOJO> findAllRolesByUserId(Integer userId) {
		return userRoleDAOImpl.findAllRolesByUserId(UserRolePOJO.class, userId);
	}

}
