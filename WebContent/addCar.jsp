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
String vin = request.getParameter("vin");
String category = request.getParameter("category");
String make = request.getParameter("make");
String model = request.getParameter("model");

if (vin == null || category == null || make == null || model == null)
{
%>
Add UUber Car
	<p>Car VIN Number</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="addCar.jsp">
	<input type=hidden name="searchAttribute" value="login">
	<input type=text name="vin">
	<p>Car Category</p>
	<input type=text name="category">
	<p>Car Make</p>
	<input type=text name="make">
	<p>Car Model</p>
	<input type=text name="model">
	<input type=submit  value = "Submit">
<%
}
else if (vin == "" || category == "" || make == "" || model == "")
{
%>
Add UUber Car
	<p>Car VIN Number</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="addCar.jsp">
	<input type=hidden name="searchAttribute" value="login">
	<input type=text name="vin">
	<p>Car Category</p>
	<input type=text name="category">
	<p>Car Make</p>
	<input type=text name="make">
	<p>Car Model</p>
	<input type=text name="model">
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
	
		result = user.addCar(user.login, vin, category, make, model, con.stmt);
		
		if (result == 1)
		{
			out.print("Car Added Succesful");
		}
		else
		{
			out.print("Car Added Failed");
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