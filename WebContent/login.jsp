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
	Connector con = new Connector();
	BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
	user.verifyLogin(templogin, temppassword, type, con.stmt);
	
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
		Incorrect Login or Password
		<p>Login</p>
		<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="login.jsp">
		<input type=hidden name="searchAttribute" value="templogin">
		<input type=text name="templogin">
		<p>Password</p>
		<input type=text name="temppassword">
		<input type=submit name="person" value = "User">
		<input type=submit name="person" value = "Driver">
		<input type=button onclick="register()" value = "Register" >
	    </form>

		<%
	}
}
%>