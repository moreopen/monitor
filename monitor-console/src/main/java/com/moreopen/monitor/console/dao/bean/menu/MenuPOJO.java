package com.moreopen.monitor.console.dao.bean.menu;

import java.io.Serializable;
import java.util.Date;

public class MenuPOJO implements Serializable {

	private static final long serialVersionUID = 1L;
	private Integer seqId;
	private String menuName;
	private Integer menuPosition;
	private Integer menuFloor;
	private Integer menuIsleaf;
	private int menuPid;
	private Integer createUserid;
	private Date createTime;
	private Integer updateUserid;
	private Date updateTime;
	private Integer status;
	private Integer id;
	
	/**
	 * 创建菜单时自动生成的唯一 menuCode, 以父菜单的 menuCode 作为前缀, 此 menuCode 就是客户端打点对应的 key 值
	 */
	private String menuCode;
	/**
	 * 下级子菜单的数量。XXX 为了保证 menuCode 的唯一性，当删除子菜单时，不会改变父菜单 childrenSize 的值，只有父菜单变为叶子节点时才会重置 childrenSize 为 0.
	 * 所以 childrenSize 并不是此菜单最真实的子菜单数量，只是用来生成子菜单 menuCode 的一个计数器而已
	 */
	private int childrenSize;
	
	private String updateTimeFormat;//更新时间格式化
	private String createTimeFormat;//创建时间格式化
	private String createUserName;//创建者名字
	private String updateUserName;//更新人的名字
	
	public String getUpdateTimeFormat() {
		return updateTimeFormat;
	}

	public void setUpdateTimeFormat(String updateTimeFormat) {
		this.updateTimeFormat = updateTimeFormat;
	}

	public String getCreateTimeFormat() {
		return createTimeFormat;
	}

	public void setCreateTimeFormat(String createTimeFormat) {
		this.createTimeFormat = createTimeFormat;
	}

	public String getCreateUserName() {
		return createUserName;
	}

	public void setCreateUserName(String createUserName) {
		this.createUserName = createUserName;
	}

	public String getUpdateUserName() {
		return updateUserName;
	}

	public void setUpdateUserName(String updateUserName) {
		this.updateUserName = updateUserName;
	}

		
	public Integer getSeqId() {
		return seqId;
	}

	public void setSeqId(Integer seqId) {
		this.seqId = seqId;
	}
	
	public String getMenuName() {
		return menuName;
	}

	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}

	public Integer getMenuPosition() {
		return menuPosition;
	}

	public void setMenuPosition(Integer menuPosition) {
		this.menuPosition = menuPosition;
	}

	public Integer getMenuFloor() {
		return menuFloor;
	}

	public void setMenuFloor(Integer menuFloor) {
		this.menuFloor = menuFloor;
	}

	public Integer getMenuIsleaf() {
		return menuIsleaf;
	}

	public void setMenuIsleaf(Integer menuIsleaf) {
		this.menuIsleaf = menuIsleaf;
	}

	public int getMenuPid() {
		return menuPid;
	}

	public void setMenuPid(int menuPid) {
		this.menuPid = menuPid;
	}

	public Integer getCreateUserid() {
		return createUserid;
	}

	public void setCreateUserid(Integer createUserid) {
		this.createUserid = createUserid;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Integer getUpdateUserid() {
		return updateUserid;
	}

	public void setUpdateUserid(Integer updateUserid) {
		this.updateUserid = updateUserid;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getMenuCode() {
		return menuCode;
	}

	public void setMenuCode(String menuCode) {
		this.menuCode = menuCode;
	}

	public int getChildrenSize() {
		return childrenSize;
	}

	public void setChildrenSize(int childrenSize) {
		this.childrenSize = childrenSize;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

}
