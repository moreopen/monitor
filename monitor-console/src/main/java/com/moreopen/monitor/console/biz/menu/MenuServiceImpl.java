package com.moreopen.monitor.console.biz.menu;

import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.moreopen.monitor.console.constant.MonitorConstant;
import com.moreopen.monitor.console.dao.bean.menu.Alarm;
import com.moreopen.monitor.console.dao.bean.menu.MenuPOJO;
import com.moreopen.monitor.console.dao.impl.menu.MenuDAOImpl;
import com.moreopen.monitor.console.dao.jdbc.JdbcTemplateBasedMenuDAO;
import com.moreopen.monitor.console.dao.jdbc.JdbcTemplateBasedRoleDAO;
import com.moreopen.monitor.console.dao.redis.RedisBasedMonitorSourceDao;

public class MenuServiceImpl {
	
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private MenuDAOImpl menuDAOImpl;
	
	@Autowired
	private JdbcTemplateBasedMenuDAO jdbcTemplateBasedMenuDAO;
	
	@Autowired
	private JdbcTemplateBasedRoleDAO jdbcTemplateBasedRoleDAO;
	
	@Autowired
	private RoleServiceImpl roleService;
	
	@Autowired
	private RedisBasedMonitorSourceDao monitorSourceDao;

	public List<MenuPOJO> findByMenuPid(int menuPid) {
		List<MenuPOJO> menuList = menuDAOImpl.findBy(MenuPOJO.class, "menuPid", menuPid);
		return menuList;
	}

	@SuppressWarnings("all")
	public List<MenuPOJO> getMenuTree(Integer status, String menuPid) {
		Map map = new HashMap();
		map.put("status", status);
		map.put("menuPid", menuPid);
		List<MenuPOJO> list = menuDAOImpl.findBy(MenuPOJO.class, map);
		Collections.sort(list, new Comparator<MenuPOJO>() {
			@Override
			public int compare(MenuPOJO o1, MenuPOJO o2) {
				return o1.getMenuPosition() - o2.getMenuPosition();
			}
		});
		return list;
	}

	/**
	 * 
	 * @param userId
	 *            添加者的用户id
	 * @param pid
	 *            新增菜单的父菜单Id
	 * @param menuName
	 *            新增菜单的名字
	 * @param parentMenuCode
	 * 			父菜单的 menu code
	 */
	public MenuPOJO addMenu(Integer userId, int pid, String menuName, String parentMenuCode) {

		MenuPOJO menuPOJO = new MenuPOJO();
		try {
			MenuPOJO parentMenuPOJO = menuDAOImpl.findByMenuId(pid);

			menuPOJO.setMenuName(menuName);
			menuPOJO.setMenuPosition(createNewMenuPostion(pid));
			menuPOJO.setMenuFloor(createNewMenuFloor(parentMenuPOJO));// 该菜单所在层数为父菜单的层数+1
			menuPOJO.setMenuIsleaf(MonitorConstant.isLeafMenu);// 默认设置为叶子节点

			menuPOJO.setMenuPid(pid);

			menuPOJO.setCreateUserid(userId);// 当前登录用户的user_id
			menuPOJO.setCreateTime(new Date());
			menuPOJO.setUpdateTime(new Date());
			menuPOJO.setUpdateUserid(userId);
			
			//自动生成唯一的 menu code
			int childrenSize = parentMenuPOJO.getChildrenSize() == null ? 0 : parentMenuPOJO.getChildrenSize(); 
			String suffix = StringUtils.leftPad(childrenSize + "", 3, "0");
			menuPOJO.setMenuCode(parentMenuCode + suffix);
			
			jdbcTemplateBasedMenuDAO.insertMenu(menuPOJO);

			if (parentMenuPOJO.getMenuIsleaf().equals(MonitorConstant.isLeafMenu)) {// 如果父菜单原先是叶子菜单，那么要更新为非叶子菜单
				parentMenuPOJO.setMenuIsleaf(MonitorConstant.isNotLeafMenu);
			}
			parentMenuPOJO.setChildrenSize(++childrenSize);
			menuDAOImpl.update(parentMenuPOJO);
			return menuPOJO;
		} catch (Exception e) {
			logger.error("add menu failed", e);
			return null;
		}
	}

	public MenuPOJO findByMenuId(int id) {
		MenuPOJO menuPOJO = menuDAOImpl.findByMenuId(id);
		return menuPOJO;
	}

	public void updateMenuName(int id, String menuName, Integer userId) {
		MenuPOJO menuPOJO = new MenuPOJO();
		menuPOJO.setId(id);
		menuPOJO.setMenuName(menuName);
		menuPOJO.setUpdateTime(new Date());
		menuPOJO.setUpdateUserid(userId);
		menuDAOImpl.update(menuPOJO);
	}

	@SuppressWarnings("all")
	public List<MenuPOJO> getEditMenu(String menuPid, Integer status, Integer page, Integer rows) {
		Map map = new HashMap();
		map.put("menuPid", menuPid);
		map.put("status", Integer.valueOf(status));

		Integer startPostion = page * rows;
		Integer pageSize = rows;

		map.put("startPostion", startPostion);
		map.put("pageSize", pageSize);
		List<MenuPOJO> list = menuDAOImpl.findBy(MenuPOJO.class, map);
		Collections.sort(list, new Comparator<MenuPOJO>() {
			@Override
			public int compare(MenuPOJO o1, MenuPOJO o2) {
				return o1.getMenuPosition() - o2.getMenuPosition();
			}
		});
		return list;
	}

	/**
	 *TODO 事物控制
	 * 根据菜单ID删除菜单
	 * 
	 * @param menuId
	 */
	public void deleteByMenuId(int menuId) {
		// 如果删掉的菜单是其父菜单的最后一个菜单，那么需要将其父菜单变为叶子节点
		MenuPOJO menuPOJO = findByMenuId(menuId);
		menuDAOImpl.remove(menuPOJO);
		int pid = menuPOJO.getMenuPid();
		List<MenuPOJO> childrenMenuList = findByMenuPid(pid);
		if (childrenMenuList.size() == 0) {//
			MenuPOJO parentMenuPOJO = findByMenuId(pid);
			parentMenuPOJO.setMenuIsleaf(MonitorConstant.isLeafMenu);
			parentMenuPOJO.setChildrenSize(0);
			menuDAOImpl.update(parentMenuPOJO);
		}
		//如果删除的是第二级菜单，则删除对应的 RoleResource 记录
		if (MonitorConstant.defaultRootMenuId.equals("" + menuPOJO.getMenuPid())) {
			jdbcTemplateBasedRoleDAO.removeMenus(menuId);
		}
	}


	/**
	 * 创建新菜单的position
	 * 
	 * @param pid
	 * @return
	 */
	private Integer createNewMenuPostion(int pid) {
		Integer maxMenuFloor = menuDAOImpl.selectMaxMenuPosition(pid);// 查询同级菜单最大的menuposition
		return maxMenuFloor == null ? MonitorConstant.defalutMenuPostion
				: maxMenuFloor + 1;
	}
	
	private Integer createNewMenuFloor(MenuPOJO parentMenuPOJO) {
		Integer menuFloor = (parentMenuPOJO.getMenuFloor().equals(MonitorConstant.isRootMenuFloor)) ? MonitorConstant.defaultMenuFloor: parentMenuPOJO.getMenuFloor() + 1;
		return menuFloor;
	}

	public MenuPOJO findByMenuCode(String menuCode) {
		return menuDAOImpl.findUniqueBy(MenuPOJO.class, "menuCode", menuCode);
	}

	public void updateMenuAlarm(MenuPOJO menu, Alarm alarm, Integer userId) {
		MenuPOJO menuPOJO = new MenuPOJO();
		menuPOJO.setId(menu.getId());
		menuPOJO.setUpdateTime(new Date());
		menuPOJO.setUpdateUserid(userId);
		menuPOJO.setAlarm(alarm);
		menuDAOImpl.update(menuPOJO);
//		XXX 清空 redis 中对应的 menu 数据，Monitor Server 会触发 reload
		monitorSourceDao.deleteMenu(menu);

	}

	public void delMenuAlarm(MenuPOJO menu, Integer userId) {
		jdbcTemplateBasedMenuDAO.delAlarm(menu.getId(), userId);
		if (logger.isDebugEnabled()) {
			logger.debug(String.format("deleted alarm on menu [%s], operator [%s]", menu.getId(), userId));
		}
//		XXX 清空 redis 中对应的 menu 数据，Monitor Server 会触发 reload
		monitorSourceDao.deleteMenu(menu);
	}

}
