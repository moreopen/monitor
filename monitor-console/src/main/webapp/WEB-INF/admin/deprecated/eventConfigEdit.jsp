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
	function addEvent(){
		var monitorEventName=$("#monitorEventName").val().trim();
		var monitorEventClass=$("#monitorEventClass").val().trim();
		var monitorEventId=$("#monitorEventId").val().trim();
		var appName=$("#appId").val().trim().split("@")[1];
		var appId=$("#appIdForEventAdd").val().trim().split("@")[0];
		
		if(appId==""){
			alert("请选择监控业务!");
			$("#appIdForEventAdd").focus();
			return;
		}
		
		if(monitorEventId==""){
			alert("请输入事件编号!");
			return;
		}
		if(monitorEventName==""){
			alert("请输入事件名!");
			return;
		}
		
		
		
		
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/addEvent.htm",
			data:{monitorEventId:monitorEventId,monitorEventName:monitorEventName,monitorEventClass:monitorEventClass,appName:appName,appId:appId},
			dataType:"text",
			success:function(msg){
				if(msg=="hasData"){
					alert("事件编号已经存在，请重新输入!");
					$("#monitorEventId").focus();
				}else{
					$('#easyui-datagrid').datagrid('reload'); 
					$("#monitorEventId").val("");//清空
					$("#monitorEventName").val("");//清空
					$("#monitorEventClass").val("");//清空
					$("#appId").val("");//清空
					$("#addDlg").dialog('close');
				}
			}
		});
		
	}
	
	function openEditDlg(){
		var row=$("#easyui-datagrid").datagrid('getSelected');
		if(row==null){
			alert("请选择要修改的事件!");
			return;
		}else{
			$("#editDlg").dialog('open');
			$("#editMonitorEventId").val(row.monitorEventId);
			$("#editMonitorEventName").val(row.monitorEventName);
			$("#editMonitorEventClass").val(row.monitorEventClass);
			$("#appIdForEventEdit").val(row.appId);
		}
	}
	
	function editEvent(){
		var monitorEventName=$("#editMonitorEventName").val().trim();
		var monitorEventClass=$("#editMonitorEventClass").val().trim();
		var appId=$("#appIdForEventEdit").val();
		
		var row=$("#easyui-datagrid").datagrid('getSelected');
		var id=row.id;
		
		if(appId==""){
			alert("请选择监控业务!");
			$("#appIdForEventEdit").focus();
			return;
		}
		
		if(monitorEventName==""){
			alert("请输入事件名!");
			return;
		}
		
		
		
		var row=$("#easyui-datagrid").datagrid('getSelected');
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/updateEvent.htm",
			data:{id:id,monitorEventName:monitorEventName,monitorEventClass:monitorEventClass,appId:appId},
			dataType:'text',
			success:function(msg){
				if(msg=="hasData"){
					alert("事件编号已经存在，请重新输入!");
					$("#monitorEventId").focus();
				}else{
					$('#easyui-datagrid').datagrid('reload'); 
					$("#editDlg").dialog('close');
				}
			}
		});
	}
	
	
	function deleteEvent(){
		var data=$("#easyui-datagrid").datagrid('getSelected');
		if(data==null){
			alert("请选择要删除的事件!");
			return;
		}else{
			if(confirm("确认要删除该事件吗？该操作将关联删除与此事件相关的其他所有配置！")){
				$.ajax({
					type:"POST",
					url:"/monitor/admin/deleteEvent.htm",
					data:{id:data.id,monitorEventId:data.monitorEventId},
					success:function(msg){
						$('#easyui-datagrid').datagrid('reload'); 
					}
				});
			}
		}
	}
	
	
	function searchByEventName(){
		var eventId=$("#searchEventId").val().trim();
		var eventName=$("#searchEventName").val().trim();
		var appId=$("#appId").val().trim();
		if(appId!=""){
			appId=appId.split("@")[0];
		}
		$.ajax({
			type:"POST",
			url:"/monitor/admin/searchByEventName.htm",
			data:{eventName:eventName,appId:appId,eventId:eventId},
			success:function(msg){
				var json=eval("("+msg+")");
				$("#easyui-datagrid").datagrid("loadData",json);
			}
		})
	}
	
	$(document).ready(function(){
		$("#easyui-datagrid").datagrid({"url":"/monitor/admin/getEventJson.htm"})
		$.ajax({
			type:"POST",
			url:"/monitor/admin/getAppJson.htm",
			success:function(msg){
				var json=eval("("+msg+")");
				var options=$(".parentSelect").html();
				var optionsForAdd=$("#appIdForEventAdd").html();
				var optionsForEdit=$("#appIdForEventEdit").html();
				for(var i=0;i<json.length;i++){
					options=options+"<option value="+json[i].appId+"@"+json[i].appName+">"+json[i].appName+"("+json[i].appId+")"+"</option>";
					optionsForAdd=optionsForAdd+"<option value="+json[i].appId+"@"+json[i].appName+">"+json[i].appName+"("+json[i].appId+")"+"</option>";
					optionsForEdit=optionsForEdit+"<option value=\""+json[i].appId+"\">"+json[i].appName+"("+json[i].appId+")"+"</option>";
				}
				$(".parentSelect").html(options);
				$("#appIdForEventAdd").html(optionsForAdd);
				$("#appIdForEventEdit").html(optionsForEdit);
				
			}
		});
	/**	$("#appId").change(function(){
			var appId=$("#appId").val().trim();
			if(appId==""){
				$("#easyui-datagrid").datagrid({"url":"/monitor/admin/getEventJson.htm"})
			}else{
				$("#easyui-datagrid").datagrid({"url":"/monitor/admin/getEventJson.htm?appId="+$("#appId").val().trim().split("@")[0]})
			}
		})
		**/
	
	})
	
	
	</script>

</head>
<body>

	
	<div>
	
	监控业务：
	<select id="appId" class="parentSelect">
			<option value="">所有监控业务</option>
	</select>
	监控事件编号：
	<input id="searchEventId"  type="text"/>
	监控事件名：
	<input id="searchEventName"  type="text" />
	<a id="search-button" href="#" class="easyui-linkbutton" iconCls="icon-search" onClick="javascript:searchByEventName()">Search</a>
	</div>
	
	<div style="margin:10px 0;"></div>

	<div id="tb">

		<span class="addSpan" onclick="openAddDlg()">新增</span>
		<span class="editSpan" onclick="openEditDlg()">修改</span>
		<span class="delSpan" onclick="deleteEvent()">删除</span>
	</div>

	<table id="easyui-datagrid" class="easyui-datagrid"
			rownumbers="true" 
			idField="id" 
			striped="true"
			pagination="true"
			pageSize="20"
			singleSelect="true"
			method="get"
			toolbar="#tb"
			pageList="[20,50,100]"
			>
		<thead>
			<tr>
				<th data-options="field:'monitorEventId',width:120">事件编号</th>
				<th data-options="field:'monitorEventName',width:120">事件名</th>
				<th data-options="field:'monitorEventClass',width:300">监控事件类全路径(Java代理必填)</th>
				<th data-options="field:'appName',width:100">所属监控业务</th>
				<th data-options="field:'appId',width:100">所属监控业务ID</th>
				<th data-options="field:'createUserName',width:100">创建人</th>
				<th data-options="field:'createTimeFormat',width:120">创建时间</th>
				<th data-options="field:'updateUserName',width:60">修改人</th>
				<th data-options="field:'updateTimeFormat',width:120">修改时间</th>
			</tr>
		</thead>
	</table>
	
	<!-- 添加事件的dialog -->
	<div id="addDlg" class="easyui-dialog" title="&nbsp;&nbsp;新增监控事件" style="width:600px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-add',
				buttons: '#add-buttons',
				closed: true,
				modal: true,
				fitColumns:true
			">
			<table width="100%">
				<tr>
					<td align="right">监控业务：</td>
					<td>
						<select id="appIdForEventAdd" class="parentSelect">
							<option value="">请选择监控业务</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">事件编号：</td>
					<td><input id="monitorEventId" type="text" name="monitorEventId" /></td>
				</tr>
				<tr>
					<td align="right">事件名：</td>
					<td><input id="monitorEventName" type="text" name="monitorEventName" /></td>
				</tr>
				<tr>
					<td align="right">监控事件类全路径：</td>
					<td><input id="monitorEventClass" type="text" name="monitorEventClass" />*Java代理必填</td>
				</tr>
			</table>
	</div>
	
	<div id="add-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="addEvent()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addDlg').dialog('close')">取消</a>
	</div>
	
	<!-- 修改事件的dialog -->
	<div id="editDlg" class="easyui-dialog" title="&nbsp;&nbsp;修改监控事件" style="width:600px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-edit',
				buttons: '#edit-buttons',
				closed: true,
				modal: true
			">
			<table  width="100%">
				<tr>
					<td align="right">监控业务：</td>
					<td>
						<select id="appIdForEventEdit" class="parentSelect">
							<option value="">请选择监控业务</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">事件编号：</td>
					<td><input id="editMonitorEventId" type="text" disabled/></td>
				</tr>
				<tr>
					<td align="right">事件名：</td>
					<td><input id="editMonitorEventName" type="text"  /></td>
				</tr>
				<tr>
					<td align="right">监控事件类全路径：</td>
					<td><input id="editMonitorEventClass" type="text"/></td>
				</tr>
				
			</table>
	</div>
	
	<div id="edit-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="editEvent()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#editDlg').dialog('close')">取消</a>
	</div>
	
	
</body>
</html>