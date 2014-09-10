package com.moreopen.monitor.console.constant;

public class MonitorConstant {
//	编码
	public static String encodeUTF8="utf-8";
	
	public static int success=0;
	
	public static int failed=-1;
	
	public static String successMsg="success";
	
	public static String failedMsg="failed";
	
	public static Integer disabled=-1;//不可用状态
	public static Integer available=1;//可用状态
	/**
	 * 菜单相关参数
	 */
	public static String defaultRootMenuId = "1";// 默认显示
	public static Integer defalutMenuPostion = 1;// 默认新增菜单在该级别所处的位置
	public static Integer isLeafMenu = 1;// 表示是叶子菜单
	public static Integer isNotLeafMenu = -1;// 表示不是是叶子菜单
	public static Integer isRootMenuFloor = -1;// 根目录的floor
	public static Integer defaultMenuFloor = 1;// 默认菜单所处级别
	
	public static String defaultResourceStatus="1";
	
	public static Integer defaultUserStatus=1;//默认用户状态
	
	public static Integer defaultPageNum=0;//默认页数
	public static Integer defaultPageSize=50;//默认每页条数
	
	
	public static String defaultReturnStr="success";//默认返回客户端的字符串
	
	
	public static String defaultEventStatus="2";//增加event的时候的默认状态
	
	public static String defaultItemStatus="2";//增加item的时候的默认状态
	
	public static String defaultIpPortStatus="2";//增加ipport的时候的默认状态
	
	public static String defaultMonitorAlarmStatus="2";//增加alarm的时候的默认状态
	public static String defaultMonitorAlarmString="正常";
	
	public static String stopMonitorAlarmStatus="3";//停止报警
	public static String stopMonitorAlarmString="停止";
	
	public static String defaultMonitorUploadStatus="2";//增加alarm的时候的默认状态
	
	public static String noDataResult="noData";//没数据的时候默认字符串
	public static String hasDataResult="hasData";//有数据的时候默认字符串
	
	public static String dayMonitorUrl="/monitor/dataEvent/dataEventPage.htm";//日监控的url
	
	
	public static String dayStartHourMinuteSecond=" 00:00:00";
	public static String dayEndHourMiniuteSecond=" 23:59:59";
	
	public static Integer superAdminRoleId=1;//超级管理员的角色ID
	public static Integer superAdminUserId = 1;
	
	public static String noPermissionNotice="您没有权限访问该页面，请<a href='/'>点此重新登录</a>或联系管理员!";
	
	public static String semicolonSeparator=";";//报警联系人分隔符
	
	
}
