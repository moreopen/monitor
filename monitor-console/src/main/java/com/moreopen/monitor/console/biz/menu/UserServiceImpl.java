package com.moreopen.monitor.console.biz.menu;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import com.moreopen.monitor.console.dao.bean.menu.UserPOJO;
import com.moreopen.monitor.console.dao.impl.menu.UserDAOImpl;
import com.moreopen.monitor.console.dao.impl.menu.UserRoleDAOImpl;

public class UserServiceImpl {

	@Autowired
	private UserDAOImpl userDAOImpl;

	@Autowired
	private UserRoleDAOImpl userRoleDAOImpl;

	public void addUser(UserPOJO userPOJO) {
		userDAOImpl.insert(userPOJO);
	}

	@SuppressWarnings("rawtypes")
	public List<UserPOJO> query(Map map) {
		List<UserPOJO> list = userDAOImpl.findBy(UserPOJO.class, map);
		return list;
	}

	public UserPOJO queryUserByUserNameAndPW(String userName, String passWord) {
		return userDAOImpl.queryUserByUserNameAndPW(userName, passWord);
	}

	public UserPOJO queryUserByUserName(String userName) {
		return userDAOImpl.queryUserByUserName(userName);
	}

	public boolean isUserExist(String userName) {
		return userDAOImpl.isUserExist(userName);
	}

	@SuppressWarnings("rawtypes")
	public Integer count(Map map) {
		Integer size = userDAOImpl.countBy(UserPOJO.class, map);
		return size;
	}

	public void update(Integer userId, String userName, String password,
			String phone, String email) {
		UserPOJO user = new UserPOJO();
		user.setUserId(userId);
		user.setPassword(password);
		user.setUserName(userName);
		user.setPhone(phone);
		user.setEmail(email);
		userDAOImpl.update(user);
	}

	public void deleteUser(Integer userId) {
		userDAOImpl.removeById(UserPOJO.class, userId);
		userRoleDAOImpl.deleteUserRoleByUserId(userId);
	}

	public List<UserPOJO> queryAllUser() {
		return userDAOImpl.queryAllUser();
	}
}
