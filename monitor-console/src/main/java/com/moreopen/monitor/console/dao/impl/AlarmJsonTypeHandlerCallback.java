package com.moreopen.monitor.console.dao.impl;

import java.sql.SQLException;

import org.apache.commons.lang.StringUtils;

import com.ibatis.sqlmap.client.extensions.ParameterSetter;
import com.ibatis.sqlmap.client.extensions.ResultGetter;
import com.ibatis.sqlmap.client.extensions.TypeHandlerCallback;
import com.moreopen.monitor.console.dao.bean.menu.Alarm;
import com.moreopen.monitor.console.utils.JsonUtils;

public class AlarmJsonTypeHandlerCallback implements TypeHandlerCallback {
	
	@Override
    public Object getResult(ResultGetter getter) throws SQLException {  
        String value = getter.getString();
        if (StringUtils.isBlank(value)) {
        	return null;
        }
        return JsonUtils.json2Bean(value, Alarm.class);  
    }  

    @Override
    public void setParameter(ParameterSetter setter, Object parameter) throws SQLException {  
        if (parameter == null) {
        	setter.setString(null);
        } else {
        	setter.setString(JsonUtils.bean2Json(parameter));
        }
    }  
  
    @Override
    public Object valueOf(String s) {  
        return null;  
    }

}
