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
	window.location = "driverMenu.jsp";
}
</script> 
</head>
<body>

<%
String login = (String)session.getAttribute("login");
String from = request.getParameter("from");
String to = request.getParameter("to");

if (from == null || to == null)
{
%>
Set Hours of Operations
	<p>Start Time</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="setHour.jsp">
	<input type=hidden name="searchAttribute" value="login">
	<input type=text name="from">
	<p>End Time</p>
	<input type=text name="to">
	<input type=submit  value = "Submit">
<%
}
else if (from == "" || to == "")
{
%>
Set Hours of Operations
	<p>Start Time</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="setHour.jsp">
	<input type=hidden name="searchAttribute" value="login">
	<input type=text name="from">
	<p>End Time</p>
	<input type=text name="to">
	<input type=submit  value = "Submit">
All fields should be non empty.
<%	
}
else
{
	Database user = new Database();
	Connector con=null;
	try
	{
		con = new Connector();
		
		int result;

		result = user.addHours(login, from, to, con.stmt);
		
		if (result == 1)
		{
			out.print("Hours of Operations Added Succesful");
		}
		else
		{
			out.print("Hours of Operations Added Failed");
		}
		
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
	<input type=button onclick="menu()" value = "Return to Main Menu">
	</form>
	<%
}
%>