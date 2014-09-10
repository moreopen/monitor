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
function isDigit(s) {
	 var patrn=/^\d*$/;
	 if (patrn.test(s)) {   
	           return true;
	   } else {
	           return false;
	   }
	   return false;
}

$(document).ready(function(){
	$("#ruleUploadList").datagrid({"url":"/monitor/admin/getRuleUploadJson.htm"});
	$.ajax({
		type:"POST",
		url: '/monitor/admin/getEventJson.htm', 
		dataType: 'json',
		success:function(json){
			var r=json.rows;
			var options=$("#event").html();;
			var optionsForAdd=$("#eventAdd").html();
			var optionsForEdit=$("#eventEdit").html();
			for(var i=0;i<r.length;i++){
				options=options+"<option value=\""+r[i].monitorEventId+"\">"+r[i].monitorEventName+"("+r[i].monitorEventId+")"+"</option>";
				optionsForAdd=optionsForAdd+"<option value=\""+r[i].monitorEventId+"\">"+r[i].monitorEventName+"("+r[i].monitorEventId+")"+"</option>";
				optionsForEdit=optionsForEdit+"<option value=\""+r[i].monitorEventId+"\">"+r[i].monitorEventName+"("+r[i].monitorEventId+")"+"</option>";
			}
			$("#event").html(options);
			$("#eventAdd").html(optionsForAdd);
			$("#eventEdit").html(optionsForAdd);
		}
	});
	/**$("#event").change(function(){
		var event=$("#event").val().trim();
		if(event==""){
			$("#ruleUploadList").datagrid({"url":"/monitor/admin/getRuleUploadJson.htm"});
		}else{
			$("#ruleUploadList").datagrid({"url":"/monitor/admin/getRuleUploadJson.htm?eventId="+$("#event").val()});
		}
	})
**/
})

	
	function openAddUploadDlg(){
		$("#addRuleUploadDlg").dialog("open");
	}
	function addRuleUpload(){
		var eventId=$("#eventAdd").val();
		var uploadRuleId=$("#uploadRuleId").val().trim();
		var uploadInterval=$("#uploadInterval").val().trim();
		var uploadRuleLogicClass=$("#uploadRuleLogicClass").val().trim();
		if(eventId==""){
			alert("请选择监控事件!");
			$("#eventAdd").focus();
			return;
		}
		if(uploadRuleId==""){
			alert("请输入上报规则ID!");
			$("#uploadRuleId").focus();
			return;
		}
		if(uploadInterval==""){
			alert("请输入上报时间间隔!");
			$("#uploadInterval").focus();
			return;
		}
		if(!isDigit(uploadInterval)){
			alert("时间间隔只能是数字，请重新输入!");
			$("#uploadInterval").val("");
			$("#uploadInterval").focus();
			return;
		}
		if(uploadRuleLogicClass==""){
			alert("请输入上报逻辑处理类!");
			$("#uploadRuleLogicClass").focus();
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/addRuleUpload.htm",
			data:{eventId:eventId,uploadRuleId:uploadRuleId,uploadInterval:uploadInterval,uploadRuleLogicClass:uploadRuleLogicClass},
			dataType:"text",
			success:function(msg){
				if(msg=="hasData"){
					alert("上报规则ID已经存在，请重新输入!");
					return;
				}else{
					$("#ruleUploadList").datagrid("reload");
					$("#addRuleUploadDlg").dialog("close");
					
					$("#uploadRuleId").val("");
					$("#uploadInterval").val("");
					$("#uploadRuleLogicClass").val("");
				}
			}
		})
		
	}
	function openEditUploadDlg(){
		var row=$("#ruleUploadList").datagrid("getSelected");
		if(row==null){
			alert("请选择upload!");
			return;
		}else{
			$("#editUploadRuleId").val(row.uploadRuleId);
			$("#editUploadInterval").val(row.uploadInterval);
			$("#editUploadRuleLogicClass").val(row.uploadRuleLogicClass);
			$("#eventEdit").val(row.monitorEventId);
			$("#editRuleUploadDlg").dialog("open");
		}
	}
	function editRuleUpload(){
		var uploadRuleId=$("#editUploadRuleId").val().trim();
		var uploadInterval=$("#editUploadInterval").val().trim();
		var uploadRuleLogicClass=$("#editUploadRuleLogicClass").val().trim();
		var eventId=$("#eventEdit").val();
		
		if(eventId==""){
			alert("请选择监控事件!");
			$("#eventEdit").focus();
			return;
		}
		
		if(uploadRuleId==""){
			alert("请输入uploadRuleId!");
			return;
		}
		if(uploadInterval==""){
			alert("请输入uploadInterval!");
			return;
		}
		if(!isDigit(uploadInterval)){
			alert("时间间隔只能是数字，请重新输入!");
			$("#editUploadInterval").val("");
			$("#editUploadInterval").focus();
			return;
		}
		if(uploadRuleLogicClass==""){
			alert("请输入uploadRuleLogicClass!");
			return;
		}
		
		
		var row=$("#ruleUploadList").datagrid("getSelected");
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/updateRuleUpload.htm",
			data:{id:row.id,uploadRuleId:uploadRuleId,uploadInterval:uploadInterval,uploadRuleLogicClass:uploadRuleLogicClass,eventId:eventId},
			dataType:"text",
			success:function(msg){
				if(msg=="hasData"){
					alert("上报规则ID已经存在，请重新输入!");
					return;
				}else{
					$("#ruleUploadList").datagrid("reload");
					$("#editRuleUploadDlg").dialog("close");
					$("#editUploadRuleId").val("");
					$("#editUploadInterval").val("");
					$("#editUploadRuleLogicClass").val("");
				}
			}
		})
	}
	
	function deleteUpload(){
		var row=$("#ruleUploadList").datagrid("getSelected");
		if(row==null){
			alert("请选择要删除的upload!");
			return;
		}
		if(confirm("确认要删除该规则吗?")){
			$.ajax({
				type:"POST",
				url:"/monitor/admin/deleteRuleUpload.htm",
				data:{id:row.id},
				success:function(msg){
					$("#ruleUploadList").datagrid("reload");
				}
			})
		}
	}
	function searchByUploadId(){
		var uploadId=$("#searchUploadId").val().trim();
		if(uploadId=="请输入上报规则ID"){
			uploadId="";
		}
		var eventId=$("#event").val().trim();
		$.ajax({
			type:"POST",
			url:"/monitor/admin/searchByUploadId.htm",
			data:{uploadId:uploadId,eventId:eventId},
			success:function(msg){
				var json=eval("("+msg+")");
				$("#ruleUploadList").datagrid("loadData",json);
			}
		})
	}
</script>
<title>Insert title here</title>
</head>
<body>
<div style="margin-bottom: 10px">
			监控事件:<select id="event"  class="parentSelect">
					<option value="">所有监控事件</option>
				</select>
				&nbsp;上报规则编号：<input id="searchUploadId" type="text" class="searchInput"/>
	<a id="search-button" href="#" class="easyui-linkbutton" iconCls="icon-search" onClick="javascript:searchByUploadId()">Search</a>
				
</div>
<div style="height:2px">&nbsp;</div>

<!-- RULE UPLOAD 列表 的DIALOG -->


	<div id="tb">

		<span class="addSpan" onclick="openAddUploadDlg()">新增</span>
		<span class="editSpan" onclick="openEditUploadDlg()">修改</span>
		<span class="delSpan" onclick="deleteUpload()">删除</span>
		
	</div>

	<table id="ruleUploadList" class="easyui-datagrid"
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
				
				<th data-options="field:'uploadRuleId',width:120">上报规则编号</th>
				<th data-options="field:'uploadInterval',width:100">上报间隔(秒)</th>
				<th data-options="field:'uploadRuleLogicClass',width:300">上报逻辑对象处理类</th>
				<th data-options="field:'appName',width:120">所属监控业务</th>
				<th data-options="field:'monitorEventName',width:120">所属监控事件</th>
				<th data-options="field:'createUserName',width:60">创建人</th>
				<th data-options="field:'createTimeFormat',width:120">创建时间</th>
				<th data-options="field:'updateUserName',width:60">修改人</th>
				<th data-options="field:'updateTimeFormat',width:120">修改时间</th>
			</tr>
		</thead>
	</table>
	
	<!-- 添加 rule Upload的Dlg -->
	<div id="addMonitorButtons">
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="addRuleUpload()">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addRuleUploadDlg').dialog('close')">取消</a>
	</div>
	<div id="addRuleUploadDlg" class="easyui-dialog" title="&nbsp;新增上报规则" style="width:450px;height:240px;"
		data-options="
			iconCls: 'icon-add',
			closed: true,
			modal: true,
			fitColumns:true,
			buttons: '#addMonitorButtons'
		">
		<table style="margin-top:10px"  width="100%">
			<tr>
					<td align="right">监控事件：</td>
					<td>
						<select id="eventAdd"  class="parentSelect">
							<option value="">选择监控事件</option>
						</select>					
					</td>
				</tr>
				<tr>
					<td align="right">上报规则编号：</td>
					<td><input type="text" id="uploadRuleId"/></td>
				</tr>
				<tr>
					<td align="right">上报间隔(秒)：</td>
					<td><input type="text" id="uploadInterval"/></td>
				</tr>
				<tr>
					<td align="right">上报逻辑对象处理类：</td>
					<td><input type="text" id="uploadRuleLogicClass"/>*Java代理必填</td>
				</tr>
				
			</table>

			
		</div>
		
	<!-- 更新 rule Upload的Dlg -->
	<div id="editUploadButtons">
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="editRuleUpload()">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#editRuleUploadDlg').dialog('close')">取消</a>
			</div>
	<div id="editRuleUploadDlg" class="easyui-dialog" title="修改上报规则" style="width:450px;height:240px;"
		data-options="
			iconCls: 'icon-list',
			closed: true,
			modal: true,
			fitColumns:true,
			buttons: '#editUploadButtons'
		">
		<table style="margin-top:10px" width="100%">
				<tr>
					<td align="right">监控事件：</td>
					<td>
						<select id="eventEdit"  class="parentSelect">
							<option value="">选择监控事件</option>
						</select>					
					</td>
				</tr>
				<tr>
					<td align="right">上报规则ID：</td>
					<td><input type="text" id="editUploadRuleId"/></td>
				</tr>
				<tr>
					<td align="right">上报间隔：</td>
					<td><input type="text" id="editUploadInterval"/>(秒)</td>
				</tr>
				<tr>
					<td align="right">上报逻辑对象处理类：</td>
					<td><input type="text" id="editUploadRuleLogicClass"/>*Java代理必填</td>
				</tr>
				
			</table>
		</div>

</body>
</html>