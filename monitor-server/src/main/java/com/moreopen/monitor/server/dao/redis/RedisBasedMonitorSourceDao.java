package com.moreopen.monitor.server.dao.redis;

import javax.annotation.Resource;

import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

/**
 * 维护监控代码与对应调用方 ip 的对应关系
 * 可在 monitor console 列出对应的 ip 列表并选择 ip 展示曲线
 */

@Component
public class RedisBasedMonitorSourceDao {
	
	private static final String PREFIX = "monitor.source.";
	
	@Resource
	private RedisTemplate<String, String> redisTemplate;

	public void update(String monitorCode, String ip) {
		redisTemplate.opsForZSet().add(generateKey(monitorCode), ip, System.currentTimeMillis());
	}
	
	private String generateKey(String monitorCode) {
		return PREFIX + monitorCode;
	}

}
