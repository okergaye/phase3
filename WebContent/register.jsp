<%@ page language="java" import="cs5530FinalProj.*,java.lang.*,java.sql.*,java.util.ArrayList,java.io.*" %>

<html>
<head>
<script LANGUAGE="javascript">

function check_all_fields(form_obj){
	alert(form_obj.searchAttribute.value+"='"+form_obj.attributeValue.value+"'");
	if( form_obj.attributeValue.value == ""){
		alert("Search field should be nonempty");
		return false;
	}
	return true;
}
function login()
{
	window.location = "login.jsp";
}
</script> 
</head>
<body>

<%
String tempLogin = request.getParameter("regLogin");
String password = request.getParameter("password");
String name = request.getParameter("name");
String address = request.getParameter("address");
String phone = request.getParameter("phone");
String type = request.getParameter("registration");

if (tempLogin == null || password == null || name == null || address == null || phone == null)
{
%>
Registration
	<p>Login</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="register.jsp">
	<input type=hidden name="searchAttribute" value="login">
	<input type=text name="regLogin" length=16>
	<p>Password</p>
	<input type=text name="password" length=16>
	<p>Name</p>
	<input type=text name="name">
	<p>Address</p>
	<input type=text name="address" length=60>
	<p>Phone</p>
	<input type=text name="phone" length=10>
	<input type=submit name="registration" value = "Register Standard">
	<input type=submit name="registration" value = "Register Driver">
<%
}
else if (tempLogin == "" || password == "" || name == "" || address == "" || phone == "")
{
%>
Registration
	<p>Login</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="register.jsp">
	<input type=hidden name="searchAttribute" value="login">
	<input type=text name="regLogin" length=16>
	<p>Password</p>
	<input type=text name="password" length=16>
	<p>Name</p>
	<input type=text name="name">
	<p>Address</p>
	<input type=text name="address" length=60>
	<p>Phone</p>
	<input type=text name="phone" length=10>
	<input type=submit name="registration" value = "Register Standard">
	<input type=submit name="registration" value = "Register Driver">
All fields should be non empty.
<%	
}
else
{
	Database user = new Database();
	Connector con = new Connector();
	
	int result;

	if (type.equals("Register Standard")) //Register to standard user
	{
		result = user.createUberUser(tempLogin, password, name, address, phone, con.stmt);
	}
	else
	{
		result = user.createUberDriver(tempLogin, password, name, address, phone, con.stmt);
	}
	
	if (result == 1)
	{
		out.print("Registration Succesful");
	}
	else
	{
		out.print("Registration Failed");
	}
	%>
	<form>
	<input type=button onclick="login()" value = "Back to Login">
	</form>
	<%
}
%>