<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="/css/easyui.css">
<link rel="stylesheet" type="text/css" href="/css/icon.css">
<link rel="stylesheet" type="text/css" href="/css/demo.css">
	


<script type="text/javascript" src="/js/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="/js/jquery.easyui.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#dataRiskList").datagrid({"url":"/monitor/admin/getDataRiskJson.htm?"});
	var options=$("#items").html();
	var optionsForAdd=$("#itemsForAdd").html();
	var optionsForEdit=$("#itemsForEdit").html();
	$.getJSON("/monitor/admin/getAllItemsJson.htm",function(data){
		$.each(data,function(index,json){
			options=options+"<option value=\""+json.monitorEventItemId+"-"+json.monitorEventId+"\">"+json.monitorEventName+"-"+json.monitorEventItemName+"</option>";
			optionsForAdd=optionsForAdd+"<option value=\""+json.monitorEventItemId+"-"+json.monitorEventId+"\">"+json.monitorEventName+"-"+json.monitorEventItemName+"</option>";
			optionsForEdit=optionsForEdit+"<option value=\""+json.monitorEventItemId+"-"+json.monitorEventId+"\">"+json.monitorEventName+"-"+json.monitorEventItemName+"</option>";
		})
		$("#items").html(options);
		$("#itemsForAdd").html(optionsForAdd);
		$("#itemsForEdit").html(optionsForEdit);
	});
/**	$("#items").change(function(){
		var itemEvent=$("#items").val().trim();
		if(itemEvent==""){
			$("#dataRiskList").datagrid({"url":"/monitor/admin/getDataRiskJson.htm"});
		}else{
			var itemId=$("#items").val().split('-')[0];
			var eventId=$("#items").val().split('-')[1];
			$("#dataRiskList").datagrid({"url":"/monitor/admin/getDataRiskJson.htm?eventId="+eventId+"&itemId="+itemId});
		}
		$("#dataRiskList").datagrid("unselectAll");
	});
	**/
	$("#itemsForAdd").change(function(){//增加事件弹框中，如果选择监控项，ip下拉框需要相应的改变
		var itemId=$(this).val().split('-')[0];
		var eventId=$(this).val().split('-')[1];
		var options="<option value=\"\">请选择主机</option>";
		$.ajax({
	 		type:"POST",
	 		url:"/monitor/ipport/getIpPortByEvenId.htm?eventId="+eventId+"&itemId="+itemId,
	 		success:function(msg){
	 			var json=eval("("+msg+")");
	 			for(var i=0;i<json.length;i++){
	 				options=options+"<option value=\""+json[i].monitorEventIpPort+"\">"+json[i].monitorEventIpPort+"</option>"
	 			}
	 			$("#ipPort").html(options);
	 		}
	 	})
	});
	$("#itemsForEdit").change(function(){//增加事件弹框中，如果选择监控项，ip下拉框需要相应的改变
		var itemId=$(this).val().split('-')[0];
		var eventId=$(this).val().split('-')[1];
		var options="<option value=\"\">请选择主机</option>";
		$.ajax({
	 		type:"POST",
	 		url:"/monitor/ipport/getIpPortByEvenId.htm?eventId="+eventId+"&itemId="+itemId,
	 		success:function(msg){
	 			var json=eval("("+msg+")");
	 			for(var i=0;i<json.length;i++){
	 				options=options+"<option value=\""+json[i].monitorEventIpPort+"\">"+json[i].monitorEventIpPort+"</option>"
	 			}
	 			$("#ipPortEdit").html(options);
	 		}
	 	})
	});
})
/**
 * 格式化时间输入
 */
$.fn.datebox.defaults.formatter = function(date){
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			return y+'/'+m+'/'+d;
		}
function openEditDlg(){
	var row=$("#dataRiskList").datagrid("getSelected");
	if(row==null){
		alert("请选择需要修改的风险事件!");
		return;
	}else{
	//	$("#itemsForEdit").val(row.monitorEventItemId+"-"+row.monitorEventId); 修改时候 不自动选择，便于动态加载IP
		$("#editRiskEventId").val(row.riskEventId);
		$("#editRiskEventName").val(row.riskEventName);
		$("#editRiskDescribe").val(row.riskDescribe);
		$("#editRiskDealwithDescribe").val(row.riskDealwithDescribe);
		$("#editRiskLevel").val(row.riskLevel);
		$("#editRisk").dialog("open");
	}
}
function updateRisk(){
	var row=$("#dataRiskList").datagrid("getSelected");
	var id=row.id;
	var riskEventId=$("#editRiskEventId").val().trim();
	var riskEventName=$("#editRiskEventName").val().trim();
	var riskDescribe=$("#editRiskDescribe").val().trim();
	var riskDealwithDescribe=$("#editRiskDealwithDescribe").val().trim();
	var riskLevel=$("#editRiskLevel").val().trim();
	var item=$("#itemsForEdit").val().trim();
	var itemId=item.split("-")[0];
	var eventId=item.split("-")[1];
	
	if(itemId==""){
		alert("请选择监控项!");
		$("#itemsForEdit").focus();
		return;
	}
	
	if(riskEventId==""){
		alert("请输入风险事件编号");
		$("#editRiskEventId").focus();
		return;
	}
	if(riskEventName==""){
		alert("请输入风险事件名称!");
		$("#editRiskEventName").focus();
		return;
	}
	if(riskDescribe==""){
		alert("请输入风险事件描述!");
		$("#editRiskDescribe").focus();
		return;
	}
	if(riskDealwithDescribe==""){
		alert("请输入事件处理描述");
		$("#editRiskDealwithDescribe").focus();
		return;
	}
	$.ajax({
		type:"POST",
		url:"/monitor/admin/updateDataRisk.htm",
		data:{id:id,riskEventName:riskEventName,riskDescribe:riskDescribe,riskDealwithDescribe:riskDealwithDescribe,riskLevel:riskLevel,itemId:itemId,eventId:eventId},
		success:function(msg){
			$("#dataRiskList").datagrid("reload");
			$("#editRisk").dialog("close");
		}
	})
	
}

function deleteRisk(){
	var row=$("#dataRiskList").datagrid("getSelected");
	if(row==null){
		alert("请选择需要删除的风险事件!");
		return;
	}else{
		if(confirm("确认删除此风险事件?")){
			$.ajax({
				type:"POST",
				url:"/monitor/admin/deleteDataRisk.htm",
				data:{id:row.id},
				success:function(msg){
					$("#dataRiskList").datagrid("unselectAll")
					$("#dataRiskList").datagrid("reload");
				}
			})
		}
	}
}
function openRiskDialog(){
	$("#addDataRiskDlg").dialog("open");
}
/**
	**增加风险事件的方法
	**/
function addDataRisk(){
		var item=$("#itemsForAdd").val().trim();
		var itemId=item.split("-")[0];
		var eventId=item.split("-")[1];
		var riskEventId=$("#riskEventId").val().trim();
		var riskEventName=$("#riskEventName").val().trim();
		var riskDescribe=$("#riskDescribe").val().trim();
		var riskLevel=$("#riskLevel").val().trim();
		var eventCreateTime=$('#eventCreateTime').datetimebox('getValue');
		var createTime=(new Date(eventCreateTime)).getTime();
		var ipport=$("#ipPort").val().trim();
		
		if(itemId==""){
			alert("请选择监控项!");
			$("#itemsForAdd").focus();
			return;
		}
		
		if(riskEventId==""){
			alert("请输入风险事件编号!");
			$("#riskEventId").focus();
			return;
		}
		if(riskEventName==""){
			alert("请输入风险名称!");
			$("#riskEventName").focus();
			return;
		}
		if(riskDescribe==""){
			alert("请输入风险描述!");
			$("#riskDescribe").focus();
			return;
		}
		if(riskLevel==""){
			alert("请输入风险级别!");
			$("#riskLevel").focus();
			return;
		}
		if(ipport==""){
			alert("请选择主机端口!");
			$("#ipport").focus();
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/addDataRisk.htm?eventId="+eventId+"&itemId="+itemId,
			data:{riskEventId:riskEventId,riskEventName:riskEventName,riskDescribe:riskDescribe,riskLevel:riskLevel,eventCreateTime:createTime,ipport:ipport},
			dataType:"text",
			success:function(msg){
				if(msg=="hasData"){
					alert("风险事件编号已经存在，请重新输入!");
					$("#riskEventId").focus();
					return;
				}else{
					$("#riskEventId").val("");
		 			$("#riskEventName").val("");
		 			$("#riskDescribe").val("");
		 			$("#riskLevel").val("");
		 			
					$("#addDataRiskDlg").dialog("close");
					$("#dataRiskList").datagrid("reload");
				}
			}
		})
	}

function searchByRiskName(){
	var riskName=$("#searchRiskName").val().trim();
	var riskId=$("#searchRiskId").val().trim();
	var item=$("#items").val().trim();
	if(item!=""){
		item=item.split("-")[0];
	}
	$.ajax({
		type:"POST",
		url:"/monitor/admin/searchByRiskName.htm",
		data:{item:item,riskName:riskName,riskId:riskId},
		success:function(msg){
			var json=eval("("+msg+")");
			$("#dataRiskList").datagrid("loadData",json);
		}
		
	})
}
</script>
</head>
<body>


<div>
	监控项：<select id="items" class="parentSelect">
		<option value="">所有监控项</option>
	</select>
	&nbsp;风险事件编号：<input id="searchRiskId" type="text" />
	&nbsp;风险事件名称：<input id="searchRiskName" type="text"/>
	<a id="search-button" href="#" class="easyui-linkbutton" iconCls="icon-search" onClick="javascript:searchByRiskName()">Search</a>
</div>
<div style="height";2px>&nbsp;</div>
	<div id="tb">
		<span class="addSpan" onclick="openRiskDialog()">新增</span>
		<span class="editSpan" onclick="openEditDlg()">修改</span>
		<span class="delSpan" onclick="deleteRisk()">删除</span>
	</div>
	
	<table id="dataRiskList" class="easyui-datagrid"
			rownumbers="true" 
			idField="id" 
			striped="true"
			pagination="true"
			pageSize="20"
			singleSelect="true"
			method="get"
			pageList="[20,50,100]"
			toolbar="#tb"
			>
		<thead>
			<tr>
				<th data-options="field:'riskEventId',width:120">风险事件编号</th>
				<th data-options="field:'riskEventName',width:100">风险事件名称</th>
				<th data-options="field:'riskLevel',width:60">风险级别</th>
				<th data-options="field:'riskDescribe',width:100">风险描述</th>
				<th data-options="field:'riskDealwithDescribe',width:120">风险处理描述</th>
				<th data-options="field:'createTimeFormat',width:180">风险发生时间</th>
				<th data-options="field:'createUserName',width:80">风险记录人</th>
				<th data-options="field:'updateTimeFormat',width:180">风险处理时间</th>
				<th data-options="field:'updateUserName',width:80">风险处理人</th>
				<th data-options="field:'appName',width:120">所属监控业务</th>
				<th data-options="field:'monitorEventName',width:120">所属监控事件</th>
				<th data-options="field:'monitorEventItemName',width:120">所属监控项</th>
			</tr>
		</thead>
	</table>
	
	<!-- 修改risk的dialog -->
	<div id="editRisk" class="easyui-dialog" title="修改风险事件"
			style="width:500px;height:300px;padding-top:10px;"
			data-options="
				iconCls: 'icon-edit',
				buttons: '#edit-risk-buttons',
				closed: true,
				modal: true,
				fitColumns:true
			">
			<table width="100%">
				<tr>
						<td align="right">监控项：</td>
						<td>
							<select id="itemsForEdit" class="parentSelect">
								<option value="">请选择监控项</option>
							</select>
						</td>
				</tr>
				<tr>
					<td align="right">风险事件编号：</td>
					<td><input id="editRiskEventId" type="text"  disabled/></td>
				</tr>
				<tr>
					<td align="right">风险事件名称：</td>
					<td><input id="editRiskEventName" type="text" /></td>
				</tr>
				<tr>
					<td align="right">风险描述：</td>
					<td>
						<textarea rows="1" cols="29" id="editRiskDescribe"></textarea>
					</td>
				</tr>
				<tr>
					<td align="right">风险处理描述：</td>
					<td>
						<textarea rows="1" cols="29" id="editRiskDealwithDescribe"></textarea>
					</td>
				</tr>
				<tr>
					<td align="right">风险级别：</td>
					<td>
					
						<select id="editRiskLevel">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
						</select>*值越大，表示风险越高
					</td>
				</tr>
				
				<tr>
					<td align="right">主机：</td>
					<td>
						<select id="ipPortEdit">
							<option value="">请选择主机</option>
						</select>
					</td>
				</tr>
			</table>
	</div>
	
	<div id="edit-risk-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="updateRisk()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#editRisk').dialog('close')">取消</a>
	</div>
	
	 <!-- 添加risk Dialog -->
	<div id="risk-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="addDataRisk()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addDataRiskDlg').dialog('close')">取消</a>
	</div>
	<div id="addDataRiskDlg" class="easyui-dialog" title="&nbsp;新增风险事件" style="width:450px;height:300px;padding:10px"
			data-options="
				iconCls: 'icon-add',
				buttons: '#risk-buttons',
				closed: true,
				modal: true,
				fitColumns:true
			">
			<input id="seriesIdForThisFlag" type="hidden" />
			<table width="100%">
				<tr>
					<td align="right">监控项：</td>
					<td>
						<select id="itemsForAdd" class="parentSelect">
							<option value="">请选择监控项</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">风险事件编号：</td>
					<td><input id="riskEventId" type="text" /></td>
				</tr>
				<tr>
					<td align="right">风险事件发生时间：</td>
					<td><input id="eventCreateTime" class="easyui-datetimebox" /></td>
				</tr>
				<tr>
					<td align="right">风险事件名称：</td>
					<td><input id="riskEventName" type="text" /></td>
				</tr>
				<tr>
					<td align="right">风险描述：</td>
					<td>
					<textarea rows="1" cols="29" id="riskDescribe"></textarea>
					</td>
				</tr>
				<tr>
					<td align="right">风险级别：</td>
					<td>
						<select id="riskLevel" style="padding:3px">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
						</select>*值越大，表示风险越高
					</td>
				</tr>
				
				
				
				<tr>
					<td align="right">主机：</td>
					<td>
						<select id="ipPort">
							<option value="">请选择主机</option>
						</select>
					</td>
				</tr>
			</table>
	</div>

</body>
</html>