package com.moreopen.monitor.console.controller.monitor;

import static org.springframework.web.bind.annotation.RequestMethod.POST;

import java.io.IOException;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.moreopen.monitor.console.biz.monitor.MonitorHostServiceImpl;
import com.moreopen.monitor.console.controller.BaseController;

@Controller
public class MonitorHostController extends BaseController {
	
	@Autowired
	private MonitorHostServiceImpl monitorHostServiceImpl;
	
	/**
	 * 根据监控代码获取对应的 IP 地址
	 * 
	 * @param request
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping(value = "/monitor/ipport/getHostsByMonitorCode", method = POST)
	public void getIpPort(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String monitorCode = request.getParameter("menuCode");
		Set<String> set = monitorHostServiceImpl.getIpListByMonitorCode(monitorCode);
		outputResult2Client(response, jsonSerializer.encode(set));
	}

}
