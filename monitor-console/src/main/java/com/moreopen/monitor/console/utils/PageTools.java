package com.moreopen.monitor.console.utils;

import com.moreopen.monitor.console.constant.MonitorConstant;

public class PageTools {
	
	public static Integer parsePage(String stringPage) {
		Integer page = null;
		if ((stringPage == null)) {
			page = MonitorConstant.defaultPageNum;
		} else {
			page = Integer.valueOf(stringPage) - 1;
		}
		return page;
	}

	public static Integer parseRows(String stringRows) {
		Integer rows = null;
		if (stringRows == null) {
			rows = MonitorConstant.defaultPageSize;
		} else {
			rows = Integer.valueOf(stringRows);
		}
		return rows;
	}

}
