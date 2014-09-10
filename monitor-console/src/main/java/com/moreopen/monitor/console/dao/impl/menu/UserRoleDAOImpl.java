package com.moreopen.monitor.console.dao.impl.menu;

import java.util.List;

import com.moreopen.monitor.console.dao.bean.menu.UserRolePOJO;
import com.moreopen.monitor.console.dao.impl.IBatisGenericDAOImpl;

public class UserRoleDAOImpl extends IBatisGenericDAOImpl {
	
	public UserRoleDAOImpl(){
		sqlMapNamespace = UserRolePOJO.class.getName();
	}
	
	public static final String POSTFIX_FINDALLROWSBYUSERID = ".findAllRolesByUserId";
	
	public void deleteUserRoleByUserId(Integer userId) {
		removeById(UserRolePOJO.class, userId);
	}
	
	public void deleteUserRoleByRoleId(Integer roleId) {
		remove(roleId);
	}

	@SuppressWarnings("unchecked")
	public List<UserRolePOJO> findAllRolesByUserId(Class<UserRolePOJO> clazz, Integer userId) {
		List<UserRolePOJO> list = getSqlMapClientTemplate().queryForList(
				sqlMapNamespace + POSTFIX_FINDALLROWSBYUSERID, userId);
		return list;
	}


}
