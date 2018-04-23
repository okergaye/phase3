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
String catagory = request.getParameter("catagory");
String address = request.getParameter("address");
String model = request.getParameter("model");
String choice = request.getParameter("sort");
String login = (String)session.getAttribute("login");
if (catagory == null && address == null && model == null)
{
%>
Browse UUber Car
<br>
<br>
If Blank it will not be considered.
	<p>Category</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="browse.jsp">
	<input type=hidden name="searchAttribute" value="user">
	<input type=text name="catagory">
	<p>Address (City, State)</p>
	<input type=text name="address">
	<p>Car Model</p>
	<input type=text name="model">
	<p>Sorting Order</p>
	<p>(a) Average Numerical Score of Feedbacks</p>
	<p>(b) Average Numerical Score of Trusted User Feedbacks</p>
	<input type=submit name="sort" value = "a">
	<input type=submit name="sort" value = "b">
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
		
		if (catagory == null)
		{
			catagory = "";
		}
		if (address == null)
		{
			address = "";
		}
		if (model == null)
		{
			model = "";
		}
		String result = user.userBrowseUC(login, catagory, address, model, choice, con.stmt);
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