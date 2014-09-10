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
	<script type="text/javascript">
	function openAddDlg(){
		$("#addDlg").dialog('open');
	}
	function checkEmail(email){
		var reg=/^[^\.@]+@[^\.@]+\.[a-z]+$/;
		if(reg.test(email)){
			return true;
		}
		return false;
	}
	function checkPhone(phone){
		var reg=/^\d{11}$/;
		if(reg.test(phone)){
			return true;
		}
		return false;
	}
	function add(){
		var userName=$("#newUserName").val().trim();
		if(userName==""){
			alert("请输入用户名!");
			return;
		}
		var password=$("#newPassword").val().trim();
		if(password==""){
			alert("请输入密码");
			return;
		}
		var phone=$("#newIphone").val().trim();
		var email=$("#newEmail").val().trim();
		if(phone==""){
			alert("请输入电话号码!");
			$("#newIphone").focus();
			return;
		}
		if(!checkPhone(phone)){
			alert("系统只支持11位纯数字手机号,请重新输入!");
			$("#newIphone").focus();
			return;
		}
		if(email==""){
			alert("请输入邮箱!");
			$("#newEmail").focus();
			return;
		}
		if(!checkEmail(email)){
			alert("请输入正确的邮箱地址!");
			$("#newEmail").focus();
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/monitor/user/addUser.htm",
			data:{userName:userName,password:password,phone:phone,email:email},
			success:function(msg){
				if(msg=="exitis"){
					alert("该用户名已经被占用！");
				}else{
					$("#addDlg").dialog('close');
					var json=eval("("+msg+")");
					$('#dg').datagrid('appendRow',
							json
					);
					$("#newUserName").val("");
					$("#newPassword").val("");
					$("#newIphone").val("");
					$("#newEmail").val("");
				}
			}
		});
	}
	
	function openEditDlg(){
		var row=$("#dg").datagrid('getSelected');
		
		if(row==null){
			alert("请选择要修改的用户!");
			return;
		}else{
			$("#editDlg").dialog('open');
			$("#editUserName").val(row.userName);
			$("#editPassword").val(row.password);
			$("#editIphone").val(row.phone);
			$("#editEmail").val(row.email);
			
		}
	}
	
	function editUser(){
		/**var userName=$("#editUserName").val().trim();
		if(userName==""){
			alert("请输入用户名!");
			return;
		}**/
		var password=$("#editPassword").val().trim();
		if(password==""){
			alert("请输入密码!");
			return;
		}
		var phone=$("#editIphone").val().trim();
		var email=$("#editEmail").val().trim();
		if(phone==""){
			alert("请输入电话!");
			return;
		}
		if(!checkPhone(phone)){
			alert("系统只支持11位纯数字手机号,请重新输入!");
			$("#newIphone").focus();
			return;
		}
		if(email==""){
			alert("请输入邮箱!");
			return;
		}
		if(!checkEmail(email)){
			alert("请输入正确的邮箱地址!");
			$("#editEmail").focus();
			return;
		}
		$("#editDlg").dialog('close');
		var row=$("#dg").datagrid('getSelected');
		$.ajax({
			type:"POST",
			url:"/monitor/user/updateUser.htm",
			data:{userId:row.userId,password:password,phone:phone,email:email},
			success:function(msg){
				$("#dg").datagrid('reload');
			}
		});
	}
	
	function deleteResource(){
		var data=$("#dg").datagrid('getSelected');
		if(data==null){
			alert("请选择要删除的用户!");
			return;
		}else{
			if(confirm("确认要删除该用户吗？")){
				var index=$("#dg").datagrid('getRowIndex',data);
				$.ajax({
					type:"POST",
					url:"/monitor/user/deleteUser.htm",
					data:"userId="+data.userId,
					success:function(msg){
						$("#dg").datagrid('deleteRow',index);
					},
					error:function(){
						alert("删除失败,请联系管理员!");
					}
				});
			}
		}
	}
	
	function searchByUserName(){
		var userName=$("#searchUserName").val().trim();
		$.ajax({
				type:"POST",
				url:"/monitor/user/queryUser.htm",
				data:"userName="+userName,
				success:function(msg){
					var json=eval("("+msg+")");
					$("#dg").datagrid("loadData",json);
				}
		})
	}
	
	function openEditRoleDlg(){
		var data=$("#dg").datagrid('getSelected');
		if(data==null){
			alert("请选择用户!");
			return;
		}else{
			$("#editRoleDlg").dialog('open');
			$.ajax({
				type:"POST",
				url:"/monitor/user/getRolesByUserId.htm?userId="+data.userId,
				//data:"roleId="+data.roleId,
				success:function(msg){
					var json=eval("("+msg+")");
					for(var i=0;i<json.length;i++){
						var jsonobj = json[i];
						var rowIndex=$("#role-dg").datagrid('getRowIndex',jsonobj.roleId);
						$("#role-dg").datagrid('checkRow',rowIndex);
					}
				}
			});
		}
	}
	
	function saveUserRoles(){
		var userRow=$("#dg").datagrid('getSelected');
		var rows=$("#role-dg").datagrid('getSelections');
		var roleIds="";
		for(var i=0;i<rows.length;i++){
			roleIds=roleIds+rows[i].roleId+",";
		}
		$.ajax({
			type:"POST",
			url:"/monitor/user/updateUserRole.htm",
			data:"userId="+userRow.userId+"&roleId="+roleIds,
			success:function(msg){
				$("#role-dg").datagrid("unselectAll");
				$("#editRoleDlg").dialog('close');
				$("#dg").datagrid('reload');
			}
		});
	}
</script>
<title>修改用户密码</title>
</head>
<body>
<table>
	<tr>
		<td>
			用户名：<input id="searchUserName" type="text" name="searchUserName" class="searchInput"/>
		</td>
		<td>
			<a id="search-button" href="#" class="easyui-linkbutton" iconCls="icon-search" onClick="javascript:searchByUserName()">Search</a>
		</td>
	</tr>
</table>
<table id="dg" class="easyui-datagrid" 
            url="/monitor/user/queryUser.htm"  
            rownumbers="true"
            resizable="true"
            singleSelect="true"
            toolbar="#tb"
            pagination="true"
            pageSize="10"
>  
        <thead>  
            <tr>  
                <th field="userName" width="80" align="center">用户名</th>  
                <th field="password" width="120" align="center">密码</th>  
                <th field="phone" width="120" align="center">电话</th>
                <th field="email" width="120" align="center">Email</th>
               
                 <th data-options="field:'roleNames',width:240,title:'aaa'">角色</th>
                <th field="createUserName" width="50" align="center">创建人</th>  
                <th field="createTimeFormat" width="140" align="center">创建时间</th>  
                <th field="updateUserName" width="70" align="center">修改人</th>  
                <th field="updateTimeFormat" width="140" align="center">修改时间</th>  
            </tr>  
        </thead>  
 </table>  
    <!-- 工具按钮 -->
	 <div id="tb" style="height:auto">
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="openAddDlg()">新增</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="openEditDlg()">修改</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="deleteResource()">删除</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-redo',plain:true" onclick="openEditRoleDlg()">分配角色</a>
	</div>
	<!-- 添加用户的dialog -->
	<div id="addDlg" class="easyui-dialog" title="新增用户" style="width:400px;height:200px;"
			data-options="
				iconCls: 'icon-add',
				toolbar: '#dlg-toolbar',
				buttons: '#dlg-buttons',
				closed: true,
				modal: true
			">
			<table width="100%"  style="margin-top:10px">
				<tr>
					<td align="right">用户名：</td>
					<td><input id="newUserName" type="text" name="newUserName" /></td>
				</tr>
				<tr>
					<td align="right">密码：</td>
					<td><input id="newPassword" type="text" name="newPassword" /></td>
				</tr>
				<tr>
					<td align="right">电话：</td>
					<td><input id="newIphone" type="text" name="newPassword" /></td>
				</tr>
				<tr>
					<td align="right">邮箱：</td>
					<td><input id="newEmail" type="text" name="newPassword" /></td>
				</tr>
			</table>
	</div>
	
	<div id="dlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="add()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addDlg').dialog('close')">取消</a>
	</div>
	
	<!-- 修改用户的dialog -->
	<div id="editDlg" class="easyui-dialog" title="修改用户" style="width:400px;height:200px;padding:10px"
			data-options="
				iconCls: 'icon-edit',
				buttons: '#dlg-buttons',
				closed: true,
				modal: true
	">
			<table width="100%"  style="margin-top:10px">
				<tr>
					<td align="right">用户名：</td>
					<td><input id="editUserName" type="text" name="editUserName"  disabled="true"/></td>
				</tr>
				<tr>
					<td align="right">密码：</td>
					<td><input id="editPassword" type="text" name="editPassword" /></td>
				</tr>
				<tr>
					<td align="right">电话：</td>
					<td><input id="editIphone" type="text" name="editIphone" /></td>
				</tr>
				<tr>
					<td align="right">邮箱：</td>
					<td><input id="editEmail" type="text" name="editEmail" /></td>
				</tr>
			</table>
	</div>
	
	<div id="dlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="editUser()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#editDlg').dialog('close')">取消</a>
	</div>
	
	<!-- 分配角色的DIALOG -->
		<div id="editRoleDlg" class="easyui-dialog" title="&nbsp;&nbsp;分配角色" style="width:400px;height:400px;padding:10px"
			data-options="
				iconCls: 'icon-redo',
				buttons: '#editRoleDlg-buttons',
				closed: true,
				modal: true,
				
			">
			
			<table id="role-dg" class="easyui-datagrid"  width="100%" style="margin-top:10px"
					data-options="
					rownumbers:true,
					url:'/monitor/role/queryAllRole.htm',
					idField:'roleId',
					pagination:'true',
					pageSize:'20'
					">
				<thead>
					<tr>
						<th data-options="field:'ck',checkbox:true"></th>
						<th data-options="field:'roleId',width:80">角色ID</th>
						<th data-options="field:'roleName',width:100">角色名</th>
					</tr>
				</thead>
			</table>
			
		</div>
	
	<div id="editRoleDlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveUserRoles()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#editRoleDlg').dialog('close')">取消</a>
	</div>
	
</body>
</html>