package com.moreopen.monitor.console.dao.redis;

import java.util.Collections;
import java.util.Set;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import com.moreopen.monitor.console.dao.bean.menu.MenuPOJO;

/**
 * XXX 需重构, 与 monitor-server 中的代码有关联, 不能修改相关的 key 及逻辑。
 * 1.
 * 维护监控代码与对应调用方 ip 的对应关系
 * 可在 monitor console 列出对应的 ip 列表并选择 ip 展示曲线
 * 
 * 2.维护 Menu 的缓存数据 (主要用以报警业务)
 * monitor console 在更新或者删除 alarm 设置的时候会清空缓存
 */

@Component
public class RedisBasedMonitorSourceDao {
	
	private static final String PREFIX = "monitor.source.";
	
	private static final String MENU_PREFIX = "monitor.menu.";

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
	
	private String generateMonitorMenuKey(String monitorCode) {
		return MENU_PREFIX + monitorCode;
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

	public void deleteMenu(MenuPOJO menu) {
		redisTemplate.delete(generateMonitorMenuKey(menu.getMenuCode()));
		if (logger.isInfoEnabled()) {
			logger.info(String.format("delete menu [%s] from cache", menu.getMenuCode()));
		}
	}

}
