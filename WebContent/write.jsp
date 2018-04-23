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
String vin = request.getParameter("vin");
String feedback = request.getParameter("feedback");
String login = (String)session.getAttribute("login");
if (vin == null || feedback == null)
{
%>
Write Feedback
	<p>Car VIN</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="write.jsp">
	<input type=hidden name="searchAttribute" value="user">
	<input type=text name="vin">
	<p>Feedback</p>
	<input type=text name="feedback">
	<input type=submit  value = "Enter">
	</form>
<%
}
else
{
	Database user = new Database();
	Feedback fb = new Feedback();
	
	Connector con=null;
	try
	{
		con = new Connector();
		
		//Feedback creation here
		int result = fb.createFeedback(feedback, vin, login, con.stmt);
		
		if (result == 1)
		{
			out.print("Feedback creation Succesful");
		}
		else
		{
			out.print("Feedback creation Failed");
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
	<input type=button onclick="menu()" value = "Return To Main Menu">
	</form>
	<%
}
%>