package com.moreopen.monitor.console.utils;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class DateTools {
	/**
	 * 把时间戳转化为 yyyy-MM-dd HH:mm:ss 格式
	 * 
	 * @param timeStamp
	 * @return
	 */
	public static String formatTimeStamp(String timeStamp) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String s = format.format((new Timestamp(Long.parseLong(timeStamp))));
		return s;
	}
	
	public static String formatTimeStamp(Date date) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String s = format.format(date);
		return s;
	}
	
	public static String simpleDateFormat(Date date) {
		return new SimpleDateFormat("yyyy-MM-dd").format(date);
	}
	
	public static String monthFormat(Date date) {
		return new SimpleDateFormat("yyyy-MM").format(date);
	}
	
	public static String abbreviatedDateFormat(Date date) {
		return new SimpleDateFormat("yyyyMMdd").format(date);
	}

	/**
	 * 获取 指定日期的毫秒数
	 * 
	 * @param date
	 *            yyyy-MM-dd HH:mm:ss
	 * @return
	 */
	public static long getTimeStamp(String dateString) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		try {
			Date date = sdf.parse(dateString);
			long longDate = date.getTime();
			return longDate;
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return 0;

	}

	/**
	 * 把 类似135667864521000 格式转化成Date
	 * 
	 * @param dateString
	 * @return
	 */
	public static Date getDateFromTimeStamp(String millSeconds) {

		Date date = new Date();
		try {
			date.setTime(Long.parseLong(millSeconds));
		} catch (NumberFormatException nfe) {
			nfe.printStackTrace();
			return null;
		}
		return date;

	}

	/**
	 * 获取今天开始时间的毫秒数
	 * 
	 * @return
	 */
	public static long getTodayBegin() {
		String d = new SimpleDateFormat("yyyy-MM-dd").format(Calendar
				.getInstance().getTime());
		return getTimeStamp(d + " 00:00:00");
	}

	/**
	 * 获取今天结束时间的毫秒数 23:59:59
	 * 
	 * @return
	 */
	public static long getTodayEnd() {
		String d = new SimpleDateFormat("yyyy-MM-dd").format(Calendar
				.getInstance().getTime());
		return getTimeStamp(d + " 23:59:59");
	}
	/**
	 * 把 yyyy/MM/dd HH:mm:ss 转化成Date类型
	 * @param dateString
	 * @return
	 */
	public static Date getDate(String dateString) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		try {
			Date date = sdf.parse(dateString);
		
			return date;
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;

	}

	/**
	 * 根据月份得到这个月的所有日期
	 * @param month : yyyy-MM
	 */
	public static List<Date> getAllDays(String month) {
		List<Date> result = new ArrayList<Date>();
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date firstDate = null;
		try {
			firstDate = dateFormat.parse(month + "-01");
		} catch (ParseException e) {
			throw new IllegalArgumentException(e);
		}
		result.add(firstDate);
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(firstDate);
		int monthValue = calendar.get(Calendar.MONTH);
		while (true) {
			calendar.add(Calendar.DAY_OF_MONTH, 1);
			if (calendar.get(Calendar.MONTH) != monthValue) {
				break;
			}
			result.add(calendar.getTime());
		}
		return result;
	}

}
