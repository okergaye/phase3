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
if (vin == null)
{
%>
	<p>Car VIN</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="view.jsp">
	<input type=hidden name="searchAttribute" value="viewVin">
	<input type=text name="vin">
	<input type=submit  value = "Enter">
	</form>
<%
}
else
{
	Feedback fb = new Feedback();
	Connector con = new Connector();
	String result =	fb.getFeedback(vin, con.stmt);
	
	System.out.println("Here are your results: \n" + result);
	out.print("Here are your results: <br>" + result);
	%>
	<form>
	<input type=button onclick="menu()" value = "Return To Main Menu">
	</form>
	<%
}
%>