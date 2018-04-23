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
String fid = request.getParameter("fid");
String score = request.getParameter("feedbackRating");
String login = (String)session.getAttribute("login");
if (fid == null || score == null)
{
%>
Rate Feedback
	<p>Feedback FID</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="rate.jsp">
	<input type=hidden name="searchAttribute" value="user">
	<input type=text name="fid">
	<input type=submit name="feedbackRating" value = "0">
	<input type=submit name="feedbackRating" value = "1">
	<input type=submit name="feedbackRating" value = "2">
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
		int result = fb.rateFeedback(login, fid, score, con.stmt);;
		
		if (result == 1)
		{
			out.print("Feedback rating Succesful");
		}
		else
		{
			out.print("Feedback rating Failed");
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