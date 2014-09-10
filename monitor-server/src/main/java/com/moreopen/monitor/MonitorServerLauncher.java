package com.moreopen.monitor;

import java.util.Properties;
import java.util.TimeZone;

import org.eclipse.jetty.server.NCSARequestLog;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.HandlerCollection;
import org.eclipse.jetty.server.handler.RequestLogHandler;
import org.eclipse.jetty.util.thread.ExecutorThreadPool;
import org.eclipse.jetty.webapp.WebAppContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.support.PropertiesLoaderUtils;

public class MonitorServerLauncher {

	private static Logger LOGGER = LoggerFactory.getLogger(MonitorServerLauncher.class);
	
	private static final int DEFAULT_JETTY_PORT  = 9090;

	private Server server = null;

	private int port;

	public MonitorServerLauncher(int port) {
		this.port = port;
	}

	public void run() throws Exception {
		if (server != null) {
			return;
		}

		server = new Server(this.port);
		server.setThreadPool(new ExecutorThreadPool());
		server.setStopAtShutdown(true);
		server.setSendServerVersion(true);
		
		HandlerCollection handlers = new HandlerCollection();
		handlers.addHandler(getWebAppContext());
		handlers.addHandler(getRequestLogHandler());
		server.setHandler(handlers);
		
		server.start();

		LOGGER.info("Start server, done. port: {}", this.port);
		server.join();
	}

	public void stop() throws Exception {
		if (server != null) {
			server.stop();
			server = null;
		}
	}
	
	protected RequestLogHandler getRequestLogHandler() {
		RequestLogHandler logHandler = new RequestLogHandler();
		NCSARequestLog requestLog = new NCSARequestLog("jetty-yyyy_MM_dd.access.log");
		requestLog.setAppend(true);
		requestLog.setLogServer(true);
		requestLog.setExtended(false);
		requestLog.setLogTimeZone(TimeZone.getDefault().getID());
		requestLog.setLogLatency(true);
		requestLog.setLogDateFormat("yyyy-MM-dd HH:mm:ss,SSS");
		logHandler.setRequestLog(requestLog);
		return logHandler;
	}

	private WebAppContext getWebAppContext() {
		
		
		String path = MonitorServerLauncher.class.getResource("/").getFile().replaceAll("/target/(.*)", "")	+ "/src/main/webapp";
		return new WebAppContext(path, "/");
		
	}

	public static void main(String[] args) throws Exception {
		
		Properties properties = PropertiesLoaderUtils.loadAllProperties("monitor-service.properties");
		int port = DEFAULT_JETTY_PORT;
		if (properties != null && properties.getProperty("jetty.port") != null) {
			port = Integer.parseInt(properties.getProperty("jetty.port"));
		}
		new MonitorServerLauncher(port).run();
	}

	
	
	
}