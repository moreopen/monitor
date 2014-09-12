package com.moreopen.monitor.console.controller.menu;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.moreopen.monitor.console.biz.menu.UserRoleServiceImpl;
import com.moreopen.monitor.console.biz.menu.UserServiceImpl;
import com.moreopen.monitor.console.constant.MonitorConstant;
import com.moreopen.monitor.console.controller.BaseController;
import com.moreopen.monitor.console.dao.bean.menu.UserPOJO;
import com.moreopen.monitor.console.dao.bean.menu.UserRolePOJO;
import com.moreopen.monitor.console.utils.JsonUtils;
import com.moreopen.monitor.console.utils.PageTools;

@Controller
public class UserController extends BaseController {
	
	@Autowired
	private UserServiceImpl userServiceImpl;
	
	@Autowired
	private UserRoleServiceImpl userRoleServiceImpl;
	
	/**
	 * 增
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/user/addUser",method = POST)
	public void addUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String userName = request.getParameter("userName");
		String password = request.getParameter("password");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");

		UserPOJO userPOJO = new UserPOJO();
		userPOJO.setUserName(userName);
		userPOJO.setPassword(password);
		userPOJO.setPhone(phone);
		userPOJO.setEmail(email);
		userPOJO.setStatus(MonitorConstant.available);
		userPOJO.setCreateUserId(MonitorConstant.superAdminUserId);
		userPOJO.setCreateTime(new Date());

		
		boolean userExist = userServiceImpl.isUserExist(userName);
		if (userExist) {
			outputResult2Client(response, MonitorConstant.hasDataResult);
		} else {
			userServiceImpl.addUser(userPOJO);
			String result = JsonUtils.bean2Json(userPOJO);
			outputResult2Client(response, result);
		}
		
	}
	/**
	 * 删除
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/user/deleteUser",method = POST)
	public void delete(HttpServletRequest request,HttpServletResponse response) throws IOException {
		
		String userId = request.getParameter("userId");
		userServiceImpl.deleteUser(Integer.valueOf(userId));

		outputResult2Client(response, MonitorConstant.successMsg);
	}
	
	/**
	 * 改
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/user/updateUser",method = POST)
	public void update(HttpServletRequest request,HttpServletResponse response) throws IOException {
		
		String userId = request.getParameter("userId");
		String userName = request.getParameter("userName");
		String password = request.getParameter("password");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");

		userServiceImpl.update(Integer.parseInt(userId), userName, password, phone, email);
		outputResult2Client(response, MonitorConstant.successMsg);
	}
	/**
	 * 查
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/user/queryUser",method = POST)
	public void query(HttpServletRequest request,HttpServletResponse response) throws IOException {
		
		int status = request.getParameter("status") == null ? MonitorConstant.available : Integer.parseInt(request.getParameter("status"));

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("status", status);
		String userName = request.getParameter("userName");
		if ("".equals(userName)) {
			userName = null;
		}

		Integer page = PageTools.parsePage(request.getParameter("page"));
		Integer rows = PageTools.parseRows(request.getParameter("rows"));
		Integer startPostion = page * rows;
		Integer pageSize = rows;

		map.put("userName", userName);
		map.put("startPostion", startPostion);
		map.put("pageSize", pageSize);

		List<UserPOJO> list = userServiceImpl.query(map);

		Integer totalSize = userServiceImpl.count(map);

		String result = JsonUtils.parseJson(totalSize, list);

		outputResult2Client(response, result);
	}
	
	/**
	 * 跳到用户编辑页面
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value="/monitor/user/userEditPage",method=GET)
	public ModelAndView editMenu() {
		return new ModelAndView("/admin/userEdit");
	}
	

	/**
	 * 获取指定用户的所有角色
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/user/getRolesByUserId",method = POST)
	public void getRolesByUserId(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String userId = request.getParameter("userId");

		Map<String, Object> map = new HashMap<String, Object>();
		int status = request.getParameter("status") == null ? MonitorConstant.available : Integer.parseInt(request.getParameter("status"));
		map.put("status", status);
		map.put("userId", userId);
		List<UserRolePOJO> list = userRoleServiceImpl.findAllRolesByUserId(Integer.parseInt(userId));
		
		String result = JsonUtils.bean2Json(list);
		outputResult2Client(response, result);
	}
	
	/**
	 * 更新用户的角色
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/user/updateUserRole",method = POST)
	public void updateUserRole(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String userId = request.getParameter("userId");

		// 步骤1：先删除这个用户所有的角色
		userRoleServiceImpl.removeById(Integer.valueOf(userId));

		// 步骤2：把客户端传过来的所有角色循环插入到数据库
		String roleIds = request.getParameter("roleId");
		if (StringUtils.isNotBlank(roleIds)) {
			String roleIdArray[] = roleIds.split(",");
			if (roleIdArray.length != 0) {
				for (String s : roleIdArray) {
					UserRolePOJO userRolePOJO = new UserRolePOJO();
					userRolePOJO.setCreateTime(new Date());
					userRolePOJO.setCreateUserId(MonitorConstant.superAdminUserId);
					userRolePOJO.setRoleId(Integer.valueOf(s));
					userRolePOJO.setStatus(MonitorConstant.available);
					userRolePOJO.setUserId(Integer.valueOf(userId));
					userRoleServiceImpl.insert(userRolePOJO);
				}
			}
		}

		outputResult2Client(response, MonitorConstant.successMsg);
		
	}
	/**
	 * 查找所有的用户
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/user/queryAllUser",method = POST)
	public void queryAllUser(HttpServletResponse response) throws IOException {
		
		List<UserPOJO> list = userServiceImpl.queryAllUser();

		outputResult2Client(response, JsonUtils.bean2Json(list));
		
	}
}
