package com.moreopen.monitor.console.utils;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;

import com.moreopen.monitor.console.biz.menu.RoleServiceImpl;
import com.moreopen.monitor.console.constant.MonitorConstant;
import com.moreopen.monitor.console.dao.bean.menu.RoleResourcePOJO;
import com.moreopen.monitor.console.dao.bean.menu.UserPOJO;
import com.moreopen.monitor.console.dao.bean.menu.UserRolePOJO;

/**
 * 封装对 HttpSession 中变量的读写操作
 */
@SuppressWarnings("unchecked")
public class SessionContextUtils {
	/**
	 * 获取当前登录的用户
	 * @param request
	 * @return
	 */
	public static String getCurrentUserId(HttpServletRequest request){
		HttpSession session=request.getSession();
		String userId = ((UserPOJO) session.getAttribute("user")).getUserId()+"";
		return userId;
	}

	public static void setRoleResources(HttpSession session, List<RoleResourcePOJO> roleResources) {
		session.setAttribute("roleResources", roleResources);
	}
	
	public static List<RoleResourcePOJO> getRoleResources(HttpSession session) {
		return (List<RoleResourcePOJO>) session.getAttribute("roleResources");
	}

	public static void resetRoleResources(HttpSession session, List<UserRolePOJO> roles, RoleServiceImpl roleServiceImpl) {
		List<RoleResourcePOJO> roleResources = new ArrayList<RoleResourcePOJO>();
		for (UserRolePOJO userRole : roles) {
			List<RoleResourcePOJO> resources = roleServiceImpl.getResourcesByRoleId(MonitorConstant.available, userRole.getRoleId());
			for (final RoleResourcePOJO roleResource : resources) {
				if (!CollectionUtils.exists(roleResources, new Predicate() {
					@Override
					public boolean evaluate(Object object) {
						return ((RoleResourcePOJO) object).getMenuId().equals(roleResource.getMenuId());
					}
				})) {
					roleResources.add(roleResource);
				}
			}
		}
		setRoleResources(session, roleResources);
	}

	public static void setUser(HttpSession session, UserPOJO userPOJO) {
		session.setAttribute("user",userPOJO);
	}
	
	public static UserPOJO getUser(HttpSession session) {
		return (UserPOJO) session.getAttribute("user");
	}

	public static void setRoles(HttpSession session, List<UserRolePOJO> roles) {
		session.setAttribute("roles", roles);
	}
	
	public static List<UserRolePOJO> getRoles(HttpSession session) {
		return (List<UserRolePOJO>) session.getAttribute("roles");
	}

	public static void setAdmin(HttpSession session, String value) {
		session.setAttribute("superAdmin", value);
	}
	
	public static boolean isAdmin(HttpSession session) {
		return "true".equals(session.getAttribute("superAdmin"));
	}

	
}
