<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="/css/easyui.css">
<link rel="stylesheet" type="text/css" href="/css/icon.css">
<link rel="stylesheet" type="text/css" href="/css/demo.css">

<script type="text/javascript" src="/js/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="/js/jquery.easyui.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$(".left-a").click(function(){
			if(!$('#easyui-tabs').tabs('exists',$(this).attr("title"))){
				$("#easyui-tabs").tabs('add',{
					title: $(this).attr("title"),
					content: createFrame($(this).attr("url")),  // the new content URL
					closable: true,
					cache:false
				});
			}else{	//如果已经存在，就让其处于选中状态
				$('#easyui-tabs').tabs('select',$(this).attr('title')).selected;
			}
		});
		
		
	})

function createFrame(url)
{
	var s = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
	return s;
}
</script>
<style type="text/css">
.left-a{
margin: 3px;
display: block
}
</style>
<title>普通管理员后台</title>
</head>
<body>



<body class="easyui-layout">
	<div data-options="region:'north',border:true,split:true" style="height:25px;background: url('/images/layout-browser-hd-bg.gif');">
	<b>Moreopen Monitor</b>
	欢迎您,${sessionScope.user.userName}&nbsp;<a href="/monitor/login/exit.htm">退出</a>&nbsp;
	<!--
	&nbsp;
	<a href="/monitor/admin/superAdmin.htm">超级管理员后台</a>
	-->
	&nbsp;
	<a href="/monitor/main.htm">监控平台</a>
	</div>
	
	<div data-options="region:'west',split:true,title:'导航菜单'" style="width:250px;padding:10px;">
		<!--<a class="left-a" href="javascript:void(0)" title="管理用户" url="/monitor/user/userEditPage.htm">管理用户</a><br/-->
		<a class="left-a" href="javascript:void(0)" title="管理菜单" url="/monitor/menu/menuEditPage.htm">管理菜单</a><br/>
		
	</div>
	<div data-options="region:'east',split:true,collapsed:true,title:'East'" style="width:300px;padding:10px;">east region</div>
	
	<div data-options="region:'center',border:false">
		<!-- tabs 页面-->
		<div id="easyui-tabs" class="easyui-tabs" data-options="tools:'#tab-tools'" fit="true"></div>
	</div>
	<!-- 南边区域 -->
	<div data-options="region:'south',split:true" style="height:25px;background:url('/images/layout-browser-hd-bg.gif');padding:0px;text-align:center">
		版权所有，侵权不究 &copy;monitor.moreopen
	</div>
</body>
</html>