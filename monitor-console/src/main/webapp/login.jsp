<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登录</title>
<style type="text/css">
body{
text-align:center;
margin:0 auto;
}
</style>
</head>
<body class="easyui-layout">
	<div data-options="region:'north',border:true,split:true"
		style="height: 25px; background: url('/images/layout-browser-hd-bg.gif');">
		<b>Moreopen Monitor</b>
	</div>
	<div data-options="region:'center',border:true,split:true" style="height:50px"></div>
	<div data-options="region:'center',border:true,split:true" style="height:300px">
		<form action="/monitor/login/loginAction.htm" method="post">
			<table align="center">
				<tr>
					<td align="right"> 用户名:</td><td><input type="text" name="userName"/></td>
				</tr>
				<tr>
					<td align="right">密码:</td><td><input type="password" name="password"/></td>
				</tr>
				<tr>
					<td colspan="2" align="center"><input type="submit" value="登录"></td>
				</tr>
			</table>
			
			<!--div style="margin-top:10px">密 码：<input type="password" name="password"/></div>
			<div style="margin-top:10px">用户名：<input type="text" name="userName"/></div>
			<div><input type="submit" value="登录"></div-->
		</form>
	</div>
<br/>
<!--a href="/monitor/user/userRegistPage.htm">注册用户</a-->
</body>
</html>