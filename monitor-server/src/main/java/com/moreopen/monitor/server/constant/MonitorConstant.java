package com.moreopen.monitor.server.constant;

public class MonitorConstant {
	
	public static String charSet="utf-8";
	
	public static String SimpleMonitorRule="1";
	
	public static String ComplexMonitorRule="2";
	
	public static String colonSeparator=":";
	public static String semicolonSeparator=";";
	
	public static String ruleConditionGT="gt";
	
	public static String ruleConditionLT="lt";
	
	public static String ruleConditionEQ="eq";
	
	public static String  alarmWayEmail="1";
	
	public static String alarmWayPhone="2";
//	
//	public static String alarmWayEmailAndPhone="3";
	
	public static char alarmWaySend=1;
	
	public static int  noRisk=0;
	
	public static int noDataUploadRisk=-1;
	public static String stopAlarmStatus="3";
	public static int updatemonitorConfigCheckInterval=60*5;//单位是s
	public static int noDataUploadCheckInterval=60;//单位是s
	public static int noDataUploadAlarmInterval=120;//单位是s
}
