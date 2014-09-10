package com.moreopen.monitor.console.dao;

import java.io.Serializable;
import java.util.List;
import java.util.Map;


@SuppressWarnings("rawtypes")
public interface EntityDAO {

	public <T> T get(Class<T> entityClass, Serializable id);
	
	public <T> List<T> getAll(Class<T> entityClass);
	
	public void insert(Object o);
	
	public void update(Object o);
	
	public void remove(Object o);
	
	public <T> void removeById(Class<T> entityClass, Serializable id);
	
	public  <T> Long selectKeyBy(Class<T> entityClass, String name) ;
	
	public  <T> Integer countUniqueBy(Class<T> entityClass, String name, Object value);
	
	public <T> Integer countBy(Class<T> entityClass, Map map);
	
	public <T> T findUniqueBy(Class<T> entityClass, String name, Object value);
	
	public <T> List<T> findBy(Class<T> entityClass, Map map);
	
	public Page pagedQuery(Class entityClass, Object parameterObject, int pageNo, int pageSize);
	
	public <T> List<T> findBy(Class<T> entityClass, String name, Object value);
}
