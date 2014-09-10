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

function checkIP(value){
    var exp=/^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
    var reg = value.match(exp);
    if(reg==null){
    	return false;
    }
    return true;
}
$(document).ready(function(){
	$.ajax({
		type:"POST",
		url: '/monitor/admin/getEventJson.htm', 
		dataType: 'json',
		success:function(json){
			var r=json.rows;
			var options="";
			var optionsAdd=$("#eventAdd").html();
			var optionsEdit=$("#eventEdit").html();
			for(var i=0;i<r.length;i++){
				options=options+"<option value=\""+r[i].monitorEventId+"\">"+r[i].monitorEventName+"("+r[i].monitorEventId+")"+"</option>";
				optionsAdd=optionsAdd+"<option value=\""+r[i].monitorEventId+"\">"+r[i].monitorEventName+"("+r[i].monitorEventId+")"+"</option>";
				optionsEdit=optionsEdit+"<option value=\""+r[i].monitorEventId+"\">"+r[i].monitorEventName+"("+r[i].monitorEventId+")"+"</option>";
			}
			var oldOptions=$("#event").html();
			$("#event").html(oldOptions+options);
			$("#eventAdd").html(optionsAdd);
			$("#eventEdit").html(optionsEdit);
			$("#ipTable").datagrid({"url":"/monitor/admin/getIpPortJson.htm"});
		}
	});
	/**$("#event").change(function(){
		var event=$("#event").val().trim();
		if(event==""){
			$("#ipTable").datagrid({"url":"/monitor/admin/getIpPortJson.htm"});
		}else{
			$("#ipTable").datagrid({"url":"/monitor/admin/getIpPortJson.htm?eventId="+$("#event").val()});
		}
		
	})
	**/
})

	function openAddIPDialog(){
		$("#addIpPortDialog").dialog("open");
	}
	function addIpPort(){
		var ipport=$("#newIpPort").val().trim();
		var eventId=$("#eventAdd").val();
		if(eventId==""){
			alert("请选择所属事件!");
			$("#eventAdd").focus();
			return;
		}
		if(ipport==""){
			alert("请输入主机!");
			return;
		}
		if(!checkIP(ipport)){
			alert("请输入合法的IP地址!");
			$("#newIpPort").focus();
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/monitor/admin/addIpPort.htm",
			data:{ipport:ipport,eventId:eventId},
			dataType:"text",
			success:function(msg){
				if(msg=="hasData"){
					alert("该监控事件下的主机地址已经存在，请重新输入!");
				}else if(msg=="success"){
					$("#addIpPortDialog").dialog("close");
					$("#newIpPort").val("");
					$("#ipTable").datagrid("reload");
				}else{
					alert("添加出错，请联系管理员!");
				}
				
			}
		});
	}
	
	function openEditIpDialog(){
		var row=$("#ipTable").datagrid("getSelected");
		if(row==null){
			alert("请选择要修改的主机!");
			return;
		}else{
			$("#editIpPort").val(row.monitorEventIpPort);
			$("#eventEdit").val(row.monitorEventId);
			$("#editIpPortDialog").dialog("open");
		}
	}
	function updateIpPort(){
		var ip=$("#editIpPort").val().trim();
		var id=$("#ipTable").datagrid("getSelected").id;
		var eventId=$("#eventEdit").val();
		if(eventId==""){
			alert("请选择所属事件!");
			$("#eventEdit").focus();
			return;
		}
		if(ip==""){
			alert("请输入ip地址!");
			return;
		}
		if(!checkIP(ip)){
			alert("请输入合法的IP地址!");
			$("#editIpPort").focus();
			return;
		}
		
		$.ajax({
				type:"POST",
				url:"/monitor/admin/updateIpPort.htm",
				data:{id:id,ipport:ip,eventId:eventId},
				dataType:"text",
				success:function(msg){
					
					
					
					
					if(msg=="hasData"){
						alert("该监控事件下的主机地址已经存在，请重新输入!");
					}else if(msg=="success"){
						$("#editIpPortDialog").dialog("close");
						$("#ipTable").datagrid("reload");
					}else{
						alert("更新出错，请联系管理员!");
					}
				}
				
			})
		
	}
	function deleteIpPort(){
		var row=$("#ipTable").datagrid("getSelected");
		if(row==null){
			alert("请选择要删除的ip.");
			return;
		}else{
			var id=row.id;
			if(confirm("确认要删除此IP吗？")){
				$.ajax({
					type:"POST",
					url:"/monitor/admin/deleteIpPort.htm",
					data:{id:id},
					success:function(msg){
						$("#ipTable").datagrid("reload");
					}
				})
			}
		}
	}
	function searchByIp(){
		var ip=$("#searchIp").val().trim();
		var eventId=$("#event").val().trim();
		if(ip=="请输入IP地址"){
			ip="";
		}
		$.ajax({
			type:"POST",
			url:"/monitor/admin/searchByIp.htm",
			data:{ip:ip,eventId:eventId},
			success:function(msg){
				var json=eval("("+msg+")");
				$("#ipTable").datagrid("loadData",json);
			}
		})
	}
	
</script>
<title>Insert title here</title>
</head>
<body>

<div>
			监控事件:<select id="event"  class="parentSelect">
						<option value="">所有监控事件</option>
				</select>
				&nbsp;主机：<input id="searchIp" type="text"/>
	<a id="search-button" href="#" class="easyui-linkbutton" iconCls="icon-search" onClick="javascript:searchByIp()">Search</a>
</div>
<div style="height:2px"></div>
<!-- 监控项 ip - port 的dialog -->

			
	<div id="ipTableToolbar">  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="openAddIPDialog()">新增</a>  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="openEditIpDialog()">修改</a>  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteIpPort()">删除</a>  
    </div>
	<table id="ipTable" class="easyui-datagrid" 
           rownumbers="true"
           resizable="true"
           singleSelect="true"
           toolbar="#ipTableToolbar"
           pagination="true"
          >  
        <thead>  
            <tr> 
            	
                <th field="monitorEventIpPort" width="200">主机端口</th>
                <th data-options="field:'appName',width:120">监控业务</th> 
            	<th field="monitorEventName" width="200">监控事件</th>
                <th data-options="field:'createUserName',width:60">创建人</th>
				<th data-options="field:'createTimeFormat',width:120">创建时间</th>
				<th data-options="field:'updateUserName',width:60">修改人</th>
				<th data-options="field:'updateTimeFormat',width:120">修改时间</th>
            </tr>  
        </thead>  
	</table>
	
	<!-- 添加IP-PORT的dialog -->
	<div id="addIpPortDialog" class="easyui-dialog" title="&nbsp;&nbsp;新增主机端口" style="width:350px;height:150px;"
			data-options="
				iconCls: 'icon-add',
				buttons: '#add-ipport-buttons',
				closed: true,
				modal: true,
				fitColumns:true
			">
			<table width="100%" style="margin-top:10px">
				<tr>
					<td align="right">监控事件：</td>
					<td>
						<select id="eventAdd"  class="parentSelect">
							<option value="">选择监控事件</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">主机IP：</td>
					<td><input id="newIpPort" type="text"/></td>
				</tr>
				
			</table>
	</div>
	
	<div id="add-ipport-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="addIpPort()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addIpPortDialog').dialog('close')">取消</a>
	</div>
	
	<!-- 修改IP-PORT的dialog -->
	<div id="editIpPortDialog" class="easyui-dialog" title="&nbsp;&nbsp;修改主机IP" style="width:350px;height:150px;"
			data-options="
				iconCls: 'icon-edit',
				buttons: '#edit-ipport-buttons',
				closed: true,
				modal: true,
				fitColumns:true
			">
			<table width="100%" style="margin-top:10px">
				<tr>
					<td align="right">监控事件：</td>
					<td>
						<select id="eventEdit"  class="parentSelect">
							<option value="">请选择监控事件</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">主机IP：</td>
					<td><input id="editIpPort" type="text"/></td>
				</tr>
			
			</table>
	</div>
	
	<div id="edit-ipport-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="updateIpPort()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#editIpPortDialog').dialog('close')">取消</a>
	</div>

</body>
</html>