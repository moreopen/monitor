/*
 * Copyright 2011 y.sdo.com, Inc. All rights reserved.
 * y.sdo.com PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 */
package com.moreopen.monitor.console;

import javax.servlet.ServletContextEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.moreopen.monitor.console.utils.BeanLocator;

/**
 *
 * @author zhengjunwei
 * 
 * @version 1.0.0 2012-02-21
 */
public class SpringContextLoaderListener extends ContextLoaderListener {
	
	private static final Logger logger = LoggerFactory.getLogger(SpringContextLoaderListener.class);
	
	@Override
	public void contextInitialized(ServletContextEvent event) {
		super.contextInitialized(event);
		BeanLocator.setApplicationContext(WebApplicationContextUtils.getWebApplicationContext(event.getServletContext()));
		logger.info("Initialize application context, done.");
	}
}
