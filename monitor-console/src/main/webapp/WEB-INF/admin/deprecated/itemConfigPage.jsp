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
$(document).ready(function (){
	$.ajax({
		type:"POST",
		url: '/monitor/admin/getEventJson.htm', 
		dataType: 'json',
		success:function(json){
			var r=json.rows;
			var options="";
			var optionsForAdd=$("#eventForAdd").html();
			var optionsForEdit=$("#eventForEdit").html();
			for(var i=0;i<r.length;i++){
				options=options+"<option value=\""+r[i].monitorEventId+"-"+r[i].monitorEventName+"\">"+r[i].monitorEventName+"("+r[i].monitorEventId+")"+"</option>";
				optionsForAdd=optionsForAdd+"<option value=\""+r[i].monitorEventId+"-"+r[i].monitorEventName+"\">"+r[i].monitorEventName+"("+r[i].monitorEventId+")"+"</option>";
				optionsForEdit=optionsForEdit+"<option value=\""+r[i].monitorEventId+"\">"+r[i].monitorEventName+"("+r[i].monitorEventId+")"+"</option>";
			}
			var oldOption=$("#event").html();
			$("#event").html(oldOption+options);
			$("#eventForAdd").html(optionsForAdd);
			$("#eventForEdit").html(optionsForEdit);
			var eventId=$("#event").val();
			if(eventId!=""){
				$("#itemTable").datagrid({"url":"/monitor/admin/getEventItemJson.htm?eventId="+eventId.split("-")[0]});
			}else{
				$("#itemTable").datagrid({"url":"/monitor/admin/getEventItemJson.htm"});
			}
		}
	});
	/**$("#event").change(function(){
		
		var eventId=$("#event").val();
		if(eventId!=""){
			$("#itemTable").datagrid({"url":"/monitor/admin/getEventItemJson.htm?eventId="+eventId.split("-")[0]});
		}else{
			$("#itemTable").datagrid({"url":"/monitor/admin/getEventItemJson.htm"});
		}
	})**/
})

function openAddItem(){
		$("#addItem").dialog("open");
	}
function addItem(){
		var eventId=$("#eventForAdd").val().split("-")[0];
		var eventName=$("#eventForAdd").val().split("-")[1];
		if(eventId==""){
			alert("请选择监控事件!");
			$("#eventForAdd").focus();
			return;
		}
		
		var itemId=$("#newItemId").val().trim();
		if(itemId==""){
			alert("请输入监控项编号!");
			$("#newItemId").focus();
			return;
		}
		var itemName=$("#newItemName").val().trim();
		if(itemName==""){
			alert("请输入监控项名字!");
			$("#newItemName").focus();
			return;
		}
		var getDataInterval=$("#newGetDataInterval").val().trim();
		if(getDataInterval==""){
			alert("请输入控制台获取时间间隔!");
			$("#newGetDataInterval").focus();
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/addItem.htm",
			data:{itemId:itemId,itemName:itemName,eventId:eventId,eventName:eventName,getDataInterval:getDataInterval},
			dataType:"text",
			success:function(msg){
				if(msg=="hasData"){
					alert("监控项Id已经存在，请重新输入!");
					$("#newItemId").focus();
					
				}else{
					$("#addItem").dialog("close");
					$("#newItemId").val("");
					$("#newItemName").val("");
					$("#newGetDataInterval").val("");
					$("#itemTable").datagrid("reload");
				}
			}
		});
		
	}
	
	function openEditItemDialog(){
		var row=$("#itemTable").datagrid("getSelected");
		if(row==null){
			alert("请选择要修改的监控项!");
			return;
		}else{
			$("#editItemId").val(row.monitorEventItemId);
			$("#editItemName").val(row.monitorEventItemName);
			$("#editGetDataInterval").val(row.getDataInterval);
			$("#eventForEdit").val(row.monitorEventId);
			$("#editItem").dialog("open");
		}
	}
	function updateItem(){
		var itemName=$("#editItemName").val().trim();
		var getDataInterval=$("#editGetDataInterval").val();
		var eventId=$("#eventForEdit").val();
		var id=$("#itemTable").datagrid("getSelected").id;
		if(eventId==""){
			alert("请选择监控事件!");
			$("#eventForEdit").focus();
			return;
		}
		if(itemName==""){
			alert("请输入监控项名");
			return ;
		}
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/updateItem.htm",
			data:{id:id,itemName:itemName,getDataInterval:getDataInterval,eventId:eventId},
			dataType:"text",
			success:function(msg){
				if(msg=="hasData"){
					alert("监控项编号已经存在，请重新输入!");
					$("#editItemId").focus();
					return;
				}else{
					$("#editItem").dialog("close");
					$("#itemTable").datagrid("reload");
				}
				
			}
		});
		
	}
	function deleteItem(){
		var row=$("#itemTable").datagrid("getSelected");
		if(row==null){
			alert("请选择要删除的监控项!");
			return;
		}else{
			if(confirm("确认删除此监控项？")){
				$.ajax({
					type:"POST",
					url:"/monitor/admin/deleteItem.htm",
					data:{id:row.id,monitorEventItemId:row.monitorEventItemId},
					success:function(msg){
						$("#itemTable").datagrid("reload");
					}
				})
			}
		}
	}
	
	function searchByItemName(){
		var eventId=$("#event").val().trim();
		if(eventId!=""){
			eventId=eventId.split("-")[0];
		}
		var itemName=$("#searchItemName").val().trim();
		var itemId=$("#searchItemId").val().trim();
		$.ajax({
			type:"POST",
			url:"/monitor/admin/searchByItemName.htm",
			data:{eventId:eventId,itemName:itemName,itemId:itemId},
			success:function(msg){
				var json=eval("("+msg+")");
				$("#itemTable").datagrid("loadData",json);
			}
		})
	}
</script>
<title>Insert title here</title>
</head>
<body>
		<div style="margin-bottom: 10px">
			监控事件：
			<select id="event">
				<option value="">所有监控事件</option>
			</select>
			&nbsp;
			监控项编号：<input id="searchItemId"  type="text"/>
			监控项名称：<input id="searchItemName"  type="text"/>
			<a id="search-button" href="#" class="easyui-linkbutton" iconCls="icon-search" onClick="javascript:searchByItemName()">Search</a>
		</div>
		<div id="itemTableToolbar">  
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="openAddItem()">新增</a>  
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="openEditItemDialog()">修改</a>  
	        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteItem()">删除</a>  
	    </div>
	    
		<table id="itemTable" class="easyui-datagrid" 
            rownumbers="true"
            resizable="true"
            singleSelect="true"
            pagination="true"
            toolbar="#itemTableToolbar"
           >  
	        <thead>  
	            <tr>  
	                <th field="monitorEventItemId" width="80">监控项编号</th>  
	                <th field="monitorEventItemName" width="200">监控项描述</th>
	                <th field="monitorEventId" width="200">所属监控事件</th>  
	                <th field="getDataInterval" width="200">控制台获取时间间隔(秒)</th>  
	                
	                <th data-options="field:'createUserName',width:60">创建人</th>
					<th data-options="field:'createTimeFormat',width:140">创建时间</th>
					<th data-options="field:'updateUserName',width:60">修改人</th>
					<th data-options="field:'updateTimeFormat',width:140">修改时间</th> 
	                
	            </tr>  
	        </thead>  
		</table>
		
		
	<!-- 添加Item的dialog -->
	<div id="addItem" class="easyui-dialog" title="&nbsp;&nbsp;新增监控项" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-add',
				buttons: '#add-item-buttons',
				closed: true,
				modal: true,
				fitColumns:true
			">
			<table width="100%">
				<tr>
					<td align="right">监控事件：</td>
					<td>
						<select id="eventForAdd">
							<option value="">请选择监控事件</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">监控项编号：</td>
					<td><input id="newItemId" type="text"/></td>
				</tr>
				<tr>
					<td align="right">监控项名：</td>
					<td><input id="newItemName" type="text"/></td>
				</tr>
				<tr>
					<td align="right">控制台获取时间间隔：</td>
					<td><input id="newGetDataInterval" type="text" value="60"/>(秒)</td>
				</tr>
			</table>
	</div>
	
	<div id="add-item-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="addItem()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addItem').dialog('close')">取消</a>
	</div>
	
	<!-- 修改Item的dialog -->
	<div id="editItem" class="easyui-dialog" title="&nbsp;&nbsp;修改监控项" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-edit',
				buttons: '#edit-item-buttons',
				closed: true,
				modal: true,
				fitColumns:true
			">
			<table  width="100%">
				<tr>
					<td align="right">监控事件：</td>
					<td>
						<select id="eventForEdit">
							<option value="">请选择监控事件</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">监控项编号：</td>
					<td><input id="editItemId" type="text"  disabled/></td>
				</tr>
				<tr>
					<td align="right">监控项名：</td>
					<td><input id="editItemName" type="text" /></td>
				</tr>
				<tr>
					<td align="right">控制台获取时间间隔：</td>
					<td><input id="editGetDataInterval" type="text" />(秒)</td>
				</tr>
				
			</table>
	</div>
	
	<div id="edit-item-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="updateItem()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#editItem').dialog('close')">取消</a>
	</div>

</body>
</html>