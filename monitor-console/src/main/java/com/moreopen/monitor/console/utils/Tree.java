package com.moreopen.monitor.console.utils;

import java.util.List;

import com.moreopen.monitor.console.dao.bean.menu.MenuPOJO;

public class Tree {

	/**
	 * 展示树的JSON
	 * @param menuList
	 * @return
	 */
	public static String getMenuJSON(List<MenuPOJO> menuList) {
		StringBuffer strB=new StringBuffer();
		strB.append("[");
		for(MenuPOJO m:menuList){
			strB.append("{\"id\":\"").append(m.getId()).append("\",");
			strB.append("\"menuFloor\":").append(m.getMenuFloor()).append(",");
			strB.append("\"menuIsleaf\":").append(m.getMenuIsleaf()).append(",");
			strB.append("\"menuCode\":\"").append(m.getMenuCode()).append("\",");
			strB.append("\"attributes\":{\"menuCode\":\"").append(m.getMenuCode()).append("\"},");
			strB.append("\"text\":\"").append(m.getMenuName()).append("\"");

			if(m.getMenuIsleaf().equals(Integer.valueOf("-1"))){//不是叶子菜单就保持关闭状态
				strB.append(",\"state\":\"closed\"");//定义状态
			}
			strB.append(",");
			strB.append("\"parentId\":\"").append(m.getMenuPid()).append("\"},");
		}
		strB.append("]");
		return strB.toString().replaceAll(",]", "]");
	}
	/**
	 * 可用于编辑的JSON
	 * @param menuList
	 * @return
	 */
	public static String getEditMenuJSON(List<MenuPOJO> menuList) {
		StringBuffer strB=new StringBuffer();
		strB.append("[");
		for(MenuPOJO m:menuList){
			strB.append("{\"id\":\"").append(m.getId()).append("\",");
			strB.append("\"menuFloor\":").append(m.getMenuFloor()).append(",");
			strB.append("\"menuIsleaf\":").append(m.getMenuIsleaf()).append(",");
			strB.append("\"menuCode\":\"").append(m.getMenuCode()).append("\",");
			
			
			strB.append("\"createTimeFormat\":\"").append(m.getCreateTimeFormat()).append("\",");
			strB.append("\"updateTimeFormat\":\"").append(m.getUpdateTimeFormat()).append("\",");
			strB.append("\"updateUserName\":\"").append(m.getUpdateUserName()).append("\",");
			strB.append("\"createUserName\":\"").append(m.getCreateUserName()).append("\",");
			
			strB.append("\"name\":\"").append(m.getMenuName()).append("\"");
			if(m.getMenuIsleaf().equals(Integer.valueOf("-1"))){//不是叶子菜单就保持关闭状态
				strB.append(",\"state\":\"closed\"");//定义状态
			}
			strB.append(",");
			strB.append("\"parentId\":\"").append(m.getMenuPid()).append("\"},");
		}
		strB.append("]");
		return strB.toString().replaceAll(",]", "]");
	}
	

}
