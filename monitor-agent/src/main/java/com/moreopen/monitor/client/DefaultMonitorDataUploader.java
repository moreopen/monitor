package com.moreopen.monitor.client;

import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.scheduling.concurrent.CustomizableThreadFactory;

public class DefaultMonitorDataUploader implements MonitorDataUploader, InitializingBean {
	
	private static final String DEFAULT_CHARSET = "UTF-8";
	
	private static final int HTTP_CONNECTION_TIMEOUT_MILLISECONDS = 5000;

	private static final int HTTP_SOCKET_TIMEOUT_MILLISECONDS = 5000;
	
	private static final int SECONDS_IN_ONE_MINUTE = 60;
	
	private static final int DEFAULT_UPLOAD_INTERVAL = 180;
	
	private static final String ACTION_PARAM_NAME = "action";
	private static final String IP_PARAM_NAME = "ip";
	private static final String TIMESTAMP_PARA_NAME = "timestamp";

	private Logger logger = LoggerFactory.getLogger(getClass());
	
	private MonitorDataHolder monitorDataHolder = new MonitorDataHolder();
	
	/**
	 * 监控服务地址
	 */
	private String monitorUrl;
	
	//接入监控服务的 ip 地址（即当前应用服务器 ip）
	private String host;
	
	//上报周期, 默认是 180 s
	private int uploadInterval = DEFAULT_UPLOAD_INTERVAL;
	
	//处理上报请求的线程数, 默认为 1
	private int uploadThreads = 1;
	
	private ScheduledExecutorService uploadExecutor;
	
	@Override
	public void afterPropertiesSet() throws Exception {
		if (StringUtils.isBlank(monitorUrl)) {
			throw new IllegalArgumentException("monitor service url can't be empty");
		}
		if (StringUtils.isBlank(host)) {
			String localhostAddress = "127.0.0.1";
			try {
				localhostAddress = InetAddress.getLocalHost().getHostAddress();
			} catch (UnknownHostException uhe) {
				logger.error("cannot get the host. Host is set as 127.0.0.1", uhe);
			}
			host = localhostAddress;
		}
		if (uploadInterval < SECONDS_IN_ONE_MINUTE) {
			logger.warn(String
					.format("upload interval is less than [%s]s, use default value [%s]s",
							SECONDS_IN_ONE_MINUTE, DEFAULT_UPLOAD_INTERVAL));
			uploadInterval = DEFAULT_UPLOAD_INTERVAL;
		}
		uploadExecutor = Executors.newScheduledThreadPool(uploadThreads, new CustomizableThreadFactory("Monitor-upload-"));
		uploadExecutor.scheduleWithFixedDelay(new Runnable() {
			@Override
			public void run() {
				upload();
			}
		}, 5, uploadInterval, TimeUnit.SECONDS);
	}

	@Override
	public void setValue(String key, Number value, MonitorDataType monitorDataType) {
		if (monitorDataType == MonitorDataType.INCREMENT) {
			incrementValue(key, value.intValue());
			return;
		}
		if (monitorDataType == MonitorDataType.AVERAGE) {
			insertValue(key, value.doubleValue());
			return;
		}
		if (monitorDataType == MonitorDataType.MAX) {
			setMaxValue(key, value.doubleValue());
			return;
		}
		throw new IllegalArgumentException("unsupported MonitorDataType : " + monitorDataType);
	}
	
	@Override
	public void setRatioValue(String key, int value, Ratio ratio) {
		if (ratio == Ratio.FACTOR) {
			monitorDataHolder.incrementRatioFactor(key, value, true);
			return;
		} 
		if (ratio == Ratio.BASE) {
			monitorDataHolder.incrementRatioBase(key, value);
			return;
		}
		
		throw new IllegalArgumentException("unsupported ratio : " + ratio);
	} 
	
	@Override
	public void incrRatioFactor(String key, int value, boolean incrBase) {
		monitorDataHolder.incrementRatioFactor(key, value, incrBase);
	}

	@Override
	public void incrRatioBase(String key, int value) {
		monitorDataHolder.incrementRatioBase(key, value);
	}

	private void setMaxValue(String key, double doubleValue) {
		monitorDataHolder.setMax(key, doubleValue);
	}

	private void insertValue(String key, double doubleValue) {
		monitorDataHolder.insert(key, doubleValue);
	}

	private void incrementValue(String key, int intValue) {
		monitorDataHolder.increment(key, intValue);
	}

	//每隔一定的时间上报数据，所以 HttpClient 无需池化
	@Override
	public void upload() {
		List<NameValuePair> paramsList = buildParamsList(monitorDataHolder);
		if (CollectionUtils.isEmpty(paramsList)) {
			return;
		}
		doUpload(paramsList);
		monitorDataHolder.reset();
	}
	
	
	private void doUpload(List<NameValuePair> params) {
		HttpClient httpClient = null;
		HttpPost httpPost = null;
		try {
			httpClient = new DefaultHttpClient();
			HttpParams httpParams = httpClient.getParams();
			HttpConnectionParams.setConnectionTimeout(httpParams, HTTP_CONNECTION_TIMEOUT_MILLISECONDS);
			HttpConnectionParams.setSoTimeout(httpParams, HTTP_SOCKET_TIMEOUT_MILLISECONDS);
			httpPost = new HttpPost(monitorUrl);
			HttpEntity httpEntity = new UrlEncodedFormEntity(params, DEFAULT_CHARSET);
			httpPost.setEntity(httpEntity);
			if (logger.isDebugEnabled()) {
				try {
					logger.debug("HTTP request entity: {}", org.apache.commons.io.IOUtils.toString(httpEntity.getContent()));
				} catch (IOException e) {
					logger.error("Failed to output the content of http entity.");
				}
			}
			HttpResponse response = httpClient.execute(httpPost);
			int responseStatusCode = response.getStatusLine().getStatusCode();
			if (responseStatusCode == 200) {
				if (logger.isDebugEnabled()) {
					logger.debug("Send data to Monitor system, SUCCESS");
				}
			} else {
				logger.error("Send data to Monitor system, Failure. HTTP response status code:{}", responseStatusCode);
			}
		} catch (Exception e) {
			logger.error("An error occurred while sending data to Monitor Server.", e);
		} finally {
			if (httpPost != null) {
				httpPost.abort();
				//close connection at once
				httpClient.getConnectionManager().closeIdleConnections(0, TimeUnit.MILLISECONDS);
			}
		}
	
	}

	private List<NameValuePair> buildParamsList(MonitorDataHolder monitorDataHolder) {
		List<NameValuePair> params = new ArrayList<NameValuePair>();
		
		Map<String, AtomicInteger> counters = monitorDataHolder.getCounters();
		for (Entry<String, AtomicInteger> entry : counters.entrySet()) {
			params.add(new BasicNameValuePair(ACTION_PARAM_NAME,
					String.format("%s,%d", entry.getKey(), entry.getValue().intValue())));
		}
		
		Map<String, Double> maxValues = monitorDataHolder.getMaxValues();
		for (Entry<String, Double> entry : maxValues.entrySet()) {
			params.add(new BasicNameValuePair(ACTION_PARAM_NAME,
					String.format("%s,%f", entry.getKey(), entry.getValue())));
		}
		
		Map<String, Double> averageValues = monitorDataHolder.getAverageValues();
		for (Entry<String, Double> entry : averageValues.entrySet()) {
			params.add(new BasicNameValuePair(ACTION_PARAM_NAME,
					String.format("%s,%f", entry.getKey(), entry.getValue())));
		}
		
		Map<String, Double> ratioValues = monitorDataHolder.getRatios();
		for (Entry<String, Double> entry : ratioValues.entrySet()) {
			params.add(new BasicNameValuePair(ACTION_PARAM_NAME,
					String.format("%s,%f", entry.getKey(), entry.getValue())));
		}
		
		if (CollectionUtils.isEmpty(params)) {
			return null;
		}
		
		params.add(new BasicNameValuePair(IP_PARAM_NAME, host));
		params.add(new BasicNameValuePair(TIMESTAMP_PARA_NAME, System.currentTimeMillis() + ""));
		return params;
	}

	public void setMonitorUrl(String url) {
		this.monitorUrl = url;
	}

	public void setHost(String host) {
		this.host = host;
	}

	public void setUploadInterval(int uploadInterval) {
		this.uploadInterval = uploadInterval;
	}

	public void setUploadThreads(int uploadThreads) {
		this.uploadThreads = uploadThreads;
	}

	@Override
	public void upload(String key, Number value) {
		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new BasicNameValuePair(ACTION_PARAM_NAME,
				String.format("%s,%f", key, value)));
		params.add(new BasicNameValuePair(IP_PARAM_NAME, host));
		params.add(new BasicNameValuePair(TIMESTAMP_PARA_NAME, System.currentTimeMillis() + ""));
		
		doUpload(params);
	}
	
	@Override
	public void upload(String key, long value, String host) {
		List<NameValuePair> params = new ArrayList<NameValuePair>();
		params.add(new BasicNameValuePair(ACTION_PARAM_NAME,
				String.format("%s,%d", key, value)));
		params.add(new BasicNameValuePair(IP_PARAM_NAME, host));
		params.add(new BasicNameValuePair(TIMESTAMP_PARA_NAME, System.currentTimeMillis() + ""));
		
		doUpload(params);
	}

}
