<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>角色管理</title>
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
	
	function add(){
		var roleName=$("#newRoleName").val().trim();
		if(roleName==""){
			alert("请输入角色名!");
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/monitor/role/addRole.htm",
			data:"roleName="+roleName,
			success:function(msg){
				if(msg=="exitis"){
					alert("该角色名已经被占用！");
				}else{
					$("#addDlg").dialog('close');
					$("#dg").datagrid("reload");
					$("#newRoleName").val("");
				}
			}
		});
	}
	function openEditDlg(){
		var row=$("#dg").datagrid('getSelected');
		
		if(row==null){
			alert("请选择要修改的角色!");
			return;
		}else{
			$("#editDlg").dialog('open');
			$("#editRoleName").val(row.roleName);
			
		}
	}
	
	function editRole(){
		var roleName=$("#editRoleName").val().trim();
		if(roleName==""){
			alert("请输入角色名!");
			return;
		}
		
		
		var row=$("#dg").datagrid('getSelected');
		$.ajax({
			type:"POST",
			url:"/monitor/role/updateRoleName.htm",
			data:"roleName="+roleName+"&roleId="+row.roleId,
			success:function(msg){
				$("#dg").datagrid('reload');
				$("#editDlg").dialog('close');
			}
		});
	}
	
	function deleteRole(){
		var data=$("#dg").datagrid('getSelected');
		if(data==null){
			alert("请选择要删除的角色!");
			return;
		}else{
			if(confirm("确认要删除该角色吗？")){
				var index=$("#dg").datagrid('getRowIndex',data);
				$.ajax({
					type:"POST",
					url:"/monitor/role/deleteRole.htm",
					data:{roleId:data.roleId},
					dataType:"text",
					success:function(msg){
						if(msg=="success"){
							$("#dg").datagrid('deleteRow',index);
						}
					},
					error:function(){
						alert("删除失败,请联系管理员!");
					}
				});
			}
		}
	}
	function openEditRoleDlg(){
		var data=$("#dg").datagrid('getSelected');
		if(data==null){
			alert("请选择角色!");
			return;
		}else{
			$("#editRoleResourceDlg").dialog('open');
			$.ajax({
				type:"POST",
				url:"/monitor/role/getResourcesByRoleId.htm",
				data:"roleId="+data.roleId,
				success:function(msg){
					var json=eval("("+msg+")");
					for(var i=0;i<json.length;i++){
						var jsonobj = json[i];
						var rowIndex=$("#menu-dg").datagrid('getRowIndex',jsonobj.menuId);
						$("#menu-dg").datagrid('checkRow',rowIndex);
					}	
				}
			});
		}
	}
	
	function saveRoleMenus(){
		
		var roleRow=$("#dg").datagrid('getSelected');
		var rows=$("#menu-dg").datagrid('getSelections');
		var resourceIds="";
		var menuIds = "";
		for(var i=0;i<rows.length;i++){
			//resourceIds=resourceIds+rows[i].resourceId+",";
			menuIds = menuIds + rows[i].id + ",";
		}
		$.ajax({
			type:"POST",
			url:"/monitor/role/updateRoleMenus.htm",
			data:"roleId="+roleRow.roleId+"&menuIds="+menuIds,
			dataType:"text",
			success:function(msg){
				if(msg=="success"){
					$("#menu-dg").datagrid('unselectAll');
					$("#editRoleResourceDlg").dialog('close');
					$("#dg").datagrid('reload');
				}
			}
		});
	}
	function searchByRoleName(){
		var roleName=$("#searchRoleName").val().trim();
		$.ajax({
			type:"POST",
			url:"/monitor/role/queryByRoleName.htm",
			data:"roleName="+roleName,
			success:function(msg){
				var json=eval("("+msg+")");
				$("#dg").datagrid("loadData",json);
			}
		})
		
	}
	</script>
</head>

<body>
<table>
	<tr>
		<td>
			角色名：<input id="searchRoleName" type="text"  name="searchRoleName" class="searchInput"/>
		</td>
		<td>
			<a id="search-button" href="#" class="easyui-linkbutton" iconCls="icon-search" onClick="javascript:searchByRoleName()">Search</a>
		</td>
	</tr>
</table>
<table id="dg" class="easyui-datagrid" 
            url="/monitor/role/queryAllRoleAndResource.htm"  
            rownumbers="true"
            resizable="true"
            singleSelect="true"
            toolbar="#tb"
            pagination="true"
            pageSize="20"
            >
        <thead>  
            <tr>  
                <th field="roleName" width="100">角色名</th>  
             
                <th field="resourceNames" width="250">所分配资源</th>  
                <th field="createUserName" width="50" align="right">创建人</th>  
                <th field="createTimeFormat" width="140" align="right">创建时间</th>  
                <th field="updateUserName" width="70">修改人</th>  
                <th field="updateTimeFormat" width="140" align="center">修改时间</th>  
           
            </tr> 
        </thead>  
 </table>
  <!-- 工具按钮 -->
 <div id="tb" style="height:auto">
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="openAddDlg()">新增</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="openEditDlg()">修改</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="deleteRole()">删除</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo',plain:true" onclick="openEditRoleDlg()">分配资源</a>
</div>

<!-- 添加角色的dialog -->
<div id="addDlg" class="easyui-dialog" title="新增角色" style="width:400px;height:200px;padding:10px"
		data-options="
			iconCls: 'icon-add',
			toolbar: '#dlg-toolbar',
			buttons: '#dlg-buttons',
			closed: true,
			modal: true
		">
		<table width="100%" style="margin-top:10px">
			<tr>
				<td align="right">角色名：</td>
				<td><input id="newRoleName" type="text" name="newRoleName" /></td>
			</tr>
		</table>
</div>

<div id="dlg-buttons">
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="add()">保存</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addDlg').dialog('close')">取消</a>
</div>

<!-- 修改角色的dialog -->
	<div id="editDlg" class="easyui-dialog" title="修改角色" style="width:400px;height:150px;"
			data-options="
				iconCls: 'icon-edit',
				buttons: '#dlg-buttons',
				closed: true,
				modal: true
	">
			<table width="100%"  style="margin-top:10px">
				<tr>
					<td align="right">角色名：</td>
					<td><input id="editRoleName" type="text" name="editRoleName"/></td>
				</tr>
			</table>
	</div>
	
	<div id="dlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="editRole()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#editDlg').dialog('close')">取消</a>
	</div>
	
<!-- 分配资源的DIALOG -->
		<div id="editRoleResourceDlg" class="easyui-dialog" title="&nbsp;&nbsp;分配资源" style="width:540px;height:480px;padding:10px"
			data-options="
				iconCls: 'icon-redo',
				buttons: '#editRoleResourceDlg-buttons',
				closed: true,
				modal: true
			"
			>
			<table id="menu-dg" class="easyui-datagrid"  width="100%"  style="margin-top:10px"
					data-options="
					rownumbers:true,
					url:'/monitor/menu/getSecondMenus.htm',
					idField:'id',
					pagination:'true',
					pageSize:'20'
					">
				<thead>
					 <tr>  
						<th data-options="field:'ck',checkbox:true"></th>
						<th data-options="field:'menuName',width:200">菜单名</th>
						<th data-options="field:'menuCode',width:140">菜单编码</th>		            
           			 </tr>  
				</thead>
			</table>
			
		</div>
	
	<div id="editRoleResourceDlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveRoleMenus()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#editRoleResourceDlg').dialog('close')">取消</a>
	</div>

</body>
</html>