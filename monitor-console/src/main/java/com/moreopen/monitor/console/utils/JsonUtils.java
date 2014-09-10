package com.moreopen.monitor.console.utils;

import java.io.UnsupportedEncodingException;
import java.util.List;

import com.meidusa.venus.io.serializer.json.JsonSerializer;
import com.moreopen.monitor.console.constant.MonitorConstant;

public class JsonUtils {
	/**
	 * 将json 转化为类似 {"total":"20","rows":"",[{"a":"b"}]} 这种形式
	 * @param totalSize
	 * @param list
	 * @param jsonSerializer
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@SuppressWarnings("rawtypes")
	public static String parseJson(Integer totalSize, List list,JsonSerializer jsonSerializer) {
		StringBuffer strB = new StringBuffer();
		strB.append("{\"total\":\"").append(totalSize).append("\",\"rows\":");
		try {
			strB.append(new String(jsonSerializer.encode(list), MonitorConstant.encodeUTF8));
		} catch (UnsupportedEncodingException e) {
			throw new IllegalArgumentException("unsupported encoding");
		}
		strB.append("}");
		return strB.toString();
	}
}
