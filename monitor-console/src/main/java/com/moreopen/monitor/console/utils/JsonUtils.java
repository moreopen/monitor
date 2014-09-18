package com.moreopen.monitor.console.utils;

import java.io.UnsupportedEncodingException;
import java.util.List;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JsonUtils {
	
	private static Logger logger = LoggerFactory.getLogger(JsonUtils.class);
	
	private static ObjectMapper objectMapper;
	
	//init objectMapper
	static {
		objectMapper = new ObjectMapper();
	}
	
	/**
	 * 将json 转化为类似 {"total":"20","rows":"",[{"a":"b"}]} 这种形式
	 * @param totalSize
	 * @param list
	 * @param jsonSerializer
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@SuppressWarnings("rawtypes")
	public static String parseJson(Integer totalSize, List list) {
		StringBuffer strB = new StringBuffer();
		strB.append("{\"total\":\"").append(totalSize).append("\",\"rows\":");
		
		strB.append(bean2Json(list));
		
		strB.append("}");
		return strB.toString();
	}
	
	public static <T> T json2Bean(String json, Class<T> clazz) {
		try {
			return objectMapper.readValue(json, clazz);
		} catch (Exception e) {
			logger.error("convert json to bean failed", e);
			return null;
		}
	}
	
	public static <T> T json2Bean(String json, TypeReference<T> typeReference) {
		try {
			return objectMapper.readValue(json, typeReference);
		} catch (Exception e) {
			logger.error("convert json to bean failed", e);
			return null;
		}
	}
	
	public static String bean2Json(Object bean) {
		try {
			return objectMapper.writeValueAsString(bean);
		} catch (Exception e) {
			logger.error("convert bean to json failed", e);
			return null;
		}
	}
	
}
