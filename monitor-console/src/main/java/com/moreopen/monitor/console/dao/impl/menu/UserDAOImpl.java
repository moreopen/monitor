package com.moreopen.monitor.console.dao.impl.menu;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.moreopen.monitor.console.constant.MonitorConstant;
import com.moreopen.monitor.console.dao.bean.menu.UserPOJO;
import com.moreopen.monitor.console.dao.impl.IBatisGenericDAOImpl;

@SuppressWarnings({ "all"})
public class UserDAOImpl extends IBatisGenericDAOImpl {
	
	public static final String POSTFIX_QUERYALLUSERS = ".queryAllUsers";
	public static final String POSTFIX_QUERYUSERBYUSERNAMEANDPW = ".queryUserByUserNameAndPW";
	public static final String POSTFIX_QUERYUSERSBYIDLIST = ".queryUsersByIdList";

	public UserDAOImpl() {
		sqlMapNamespace = UserPOJO.class.getName();
	}

	/**
	 * 判断用户是否存在
	 * 
	 * @param userName
	 * @param passWord
	 * @return
	 */
	public boolean isUserExist(String userName) {
		Map map = new HashMap();
		map.put("userName", userName);
		map.put("status", MonitorConstant.available);

		Integer cnt = countBy(UserPOJO.class, map);
		return cnt > 0;
	}

	public UserPOJO queryUserByUserName(String userName) {
		List<UserPOJO> list = queryUser(userName, null);
		if (list != null && list.size() >= 0) {
			return list.get(0);
		} else {
			return null;
		}
	}

	public UserPOJO queryUserByUserNameAndPW(String userName, String passWord) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("userName", userName);
		map.put("password", passWord);
		List<UserPOJO> list = getSqlMapClientTemplate().queryForList(
				sqlMapNamespace + POSTFIX_QUERYUSERBYUSERNAMEANDPW, map);
		if (list != null && list.size() > 0) {
			return list.get(0);
		} else {
			return null;
		}
	}

	public List<UserPOJO> queryUser(String userName, String passWord) {
		Map map = new HashMap();

		if (StringUtils.isNotBlank(userName)) {
			map.put("userName", userName);
		}
		if (StringUtils.isNotBlank(passWord)) {
			map.put("password", passWord);
		}
		map.put("status", MonitorConstant.available);
		List<UserPOJO> list = findBy(UserPOJO.class, map);
		return list;
	}

	public List<UserPOJO> queryAllUser() {
		return getSqlMapClientTemplate().queryForList(
				sqlMapNamespace + POSTFIX_QUERYALLUSERS);
	}

	public List<UserPOJO> queryUsersByIdList(Class<UserPOJO> class1, Map map) {
		return getSqlMapClientTemplate().queryForList(
				sqlMapNamespace + POSTFIX_QUERYUSERSBYIDLIST, map);
	}
}
