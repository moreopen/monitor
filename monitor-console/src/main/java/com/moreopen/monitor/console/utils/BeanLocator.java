/*
 * Copyright 2011 y.sdo.com, Inc. All rights reserved.
 * y.sdo.com PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 */
package com.moreopen.monitor.console.utils;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

import org.springframework.context.ApplicationContext;

/**
 * Utility class, used to find the configured Spring beans. 
 * 
 */
public class BeanLocator {

	private static AtomicBoolean init = new AtomicBoolean(false);

	private static ApplicationContext applicationContext = null;

	@SuppressWarnings("unchecked")
	public static <T> T getBean(String name) {
		return (T) applicationContext.getBean(name);
	}

	public static <T> T getBean(Class<T> clazz) {
		String[] names = applicationContext.getBeanNamesForType(clazz);
		if (names == null || names.length == 0) {
			return null;
		}
		return applicationContext.getBean(names[0], clazz);
	}

	public static <T> List<T> getBeans(Class<T> clazz) {
		String[] names = applicationContext.getBeanNamesForType(clazz);
		if (names == null || names.length == 0) {
			return null;
		}
		List<T> beans = new ArrayList<T>();
		for (String name : names) {
			beans.add(applicationContext.getBean(name, clazz));
		}
		return beans;
	}

	public static <T> T getBean(Class<T> clazz, BeanSelector<T> selector) {
		String[] names = applicationContext.getBeanNamesForType(clazz);
		if (names == null || names.length == 0) {
			return null;
		}

		for (String beanName : names) {
			T bean = applicationContext.getBean(beanName, clazz);
			if (selector.select(bean, applicationContext)) {
				return bean;
			}
		}

		return null;
	}

	public synchronized static void setApplicationContext(
			ApplicationContext applicationContext) {
		BeanLocator.applicationContext = applicationContext;
		init.set(applicationContext != null);
	}

	public static interface BeanSelector<T> {
		boolean select(T bean, ApplicationContext context);
	}

}
