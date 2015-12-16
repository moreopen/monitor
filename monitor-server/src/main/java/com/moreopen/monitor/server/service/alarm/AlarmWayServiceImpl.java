package com.moreopen.monitor.server.service.alarm;

import static com.moreopen.monitor.server.constant.MonitorConstant.alarmWayEmail;
import static com.moreopen.monitor.server.constant.MonitorConstant.alarmWayPhone;
import static com.moreopen.monitor.server.constant.MonitorErrorConstant.ALARM_SENDMSG_ERROR;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;

import com.moreopen.monitor.server.exception.ServiceException;

/**
 * 报警 
 *
 */
@Deprecated
public class AlarmWayServiceImpl {
	
	@Autowired
	private TaskExecutor taskExecutor;
	
	@Autowired
	private EmailServiceImpl emailService;
	
	@Autowired
	private SMSServiceImpl smsService;
	
	@Autowired
	private ServiceException serviceException;

	/**
     * 报警：发送email
     * @param riskDescribe
     * @param toEmailList
     */
    public void sendMonitorEmail(String riskDescribe, String[] toEmailList){
    	 taskExecutor.execute(new MonitorAlarmTask(riskDescribe,toEmailList,alarmWayEmail));  
    }
    /**
     * 报警：发送phone
     * @param riskDescribe
     * @param toPhoneList
     */
    public void sendMonitorSMS(String riskDescribe, String[] toPhoneList){
    	 taskExecutor.execute(new MonitorAlarmTask(riskDescribe,toPhoneList,alarmWayPhone));  
    }
	/**
	 * 异步执行任务
	 * @author zhengjunwei
	 *
	 */
	private class MonitorAlarmTask implements Runnable {      
		 	private String riskDescribe;
		 	private String[] toStringArray;
		 	private String alarmWay;
	        public MonitorAlarmTask(String riskDescribe, String[] toStringArray,String alarmWay) {        
	            this.riskDescribe = riskDescribe;      
	            this.toStringArray=toStringArray;
	            this.alarmWay=alarmWay;
	        }      
	        public void run() {   
	            try {
	            	if(StringUtils.equals(alarmWay, alarmWayPhone)){
	    				 for(String phone:toStringArray){
	    					 smsService.sendSms(phone, riskDescribe);
	    				 }
	    			}else if(StringUtils.equals(alarmWay, alarmWayEmail)){
	    				emailService.sendMail("Monitor", riskDescribe, toStringArray);
	    			}
	            } catch (Exception e) {
	            	serviceException.setError(ALARM_SENDMSG_ERROR, "alarm sendmsg error", e.getStackTrace().toString());
					serviceException.toString();
	            }
	        }  
	    } 
}