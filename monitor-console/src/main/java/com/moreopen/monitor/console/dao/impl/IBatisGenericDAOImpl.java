package com.moreopen.monitor.console.dao.impl;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.util.Assert;

import com.moreopen.monitor.console.dao.Page;

/**
 * IBatis Dao的泛型基类.
 * <p/>
 * 继承于Spring的SqlMapClientDaoSupport,提供分页函数和若干便捷查询方法，并对返回值作了泛型类型转换.
 *
 * @see SqlMapClientDaoSupport
 */
@SuppressWarnings("all")
public class IBatisGenericDAOImpl extends SqlMapClientDaoSupport {

	public static final String POSTFIX_INSERT = ".insert";

	public static final String POSTFIX_UPDATE = ".update";

	public static final String POSTFIX_DELETE = ".delete";

	public static final String POSTFIX_DELETE_PRIAMARYKEY = ".deleteByPrimaryKey";

	public static final String POSTFIX_SELECT = ".select";

	public static final String POSTFIX_SELECTMAP = ".selectByMap";

	public static final String POSTFIX_COUNT = ".count";
	
	public static final String POSTFIX_SELECTKEY = ".selectKey";
	
	protected String sqlMapNamespace;

	/**
	 * 根据ID获取对象
	 */
	public <T> T get(Class<T> entityClass, Serializable id) {
		T o = (T) getSqlMapClientTemplate().queryForObject(sqlMapNamespace + POSTFIX_SELECT, id);
//		if (o == null)
//			throw new ObjectRetrievalFailureException(entityClass, id);
		return o;
	}

	/**
	 * 获取全部对象
	 */
	public <T> List<T> getAll(Class<T> entityClass) {
		return getSqlMapClientTemplate().queryForList(sqlMapNamespace + POSTFIX_SELECT, null);
	}

	/**
	 * 新增对象
	 */
	public void insert(Object o) {
		getSqlMapClientTemplate().insert(sqlMapNamespace + POSTFIX_INSERT, o);
	}

	/**
	 * 保存对象
	 */
	public void update(Object o) {
		getSqlMapClientTemplate().update(sqlMapNamespace + POSTFIX_UPDATE, o);
	}

	/**
	 * 删除对象
	 */
	public void remove(Object o) {
		getSqlMapClientTemplate().delete(sqlMapNamespace + POSTFIX_DELETE, o);
	}

	/**
	 * 根据ID删除对象
	 */
	public <T> void removeById(Class<T> entityClass, Serializable id) {
		getSqlMapClientTemplate().delete(sqlMapNamespace + POSTFIX_DELETE_PRIAMARYKEY, id);
	}

	/**
	 * map查询.
	 *
	 * @param map 包含各种属性的查询
	 */
	public <T> List<T> findBy(Class<T> entityClass, Map map) {
		if (map == null)
			return this.getSqlMapClientTemplate().queryForList(sqlMapNamespace + POSTFIX_SELECT, null);
		else {
			map.put("findBy", "True");
			return this.getSqlMapClientTemplate().queryForList(sqlMapNamespace + POSTFIX_SELECTMAP, map);
		}
	}
	/**
	 * map查询.
	 *
	 * @param map 包含各种属性进行统计
	 */
	public  <T> Integer countBy(Class<T> entityClass, Map map) {
		Integer cnt;
		List<T> list;
		if (map == null)
			 list=this.getSqlMapClientTemplate().queryForList(sqlMapNamespace + POSTFIX_COUNT, null);
		else {
			map.put("findBy", "True");
			list= this.getSqlMapClientTemplate().queryForList(sqlMapNamespace + POSTFIX_COUNT, map);
		}
		if(list!=null && list.size()>0){
			cnt=(Integer)list.get(0);
		}else{
			cnt=0;
		}
		return cnt;
	}

	/**
	 * 根据属性名和属性值统计
	 * @param <T>
	 * @return 
	 */
	public  <T> Integer countUniqueBy(Class<T> entityClass, String name, Object value) {
		Assert.hasText(name);
		Map map = new HashMap();
		map.put(name, value);
		map.put("findUniqueBy", "True");
		Integer totalCount = (Integer) this.getSqlMapClientTemplate().queryForObject(sqlMapNamespace + POSTFIX_COUNT, map);
		return totalCount;
		
	}
	/**
	 * 查询selectKey
	 * @param <T>
	 * @return 
	 */
	public  <T> Long selectKeyBy(Class<T> entityClass, String name) {
		Assert.hasText(name);
		Map map = new HashMap();
		map.put(name, "True");
		Long seqId = (Long) this.getSqlMapClientTemplate().queryForObject(sqlMapNamespace + POSTFIX_SELECTKEY, map);
		return seqId;
		
	}
	/**
	 * 根据属性名和属性值查询对象.
	 *
	 * @return 符合条件的对象列表
	 */
	public <T> List<T> findBy(Class<T> entityClass, String name, Object value) {
		Assert.hasText(name);
		Map map = new HashMap();
		map.put(name, value);
		return findBy(entityClass, map);
	}

	/**
	 * 根据属性名和属性值查询对象.
	 *
	 * @return 符合条件的唯一对象
	 */
	public <T> T findUniqueBy(Class<T> entityClass, String name, Object value) {
		Assert.hasText(name);
		Map map = new HashMap();
		try {
			map.put(name, value);
			map.put("findUniqueBy", "True");
			return (T) getSqlMapClientTemplate().queryForObject(sqlMapNamespace + POSTFIX_SELECTMAP, map);
		} catch (Exception e) {
			logger.error("Error when propertie on entity," + e.getMessage(), e.getCause());
			return null;
		}

	}

	/**
	 * map查询.
	 *
	 * @param map 包含各种属性的查询
	 */
	public <T> List<T> findByLike(Class<T> entityClass, Map map) {
		if (map == null)
			return this.getSqlMapClientTemplate().queryForList(sqlMapNamespace + POSTFIX_SELECT, null);
		else {
			map.put("findLikeBy", "True");
			return this.getSqlMapClientTemplate().queryForList(sqlMapNamespace + POSTFIX_SELECTMAP, map);
		}
	}
	
	/**
	 * 根据属性名和属性值以Like AnyWhere方式查询对象.
	 */
	public <T> List<T> findByLike(Class<T> entityClass, String name, String value) {
		Assert.hasText(name);
		Map map = new HashMap();
		map.put(name, value);
		return findByLike(entityClass, map);
	}

	/**
	 * 分页查询函数，使用PaginatedList.
	 *
	 * @param pageNo 页号,从0开始.
	 */
	public Page pagedQuery(Class entityClass, Object parameterObject, int pageNo, int pageSize) {

		int startIndex = Page.getStartOfPage(pageNo, pageSize);
		Integer totalCount = (Integer) this.getSqlMapClientTemplate().queryForObject(
				sqlMapNamespace + POSTFIX_COUNT, parameterObject);

		if (totalCount == null || totalCount == 0)
			return new Page();
		
		List list = new ArrayList();
		int totalPageCount = 0;
		
		if (pageSize <= 0 || pageNo <= 0)
			return new Page();
		
		totalPageCount = (totalCount / pageSize);
		totalPageCount += ((totalCount % pageSize) > 0) ? 1 : 0;

		if (pageNo > totalPageCount)
			return new Page();
		
		list = getSqlMapClientTemplate().queryForList(sqlMapNamespace + POSTFIX_SELECTMAP,
				parameterObject, startIndex, pageSize);
		
		return new Page(startIndex, totalCount, pageSize, list);
	}

}
