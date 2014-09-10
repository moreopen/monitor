package com.moreopen.monitor.console.dao.redis;

import java.util.Collections;
import java.util.Set;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

/**
 * 维护监控代码与对应调用方 ip 的对应关系
 * 可在 monitor console 列出对应的 ip 列表并选择 ip 展示曲线
 */

@Component
public class RedisBasedMonitorSourceDao {
	
	private static final String PREFIX = "monitor.source.";

	private static final long ONE_DAY_MILLIS = 24 * 60 * 60 * 1000;
	
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Resource
	private RedisTemplate<String, String> redisTemplate;

	public void update(String monitorCode, String ip) {
		redisTemplate.opsForZSet().add(generateKey(monitorCode), ip, System.currentTimeMillis());
	}
	
	private String generateKey(String monitorCode) {
		return PREFIX + monitorCode;
	}

	/**
	 * 取得24小时之内有请求的 ip 记录
	 */
	public Set<String> get(String monitorCode) {
		try {
			long currentTimeMillis = System.currentTimeMillis();
			Set<String> result = redisTemplate.opsForZSet().reverseRangeByScore(generateKey(monitorCode), currentTimeMillis - ONE_DAY_MILLIS, currentTimeMillis);
			return result;
		} catch (Exception e) {
			logger.error("get source failed", e);
			return Collections.emptySet();
		}
	}

}
