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
String username = request.getParameter("uduser");
String number = request.getParameter("numOfFB");
if (username == null && number == null)
{
%>
Search UDriver
	<p>UberDriver Username</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="search.jsp">
	<input type=hidden name="searchAttribute" value="user">
	<input type=text name="uduser">
	<p>Number of Feedback to see</p>
	<input type=text name="numOfFB">
	<input type=submit  value = "Enter">
	</form>
	
<%
}
else
{
	Database user = new Database();
	Connector con=null;
	try
	{
		con = new Connector();
		
		String result = user.usefullFeedback(username, number, con.stmt);
		
		out.print(result);
		
		con.stmt.close();
	}
	catch (Exception e)
	{
		e.printStackTrace();
		System.err.println ("Either connection error or query execution error!");
	}
	finally
	{
		if (con != null)
		{
			try
			{
			con.closeConnection();
			System.out.println ("Database connection terminated");
			}
			catch (Exception e) { /* ignore close errors */ }
		}	 
	}
	
	%>
	<form>
	<input type=button onclick="menu()" value = "Return To Main Menu">
	</form>
	<%
}
%>