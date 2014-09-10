/*
 * Copyright 2011 y.sdo.com, Inc. All rights reserved.
 * y.sdo.com PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 */
package com.moreopen.monitor.console.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Utility class, used to save all the application properties.
 * 
 */
public class AppSettings {
	
	private static final Logger logger = LoggerFactory.getLogger(AppSettings.class);
	
	private InputStream settingConfig;

	private Properties properties = new Properties();

	public void init() throws IOException {
		this.properties.load(this.settingConfig);
	}

	public void setSettingConfig(InputStream settingConfig) {
		this.settingConfig = settingConfig;
	}

	public String getSetting(String key) {
		String value = this.properties.getProperty(key);
		logger.info("Get settings:{}={}", key, value);
		return value;
	}
	
	public String getString(String key){
		return getSetting(key).trim();
	}
	
	public boolean getBoolean(String key){
		return BooleanUtils.toBoolean(this.getSetting(key));
	}

	public int getInt(String key) {
		return NumberUtils.toInt(this.getSetting(key));
	}

	public Long getLong(String key) {
		return NumberUtils.toLong(this.getSetting(key), 0);
	}
}
