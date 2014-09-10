package com.moreopen.monitor.console.utils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.moreopen.monitor.console.biz.menu.RoleServiceImpl;
import com.moreopen.monitor.console.biz.menu.UserRoleServiceImpl;
import com.moreopen.monitor.console.constant.MonitorConstant;
import com.moreopen.monitor.console.dao.bean.menu.UserPOJO;

public class AccessInterceptor implements HandlerInterceptor {

	@Autowired
	private UserRoleServiceImpl userRoleServiceImpl;

	@Autowired
	private RoleServiceImpl roleServiceImpl;

	@Override
	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3)
			throws Exception {

	}

	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3) throws Exception {

	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object arg2) throws Exception {
		HttpSession session = request.getSession();
		UserPOJO user = (UserPOJO) session.getAttribute("user");
		if (user == null) {
			response.sendRedirect("/monitor/login/toLoginPage.htm");
			return false;
		}
		if ("true".equals(request.getSession().getAttribute("superAdmin"))) {
			return true;
		}

		// 0、获取到访问路径，即资源的url
		String resourceUrl = request.getRequestURL().toString();
		if (doAdmin(resourceUrl)) {
			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().print(MonitorConstant.noPermissionNotice);
			return false;
		}
		return true;

	}

	private boolean doAdmin(String resourceUrl) {
		// XXX TODO 判断当前请求是否做管理类操作
		return false;
	}
}
