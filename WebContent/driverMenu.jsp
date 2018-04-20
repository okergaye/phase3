<html>
<head>
<script LANGUAGE="javascript">

function addCar()
{
	window.location = "addCar.jsp";	
}
function modCar()
{
	window.location = "modCar.jsp";	
}
function setHours()
{
	window.location = "setHour.jsp";	
}
function login()
{
	window.location = "login.jsp";
}
</script> 
</head>
<body>

Welcome to UUBER System
	<p>1. Add a UberCar</p>
	<p>2. Update a UberCar</p>
	<p>3. Set Hours of Operation</p>
	<p>4. Logout</p>
	<p>Please press your desired choice.</p>
	<form name="user_search" method=get action="driverMenu.jsp">
	<input type=hidden name="searchAttribute" value="login">
	<input type=button onclick="addCar()" value = "1" >
	<input type=button onclick="modCar()" value = "2">
	<input type=button onclick="setHours()" value = "3">
	<input type=button onclick="login()" value = "4">
    </form>