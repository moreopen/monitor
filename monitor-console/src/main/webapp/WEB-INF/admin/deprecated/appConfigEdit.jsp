<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>TreeGrid ContextMenu - jQuery EasyUI Demo</title>
	<link rel="stylesheet" type="text/css" href="/css/easyui.css">
	<link rel="stylesheet" type="text/css" href="/css/icon.css">
	<link rel="stylesheet" type="text/css" href="/css/demo.css">
	<script type="text/javascript" src="/js/jquery-1.8.0.min.js"></script>
	<script type="text/javascript" src="/js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="/js/admin-main.js"></script>
	<script type="text/javascript">
	function openAddDlg(){
		$("#addDlg").dialog('open');
	}
	function addApp(){
		var newAppId=$("#newAppId").val().trim();
		
		var newAppName=$("#newAppName").val().trim();
		if(newAppId==""){
			alert("请输入业务ID!");
			return;
		}
		if(newAppName==""){
			alert("请输入业务名!");
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/addApp.htm",
			data:{newAppId:newAppId,newAppName:newAppName},
			dataType:"text",
			success:function(msg){
				if(msg=="hasData"){
					alert("appId已经存在，请重新输入!");
					$("#newAppId").focus();
				}else{
					$('#easyui-datagrid').datagrid('reload'); 
					$("#newAppId").val("");
					$("#newAppName").val("");
					$("#addDlg").dialog('close');
				}
			}
		});
	}
	
	function openEditDlg(){
		var row=$("#easyui-datagrid").datagrid('getSelected');
		if(row==null){
			alert("请选择要修改的业务!");
			return;
		}else{
			$("#editAppName").val(row.appName);
			$("#editAppId").val(row.appId);
			$("#editDlg").dialog('open');
			
		}
	}
	
	function editApp(){
		var appName=$("#editAppName").val().trim();
		
		if(appName==""){
			alert("请输入业务名!");
			return;
		}
		
		var row=$("#easyui-datagrid").datagrid('getSelected');
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/updateAppName.htm",
			data:{id:row.id,appName:appName},
			dataType:"text",
			success:function(msg){
				if(msg=="hasData"){
					alert("appId已经存在，请重新输入!");
					$("#editAppId").focus();
				}else{
					$("#editDlg").dialog('close');
					$("#editAppName").val("");
					$("#editAppId").val("");
					$('#easyui-datagrid').datagrid('reload'); 
				}
				
			}
		});
	}
	
	function deleteApp(){
		var data=$("#easyui-datagrid").datagrid('getSelected');
		if(data==null){
			alert("请选择要删除的业务!");
			return;
		}else{
			if(confirm("确认要删除该业务吗？")){
				$.ajax({
					type:"POST",
					url:"/monitor/admin/deleteApp.htm",
					data:{id:data.id,appId:data.appId},
					success:function(msg){
						$('#easyui-datagrid').datagrid('reload'); 
					}
				});
			}
		}
	}
	function searchByAppName(){
		var appName=$("#searchAppName").val().trim();
		var appId=$("#searchAppId").val().trim();
		$.ajax({
			type:"POST",
			url:"/monitor/admin/searchByAppName.htm",
			data:{appId:appId,appName:appName},
			success:function(msg){
				var json=eval("("+msg+")");
				$("#easyui-datagrid").datagrid("loadData",json);
			}
		})
	}
	</script>
	<style type="text/css">
		.addSpan{
			background:url('/icons/edit_add.png') no-repeat; height:22px; width: 33px;padding-left:20px;display:inline-block;cursor: pointer;
		}
		.delSpan{
			background:url('/icons/edit_remove.png') no-repeat; height:22px; width: 33px;padding-left:20px;display:inline-block;cursor: pointer;
		}
		.editSpan{
			background:url('/icons/pencil.png') no-repeat; height:22px; width: 33px;padding-left:20px;display:inline-block;cursor: pointer;
		}
		.editResourceSpan{
			background:url('/icons/ok.png') no-repeat; height:22px; width: 70px;padding-left:20px;display:inline-block;cursor: pointer;
		}
		.dialog-content{
			/**line-height: 109px**/
		}
	</style>
</head>
<body>
<table>
	<tr>
		<td>	
			业务编号：
		</td>
		<td>
			<input id="searchAppId" type="text"/>
		</td>
		<td>	
			业务名：
		</td>
		<td>
			<input id="searchAppName" type="text"/>
		</td>
		<td>
			<a id="search-button" href="#" class="easyui-linkbutton" iconCls="icon-search" onClick="javascript:searchByAppName()">Search</a>
		</td>
	</tr>
</table>

	<div id="tb">

		<span class="addSpan" onclick="openAddDlg()">新增</span>
		<span class="editSpan" onclick="openEditDlg()">修改</span>
		<span class="delSpan" onclick="deleteApp()">删除</span>

	</div>
	<table id="easyui-datagrid" class="easyui-datagrid"
			url="/monitor/admin/getAppJson.htm" 
			rownumbers="true" 
			idField="id" 
			striped="true"
			pagination="true"
			pageSize="20"
			singleSelect="true"
			toolbar="#tb"
			pageList="[20,50,100]"
			>
		<thead>
			<tr>
				<th data-options="field:'appId',width:120">业务编号</th>
				<th data-options="field:'appName',width:180">业务名</th>
				<th data-options="field:'createUserName',width:60">创建者</th>
				<th data-options="field:'createTimeFormat',width:120">创建时间</th>
				<th data-options="field:'updateUserName',width:60">更新者</th>
				<th data-options="field:'updateTimeFormat',width:120">最近更新时间</th>
			</tr>
		</thead>
	</table>
	
	<!-- 添加资源的dialog -->
	<div id="addDlg" class="easyui-dialog" title="&nbsp;&nbsp;新增监控业务" style="width:350px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-add',
				toolbar: '#dlg-toolbar',
				buttons: '#dlg-buttons',
				closed: true,
				modal: true,
				fitColumns:true
			">
			<table width="100%">
				<tr>
					<td align="right">业务编号：</td>
					<td><input id="newAppId" type="text" name="newAppId"/></td>
				</tr>
				<tr>
					<td align="right">业务名：</td>
					<td><input id="newAppName" type="text" name="newAppName"/></td>
				</tr>
			</table>
	</div>
	
	<div id="dlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="addApp()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addDlg').dialog('close')">取消</a>
	</div>
	
	<!-- 修改业务的dialog -->
	<div id="editDlg" class="easyui-dialog" title="&nbsp;&nbsp;修改业务" style="width:350px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-edit',
				buttons: '#edit-buttons',
				closed: true,
				modal: true
			">
			<table width="100%">
				<tr>
					<td align="right">业务编号：</td>
					<td><input id="editAppId" type="text" name="newAppName" disabled/></td>
				</tr>
				<tr>
					<td align="right">业务名：</td>
					<td><input id="editAppName" type="text" name="newAppName"/></td>
				</tr>
			</table>
	</div>
	
	<div id="edit-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="editApp()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#editDlg').dialog('close')">取消</a>
	</div>
		
</body>
</html>