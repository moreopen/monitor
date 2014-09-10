/*
 * Copyright 2011 y.sdo.com, Inc. All rights reserved.
 * y.sdo.com PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 */
package com.moreopen.monitor.console;

import org.apache.log4j.Logger;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.util.thread.ExecutorThreadPool;
import org.eclipse.jetty.util.thread.ThreadPool;
import org.eclipse.jetty.webapp.WebAppContext;

import com.moreopen.monitor.console.utils.AppSettings;

/**
 * Web Server Launcher
 */
public class MonitorConsoleServerLauncher {

	private static  Logger logger = Logger.getLogger(MonitorConsoleServerLauncher.class);

	private static Server server = null;
	private int port;

	public MonitorConsoleServerLauncher(int port) {
		this.port = port;
	}

	public void run() throws Exception {
		if (server != null) {
			return;
		}
		server = new Server(this.port);
		server.setThreadPool(getThreadPool());
		server.setStopAtShutdown(true);
		server.setSendServerVersion(true);
		server.setHandler(getWebAppContext());
		server.start();
		logger.info("Start icollector server, done.port: "+ this.port);
	}

	public void stop() throws Exception {
		if (server != null) {
			server.stop();
			server = null;
		}
	}

	public void setPort(int port) {
		this.port = port;
	}

	private ThreadPool getThreadPool() {
		return new ExecutorThreadPool();
	}

	private WebAppContext getWebAppContext() {

		String path = MonitorConsoleServerLauncher.class.getResource("/").getFile().replaceAll("/target/(.*)", "")
				+ "/src/main/webapp";

		return new WebAppContext(path, "/");
	}

	public static void main(String[] args) throws Exception {
		final String PROFILE_NAME = "monitor.properties";

		AppSettings settings = new AppSettings();
		settings.setSettingConfig(MonitorConsoleServerLauncher.class.getResourceAsStream("/" + PROFILE_NAME));
		settings.init();
		int port = settings.getInt("monitor.webserver.port");
		if (port == 0) {
			logger.error("property: monitor.webserver.port not found, please check " + PROFILE_NAME);
			return;
		}
		// launch the monitor console server
		new MonitorConsoleServerLauncher(port).run();
		server.join();
	}
}
