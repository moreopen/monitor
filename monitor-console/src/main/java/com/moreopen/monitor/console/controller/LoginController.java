package com.moreopen.monitor.console.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.moreopen.monitor.console.biz.menu.RoleServiceImpl;
import com.moreopen.monitor.console.biz.menu.UserRoleServiceImpl;
import com.moreopen.monitor.console.biz.menu.UserServiceImpl;
import com.moreopen.monitor.console.constant.MonitorConstant;
import com.moreopen.monitor.console.dao.bean.menu.UserPOJO;
import com.moreopen.monitor.console.dao.bean.menu.UserRolePOJO;
import com.moreopen.monitor.console.utils.SessionContextUtils;

/**
 * 登录控制器
 *
 */
@Controller
public class LoginController extends BaseController {
	
	@Autowired
	private UserServiceImpl userServiceImpl;
	
	@Autowired
	private UserRoleServiceImpl userRoleServiceImpl;
	
	@Autowired
	private RoleServiceImpl roleServiceImpl;
	
	/**
	 * 校验用户密码。并进行登录
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/login/loginAction",method = POST)
	public void loginAction(HttpServletRequest request,HttpServletResponse response) {
		String userName=request.getParameter("userName");
		String password=request.getParameter("password");
		try {	
			UserPOJO userPOJO=userServiceImpl.queryUserByUserNameAndPW(userName, password);
			if(userPOJO==null){
				response.sendRedirect("/");
			}else{
				//@XXX TODO 暂时先这样，以后多机器的时候要考虑分布式session的管理机制
				HttpSession session=request.getSession();
				
				//put all user related property to session
				SessionContextUtils.setUser(session, userPOJO);
				
				List<UserRolePOJO> roles = userRoleServiceImpl.findAllRolesByUserId(userPOJO.getUserId());
				SessionContextUtils.setRoles(session, roles);
				
				for (UserRolePOJO userRole : roles) {
					if (MonitorConstant.superAdminRoleId == userRole.getRoleId().intValue()) {
						SessionContextUtils.setAdmin(session, "true");
						break;
					}
				}
				
				SessionContextUtils.resetRoleResources(session, roles, roleServiceImpl);
				
				response.sendRedirect("/monitor/main.htm");
			}
		} catch (Exception e) {
			logger.error("login failed", e);
		}
	}
	
	/**
	 * 跳到无权限界面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/monitor/authority/checkFail",method = GET)
	public ModelAndView checkFail(HttpServletResponse response) throws IOException {
		ModelAndView mv=new ModelAndView("/admin/checkFail");
		outputResult2Client(response, "checkFail");
		return mv;
	}
	/**
	 * 退出登录
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/monitor/login/exit",method = GET)
	public void exit(HttpServletRequest request,HttpServletResponse response) throws IOException {
		HttpSession session=request.getSession();
		session.invalidate();
		response.sendRedirect("/monitor/login/toLoginPage.htm");
	}
	
}
