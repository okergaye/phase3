<html>
<head>
<script LANGUAGE="javascript">
function reserve()
{
	window.location = "reserve.jsp";	
	system.out.println("TEST");
}

function favorite()
{
	window.location = "favorite.jsp";	
}
function record()
{
	window.location = "record.jsp";	
}
function writeFB()
{
	window.location = "write.jsp";	
}
function view()
{
	window.location = "view.jsp";	
}
function rate()
{
	window.location = "rate.jsp";	
}
function trust()
{
	window.location = "trust.jsp";	
}
function browse()
{
	window.location = "browse.jsp";	
}
function search()
{
	window.location = "search.jsp";	
}
function orders()
{
	window.location = "orders.jsp";
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
	<input type=button onclick="reserve()" value = "1" >
	<input type=button onclick="favorite()" value = "2">
	<input type=button onclick="record()" value = "3">
	<input type=button onclick="orders()" value = "4">
    </form>