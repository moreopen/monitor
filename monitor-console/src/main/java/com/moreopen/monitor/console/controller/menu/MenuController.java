package com.moreopen.monitor.console.controller.menu;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.moreopen.monitor.console.biz.menu.MenuServiceImpl;
import com.moreopen.monitor.console.biz.menu.RoleServiceImpl;
import com.moreopen.monitor.console.constant.MonitorConstant;
import com.moreopen.monitor.console.controller.BaseController;
import com.moreopen.monitor.console.dao.bean.menu.Alarm;
import com.moreopen.monitor.console.dao.bean.menu.MenuPOJO;
import com.moreopen.monitor.console.dao.bean.menu.RoleResourcePOJO;
import com.moreopen.monitor.console.dao.bean.menu.UserRolePOJO;
import com.moreopen.monitor.console.dao.jdbc.JdbcTemplateBasedMenuDAO;
import com.moreopen.monitor.console.utils.JsonUtils;
import com.moreopen.monitor.console.utils.PageTools;
import com.moreopen.monitor.console.utils.SessionContextUtils;
import com.moreopen.monitor.console.utils.Tree;

/**
 * 菜单控制器
 * XXX 新增二级菜单自动关联到当前用户所属角色，删除二级菜单自动删除 RoleResource 中对应数据, 并刷新 session 中的数据
 */
@Controller
public class MenuController extends BaseController {
	
	@Autowired
	private MenuServiceImpl menuServiceImpl;
	
	@Autowired
	private JdbcTemplateBasedMenuDAO menuDAO;
	
	@Autowired
	private RoleServiceImpl roleServiceImpl;

	/**
	 * 获取菜单树
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/monitor/menu/getMenuTree", method = POST)
	public void getAllMenu(HttpServletRequest request,HttpServletResponse response) {
		try {
			String menuPid = request.getParameter("id");
			if (menuPid == null) {
				menuPid = MonitorConstant.defaultRootMenuId;// 默认显示pid为defaultPIdForMenuTree的子菜单
			}
			int status = request.getParameter("status") == null ? MonitorConstant.available: Integer.parseInt(request.getParameter("status"));
			List<MenuPOJO> menuList = menuServiceImpl.getMenuTree(status, menuPid);

			filterMenu(request, menuPid, menuList);
			
			String result = Tree.getMenuJSON(menuList);
			
			outputResult2Client(response, result);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void filterMenu(HttpServletRequest request, String menuPid, List<MenuPOJO> menuList) {
		//filter menu by user role, 如果是超级管理员，直接跳过, 并且只检查二级菜单的可见性
		if(!SessionContextUtils.isAdmin(request.getSession()) && MonitorConstant.defaultRootMenuId.equals(menuPid)) {
			List<RoleResourcePOJO> roleResources = SessionContextUtils.getRoleResources(request.getSession());
			for (Iterator<MenuPOJO> iter = menuList.iterator();iter.hasNext();) {
				MenuPOJO menu = iter.next();
				boolean removed = true;
				for (RoleResourcePOJO roleResource : roleResources) {
					if (menu.getId().equals(roleResource.getMenuId())) {
						removed = false;
						break;
					}
				}
				if (removed) {
					iter.remove();
				}
			}
		}
	}

	/**
	 * 返回可编辑的菜单JSON
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/monitor/menu/getEditMenu", method = POST)
	public void getAdminMenu(HttpServletRequest request,HttpServletResponse response) {
		String menuPid = request.getParameter("id");
		if (menuPid == null) {
			menuPid = MonitorConstant.defaultRootMenuId;
		}
		
		int status = request.getParameter("status") == null ? MonitorConstant.available : Integer.valueOf(request.getParameter("status"));
		Integer page = PageTools.parsePage(request.getParameter("page"));
		Integer rows = PageTools.parseRows(request.getParameter("rows"));
		
		List<MenuPOJO> menuList = menuServiceImpl.getEditMenu(menuPid, status, page, rows);
		
		filterMenu(request, menuPid, menuList);
		
		StringBuffer strB = new StringBuffer();
		strB.append(Tree.getEditMenuJSON(menuList));
		try {
			outputResult2Client(response, strB.toString());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 跳到菜单编辑页面
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/monitor/menu/menuEditPage", method = GET)
	public ModelAndView editMenu() {
		ModelAndView mv = new ModelAndView("/admin/menuEdit");
		return mv;
	}

	/**
	 * 更新菜单名字
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/monitor/menu/updateMenuName", method = POST)
	public void updateMenuName(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		HttpSession session = request.getSession();
		String menuId = request.getParameter("id");
		String menuName = request.getParameter("menuName");
		Integer userId = Integer.valueOf(SessionContextUtils.getUser(session).getUserId());

		menuServiceImpl.updateMenuName(Integer.parseInt(menuId), menuName, userId);
		outputResult2Client(response, menuName);
	}

	/**
	 * 添加菜单
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/monitor/menu/addMenu", method = POST)
	public void addMenu(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		HttpSession session = request.getSession();
		Integer userId = SessionContextUtils.getUser(session).getUserId();
		String parentMenuId = request.getParameter("menuPid");
		String menuName = request.getParameter("menuName");
		String parentMenuCode = request.getParameter("menuPCode");
		MenuPOJO menu = menuServiceImpl.addMenu(userId, Integer.parseInt(parentMenuId), menuName, parentMenuCode);
		if (menu != null) {
			//新增二级菜单自动关联到当前用户所属角色(之一)
			if ( !SessionContextUtils.isAdmin(session) && MonitorConstant.defaultRootMenuId.equals(parentMenuId)) {
				List<UserRolePOJO> roles = SessionContextUtils.getRoles(session);
				if (CollectionUtils.isNotEmpty(roles)) { 
					menu = menuServiceImpl.findByMenuCode(menu.getMenuCode());
					Assert.notNull(menu);
					roleServiceImpl.addRoleMenu(roles.iterator().next().getRoleId(), userId, menu.getId());
					SessionContextUtils.resetRoleResources(session, roles, roleServiceImpl);
				}
			}

		}
		outputResult2Client(response, MonitorConstant.successMsg);
		
	}

	/**
	 * 删除菜单
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/monitor/menu/delMenu", method = POST)
	public void delMenu(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession();
		String menuId = request.getParameter("id");
		
		MenuPOJO menu = menuServiceImpl.findByMenuId(Integer.parseInt(menuId));
		if (menu == null) {
			outputResult2Client(response, MonitorConstant.successMsg);
			return;
		}
		//XXX 不能直接删除父节点
		if (menu.getMenuIsleaf() != null && menu.getMenuIsleaf().equals(MonitorConstant.isNotLeafMenu)) {
			outputResult2Client(response, MonitorConstant.failedMsg);
			return;
		}
		
		menuServiceImpl.deleteByMenuId(Integer.parseInt(menuId));
		
		if ( !SessionContextUtils.isAdmin(session) && MonitorConstant.defaultRootMenuId.equals(menu.getMenuPid())) {
			List<UserRolePOJO> roles = SessionContextUtils.getRoles(session);
			if (CollectionUtils.isNotEmpty(roles)) { 
				SessionContextUtils.resetRoleResources(session, roles, roleServiceImpl);
			}
		}
		
		outputResult2Client(response, MonitorConstant.successMsg);
	}
	
	/**
	 * 根据页码、每页的条数来查询第二级的菜单项
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value="/monitor/menu/getSecondMenus",method = POST)
	public void getSecondMenus(HttpServletRequest request, HttpServletResponse response) throws IOException {
	
		String status = request.getParameter("status") == null ? MonitorConstant.defaultResourceStatus : request.getParameter("status");
		
		Integer page = PageTools.parsePage(request.getParameter("page"));
		Integer rows = PageTools.parseRows(request.getParameter("rows"));
		
		List<MenuPOJO> list = menuDAO.getSecondMenus(Integer.valueOf(status), page, rows);
		Integer totalSize = menuDAO.getSecondMenuCount(Integer.valueOf(status));
		String dataJSON = JsonUtils.parseJson(totalSize, list);
		
		outputResult2Client(response, dataJSON);
		
	}
	
	@RequestMapping(value="/monitor/menu/saveMenuAlarm.htm")
	public void saveMenuAlarm(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession();
		String menuId = request.getParameter("id");
		Long alarmValue = StringUtils.isNotBlank(request.getParameter("alarmValue")) ? Long.valueOf(request.getParameter("alarmValue")) : null;
		String alarmValueType = request.getParameter("alarmValueType");
		Double alarmPercent = StringUtils.isNotBlank(request.getParameter("alarmPercent")) ? Double.valueOf(request.getParameter("alarmPercent")) : null;
		String alarmPercentType = request.getParameter("alarmPercentType");
		String alarmPercentSort = request.getParameter("alarmPercentSort");
		
		Integer userId = Integer.valueOf(SessionContextUtils.getUser(session).getUserId());
		
		//check
		MenuPOJO menu = menuServiceImpl.findByMenuId(Integer.parseInt(menuId));
		if (menu == null) {
			outputResult2Client(response, MonitorConstant.successMsg);
			return;
		}
		//XXX 不能在父菜单上设置报警
		if (menu.getMenuIsleaf() != null && menu.getMenuIsleaf().equals(MonitorConstant.isNotLeafMenu)) {
			outputResult2Client(response, MonitorConstant.failedMsg);
			return;
		}

		menuServiceImpl.updateMenuAlarm(menu, new Alarm(alarmValue, alarmValueType, alarmPercent, alarmPercentType, alarmPercentSort), userId);
		outputResult2Client(response, MonitorConstant.successMsg);

	}
	
	@RequestMapping(value="/monitor/menu/delMenuAlarm.htm")
	public void delMenuAlarm(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession();
		String menuId = request.getParameter("id");
		
		Integer userId = Integer.valueOf(SessionContextUtils.getUser(session).getUserId());
		
		//check
		MenuPOJO menu = menuServiceImpl.findByMenuId(Integer.parseInt(menuId));
		if (menu == null) {
			outputResult2Client(response, MonitorConstant.successMsg);
			return;
		}

		menuServiceImpl.delMenuAlarm(menu, userId);
		outputResult2Client(response, MonitorConstant.successMsg);

	}

}
