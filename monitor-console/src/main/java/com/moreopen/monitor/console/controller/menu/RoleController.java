package com.moreopen.monitor.console.controller.menu;

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
import com.moreopen.monitor.console.constant.MonitorConstant;
import com.moreopen.monitor.console.controller.BaseController;
import com.moreopen.monitor.console.dao.bean.menu.RolePOJO;
import com.moreopen.monitor.console.dao.bean.menu.RoleResourcePOJO;
import com.moreopen.monitor.console.utils.JsonUtils;
import com.moreopen.monitor.console.utils.PageTools;
import com.moreopen.monitor.console.utils.SessionContextUtils;

@Controller
public class RoleController extends BaseController {
	
	@Autowired
	private RoleServiceImpl roleServiceImpl;
	
	/**
	 * 增
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/role/addRole",method = POST)
	public void addRole(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String roleName = request.getParameter("roleName");
		List<RolePOJO> list = roleServiceImpl.queryListByName(roleName);

		if (list.size() == 1) {// 如果数据库中已经存在该用户
			outputResult2Client(response, "exitis");
		} else {
			HttpSession session = request.getSession();
			Integer userId = Integer.valueOf(SessionContextUtils.getUser(session).getUserId());
			RolePOJO role = roleServiceImpl.addRole(roleName, userId);
			String result = JsonUtils.bean2Json(role);
			
			outputResult2Client(response, result);
		}
	}
	
	/**
	 * 删除角色
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/role/deleteRole",method = POST)
	public void deleteRole(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String roleId=request.getParameter("roleId");
		roleServiceImpl.deleteRoleByRoleId(Integer.valueOf(roleId));
		
		outputResult2Client(response, MonitorConstant.successMsg);
	}
	
	/**
	 * 修改角色名字
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/role/updateRoleName",method = POST)
	public void updateRoleName(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String roleId=request.getParameter("roleId");
		String roleName=request.getParameter("roleName");
		roleServiceImpl.updateRoleNameById(Integer.valueOf(roleId),roleName);
		
		outputResult2Client(response, MonitorConstant.successMsg);
		
	}
	
	/**
	 * 查询所有的角色以及分配的资源
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/role/queryAllRoleAndResource",method = POST)
	public void queryAllRoleAndResource(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		int status = request.getParameter("status") == null ? MonitorConstant.available : Integer.parseInt(request.getParameter("status"));
		String page = request.getParameter("page");
		String rows = request.getParameter("rows");

		Integer totalSize = roleServiceImpl.countByStatus(status);

		List<RolePOJO> list = roleServiceImpl.queryListByPage(status, PageTools.parsePage(page), PageTools.parseRows(rows));

		String result = JsonUtils.parseJson(totalSize, list);
		
		outputResult2Client(response, result);
	}
	
	/**
	 * 查询所有的角色(只查角色一个表)
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/role/queryAllRole",method = POST)
	public void queryAllRole(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		int status = request.getParameter("status") == null ? MonitorConstant.available : Integer.parseInt(request.getParameter("status"));
		String page = request.getParameter("page");
		String rows = request.getParameter("rows");

		Integer totalSize = roleServiceImpl.countByStatus(status);
		List<RolePOJO> list = roleServiceImpl.queryAllRole(status, PageTools.parsePage(page), PageTools.parseRows(rows));

		String result = JsonUtils.parseJson(totalSize, list);

		outputResult2Client(response, result);
		
	}
	
	/**
	 * 根据角色名来查询
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/role/queryByRoleName",method = POST)
	public void queryByRoleName(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		int status = request.getParameter("status") == null ? MonitorConstant.available : Integer.parseInt(request.getParameter("status"));
		
		String roleName = request.getParameter("roleName");
		if ("".equals(roleName)) {
			roleName = null;
		}

		Integer totalSize = roleServiceImpl.countByStatus(status);

		List<RolePOJO> list = roleServiceImpl.queryByRoleName(status, roleName);

		String result = JsonUtils.parseJson(totalSize, list);
		outputResult2Client(response, result);
	}
	
	/**
	 * 跳到角色编辑页面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/monitor/role/roleEditPage",method = GET)
	public ModelAndView roleEditPage() {
		ModelAndView mv = new ModelAndView("/admin/roleEdit");
		return mv;
	}
	
	
	/**
	 * 获取指定角色的所有的资源
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/role/getResourcesByRoleId",method = POST)
	public void getUsersByRoleId(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String roleId = request.getParameter("roleId");
		String status = request.getParameter("status") == null ? "1" : request.getParameter("status");
		List<RoleResourcePOJO> list = roleServiceImpl.getResourcesByRoleId(Integer.valueOf(status), Integer.valueOf(roleId));

		String result = JsonUtils.bean2Json(list);
		outputResult2Client(response, result);
	}
	
	/**
	 * 更新角色的资源
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/monitor/role/updateRoleMenus",method = POST)
	public void updateRoleMenus(HttpServletRequest request,HttpServletResponse response) throws IOException {
		String currentUserId = SessionContextUtils.getCurrentUserId(request);
		String roleId = request.getParameter("roleId");
		String menuIds = request.getParameter("menuIds");
		roleServiceImpl.updateRoleMenus(roleId, menuIds, currentUserId);

		outputResult2Client(response, MonitorConstant.successMsg);
		
	}
}
