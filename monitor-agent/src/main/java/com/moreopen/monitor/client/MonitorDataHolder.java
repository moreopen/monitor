package com.moreopen.monitor.client;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.commons.collections.KeyValue;
import org.apache.commons.collections.keyvalue.DefaultKeyValue;
import org.springframework.util.Assert;

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
	
	/**
	 * 用以存放计算 ratio 的原始值, 目前只支持因子、基数都为 int 来统计 ratio
	 */
	private Map<String, KeyValue> ratioCounters = new ConcurrentHashMap<String, KeyValue>();

	/**
	 * 递增统计接口
	 */
	//XXX 初始化时由于并发可能会产生非常微小的数据误差
	public void increment(String key, int intValue) {
		
		AtomicInteger counter = counters.get(key);
		if (counter == null) {
			counter = new AtomicInteger(0);
			counters.put(key, counter);
		}
		counter.incrementAndGet();
	}

	/**
	 * 平均值统计接口
	 */
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

	/**
	 * 最大值统计接口
	 */
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
	
	/**
	 * ratio 统计递增因子
	 */
	public void incrementRatioFactor(String key, int value) {
		KeyValue keyValue = ratioCounters.get(key);
		if (keyValue == null) {
			keyValue = new DefaultKeyValue(new AtomicInteger(0), new AtomicInteger(0));
			ratioCounters.put(key, keyValue);
		}
		synchronized (key.intern()) {
			((AtomicInteger) keyValue.getKey()).incrementAndGet();
			((AtomicInteger) keyValue.getValue()).incrementAndGet();
		}
	}
	
	/**
	 * ratio 统计递增基数
	 */
	public void incrementRatioBase(String key, int value) {
		KeyValue keyValue = ratioCounters.get(key);
		if (keyValue == null) {
			keyValue = new DefaultKeyValue(new AtomicInteger(0), new AtomicInteger(0));
			ratioCounters.put(key, keyValue);
		}
		synchronized (key.intern()) {
			((AtomicInteger) keyValue.getValue()).incrementAndGet();
		}
	}

	public Map<String, AtomicInteger> getCounters() {
		return counters;
	}

	public Map<String, Double> getAverageValues() {
		Map<String, Double> averageValues = new HashMap<String, Double>(averageCounters.size());
		DecimalFormat format = new DecimalFormat("#.#");
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
					averageValue = Double.parseDouble(format.format(averageValue));
					
				}
				averageValues.put(entry.getKey(), averageValue);
			}
		}
		return averageValues;
	}

	public Map<String, Double> getMaxValues() {
		return maxValues;
	}
	
	public Map<String, Double> getRatios() {
		Map<String, Double> ratioValues = new HashMap<String, Double>(ratioCounters.size());
		DecimalFormat format = new DecimalFormat("#.###");
		for (Entry<String, KeyValue> entry : ratioCounters.entrySet()) {
			synchronized (entry.getKey().intern()) {
				KeyValue keyValue = entry.getValue();
				Double ratio = 0d;
				int factor = ((AtomicInteger) keyValue.getKey()).get();
				int base = ((AtomicInteger) keyValue.getValue()).get();
				if (base != 0) {
					ratio = (new Double(factor) / new Double(base)) * 100;
					ratio = Double.parseDouble(format.format(ratio));
				}
				ratioValues.put(entry.getKey(), ratio);
			}
		}
		return ratioValues;
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
		for (Entry<String, KeyValue> entry : ratioCounters.entrySet()) {
			synchronized (entry.getKey().intern()) {
				KeyValue keyValue = entry.getValue();
				((AtomicInteger) keyValue.getKey()).set(0);
				((AtomicInteger) keyValue.getValue()).set(0);
			}
		}
	}
	
	//测试 AtomicInteger 的原子性
	public static void main(String[] args) throws InterruptedException {
		ExecutorService executor = Executors.newFixedThreadPool(50);
		final AtomicInteger value = new AtomicInteger(0);
		int size = 3000;
		final CountDownLatch latch = new CountDownLatch(size);
		for (int i = 0; i < size; i++) {
			executor.execute(new Runnable() {
				@Override
				public void run() {
					value.incrementAndGet();
					latch.countDown();
				}
			});
		}
		latch.await();
		System.out.println("========" + value);
		Assert.isTrue(value.get() == size);
		executor.shutdown();
	}

}
