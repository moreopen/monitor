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
<!-- -->
<script type="text/javascript" src="/js/main.js"></script>

<script type="text/javascript">

function getTitle(node) {
	var title = node.text;
	var p = $('#easyui-tree').tree('getParent', node.target);
	while (p) {
		title = p.text + "-" + title;
		p = $('#easyui-tree').tree('getParent', p.target);
	}
	return title;
}

$(document).ready(function(){
	$("#requestUrl").val("");
	$('#easyui-tree').tree({
		onClick:function(node){
			if($(this).tree('isLeaf',node.target)){//如果是叶节点，点击就在右边添加tab
				/* if(node.attributes==undefined){
					alert("该菜单没有分配资源!");
					return;
				} */
				
				var title = getTitle(node);
				if(!$('#easyui-tabs').tabs('exists',title)){//如果这个标题的tab还不存在，就添加
					$('#easyui-tabs').tabs('add',{
							title: title,
							content: createFrame("/monitor/dataEvent/dataEventPage.htm?menuCode="+node.attributes.menuCode),  // the new content URL
							//content: createFrame(node.attributes.resourceUrl),  // the new content URL
							closable: true,
							cache:false
						});
			
				}else{	//如果已经存在，就让刷新并处于选中状态
					$('#easyui-tabs').tabs('select',title);
					var currTab = $('#easyui-tabs').tabs('getSelected');
					$("#easyui-tabs").tabs("update",{
						tab:currTab,
						options:{
							title: title,
							content: createFrame("/monitor/dataEvent/dataEventPage.htm?menuCode="+node.attributes.menuCode),  // the new content URL
							//content: createFrame(node.attributes.resourceUrl),  // the new content URL
							closable: true,
							cache:false
						}
					})
					
				}
			}
		}
	});
})


function createFrame(url)
{
	$("#requestUrl").val(url.replace("/monitor/dataEvent/dataEventPage.htm?",""));
	var s = '<iframe scrolling="auto" name="dd" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
	return s;
}

</script>

<title>Moreopen Monitor</title>
</head>
<body class="easyui-layout">


	<!-- 北面区域 -->
	<div data-options="region:'north',border:true,split:true" style="height:25px;background: url('/images/layout-browser-hd-bg.gif');">
		<b>Moreopen Monitor</b>
		欢迎您,${sessionScope.user.userName}&nbsp;<a href="/monitor/login/exit.htm">退出</a>&nbsp;
		<%if ("true".equals(request.getSession().getAttribute("superAdmin"))) {%>
		<a href="/monitor/admin/superAdmin.htm">超级管理员管理后台</a>&nbsp;
		<%} else {%>
		<a href="/monitor/admin/commonAdmin.htm">监控菜单管理</a>
		<%}%>
		
		<input type="hidden" id="requestUrl"> 
	</div>
	
	<!-- 左边区域 -->
	<div data-options="region:'west',split:true,title:'导航菜单'" style="width:250px;padding:10px;">
			<!-- 左边的树-->
			<ul 
				id="easyui-tree" 
				class="easyui-tree" 
				url="/monitor/menu/getMenuTree.htm"
				lines="true"
			>
			</ul>

	</div>
	
	<!-- 中间区域 -->
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