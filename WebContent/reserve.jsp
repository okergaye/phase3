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

<p>Enter A Time to Reserve An UberCar (integer 0-9)</p>
<form name="user_search" method=get onsubmit="orders()" action="reserve.jsp">
<input type=text name="time">
<p>Car VIN</p>
<input type=text name="vin">
<p>Do you want to reserve another car?</p>
<input type=submit name="anw" value = "Yes">
<input type=submit name="anw" value = "No">
</form>
<%
}
else
{
	Database user = new Database();
	Connector con = new Connector();
	testdriver2 test = new testdriver2();
	
	//Feedback creation here
	int result = 0 ;//fb.rateFeedback(login, fid, score, con.stmt);;
	
	if (result == 1)
	{
		out.print("Feedback rating Succesful");
	}
	else
	{
		out.print("Feedback rating Failed");
	}
	%>
	<form>
	<input type=button onclick="menu()" value = "Return To Main Menu">
	</form>
	<%
}
%>


