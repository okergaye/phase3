<%@ page language="java" import="cs5530FinalProj.*,java.lang.*,java.sql.*,java.util.ArrayList,java.io.*" %>

<html>
<head>
<script LANGUAGE="javascript">

function menu()
{
	window.location = "userMenu.jsp";
}

</script> 
</head>
<body>

<%
String from = request.getParameter("from");
String vin = request.getParameter("vin");
String login = (String)session.getAttribute("login");
String choice = request.getParameter("choice");
String confirm = request.getParameter("confirm");

ArrayList<Triple> confirmedList = (ArrayList<Triple>)session.getAttribute("confirmedList");
ArrayList<Triple> tempList = (ArrayList<Triple>)session.getAttribute("tempList");

Database user = new Database();
Connector con = new Connector();

if (choice != null)
{
	if(choice.equals("N"))
	{
		//User Confirmation
		out.print("Reservations: <br/>");
		
		for (Triple temp : confirmedList)
		{
			out.print("VIN #: "+ temp.vin + " with cost: $" + temp.cost + "<br/>");
		}
		%>
		<form name="userEntersCo" method=get onsubmit="" action="reserve.jsp">
		<p>Do you want to confirm these reservations (Y/N):</p>
		<input type=submit name="confirm" value = "Y">
		<input type=submit name="confirm" value = "N">
		</form>
		<%
	}
	else if (choice.equals("Y"))
	{
		%>
		<form name="userEntersTime" method=get onsubmit="" action="reserve.jsp">
		<p>Please enter a time to reserve a car: (integer 0-23)</p>
		<input type=text name="from">
		<input type=submit name="gotTime" value = "Enter">
		</form>
		<%
	}
}
else if (confirm != null)
{
	if (confirm.toUpperCase().equals("Y"))
	{
		for (Triple temp : confirmedList)
		{
			user.reserveCarInsert(login, temp.vin, temp.pid, temp.cost, temp.time, con.stmt);
		}
		out.print("Confirmed!");
	}
	else
	{
		out.print("Reservatios Cancelled");
		session.setAttribute("confirmedList", new ArrayList<Triple>());
		%>
		<form>
		<input type=button onclick="menu()" value = "Return To Main Menu">
		</form>
		<%
	}
}
else if (from != null || vin != null)
{
	ArrayList<Triple> list = new ArrayList<Triple>();

	if(vin == null)
	{
		if (from != null)
		{
			int time = Integer.parseInt(from);
			list = user.reserveCar(login, time, con.stmt);
		}
		// Print out list of cars to reserve available 
		out.print("Here are all available Uber Cars: (There are none avaliable if this is empty) <br/>");

		for (Triple temp : list)
		{
			out.print("VIN #: "+temp.vin+", Cost: $" + temp.cost + "<br/>");
		}
		
		session.setAttribute("tempList", list);
		
		%>
		<form name="userEntersVin" method=get onsubmit="" action="reserve.jsp">
		<p>Please enter the VIN # of the car you would like to reserve:</p>
		<input type=text name="vin">
		<input type=submit name="gotVin" value = "Enter">
		</form>
		<%
	}
	else
	{
		//Stores to confirm later
		
		for (Triple temp : tempList)
		{
			if (temp.vin.equals(vin))
			{
				confirmedList.add(new Triple(vin, temp.pid, temp.cost, temp.time));
				out.print("Added VIN #: "+ vin + "<br/>");
				user.suggestion(login, vin, con.stmt);
			}
		}
		
		session.setAttribute("confirmedList", confirmedList);
		
		%>
		<form name="userEntersCo" method=get onsubmit="" action="reserve.jsp">
		<p>Do you want to reserve another car (Y/N):</p>
		<input type=submit name="choice" value = "Y">
		<input type=submit name="choice" value = "N">
		</form>
		<%
	}
}
else
{	
	%>
	<form name="userEntersTime" method=get onsubmit="" action="reserve.jsp">
	<p>Please enter a time to reserve a car: (integer 0-23)</p>
	<input type=text name="from">
	<input type=submit name="gotTime" value = "Enter">
	</form>
	<%
}
%>
