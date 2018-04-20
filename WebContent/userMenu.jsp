<html>
<head>
<script LANGUAGE="javascript">
function reserve()
{
	window.location = "reserve.jsp";
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
function login()
{
	window.location = "login.jsp";
}
</script> 
</head>
<body>

Welcome to UUBER System
	<p>1. Reserve an UberCar</p>
	<p>2. Favorite an UberCar</p>
	<p>3. Record a Ride</p>
	<p>4. Write Feedback for UberCar</p>
	<p>5. View Feedback for UberCar</p>
	<p>6. Rate Feedback</p>
	<p>7. Set User Trust Level</p>
	<p>8. Browse UberCar</p>
	<p>9. Search UberDriver Feedbacks</p>
	<p>10. Logout</p>
	<p>Please press your desired choice.</p>
	<form name="user_search" method=get action="userMenu.jsp">
	<input type=hidden name="searchAttribute" value="login">
	<input type=button onclick="reserve()" value = "1" >
	<input type=button onclick="favorite()" value = "2">
	<input type=button onclick="record()" value = "3">
	<input type=button onclick="writeFB()" value = "4">
	<input type=button onclick="view()" value = "5">
	<input type=button onclick="rate()" value = "6">
	<input type=button onclick="trust()" value = "7">
	<input type=button onclick="browse()" value = "8">
	<input type=button onclick="search()" value = "9">
	<input type=button onclick="login()" value = "10">
    </form>