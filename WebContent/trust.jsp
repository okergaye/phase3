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
function menu()
{
	window.location = "userMenu.jsp";
}
</script> 
</head>
<body>
<%
String username = request.getParameter("user");
String trusttype = request.getParameter("trust");
String login = (String)session.getAttribute("login");
if (username == null || trusttype == null)
{
%>
	<p>Other persons Username</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="trust.jsp">
	<input type=hidden name="searchAttribute" value="user">
	<input type=text name="username">
	<p>1 to Trust</p>
	<p>-1 to Not Trust</p>
	<input type=submit name="trust" value = "Trust">
	<input type=submit name="trust" value = "Do not Trust">
	</form>
<%
}
else
{
	Database user = new Database();
	Connector con = new Connector();
	int trust = -1;
	
	if (trusttype.equals("Trust"))
	{
		trust = 1;
	}
	
	if (user.userExists(username, con.stmt) == 1)
	{
		int result = user.trustUser(login, username, trust, con.stmt);
		if (result == 1)
		{
			out.print("Trust Setting Update Success");
		}
		else
		{
			out.print("Trust Setting Update Fail");
		}
	}
	else
	{
		System.out.println("User does not exists.");
	}
	%>
	<form>
	<input type=button onclick="menu()" value = "Return To Main Menu">
	</form>
	<%
}
%>