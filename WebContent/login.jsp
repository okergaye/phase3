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
function orders()
{
	window.location = "orders.jsp";
}
function menu()
{
	window.location = "userMenu.jsp";
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
	<input type=submit name="person" value = "user">
	<input type=submit name="person" value = "driver">
    </form>
    
    
<%
}
else
{
	Database user = new Database();
	Connector con = new Connector();
	BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
	user.verifyLogin(templogin, temppassword, type, con.stmt);
	
	if (user.loggedIn == true)
	{
		if (type.equals("user"))
			session.setAttribute("login", templogin);
			%>
	  		<script type="text/javascript"> register(); </script>
			<%
		//else
			//nothing yet
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
		<input type=submit name="person" value = "user">
		<input type=submit name="person" value = "driver">
	    </form>

		<%
	}
}
%>