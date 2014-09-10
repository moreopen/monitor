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
	<script type="text/javascript" src="/js/admin-main.js"></script>
	<style type="text/css">
		html,body{margin: 2px;padding: 0px}
	</style>
	<script type="text/javascript">
	function openAddDlg(){
		$("#addDlg").dialog('open');
	}
	function addResource(){
		var resourceName=$("#newResourceName").val().trim();
		if(resourceName==""){
			alert("请输入资源名!");
			return;
		}
		var resourceUrl=$("#newResourceURL").val().trim();
		if(resourceUrl==""){
			alert("请输入资源URL!");
			return;
		}
		$("#addDlg").dialog('close');
		$.ajax({
			type:"POST",
			url:"/monitor/resource/addResource.htm",
			data:{resourceName:resourceName,resourceUrl:resourceUrl},
			success:function(msg){
				$("#newResourceName").val("");
				$("#newResourceURL").val("");
				$('#dg').datagrid('reload');
				
			}
		});
	}
	
	function openEditDlg(){
		var row=$("#dg").datagrid('getSelected');
		
		if(row==null){
			alert("请选择要修改的资源!");
			return;
		}else{
			$("#editDlg").dialog('open');
			$("#editResourceName").val(row.resourceName);
			$("#editResourceURL").val(row.resourceUrl);
		}
	}
	
	function editResource(){
		var resourceName=$("#editResourceName").val().trim();
		if(resourceName==""){
			alert("请输入资源名!");
			return;
		}
		var resourceUrl=$("#editResourceURL").val().trim();
		if(resourceUrl==""){
			alert("请输入资源URL!");
			return;
		}
		$("#editDlg").dialog('close');
		var row=$("#dg").datagrid('getSelected');
		
		$.ajax({
			type:"POST",
			url:"/monitor/resource/editResource.htm",
			//data:"resourceId="+row.resourceId+"&resourceName="+resourceName+"&resourceUrl="+resourceUrl,
			data:{resourceId:row.resourceId,resourceName:resourceName,resourceUrl:resourceUrl},
			success:function(msg){
				var json=eval("("+msg+")");
				$('#dg').datagrid('updateRow',{
					index:$("#dg").datagrid('getRowIndex',row),
					row:json
				});
				
			}
		});
	}
	
	function deleteResource(){
		var data=$("#dg").datagrid('getSelected');
		if(data==null){
			alert("请选择要删除的资源!");
			return;
		}else{
			if(confirm("确认要删除该资源吗？")){
				var index=$("#dg").datagrid('getRowIndex',data);
				$("#dg").datagrid('deleteRow',index);
				$.ajax({
					type:"POST",
					url:"/monitor/resource/deleteResource.htm",
					data:{resourceId:data.resourceId},
					dataType:"text",
					success:function(msg){
						if(msg=="success"){
							$("#dg").datagrid("reload");
						}
					}
				});
			}
		}
	}
	
	function searchByResouceName(){
		var resourceName=$("#searchResourceName").val().trim();
		$.ajax({
			type:"POST",
			url:"/monitor/resource/searchByResouceName.htm",
			data:{resourceName:resourceName},
			success:function(msg){
				var json=eval("("+msg+")");
				$("#dg").datagrid("loadData",json);
			}
		})
	}

</script>
<title>编辑资源</title>
</head>
<body>
<table>
	<tr>
		
		<td>
			资源名：<input id="searchResourceName" type="text"  class="searchInput"/>
		</td>
		<td>
			<a id="search-button" href="#" class="easyui-linkbutton" iconCls="icon-search" onClick="javascript:searchByResouceName()">Search</a>
		</td>
	</tr>
</table>
<table id="dg" class="easyui-datagrid"  
            url="/monitor/resource/getResourceByPageRows.htm"  
            rownumbers="true"
            resizable="true"
            singleSelect="true"
            toolbar="#tb"
            pagination="true"
            pageSize="20"
            style="margin-right:10px"
            >  
        <thead>  
            <tr>  
                <th field="resourceName" width="160" align="center">资源名字</th>  
                <th field="resourceUrl" width="400" align="center">资源路径</th>  
               	<th field="createUserName" width="120" align="center">创建人</th>  
                <th field="createTimeFormat" width="180" align="center">创建时间</th>  
                <th field="updateUserName" width="120" align="center">修改人</th>  
                <th field="updateTimeFormat" width="140" align="center">修改时间</th>   
            </tr>  
        </thead>  
 </table>  
    <!-- 工具按钮 -->
	 <div id="tb" style="height:auto">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="openAddDlg()">新增</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="openEditDlg()">修改</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="deleteResource()">删除</a>
	</div>
	<!-- 添加资源的dialog -->
	<div id="addDlg" class="easyui-dialog" title="&nbsp;&nbsp;添加资源" style="width:350px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-add',
				toolbar: '#dlg-toolbar',
				buttons: '#dlg-buttons',
				closed: true,
				modal: true,
				fitColumns:true
			">
		资&nbsp;源&nbsp;名：<input id="newResourceName" type="text" name="newMenuName" /><br/>
		<br/>
		资源Url：<input id="newResourceURL" type="text" name="newMenuName" />
	</div>
	
	<div id="dlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="addResource()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addDlg').dialog('close')">取消</a>
	</div>
	
	<!-- 修改资源的dialog -->
	<div id="editDlg" class="easyui-dialog" title="&nbsp;&nbsp;修改资源" style="width:350px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-edit',
				toolbar: '#dlg-toolbar',
				buttons: '#dlg-buttons',
				closed: true,
				modal: true
			">
		资&nbsp;源&nbsp;名：<input id="editResourceName" type="text" name="newMenuName" /><br/>
		<br/>
		资源Url：<input id="editResourceURL" type="text" name="newMenuName" />
	</div>
	
	<div id="dlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="editResource()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#editDlg').dialog('close')">取消</a>
	</div>
</body>
</html>