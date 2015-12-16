package com.moreopen.monitor.server.dao.redis;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import com.moreopen.monitor.server.domain.Menu;
import com.moreopen.monitor.server.util.JsonUtils;

/**
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

	public Menu getMenu(String monitorCode) {
		String value = redisTemplate.opsForValue().get(generateMonitorMenuKey(monitorCode));
		if (StringUtils.isBlank(value)) {
			return null;
		}
		return JsonUtils.json2Bean(value, Menu.class);
	}

	public void saveMenu(Menu menu) {
		String json = JsonUtils.bean2Json(menu);
		redisTemplate.opsForValue().set(generateMonitorMenuKey(menu.getCode()), json);
	}

}
