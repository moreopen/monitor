package com.moreopen.monitor.console.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
/**
 * 专门用来做页面跳转的控制器
 *
 */
@Controller
public class DispatchController extends BaseController {
	/**
	 * 跳到超级管理员的界面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/monitor/admin/superAdmin",method = GET)
	public ModelAndView superAdmin(){
		ModelAndView mv=new ModelAndView("/admin/superAdmin");
		return mv;
	}
	
	@RequestMapping(value="/monitor/admin/commonAdmin",method = GET)
	public ModelAndView commonAdmin(){
		ModelAndView mv=new ModelAndView("/admin/commonAdmin");
		return mv;
	}
	/**
	 * 动态的监控页
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/monitor/dongtai/jqchart", method = GET)
	public ModelAndView jqchart() {
		ModelAndView mav = new ModelAndView("/jsp/jqchart");
		return mav;
	}
	
	/**
	 * 跳到用户注册页面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/monitor/user/userRegistPage", method = GET)
	public ModelAndView userRegistPage() {
		ModelAndView mav = new ModelAndView("/jsp/userRegistPage");
		return mav;
	}
	/**
	 * 跳到程序主界面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/monitor/main", method = GET)
	public ModelAndView main() {
		ModelAndView mav = new ModelAndView("/jsp/main");
		return mav;
	}
	
	/**
	 * 跳到登陆界面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/monitor/login/toLoginPage",method = GET)
	public ModelAndView toLoginPage(){
		ModelAndView mv=new ModelAndView("../login");
		return mv;
	}
	/**
	 * 去监控业务编辑页面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/monitor/admin/toAppConfigEditPage",method=GET)
	public ModelAndView toAppConfigPage(){
		ModelAndView mv=new ModelAndView("/admin/appConfigEdit");
		return mv;
	}
	
	/**
	 * 去监控事件编辑页面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/monitor/admin/toEventConfigEditPage",method=GET)
	public ModelAndView toEventConfigEditPage(){
		ModelAndView mv=new ModelAndView("/admin/eventConfigEdit");
		return mv;
	}
	
	/**
	 * 去监控项配置页面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/monitor/admin/toMonitorItemConfigPage",method = GET)
	public ModelAndView toMonitorItemConfigPage(){
		ModelAndView mv=new ModelAndView("/admin/itemConfigPage");

		return mv;
	}
	/**
	 * 去报警规则页面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/monitor/admin/toRuleAlarmconfigPage",method = GET)
	public ModelAndView toRuleAlarmconfigPage(){
		ModelAndView mv=new ModelAndView("/admin/ruleAlarmConfigPage");

		return mv;
	}
	
	/**
	 * 去监控规则页面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/monitor/admin/toRuleMonitorconfigPage",method = GET)
	public ModelAndView toRuleMonitorconfigPage(){
		ModelAndView mv=new ModelAndView("/admin/ruleMonitorConfigPage");

		return mv;
	}
	
	/**
	 * 去ipport配置页面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/monitor/admin/toIpPortconfigPage",method = GET)
	public ModelAndView toIpPortconfigPage(){
		ModelAndView mv=new ModelAndView("/admin/ipPortconfigPage");

		return mv;
	}
	
	/**
	 * 去upload配置页面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/monitor/admin/toUploadtconfigPage",method = GET)
	public ModelAndView toUploadtconfigPage(){
		ModelAndView mv=new ModelAndView("/admin/uploadtconfigPage");

		return mv;
	}
	
	
	/**
	 * 跳到监控详情页
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value="/monitor/dataEvent/dataEventPage",method = GET)
	public ModelAndView dataEventPage(){
		ModelAndView mv=new ModelAndView("/jsp/quxian2");

		return mv;
	}
	
	
	/**
	 * 跳到风险事件页面
	 * @return
	 */
	
	
	@RequestMapping(value="/monitor/admin/toDataRiskPage.htm",method = GET)
	public ModelAndView toDataRiskPage(){
		ModelAndView mv=new ModelAndView("/admin/datarisk");

		return mv;
	}
	

}
