package com.moreopen.monitor.console.dao.impl.menu;

import com.moreopen.monitor.console.dao.bean.menu.MenuPOJO;
import com.moreopen.monitor.console.dao.impl.IBatisGenericDAOImpl;

public class MenuDAOImpl extends IBatisGenericDAOImpl {
	
	public static final String POSTFIX_SELECT = ".selectMaxMenuId";
	public static final String POSTFIX_SELECTMAXMENUPOSITION = ".selectMaxMenuPosition";
	public static final String POSTFIX_SELECTBYMENUID = ".selectByMenuId";
	public static final String POSTFIX_INSERTMENU= ".insertMenu";
	public static final String POSTFIX_QUERYLISTBYMENUID=".queryListByMenuId";
	
	public MenuDAOImpl(){
		sqlMapNamespace=MenuPOJO.class.getName();
	}
	/**
	 * 插入菜单
	 * @param pojo
	 * @return
	 */
	public void insertMenu(MenuPOJO pojo){
		getSqlMapClientTemplate().insert(sqlMapNamespace + POSTFIX_INSERTMENU, pojo);
	}
	
	/**
	 * 获取menu_id的最大值
	 */
	public Integer getMaxMenuId() {
		Integer t= (Integer)getSqlMapClientTemplate().queryForObject(sqlMapNamespace + POSTFIX_SELECT);
		return t;
	}
	
	/**
	 * 获取某一级的菜单的最大位置
	 */
	public Integer selectMaxMenuPosition(int id) {
		Integer t= (Integer)getSqlMapClientTemplate().queryForObject(sqlMapNamespace + POSTFIX_SELECTMAXMENUPOSITION, id);
		return t;
	}
	/**
	 * 根据menu_id获取菜单
	 * @param id
	 * @return
	 */
	public MenuPOJO findByMenuId(int id){
		MenuPOJO menu=(MenuPOJO)getSqlMapClientTemplate().queryForObject(sqlMapNamespace+POSTFIX_SELECTBYMENUID, id);
		return menu;
	}	
	
}
