package com.moreopen.monitor.client;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 存放监控数据的容器类
 */
public class MonitorDataHolder {
	
	/**
	 * 用以存放请求数量
	 */
	private Map<String, AtomicInteger> counters = new ConcurrentHashMap<String, AtomicInteger>();
	
	/**
	 * 用以存放计算平均数的中间数据
	 */
	private Map<String, List<Double>> averageCounters = new ConcurrentHashMap<String, List<Double>>(); 
	
	/**
	 * 用以存放最大值
	 */
	private Map<String, Double> maxValues = new ConcurrentHashMap<String, Double>();

	//XXX 初始化时由于并发可能会产生非常微小的数据误差
	public void increment(String key, int intValue) {
		
		AtomicInteger counter = counters.get(key);
		if (counter == null) {
			counter = new AtomicInteger(0);
			counters.put(key, counter);
		}
		counter.incrementAndGet();
	}

	public void insert(String key, double doubleValue) {
		List<Double> counter = averageCounters.get(key);
		if (counter == null) {
			counter = new ArrayList<Double>();
			averageCounters.put(key, counter);
		}
		synchronized (key.intern()) {
			counter.add(doubleValue);
		}
	}

	public void setMax(String key, double newValue) {
		Double value = maxValues.get(key);
		if (value == null) {
			maxValues.put(key, newValue);
		} else {
			if (newValue > value.doubleValue()) {
				synchronized (key.intern()) {
					if (newValue > maxValues.get(key).doubleValue()) {
						maxValues.put(key, newValue);		
					}
				}
			}
		}
	}

	public Map<String, AtomicInteger> getCounters() {
		return counters;
	}

	public Map<String, Double> getAverageValues() {
		Map<String, Double> averageValues = new HashMap<String, Double>(averageCounters.size());
		for (Entry<String, List<Double>> entry : averageCounters.entrySet()) {
			synchronized(entry.getKey().intern()) {
				List<Double> values = entry.getValue();
				Double averageValue = 0d;
				if (values != null && values.size() > 0) {
					Double total = 0d;
					for (Double value : values) {
						total = total + value;
					}
					averageValue = total / values.size();
				}
				averageValues.put(entry.getKey(), averageValue);
			}
		}
		return averageValues;
	}

	public Map<String, Double> getMaxValues() {
		return maxValues;
	}

	//XXX 有比较轻微的并发问题
	public void reset() {
		for (Entry<String, AtomicInteger> entry : counters.entrySet()) {
			entry.getValue().set(0);
		}
		for (String key : maxValues.keySet()) {
			maxValues.put(key, 0d);
		}
		for (String key : averageCounters.keySet()) {
			averageCounters.put(key, new ArrayList<Double>());
		}
	}

}
