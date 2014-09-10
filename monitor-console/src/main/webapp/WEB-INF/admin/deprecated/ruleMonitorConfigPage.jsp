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
	var options="";
	var optionsForAdd=$("#itemsForAdd").html();//添加时候需要选择的监控项
	var optionsForEdit=$("#itemsForEdit").html();//编辑时候需要选择的监控项
	$.getJSON("/monitor/admin/getAllItemsJson.htm",function(data){
		$.each(data,function(index,json){
			options=options+"<option value=\""+json.monitorEventItemId+"-"+json.monitorEventId+"\">"+json.monitorEventName+"-"+json.monitorEventItemName+"</option>";
			optionsForAdd=optionsForAdd+"<option value=\""+json.monitorEventItemId+"-"+json.monitorEventId+"\">"+json.monitorEventName+"-"+json.monitorEventItemName+"</option>";
			optionsForEdit=optionsForEdit+"<option value=\""+json.monitorEventItemId+"\">"+json.monitorEventName+"-"+json.monitorEventItemName+"</option>";
		})
		var oldOptions=$("#items").html();
		$("#items").html(oldOptions+options);
		$("#itemsForAdd").html(optionsForAdd);
		$("#itemsForEdit").html(optionsForEdit);
		var itemValue=$("#items").val().trim();
		if(itemValue==""){
			$("#ruleMonitorList").datagrid({"url":"/monitor/admin/getRuleMonitorJson.htm"});
		}else{
			var itemId=$("#items").val().split('-')[0];
			var eventId=$("#items").val().split('-')[1];
			$("#ruleMonitorList").datagrid({"url":"/monitor/admin/getRuleMonitorJson.htm?eventId="+eventId+"&itemId="+itemId});
		}
	});
	/**$("#items").change(function(){
		var itemValue=$("#items").val().trim();
		if(itemValue==""){
			$("#ruleMonitorList").datagrid({"url":"/monitor/admin/getRuleMonitorJson.htm"});
		}else{
			var itemId=$("#items").val().split('-')[0];
			var eventId=$("#items").val().split('-')[1];
			$("#ruleMonitorList").datagrid({"url":"/monitor/admin/getRuleMonitorJson.htm?eventId="+eventId+"&itemId="+itemId});
		}
		$("#ruleMonitorList").datagrid("unselectAll");
	});
**/
})
	

	function addRuleMonitor(){
		var monitorRuleId=$("#monitorRuleId").val().trim();
		var monitorRuleName=$("#monitorRuleName").val().trim();
		var monitorRuleCondition=$("#monitorRuleCondition").val().trim();
		var monitorRuleThreshold=$("#monitorRuleThreshold").val().trim();
		var monitorType=$("#monitorType").val().trim();
		
		var monitorBeginTime=$("#monitorBeginTime").val().trim();
		
		var monitorEndTime=$("#monitorEndTime").val().trim();
		
		var monitorRisk=$("#monitorRisk").val().trim();
		var monitorPriority=$("#monitorPriority").val().trim();
		
		var itemId=$("#itemsForAdd").val().split('-')[0];
		var eventId=$("#itemsForAdd").val().split('-')[1];
		
		
		if(itemId==""){
			alert("请选择监控项!");
			$("#itemsForAdd").focus();
			return;
		}
		
		if(monitorRuleId==""){
			alert("请输入监控规则ID!");
			return;
		}
		if(monitorRuleName==""){
			alert("请输入监控名称!");
			return;
		}
		if(monitorRuleCondition==""){
			alert("请输入触发条件!");
			return;
		}
		if(monitorRuleThreshold==""){
			alert("请输入监控阀值!");
			return;
		}
		
		
		if(monitorType==""){
			alert("请选择监控类型!");
			return;
		}
		if(monitorBeginTime==""){
			alert("请选择监控开始时间!");
			return;
		}
		
		if(monitorEndTime==""){
			alert("请选择监控结束时间!");
			return;
		}
		var startMinute=(parseInt(monitorBeginTime.split(":")[0]))*60+(parseInt(monitorBeginTime.split(":")[1]));
		var endMinute=(parseInt(monitorEndTime.split(":")[0]))*60+(parseInt(monitorEndTime.split(":")[1]));
		if((endMinute<startMinute)||(endMinute==startMinute)){
			alert("监控结束时间应该大于开始时间!");
			return;
		}
		if(monitorRisk==""){
			alert("请输入监控风险值!");
			return;	
		}
		
		if(monitorPriority==""){
			alert("请选择优先级!");
			return;	
		}
		
		if (/[^\d]/.test(monitorRuleThreshold.trim())){
			alert("监控阀值只能为数字!");
			$("#monitorRuleThreshold").val("");
			$("#monitorRuleThreshold").focus();
			return;
		}
		
		
		if (/[^\d]/.test(monitorRisk.trim())){
			alert("监控风险值只能为数字!");
			$("#monitorRisk").val("");
			$("#monitorRisk").focus();
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/addRuleMonitor.htm",
			data:{monitorRuleId:monitorRuleId,monitorRuleName:monitorRuleName,monitorEventId:eventId,monitorEventItemId:itemId,monitorRuleCondition:monitorRuleCondition,monitorRuleThreshold:monitorRuleThreshold,monitorType:monitorType,monitorBeginTime:monitorBeginTime,monitorEndTime:monitorEndTime,monitorRisk:monitorRisk,monitorPriority:monitorPriority},
			dataType:"text",
			success:function(msg){
				if(msg=="hasData"){
					alert("规则ID已经存在，请重新输入!");
					$("#monitorRuleId").focus();
				}else{
					$("#addRuleMonitorDlg").dialog('close');
					$("#ruleMonitorList").datagrid("reload");
					
					$("#monitorRuleId").val("");
					$("#monitorRuleName").val("");
					$("#monitorRuleCondition").val("");
					$("#monitorRuleThreshold").val("");
					$("#monitorType").val("");
					$("#monitorBeginTime").val("");
					$("#monitorEndTime").val("");
					$("#monitorRisk").val("");
					$("#monitorPriority").val("");
				}
			}
		});
		
	}
	
	function openEditMonitorDlg(){
		var row=$("#ruleMonitorList").datagrid("getSelected");
		
		if(row==null){
			alert("请选择需要修改的监控规则!");
			return;
		}else{
			$("#editMonitorRuleId").val(row.monitorRuleId);
			$("#editMonitorRuleName").val(row.monitorRuleName);
			$("#editMonitorRuleCondition").val(row.monitorRuleCondition);
			$("#editMonitorRuleThreshold").val(row.monitorRuleThreshold);
			$("#editMonitorType").val(row.monitorType);
			$("#editMonitorBeginTime").val(row.monitorBeginTime);
			$("#editMonitorEndTime").val(row.monitorEndTime);
			$("#editMonitorRisk").val(row.monitorRisk);
			$("#editMonitorPriority").val(row.monitorPriority);
			$("#itemsForEdit").val(row.monitorEventItemId);
			
			$("#editRuleMonitorDlg").dialog("open");
		}
	}
	function eidtRuleMonitor(){
		var row=$("#ruleMonitorList").datagrid("getSelected");
		
		var monitorRuleId=$("#editMonitorRuleId").val().trim();
		var monitorRuleName=$("#editMonitorRuleName").val().trim();
		var monitorRuleCondition=$("#editMonitorRuleCondition").val().trim();
		var monitorRuleThreshold=$("#editMonitorRuleThreshold").val().trim();
		var monitorType=$("#editMonitorType").val().trim();
		
		var monitorBeginTime=$("#editMonitorBeginTime").val().trim();
		
		var monitorEndTime=$("#editMonitorEndTime").val().trim();
		
		var monitorRisk=$("#editMonitorRisk").val().trim();
		var monitorPriority=$("#editMonitorPriority").val().trim();
		var monitorEventItemId=$("#itemsForEdit").val().trim();
		
		if(monitorEventItemId==""){
			alert("请选择监控项!");
			$("#itemsForEdit").focus();
			return;
		}
		
		if(monitorRuleName==""){
			alert("请输入监控名称!");
			$("#editMonitorRuleName").focus();
			return;
		}
		
		if(monitorRuleCondition==""){
			alert("请选择触发条件!");
			$("#editMonitorRuleCondition").focus();
			return;
		}
		if(monitorRuleThreshold==""){
			alert("请输入监控阀值!");
			$("#editMonitorRuleThreshold").focus();
			return;
		}
		
		if(monitorType==""){
			alert("请选择监控类型!");
			$("#editMonitorType").focus();
			return;
		}
		if(monitorBeginTime==""){
			alert("请输入监控开始时间!");
			$("#editMonitorBeginTime").focus();
			return;	
		}
		
		if(monitorEndTime==""){
			alert("请输入监控结束时间!");
			$("#editMonitorEndTime").focus();
			return;	
		}
		
		var startMinute=(parseInt(monitorBeginTime.split(":")[0]))*60+(parseInt(monitorBeginTime.split(":")[1]));
		var endMinute=(parseInt(monitorEndTime.split(":")[0]))*60+(parseInt(monitorEndTime.split(":")[1]));
		if((endMinute<startMinute)||(endMinute==startMinute)){
			alert("监控结束时间应该大于开始时间!");
			return;
		}
		
		if(monitorRisk==""){
			alert("请输入监控风险值!");
			("#editMonitorRisk").focus();
			return;	
		}
		
		if(monitorPriority==""){
			alert("请选择优先级!");
			$("#editMonitorPriority").focus();
			return;	
		}
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/updateRoleMonitor.htm",
			data:{id:row.id,monitorRuleId:monitorRuleId,monitorRuleName:monitorRuleName,monitorRuleCondition:monitorRuleCondition,monitorRuleThreshold:monitorRuleThreshold,monitorType:monitorType,monitorBeginTime:monitorBeginTime,monitorEndTime:monitorEndTime,monitorRisk:monitorRisk,monitorPriority:monitorPriority,monitorEventItemId:monitorEventItemId},
			dataType:"text",
			success:function(msg){
				if(msg=="hasData"){
					alert("规则编号已经存在，请重新输入!");
					$("#editMonitorRuleId").focus();
				}else{
					$("#editRuleMonitorDlg").dialog('close');
					$("#ruleMonitorList").datagrid("reload");
				}
			}
		})
	}
	function deleteMonitor(){
		var row=$("#ruleMonitorList").datagrid("getSelected");
		if(row==null){
			alert("请选择要删除的monitor!");
			return;
		}else{
			if(confirm("确认要删除吗?")){
				$.ajax({
					type:"POST",
					url:"/monitor/admin/deleteRuleMonitor.htm",
					data:{id:row.id},
					success:function(msg){
						$("#ruleMonitorList").datagrid("reload");
					}
				})
			}
		}
	}
	function openAddDialog(){
		$("#addRuleMonitorDlg").dialog("open");
	}
	function searchByRuleName(){
		var ruleName=$("#searchRuleName").val().trim();
		var ruleId=$("#searchRuleId").val().trim();
		var item=$("#items").val().trim();
		if(item!=""){
			item=item.split("-")[0];
		}
		$.ajax({
			type:"POST",
			url:"/monitor/admin/searchByRuleName.htm",
			data:{ruleName:ruleName,item:item,ruleId:ruleId},
			success:function(msg){
				var json=eval("("+msg+")");
				$("#ruleMonitorList").datagrid("loadData",json);
			}
		})
	}
</script>
</head>
<body>
	监控项：<select id="items" class="parentSelect">
				<option value="">所有监控项</option>
			</select>
			&nbsp;监控规则编号：<input id="searchRuleId" type="text"/>
			&nbsp;监控规则名称：<input id="searchRuleName" type="text"/>
	<a id="search-button" href="#" class="easyui-linkbutton" iconCls="icon-search" onClick="javascript:searchByRuleName()">Search</a>
	
	<div style="height:2px">&nbsp;</div>
	
	<!-- RULE monitor 列表 的DIALOG -->
			
	<div id="tb">

		<span class="addSpan" onclick="openAddDialog()">新增</span>
		<span class="editSpan" onclick="openEditMonitorDlg()">修改</span>
		<span class="delSpan" onclick="deleteMonitor()">删除</span>
	</div>

	<table id="ruleMonitorList" class="easyui-datagrid"
			idField="id" 
			striped="true"
			pagination="true"
			pageSize="20"
			singleSelect="true"
			pageList="[20,50,100]"
			toolbar="#tb"
			>
		<thead>
			<tr>
				
				<th data-options="field:'monitorRuleId',width:120">监控规则编号</th>
				<th data-options="field:'monitorRuleName',width:80">监控规则名称</th>
				<th data-options="field:'monitorRuleConditionSymbol',width:80">触发条件</th>
				<th data-options="field:'monitorRuleThreshold',width:60">监控阀值</th>
				<th data-options="field:'monitorTypeString',width:80">监控类型</th>
				<th data-options="field:'monitorBeginTime',width:60">开始时间</th>
				<th data-options="field:'monitorEndTime',width:60">结束时间</th>
				<th data-options="field:'monitorRisk',width:80">监控风险值</th>
				<th data-options="field:'monitorPriority',width:60">优先级</th>
				<th data-options="field:'appName',width:120">所属监控业务</th>
				<th data-options="field:'monitorEventName',width:120">所属监控事件</th>
				<th data-options="field:'monitorEventItemName',width:120">所属监控项</th>
				<th data-options="field:'createUserName',width:60">创建人</th>
				<th data-options="field:'createTimeFormat',width:120">创建时间</th>
				<th data-options="field:'updateUserName',width:60">修改人</th>
				<th data-options="field:'updateTimeFormat',width:120">修改时间</th>
			</tr>
		</thead>
	</table>
	
	<!-- 添加 rule Monitor的Dlg -->
	<div id="addMonitorButtons">
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="addRuleMonitor()">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addRuleMonitorDlg').dialog('close')">取消</a>
	</div>
	<div id="addRuleMonitorDlg" class="easyui-dialog" title="&nbsp;&nbsp;新增监控规则" style="width:450px;height:440px;"
		data-options="
			iconCls: 'icon-add',
			buttons: '#addMonitorButtons',
			closed: true,
			modal: true,
			fitColumns:true
		">
		<table width="100%" style="margin-top:10px">
				<tr>
					<td align="right">
						监控项：
					</td>
					<td>
						<select id="itemsForAdd" class="parentSelect">
							<option value="">请选择监控项</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">监控规则编号：</td>
					<td><input type="text" id="monitorRuleId" /></td>
				</tr>
				<tr>
					<td align="right">监控名称：</td>
					<td><input type="text" id="monitorRuleName"/></td>
				</tr>
				<tr>
					<td align="right">触发条件：</td>
					<td>
						<select id="monitorRuleCondition">
							<option></option>
							<option value="lt">&lt;</option>
							<option value="gt">&gt;</option>
							<option value="eq">=</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">监控阀值：</td>
					<td><input type="text" id="monitorRuleThreshold"/></td>
				</tr>
				<!-- 
					<tr>
						<td align="right">时间窗长度：</td>
						<td><input type="text" id="timeWindow"/></td>
					</tr>
				 -->
				<tr>
					<td align="right">监控类型：</td>
					<td>
						<select id="monitorType">
							<option value=""></option>
							<option value="1">1-简单事件</option>
							<!-- <option value="2">2-复杂事件</option> -->
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">开始时间：</td>
					<td>
						<input id="monitorBeginTime" class="easyui-timespinner" style="width:80px;"/>
					</td>
				</tr>
				<tr>
					<td align="right">结束时间：</td>
					<td>
						<input id="monitorEndTime" class="easyui-timespinner" style="width:80px;"/>
					
					</td>
				</tr>	
				<tr>
					<td align="right">监控风险值：</td>
					<td><input type="text" id="monitorRisk"/></td>
				</tr>	
				<tr>
					<td align="right">优先级：</td>
					<td>
					<select id="monitorPriority">
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
						<option value="5">5</option>
					</select>*优先级越高，表示越紧急
					</td>
				</tr>	
				
			</table>
		</div>
		
		
<!-- 修改 rule Monitor的Dlg -->
	<div id="editMonitorButtons">
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="eidtRuleMonitor()">保存</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#editRuleMonitorDlg').dialog('close')">取消</a>
	</div>
	<div id="editRuleMonitorDlg" class="easyui-dialog" title="&nbsp;&nbsp;修改监控规则" style="width:450px;height:440px;"
		data-options="
			iconCls: 'icon-edit',
			closed: true,
			modal: true,
			fitColumns:true,
			buttons: '#editMonitorButtons'
		">
		<table width="100%"  style="margin-top:10px">
				<tr>
					<td align="right">
						监控项：
					</td>
					<td>
						<select id="itemsForEdit" class="parentSelect">
							<option value="">请选择监控项</option>
						</select>
					</td>
				</tr>	
				<tr>
					<td align="right">规则ID：</td>
					<td><input type="text" id="editMonitorRuleId" disabled/></td>
				</tr>
				<tr>
					<td align="right">监控名称：</td>
					<td><input type="text" id="editMonitorRuleName"/></td>
				</tr>
				<tr>
					<td align="right">触发条件：</td>
					<td>
						<select id="editMonitorRuleCondition">
							<option></option>
							<option value="lt">&lt;</option>
							<option value="gt">&gt;</option>
							<option value="eq">=</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">监控阀值：</td>
					<td><input type="text" id="editMonitorRuleThreshold"/></td>
				</tr>
				<!-- 
				<tr>
					<td align="right">时间窗长度：</td>
					<td><input type="text" id="editTimeWindow"/></td>
				</tr>
				 -->
				<tr>
					<td align="right">监控类型：</td>
					<td>
						<select id="editMonitorType">
							<option value=""></option>
							<option value="1">1-简单事件</option>
							<!--  <option value="2">2-复杂事件</option> -->
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">监控开始时间：</td>
					<td>
						<input id="editMonitorBeginTime" class="easyui-timespinner" style="width:80px;"/>
					</td>
				</tr>
				<tr>
					<td align="right">监控结束时间：</td>
					<td>
					
						<input id="editMonitorEndTime" class="easyui-timespinner" style="width:80px;"/>
					</td>
				</tr>	
				<tr>
					<td align="right">监控风险值：</td>
					<td><input type="text" id="editMonitorRisk"/></td>
				</tr>	
				<tr>
					<td align="right">优先级：</td>
					<td>
					<select id="editMonitorPriority">
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
						<option value="5">5</option>
					</select>*优先级越高，表示越紧急
					</td>
				</tr>
				
			</table>
		</div>
</body>
</html>