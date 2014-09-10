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
			var node=$("#easyui-treegrid").treegrid("getSelected");
			if(node==null){
				alert("请选择父菜单!");
				return;
			}
			$('#dlg').dialog('open');
		}
		function addMenu(){
			var newMenuName=$("#newMenuName").val().trim();
			/* var newMenuId=$("#newMenuId").val().trim();
			if(newMenuId==""){
				alert("请输入菜单ID！");
				return;
			} */

			if(newMenuName==""){
				alert("请输入菜单名！");
				return;
			}

			
				var node=$("#easyui-treegrid").treegrid("getSelected");
				$.ajax({
					type:"POST",
					url:"/monitor/menu/addMenu.htm",
					data:{menuPid:node.id,menuName:newMenuName,menuPCode:node.menuCode},
					dataType:"text",
					success:function(msg){
						/* if(msg=="hasData"){
							alert("menuId已经存在，请重新输入!");
						}else{ */
							$("#easyui-treegrid").treegrid("append",{
								parent:node.id,
								data: [{
									id: msg,
									name:newMenuName
								}]
							});
							$("#newMenuName").val("");
							$("#easyui-treegrid").treegrid("reload",node.id);
							$('#dlg').dialog('close');
						/* } */
					}
				});
			
		}
		
		function openEditDlg(){
			var node = $('#easyui-treegrid').treegrid('getSelected');
			if(node==null){
				alert("请选择菜单");
				return;
			}else{
				$("#editMenuName").val(node.name);
				$("#modify-dlg").dialog('open');
			}
		}
		function editMenu(){
			var node = $('#easyui-treegrid').treegrid('getSelected');
			var menuName=$("#editMenuName").val().trim();
			if(menuName==""){
				alert("请输入菜单名字!");
				return;
			}else{
				$("#modify-dlg").dialog('close');
				$.ajax({
					type:"POST",
					url:"/monitor/menu/updateMenuName.htm",
					data:{id:node.id,menuName:menuName},
					success:function(msg){
						
						$('#easyui-treegrid').treegrid('update',{
							id:node.id,
							row:{
								name:menuName
							}
						})
					}
				});
			}
		}
		
		function deleteMenu(){
			var node = $('#easyui-treegrid').treegrid('getSelected');
			//var parentNode=$('#easyui-treegrid').treegrid('getParent',node.menuId);
			//此逻辑由服务端判断，避免客户端缓存数据与真实数据不一致
			/* if(node.menuIsleaf==-1){
				alert("该节点非叶子节点，不能删除，请刷新后重试。");
				return;
			}else{ */
				if(confirm("确实要删除该菜单吗？")){
					$.ajax({
						type:"POST",
						url:"/monitor/menu/delMenu.htm",
						data:"id="+node.id,
						success:function(msg){
							if(msg=="failed"){
								alert("删除失败，该节点可能是非叶子节点!");
								return;
							}else{
								$("#easyui-treegrid").treegrid("pop",node.id);//用pop，当被删的是最后一个子节点的时候，会改变父节点的图标
							}
						}
					});
				}
			/* } */
			
		}

	</script>
	<style type="text/css">
		.addSpan{
			background:url('/icons/edit_add.png') no-repeat; height:22px; width: 33px;padding-left:20px;display:inline-block;cursor: pointer;
		}
		.delSpan{
			background:url('/icons/edit_remove.png') no-repeat; height:22px; width: 33px;padding-left:20px;display:inline-block;cursor: pointer;
		}
		.editSpan{
			background:url('/icons/pencil.png') no-repeat; height:22px; width: 33px;padding-left:20px;display:inline-block;cursor: pointer;
		}
		.dialog-content{
			/**line-height: 109px**/
		}
	</style>
</head>
<body>
	
<!-- 
<table>
	<tr>
		<td>	
			按菜单名查找:
		</td>
		<td>
			<input id="searchMenuName" type="text" style="padding:3px;height:20px;width:200px"/>
		</td>
		<td>
			<a id="search-button" href="#" class="easyui-linkbutton" iconCls="icon-search" onClick="javascript:searchByMenuName()">Search</a>
		</td>
	</tr>
</table>
 -->	
	<div style="margin:10px 0;"></div>

	<div style="margin:10px" id="tb">

		<span class="addSpan" onclick="openAddDlg()">新增</span>
		<span class="editSpan" onclick="openEditDlg()">修改</span>
		<span class="delSpan" onclick="deleteMenu()">删除</span>

	</div>
	<table id="easyui-treegrid" class="easyui-treegrid"
			url="/monitor/menu/getEditMenu.htm" 
			rownumbers="true" 
			idField="id" 
			treeField="name"
			striped="true"
			pagination="true"
			pageSize="20"
			toolbar="#tb"
			pageList="[20,50,100]"
			data-options="
				onBeforeLoad: function(row,param){  
                    if (!row) { // 刷新的时候加载menu_pid为-1的子菜单
                        param.id = -1;   // set id=0, indicate to load new page rows  
                    } 
                }  
			"
			>
		<thead>
			<tr>
				<th data-options="field:'name',width:180,align:'left'">菜单名</th>
				<th field="menuCode" align="center">菜单编码</th>
				<th field="createUserName" width="50" align="center">创建人</th>  
                <th field="createTimeFormat" width="140" align="center">创建时间</th> 
                <th field="updateUserName" width="70" align="center">修改人</th>  
                <th field="updateTimeFormat" width="140" align="center">修改时间</th>  
			</tr>
		</thead>
	</table>
	<!-- 添加菜单的dialog -->
		<div id="dlg" class="easyui-dialog" title="&nbsp;&nbsp;添加菜单" style="width:400px;height:200px;padding:10px"
				data-options="
					iconCls: 'icon-add',
					toolbar: '#dlg-toolbar',
					buttons: '#dlg-buttons',
					closed: true,
					modal: true
				">
				<table>
					<!-- <tr>
						<td align="right">请输入菜单ID：</td>
						<td><input id="newMenuId" type="text" name="newMenuId"/></td>
					</tr> -->
					<tr>
						<td align="right">请输入菜单名：</td>
						<td><input id="newMenuName" type="text" name="newMenuName"/></td>
					</tr>
				</table>
		</div>
		
		<div id="dlg-buttons">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="addMenu()">Save</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#dlg').dialog('close')">取消</a>
		</div>
	
	<!-- 修改菜单的dialog -->
		<div id="modify-dlg" class="easyui-dialog" title="&nbsp;&nbsp;修改菜单" style="width:400px;height:200px;padding:10px"
				data-options="
					iconCls: 'icon-edit',
					buttons: '#modify-dlg-buttons',
					closed: true,
					modal: true
				">
			菜单名：&nbsp;<input id="editMenuName" type="text" name="newMenuName" style="width:200px;height:30px;padding:3px"/>
		</div>
		
		<div id="modify-dlg-buttons">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="editMenu()">Save</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#modify-dlg').dialog('close')">取消</a>
		</div>
	
</body>
</html>