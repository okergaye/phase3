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
function register()
{
	window.location = "register.jsp";
}
function menu()
{
	window.location = "userMenu.jsp";
}
function dmenu()
{
	window.location = "driverMenu.jsp";
}
</script> 
</head>
<body>
<%
String templogin = request.getParameter("templogin");
String temppassword = request.getParameter("temppassword");
String type = request.getParameter("person");
if (templogin == null && temppassword == null)
{
%>
Welcome to the UUber System
	<p>Login</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="login.jsp">
	<input type=hidden name="searchAttribute" value="templogin">
	<input type=text name="templogin">
	<p>Password</p>
	<input type=text name="temppassword">
	<input type=submit name="person" value = "Standard Login">
	<input type=submit name="person" value = "Driver Login">
	<input type=submit name="person" value = "Register User" >
    </form>
    
    
<%
}
else if (type.equals("Register User"))
{
	%>
	<script type="text/javascript"> register(); </script>
	<%
}
else
{
	if (type.equals("Standard Login"))
	{
		type = "user";
	}
	else
	{
		type = "driver";
	}
	
	Database user = new Database();
	Connector con=null;
	try
	{
		con = new Connector();
		
		BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
		user.verifyLogin(templogin, temppassword, type, con.stmt);
		
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
	
	if (user.loggedIn == true)
	{
		session.setAttribute("login", templogin);
		
		if (type.equals("user"))
		{
			%>
	  		<script type="text/javascript"> menu(); </script>
			<%
		}
		else // Go to driver menu
		{
			%>
	  		<script type="text/javascript"> dmenu(); </script>
			<%
		}
	}
	else
	{
		%>
		Welcome to the UUber System
		<p>Login</p>
		<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="login.jsp">
		<input type=hidden name="searchAttribute" value="templogin">
		<input type=text name="templogin">
		<p>Password</p>
		<input type=text name="temppassword">
		<input type=submit name="person" value = "Standard Login">
		<input type=submit name="person" value = "Driver Login">
		<input type=submit name="person" value = "Register User" >
	    </form>
	    
	    Incorrect Login or Password

		<%
	}
}
%>