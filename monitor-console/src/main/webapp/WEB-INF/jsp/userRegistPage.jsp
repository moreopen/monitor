<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户注册</title>
<script type="text/javascript" src="/js/jquery-1.8.0.min.js"></script>
<script type="text/javascript">
function checkEmail(email){
	var reg=/^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;
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
	var userName=$("#userName").val().trim();
	var password=$("#password").val().trim();
	if(userName==""){
		alert("请输入用户名!");
		return;
	}
	if(password==""){
		alert("请输入用户名!");
		return;
	}
	var phone=$("#phone").val().trim();
	if(!checkPhone(phone)){
		alert("系统只支持11位纯数字的手机号，请重新输入!");
		$("#phone").focus();
		return;
	}
	var email=$("#email").val().trim();
	if(!checkEmail(email)){
		alert("请输入正确的邮箱格式!");
		$("#email").focus();
		return;
	}
	
	
	$.ajax({
		type:"POST",
		url:"/monitor/user/addUser.htm",
		data:{userName:userName,password:password,email:email,phone:phone},
		dataType:"text",
		success:function(msg){
			if("hasData"==msg){
				alert("用户名已经存在，请重新输入!");
			}else{
				alert("注册成功!");
			}
		}
	})
}
</script>
</head>
<body>
<form action="" method="POST" id="regform">
<table>
	<tr>
		<td align="right">用户名：</td>
		<td><input type="text" name="userName" id="userName"></td>
	</tr>
	<tr>
		<td align="right">密码：</td>
		<td><input type="text" name="password" id="password"></td>
	</tr>
	<tr>
		<td align="right">手机：</td>
		<td><input type="text" name="phone" id="phone"></td>
	</tr>
	<tr>
		<td align="right">邮箱：</td>
		<td><input type="text" name="email" id="email"></td>
	</tr>
	<tr>
		<td colspan="2"><input type="button"  onclick="add()" value="注册用户"></td>
	</tr>
</table>
</form>

</body>
</html>