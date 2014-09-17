<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="/css/easyui.css">
<link rel="stylesheet" type="text/css" href="/css/icon.css">
<link rel="stylesheet" type="text/css" href="/css/demo.css">
<link rel="stylesheet" type="text/css" href="/css/default.css">

<script type="text/javascript" src="/js/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="/js/jquery.easyui.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
				$(".left-a").click(
						function() {
							if (!$('#easyui-tabs').tabs('exists',
									$(this).attr("title"))) {
								$("#easyui-tabs").tabs('add', {
									title : $(this).attr("title"),
									content : createFrame($(this).attr("url")), // the new content URL
									closable : true,
									cache : false
								});
							} else { //如果已经存在，就让其处于选中状态
								$('#easyui-tabs').tabs('select',$(this).attr("title"));
								var currTab = $('#easyui-tabs').tabs('getSelected');
							
								$("#easyui-tabs").tabs('update',{
									tab:currTab,
									options:{
										title: $(this).attr("title"),
										content: createFrame($(this).attr("url")),  // the new content URL
										closable: true,
										cache:false
									}
								});
							}
						});
				$('.easyui-accordion li a').click(function(){
					var tabTitle = $(this).children('.nav').text();

					var url = $(this).attr("rel");
					var menuid = $(this).attr("ref");
					//var icon = getIcon(menuid,icon);

				//	addTab(tabTitle,url,icon);
					$('.easyui-accordion li div').removeClass("selected");
					$(this).parent().addClass("selected");
				}).hover(function(){
					$(this).parent().addClass("hover");
				},function(){
					$(this).parent().removeClass("hover");
				});

			})

	function createFrame(url) {
		var s = '<iframe scrolling="auto" frameborder="0"  src="' + url
				+ '" style="width:100%;height:100%;"></iframe>';
		return s;
	}
</script>
<style type="text/css">
.left-a {
	margin: 3px;
	display: block
}
</style>
<title>超级管理员后台</title>
</head>
<body>
<body class="easyui-layout">
	<div data-options="region:'north',border:true,split:true"
		style="height: 25px; background: url('/images/layout-browser-hd-bg.gif');">
		<b>Moreopen Monitor</b> 欢迎您,${sessionScope.user.userName}&nbsp;<a
			href="/monitor/login/exit.htm">退出</a>&nbsp;
			&nbsp; <a href="/monitor/main.htm">监控平台</a>
	</div>

	<div data-options="region:'west',split:true,title:'导航菜单'"
		style="width: 200px;">
		<div class="easyui-accordion" style="width: 200px;" fit="true" border="false">
			<div  title="用户菜单管理" data-options="iconCls:'icon icon-set'" style="overflow:auto;padding:10px;" selected="true">
			<ul>
				<li>
					<div>
						<a class="left-a" href="javascript:void(0)" title="管理用户" url="/monitor/user/userEditPage.htm">
						<span class="icon icon-users">&nbsp;</span>管理用户</a>
					</div>
				</li>
				<li>
					<div>
						<a class="left-a" href="javascript:void(0)" title="管理角色" url="/monitor/role/roleEditPage.htm">
						<span class="icon icon-role">&nbsp;</span>管理角色</a>
					</div>
				</li>
				<li>
					<div>
						<a class="left-a" href="javascript:void(0)" title="管理菜单" url="/monitor/menu/menuEditPage.htm">
							<span class="icon icon-nav">&nbsp;</span>
							管理菜单
						</a>
					</div>
				</li>
				<!--
				<li>
					<div>
						<a class="left-a" href="javascript:void(0)" title="管理资源" url="/monitor/resource/resourceEditPage.htm">
						<span class="icon icon-nav">&nbsp;</span>
						管理资源</a>
					</div>
				</li>
				-->
			</ul>
				
			</div>
			
			<div  title="监控报警管理" data-options="iconCls:'icon icon-monitor'" style="overflow:auto;padding:10px;" selected="false">
				<ul>
					<!--
					<li>
						<div>
							<a class="left-a" href="javascript:void(0)" title="监控业务" url="/monitor/admin/toAppConfigEditPage.htm">
							<span class="icon icon-nav">&nbsp;</span>监控业务</a>
						</div>
					</li>
					<li>
						<div>
							<a class="left-a" href="javascript:void(0)" title="监控事件" url="/monitor/admin/toEventConfigEditPage.htm">
							<span class="icon icon-nav">&nbsp;</span>监控事件</a>
						</div>
					</li>
					<li>
						<div>
							<a class="left-a" href="javascript:void(0)" title="监控项配置" url="/monitor/admin/toMonitorItemConfigPage.htm">
							<span class="icon icon-nav">&nbsp;</span>监控项</a>
						</div>
					</li>
					-->
					<!--
						<li>
						<div>
							<a class="left-a" href="javascript:void(0)" title="配置主机" url="/monitor/admin/toIpPortconfigPage.htm">
							<span class="icon icon-nav">&nbsp;</span>主机</a>
						</div>
					</li>
					
					<li>
						<div>
							<a class="left-a" href="javascript:void(0)" title="配置上报规则" url="/monitor/admin/toUploadtconfigPage.htm">
							<span class="icon icon-nav">&nbsp;</span>上报规则</a>
						</div>
					</li>
					<li>
						<div>
							<a class="left-a" href="javascript:void(0)" title="配置监控规则" url="/monitor/admin/toRuleMonitorconfigPage.htm">
							<span class="icon icon-nav">&nbsp;</span>监控规则</a>
						</div>
					</li>
					<li>
						<div>
							<a class="left-a" href="javascript:void(0)" title="配置报警规则" url="/monitor/admin/toRuleAlarmconfigPage.htm">
							<span class="icon icon-nav">&nbsp;</span>报警规则</a>
						</div>
					</li>
				
					
					<li>
						<div>
							<a class="left-a" href="javascript:void(0)" title="风险事件管理" url="/monitor/admin/toDataRiskPage.htm">
							<span class="icon icon-nav">&nbsp;</span>风险事件</a>
						</div>
					</li>
					-->
				</ul>
			</div>
			
		</div>
	</div>

	<div data-options="region:'center',border:false" border="false">
		<!-- tabs 页面-->
		<div id="easyui-tabs" class="easyui-tabs"
			data-options="tools:'#tab-tools'" fit="true"></div>
	</div>
	
	<!-- 南边区域 -->
	<div data-options="region:'south',split:true" style="height:25px;background:url('/images/layout-browser-hd-bg.gif');padding:0px;text-align:center">
		版权所有，侵权不究 &copy;monitor.moreopen
	</div>
	
</body>
</html>