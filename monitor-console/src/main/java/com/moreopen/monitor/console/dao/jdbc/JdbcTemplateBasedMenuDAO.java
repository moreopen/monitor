package com.moreopen.monitor.console.dao.jdbc;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.moreopen.monitor.console.dao.bean.menu.MenuPOJO;

@Component
public class JdbcTemplateBasedMenuDAO {
	
	/**
	insert monitor_menu(MENU_ID,MENU_NAME,MENU_POSITION,MENU_FLOOR,MENU_ISLEAF,MENU_PID,CREATE_USERID,CREATE_TIME,UPDATE_USERID,UPDATE_TIME,MENU_CODE,CHILDREN_SIZE)
	values(#menuId#,#menuName#,#menuPosition#,#menuFloor#,#menuIsleaf#,#menuPid#,#createUserid#,#createTime#,#updateUserid#,#updateTime#,#menuCode#,#childrenSize#)
	*/
	
	private static final String INSERT_MENU = 
			"insert into monitor_menu(menu_name,menu_position,menu_floor,menu_isleaf,menu_pid,create_userid,create_time,update_userid,update_time,menu_code,children_size) " 
				+ "values(?,?,?,?,?,?,?,?,?,?,?)";
	
	private static final String QUERY_SECOND_MENUS = "select id, menu_code, menu_name from monitor_menu where menu_pid = 1 and status = ? limit ?, ?";
	
	private static final String COUNT_SECOND_MENU = "select count(id) from monitor_menu where menu_pid = 1 and status = ?";
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	public void insertMenu(MenuPOJO menuPOJO) {
		this.jdbcTemplate.update(INSERT_MENU, new Object[] {
				menuPOJO.getMenuName(), 
				menuPOJO.getMenuPosition(), menuPOJO.getMenuFloor(), 
				menuPOJO.getMenuIsleaf(), menuPOJO.getMenuPid(), 
				menuPOJO.getCreateUserid(), menuPOJO.getCreateTime(), 
				menuPOJO.getUpdateUserid(), menuPOJO.getUpdateTime(), 
				menuPOJO.getMenuCode(), menuPOJO.getChildrenSize()
			}
		);
	}

	public List<MenuPOJO> getSecondMenus(Integer status, Integer page, Integer rows) {
		return this.jdbcTemplate.query(
				QUERY_SECOND_MENUS, 
				new Object[] {
					status, page*rows, rows
				}, 
				new RowMapper<MenuPOJO>() {
					@Override
					public MenuPOJO mapRow(ResultSet rs, int index) throws SQLException {
						MenuPOJO menu = new MenuPOJO();
						menu.setId(rs.getInt("id"));
						menu.setMenuCode(rs.getString("menu_code"));
						menu.setMenuName(rs.getString("menu_name"));
						return menu;
					}
				}
		);
	}

	public Integer getSecondMenuCount(Integer status) {
		return this.jdbcTemplate.queryForInt(COUNT_SECOND_MENU, new Object[] {status});
	}

}
