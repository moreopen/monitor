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
	var optionsForAdd=$("#itemsForAdd").html();
	var optionsForEdit=$("#itemsForEdit").html();
	$.getJSON("/monitor/admin/getAllItemsJson.htm",function(data){
		$.each(data,function(index,json){
			options=options+"<option value=\""+json.monitorEventItemId+"-"+json.monitorEventId+"\">"+json.monitorEventName+"-"+json.monitorEventItemName+"</option>";
			optionsForAdd=optionsForAdd+"<option value=\""+json.monitorEventItemId+"-"+json.monitorEventId+"\">"+json.monitorEventName+"-"+json.monitorEventItemName+"</option>";
			optionsForEdit=optionsForEdit+"<option value=\""+json.monitorEventItemId+"\">"+json.monitorEventName+"-"+json.monitorEventItemName+"</option>";
		})
		var oldOption=$("#items").html();
		$("#items").html(oldOption+options);
		$("#itemsForAdd").html(optionsForAdd);
		$("#itemsForEdit").html(optionsForEdit);
		var itemEvent=$("#items").val().trim();
		if(itemEvent==""){
			$("#ruleMonitorList").datagrid({"url":"/monitor/admin/getRuleMonitorJson.htm"});
		}else{
			var itemId=$("#items").val().split('-')[0];
			var eventId=$("#items").val().split('-')[1];
			$("#ruleMonitorList").datagrid({"url":"/monitor/admin/getRuleMonitorJson.htm?eventId="+eventId+"&itemId="+itemId});
		}
	});
	/**$("#items").change(function(){
		var itemEvent=$("#items").val();
		if(itemEvent!=""){
			var itemId=$("#items").val().split('-')[0];
			var eventId=$("#items").val().split('-')[1];
			$("#ruleAlarmList").datagrid({"url":"/monitor/admin/getRuleAlarmJson.htm?eventId="+eventId+"&itemId="+itemId});
		}else{
			$("#ruleAlarmList").datagrid({"url":"/monitor/admin/getRuleAlarmJson.htm"});
		}
		$("#ruleAlarmList").datagrid("unselectAll");
	});
	**/
	$("#editMonitorEmailsA").click(function(){
		$("#userForEmailsDlg").dialog("open");
	})
	$("#editMonitorIphonesA").click(function(){
		$("#userForIphonesDlg").dialog("open");
	})
	$("#monitorEmailsA").click(function(){
		$("#addUserForEmailsDlg").dialog("open");
	})
	$("#monitorIphonesA").click(function(){
		$("#addUserForIphonesDlg").dialog("open");
	})
})
	/**
	*让 停止报警的变红色
	*
	**/
	  function formatStatus(val,row){  
	            if (val =="停止"){  
	                return '<span style="color:red;">'+val+'</span>';  
	            } else {  
	            	 return '<span style="color:green;">'+val+'</span>';  
	            }  
	  } 
	/**
	*
	*给报警联系人添加title
	*/
	function addTitle(val,row){
		 return '<span style="display:block" title="'+val+'">'+val+'</span>';  
	}
	function configAlarm(){
		var row=$("#itemTable").datagrid("getSelected");
		if(row==null){
			alert("请选择监控项");
			return;
		}else{
			var eventId=$("#easyui-datagrid").datagrid("getSelected").monitorEventId;
			var itemId=$("#itemTable").datagrid("getSelected").monitorEventItemId;
			$("#ruleAlarmList").datagrid({"url":"/monitor/admin/getRuleAlarmJson.htm?eventId="+eventId+"&itemId="+itemId});
		}
	}
	
	function openAddAlarmDlg(){
		$("#addRuleAlarmDlg").dialog("open");
	}
	function addRuleAlarm(){
		var itemId=$("#itemsForAdd").val().trim().split('-')[0];
		var eventId=$("#itemsForAdd").val().trim().split('-')[1];
		var monitorAlarmRuleName=$("#monitorAlarmRuleName").val().trim();
		var threshold=$("#threshold").val().trim();
		var monitorAlarmCondition=$("#monitorAlarmCondition").val().trim();
		var monitorAlarmInterval=$("#monitorAlarmInterval").val().trim();
		var monitorAlarmRuleId=$("#monitorAlarmRuleId").val().trim()
		var monitorUserIds=$("#addMonitorUserIds").val().trim();
		
		var way="";
		if($(".addMonitorAlarmWayPhone").attr("checked")){
			way=way+"1";
		}else{
			way=way+"0";
		}
		if($(".addMonitorAlarmWayEmail").attr("checked")){
			way=way+"1";
		}else{
			way=way+"0";
		}
		var monitorAlarmWay=parseInt(way,2);
		
		if(itemId==""){
			alert("请选择监控项!");
			$("#itemsForAdd").focus();
			return;
		}
		
		if(monitorAlarmRuleId==""){
			alert("请输入报警规则编号!");
			$("#monitorAlarmRuleId").focus();
			return;
		}
		if(monitorAlarmRuleName.trim()==""){
			alert("请输入报警规则名称!");
			$("#monitorAlarmRuleName").focus();
			return;
		}
		
		if(threshold.trim()==""){
			alert("请输入报警阀值!");
			$("#threshold").focus();
			return;
		}
		
		if(monitorAlarmCondition.trim()==""){
			alert("请选择触发条件!");
			$("#monitorAlarmCondition").focus();
			return;
		}
		
		if(monitorAlarmInterval.trim()==""){
			alert("请输入报警时间间隔!");
			$("#monitorAlarmInterval").focus();
			return;
		}
		
		if(monitorUserIds==""){
			alert("请选择报警联系人!");
			$("#addMonitorUserNames").focus();
			return;
		}
		
		if (/[^\d]/.test(threshold.trim())){
			alert("报警阀值只能为数字!");
			$("#threshold").val("");
			$("#threshold").focus();
			return;
		}
		
		if (/[^\d]/.test(monitorAlarmInterval.trim())){
			alert("报警时间间隔只能为数字!");
			$("#monitorAlarmInterval").val("");
			$("#monitorAlarmInterval").focus();
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/addRuleAlarm.htm",
			data:{eventId:eventId,monitorAlarmRuleId:monitorAlarmRuleId,itemId:itemId,monitorAlarmRuleName:monitorAlarmRuleName,threshold:threshold,monitorAlarmWay:monitorAlarmWay,monitorAlarmCondition:monitorAlarmCondition,monitorAlarmInterval:monitorAlarmInterval,monitorUserIds:monitorUserIds},
			dataType:"text",
			success:function(msg){
				if(msg=="hasData"){
					alert("报警规则ID已经存在，请重新输入!");
					$("#monitorAlarmRuleId").focus();
				}else{
					$("#addRuleAlarmDlg").dialog("close");
					$("#ruleAlarmList").datagrid("reload");
					$("#monitorAlarmRuleName").val("");
					$("#threshold").val("");
					$("#monitorAlarmCondition").val("");
					$("#monitorAlarmInterval").val("");
					$("#monitorAlarmRuleId").val("");
					$("#monitorEmails").val("");
					$("#monitorIphones").val("");
				}
			}
		})
	}
	
	function deleteAlarm(){
		var row=$("#ruleAlarmList").datagrid("getSelected");

		if(row==null){
			alert("请选择要删除的alarm!");
			return;
		}
		if(confirm("确认要删除该报警规则吗？")){
			$.ajax({
				type:"POST",
				url:"/monitor/admin/deleteRuleAlarm.htm",
				data:{id:row.id},
				success:function(msg){
					$("#ruleAlarmList").datagrid("reload");
				}
			})
		}
		
	}
	function openEditAlarmDlg(){
		var row=$("#ruleAlarmList").datagrid("getSelected");
		if(row==null){
			alert("请选择需要修改的报警规则!");
			return;
		}
		$(".editMonitorAlarmWayEmail").attr("checked",false);//先清空可能存在的勾选
		$(".editMonitorAlarmWayPhone").attr("checked",false);
		var way=parseInt(row.monitorAlarmWay);
		if(way==1){
			$(".editMonitorAlarmWayEmail").attr("checked",true);
		}else if(way==2){
			$(".editMonitorAlarmWayPhone").attr("checked",true);
		}else if(way==3){
			$(".editMonitorAlarmWayEmail").attr("checked",true);
			$(".editMonitorAlarmWayPhone").attr("checked",true);
		}
		$("#editMonitorAlarmRuleId").val(row.monitorAlarmRuleId);
		$("#editMonitorAlarmRuleName").val(row.monitorAlarmRuleName);
		
		$("#editThreshold").val(row.threshold);
		$("#editMonitorAlarmCondition").val(row.monitorAlarmCondition);
		$("#editMonitorAlarmInterval").val(row.monitorAlarmInterval);
		
		
		$("#editMonitorUserNames").val("");//先清空可能存在的值
		$("#editMonitorUserIds").val("");
		
		$("#editMonitorUserNames").val(row.monitorUserNames);
		$("#editMonitorUserIds").val(row.monitorUserIds);
		
		$("#itemsForEdit").val(row.monitorEventItemId);
		$("#updateRuleAlarmDlg").dialog("open");
	}
	
	function updateRuleAlarm(){
		var row=$("#ruleAlarmList").datagrid("getSelected");
		
		var monitorAlarmRuleName=$("#editMonitorAlarmRuleName").val();
		var threshold=$("#editThreshold").val();
		var way="";
		if($(".editMonitorAlarmWayPhone").attr("checked")){
			way=way+"1";
		}else{
			way=way+"0";
		}
		if($(".editMonitorAlarmWayEmail").attr("checked")){
			way=way+"1";
		}else{
			way=way+"0";
		}
		var monitorAlarmWay=parseInt(way,2);
		var monitorAlarmCondition=$("#editMonitorAlarmCondition").val();
		var monitorAlarmInterval=$("#editMonitorAlarmInterval").val();
		var monitorUserIds=$("#editMonitorUserIds").val().trim();
		var monitorEventItemId=$("#itemsForEdit").val().trim();
		
		
		if(monitorEventItemId==""){
			alert("请选择监控项!");
			$("#itemsForEdit").focus();
			return;
		}
		
		if(monitorAlarmRuleName.trim()==""){
			alert("请输入报警规则描述!");
			return;
		}
		
		if(threshold.trim()==""){
			alert("请输入报警阀值!");
			return;
		}
		
		if(monitorAlarmCondition.trim()==""){
			alert("请输入报警条件!");
			return;
		}
		if(monitorAlarmInterval.trim()==""){
			alert("请输入报警时间间隔!");
			return;
		}
		if(monitorUserIds==""){
			alert("请选择报警联系人!");
			$("#monitorUserNames").focus();
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/updateRuleAlarm.htm",
			data:{id:row.id,monitorAlarmRuleName:monitorAlarmRuleName,threshold:threshold,monitorAlarmWay:monitorAlarmWay,monitorAlarmCondition:monitorAlarmCondition,monitorAlarmInterval:monitorAlarmInterval,monitorUserIds:monitorUserIds,monitorEventItemId:monitorEventItemId},
			dataType:"text",
			success:function(msg){
				if(msg=="hasData"){
					alert("报警规则ID已经存在，请重新输入!");
				}else{
					$("#updateRuleAlarmDlg").dialog("close");
					$("#ruleAlarmList").datagrid("reload");
				}
			}
		})
	}
	
	function stopAlarmDlg(){
		var row=$("#ruleAlarmList").datagrid("getSelected");
		if(row==null){
			alert("请选择要停止的报警!");
			return;
		}
		$.ajax({
			type:"POST",
			url:"/monitor/admin/stopRuleAlarm.htm",
			data:{id:row.id},
			success:function(msg){
				$("#ruleAlarmList").datagrid('reload');
				$("#ruleAlarmList").datagrid('unselectAll');
			}
		})
		
	}
	function beginAlarm(){
		var row=$("#ruleAlarmList").datagrid("getSelected");
		if(row==null){
			alert("请选择要恢复的报警!");
			return;
		}
		$.ajax({
			type:"POST",
			url:"/monitor/admin/beginRuleAlarm.htm",
			data:{id:row.id},
			success:function(msg){
				$("#ruleAlarmList").datagrid('reload');
				$("#ruleAlarmList").datagrid('unselectAll');
			}
		})
	}
	
	function searchByAlarmName(){
		var alarmId=$("#searchAlarmId").val().trim();
		var alarmName=$("#searchAlarmName").val().trim();
		var item=$("#items").val().trim();
		if(item!=""){
			item=item.split("-")[0];
		}
		$.ajax({
			type:"POST",
			url:"/monitor/admin/searchByAlarmName.htm",
			data:{item:item,alarmName:alarmName,alarmId:alarmId},
			success:function(msg){
				var json=eval("("+msg+")");
				$("#ruleAlarmList").datagrid("loadData",json);
			}
		})
	}
	
	function updateUserIds(){
		var rows=$("#usersForUpdate").datagrid("getSelections");
		var userNames="";
		var userIds="";
		for(var i=0;i<rows.length;i++){
			userNames=userNames+rows[i].userName+";"
			userIds=userIds+rows[i].userId+";"
			
		}
		$("#editMonitorUserNames").val(userNames);
		$("#editMonitorUserIds").val(userIds);
		$("#userDlg").dialog("close");
		$("#usersForUpdate").datagrid("unselectAll");
	}
	function cancelUpdateUserIdsSelect(){
		$("#userDlg").dialog("close");
		$("#usersForUpdate").datagrid("unselectAll");
	}
	
	function addUserIds(){
		var rows=$("#usersForAdd").datagrid("getSelections");
		var userNames="";
		var userIds="";
		for(var i=0;i<rows.length;i++){
			userNames=userNames+rows[i].userName+";"
			userIds=userIds+rows[i].userId+";"
		}
		$("#addMonitorUserNames").val(userNames);
		$("#addMonitorUserIds").val(userIds);
		$("#userDlgForAdd").dialog("close");
		$("#usersForAdd").datagrid("unselectAll");
	}
	
	function cancelAddUserIdsSelect(){
		$("#userDlgForAdd").dialog("close");
		$("#usersForAdd").datagrid("unselectAll");
	}
	
	
</script>
</head>
<body>
	监控项：
	<select id="items" class="parentSelect">
		<option value="">所有监控项</option>
	</select>
		&nbsp;报警规则编号：<input id="searchAlarmId"  type="text" />
		&nbsp;报警规则名称：<input id="searchAlarmName"  type="text" />
	<a id="search-button" href="#" class="easyui-linkbutton" iconCls="icon-search" onClick="javascript:searchByAlarmName()">Search</a>
	
	
	
	<!-- RULE ALARM 列表  -->
		
		<div style="margin:10px" id="tb">
	
			<span class="addSpan" onclick="openAddAlarmDlg()">新增</span>
			<span class="editSpan" onclick="openEditAlarmDlg()">修改</span>
			<span class="delSpan" onclick="deleteAlarm()">删除</span>
			<span class="stopSpan">&nbsp;</span>
			<span id="stopAlarm" onclick="stopAlarmDlg()" style="cursor: pointer">停止报警</span>
			<span class="beginSpan">&nbsp;</span>
			<span id="beginAlarm" onclick="beginAlarm()" style="cursor: pointer">恢复报警</span>
		</div>
		
		<table id="ruleAlarmList" 
				class="easyui-datagrid" 
				url="/monitor/admin/getRuleAlarmJson.htm" 
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
						<th data-options="field:'monitorAlarmRuleId',width:100">报警规则编号</th>
						<th data-options="field:'monitorAlarmRuleName',width:80">报警规则名称</th>
						<th data-options="field:'threshold',width:60">报警阀值</th>
						<th data-options="field:'monitorAlarmWaySymbol',width:100">报警方式</th>
						<th data-options="field:'monitorAlarmConditionSymbol',width:60">触发条件</th>
						<th data-options="field:'monitorAlarmInterval',width:120">报警时间间隔(分钟)</th>
						<th data-options="field:'monitorStatusString',width:90,formatter:formatStatus" align="center">报警状态</th>
						<th data-options="field:'monitorUserNames',width:90,formatter:addTitle" align="center">报警联系人</th>
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
		
		<!-- 添加rule alarm Dialog -->
		<div id="add-ruleAlarm-buttons">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="addRuleAlarm()">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addRuleAlarmDlg').dialog('close')">取消</a>
		</div>
		<div id="addRuleAlarmDlg" class="easyui-dialog" title="&nbsp;新增报警规则" style="width:400px;height:340px;"
			data-options="
				iconCls: 'icon-add',
				buttons: '#add-ruleAlarm-buttons',
				closed: true,
				modal: true,
				fitColumns:true
			">
			<table width="100%" style="margin-top:10px">
				<tr>
					<td align="right">监控项：</td>
					<td>
						<select id="itemsForAdd" class="parentSelect">
							<option value="">请选择监控项</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">报警规则编号：</td>
					<td><input type="text" id="monitorAlarmRuleId"/></td>
				</tr>
				<tr>
					<td align="right">报警规则名称：</td>
					<td><input type="text" id="monitorAlarmRuleName"/></td>
				</tr>
				
				<tr>
					<td align="right">报警阀值：</td>
					<td><input type="text" id="threshold"/></td>
				</tr>
				<tr>
					<td align="right">报警方式：</td>
					<td>
						<label><input type="checkbox" value="phone" name="addMonitorAlarmWayPhone" class="addMonitorAlarmWayPhone">电话</label>
						<label><input type="checkbox" value="email" name="addMonitorAlarmWayEmail" class="addMonitorAlarmWayEmail">email</label>
					</td>
				</tr>
				<tr>
					<td align="right">触发条件：</td>
					<td>
						<select id="monitorAlarmCondition">
							<option></option>
							<option value="lt">&lt;</option>
							<option value="gt">&gt;</option>
							<option value="eq">=</option>
						</select>
					
					</td>
				</tr>
				<tr>
					<td align="right">报警时间间隔(分钟)：</td>
					<td><input type="text" id="monitorAlarmInterval"/></td>
				</tr>
				<tr>
					<td align="right">报警联系人：</td>
					<td>
					<textarea cols="29" rows="3" id="addMonitorUserNames" readonly></textarea>
					<input type="hidden" id="addMonitorUserIds"/>
					<img src="/icons/person.jpg" style="vertical-align:middle;cursor:pointer" onClick="$('#userDlgForAdd').dialog('open');"/></td>
				</tr>
			
			</table>
	</div>
		
	<!--添加的时候用==== 选择的用户 dialog -->
	<div id="addUsersDlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="addUserIds()">确定</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="cancelAddUserIdsSelect()">取消</a>
	</div>
	
	<div id="userDlgForAdd" class="easyui-dialog" 
			style="width:500px;height:540px;padding:10px"
			data-options="
				title:'选择用户',
				closed: true,
				modal: true,
				fitColumns:true,
				buttons:'#addUsersDlg-buttons'
			">
		<table id="usersForAdd" class="easyui-datagrid" 
		            url="/monitor/user/queryAllUser.htm"
		            resizable="true"
		            checkOnSelect="true"
		            pagination="true"
		         
		>
	        <thead>  
	            <tr>
	            	<th data-options="field:'ck',checkbox:true"></th>
	                <th field="userName" width="100" align="center">用户名</th> 
	                <th field="phone" width="150" align="center">电话</th>
	                <th field="email" width="150" align="center">Email</th>
	            </tr>
	        </thead>
 		</table>
	</div>
	
<!-- 修改rule alarm Dialog -->
	<div id="edit-ruleAlarm-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="updateRuleAlarm()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#updateRuleAlarmDlg').dialog('close')">取消</a>
	</div>
	<div id="updateRuleAlarmDlg" class="easyui-dialog" title="修改报警规则" style="width:500px;height:340px;"
			data-options="
				iconCls: 'icon-edit',
				buttons: '#edit-ruleAlarm-buttons',
				closed: true,
				modal: true,
				fitColumns:true
			">
			<table width="100%" style="margin-top:20px">
				<tr>
					<td align="right">监控项：</td>
					<td>
						<select id="itemsForEdit" class="parentSelect">
							<option value="">请选择监控项</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">报警规则ID：</td>
					<td><input type="text" id="editMonitorAlarmRuleId" disabled/></td>
				</tr>
				<tr>
					<td align="right">报警规则名称：</td>
					<td><input type="text" id="editMonitorAlarmRuleName"/></td>
				</tr>
				
				<tr>
					<td align="right">监控阀值：</td>
					<td><input type="text" id="editThreshold"/></td>
				</tr>
				<tr>
					<td align="right">报警方式：</td>
					<td>
						<label><input type="checkbox" value="phone" name="editMonitorAlarmWayPhone" class="editMonitorAlarmWayPhone">电话</label>
						<label><input type="checkbox" value="email" name="editMonitorAlarmWayEmail" class="editMonitorAlarmWayEmail">email</label>
					</td>
				</tr>
				<tr>
					<td align="right">触发条件：</td>
					<td>
						<select id="editMonitorAlarmCondition">
							<option></option>
							<option value="lt">&lt;</option>
							<option value="gt">&gt;</option>
							<option value="eq">=</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">报警时间间隔：</td>
					<td><input type="text" id="editMonitorAlarmInterval"/>(分钟)</td>
				</tr>
				<tr>
					<td align="right">报警联系人：</td>
					<td><textarea rows="3" cols="29" id="editMonitorUserNames" readonly></textarea>
						<input  id="editMonitorUserIds" type="hidden"/>
						<img src="/icons/person.jpg" id="editMonitorIphonesA" style="vertical-align:middle;cursor:pointer" onClick="$('#userDlg').dialog('open');"/></td>
				</tr>	
				
			</table>
	</div>
	
	
	<!-- 修改的时候用==== 选择用户的 dialog -->
	<div id="usersForEmilas-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="updateUserIds()">确定</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="cancelUpdateUserIdsSelect()">取消</a>
	</div>
	
	<div id="userDlg" class="easyui-dialog" 
			style="width:500px;height:540px;padding:10px"
			data-options="
				title:'选择用户',
				closed: true,
				modal: true,
				fitColumns:true,
				buttons:'#usersForEmilas-buttons'
			">
		<table id="usersForUpdate" class="easyui-datagrid" 
		            url="/monitor/user/queryAllUser.htm"  
		            resizable="true"
		            checkOnSelect="true"
		            pagination="true"
		>
	        <thead>  
	            <tr>
	            	<th data-options="field:'ck',checkbox:true"></th>
	                <th field="userName" width="100" align="center">用户名</th> 
	                <th field="phone" width="150" align="center">电话</th>
	                <th field="email" width="150" align="center">Email</th>
	            </tr>
	        </thead>
 		</table>
	</div>
	
</body>
</html>