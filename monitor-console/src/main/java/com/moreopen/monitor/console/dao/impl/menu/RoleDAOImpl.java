package com.moreopen.monitor.console.dao.impl.menu;

import java.util.List;
import java.util.Map;

import com.moreopen.monitor.console.dao.bean.menu.RolePOJO;
import com.moreopen.monitor.console.dao.impl.IBatisGenericDAOImpl;

public class RoleDAOImpl extends IBatisGenericDAOImpl {

	public RoleDAOImpl() {
		sqlMapNamespace = RolePOJO.class.getName();
	}

	public static final String POSTFIX_QUERYALLROLE = ".queryAllRole";

	@SuppressWarnings("all")
	public List<RolePOJO> queryAllRole(Class<RolePOJO> class1, Map map) {
		return getSqlMapClientTemplate().queryForList(
				sqlMapNamespace + POSTFIX_QUERYALLROLE, map);
	}

}
