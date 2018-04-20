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
String choice = request.getParameter("anw");
String confirm = request.getParameter("confirm");





ArrayList<Triple> confirmedList = new ArrayList<Triple>();

Database user = new Database();
Connector con = new Connector();

if(choice == null || choice == "Y"){
	
	
	
	if(from == null){
		
		%>
		<form name="userEntersTime" method=get onsubmit="" action="reserve.jsp">
		<p>Please enter a time to reserve a car: (integer 0-23)</p>
		<input type=text name="from">
		<input type=submit name="gotTime" value = "Enter">
		</form>
		<%
		
	}else{

		int time = Integer.parseInt(from);
		ArrayList<Triple> list = new ArrayList<Triple>();

		list = user.reserveCar(login, time, con.stmt);
		
		// Print out list of cars to reserve available 
		out.print("Here are all available Uber Cars: (There are none avaliable if this is empty) <br/>");

		for (Triple temp : list)
		{
			out.print("VIN #: "+temp.vin+", Cost: $" + temp.cost + "<br/>");
		}

		
		
		if(vin == null){
			%>
			<form name="userEntersVin" method=get onsubmit="" action="reserve.jsp">
			<p>Please enter the VIN # of the car you would like to reserve:</p>
			<input type=text name="vin">
			<input type=submit name="gotVin" value = "Enter">
			</form>
			<%
		}else{
			//Stores to confirm later
			
			for (Triple temp : list)
			{
				if (temp.vin.equals(vin))
				{
					confirmedList.add(new Triple(vin, temp.pid, temp.cost, temp.time));
					System.out.println("Added VIN #: "+ vin + "");
					user.suggestion(login, vin, con.stmt);
				}
			}
			
			
			//Check if user wants to reserve car or not
			if(choice == null){
				%>
				<form name="userEntersCo" method=get onsubmit="" action="reserve.jsp">
				<p>Do you want to reserve another car (Y/N):</p>
				<input type=submit name="choice" value = "Y">
				<input type=submit name="choice" value = "N">
				</form>
				<%
			}
		}
		
		
		
		
	}
	
	
	
}else{
	
	
	//User Confirmation
	out.print("Do you want to confirm these reservations (Y/N):");
	
	for (Triple temp : confirmedList)
	{
		out.print("VIN #: "+ temp.vin + " with cost: $" + temp.cost);
	}
	
	if(confirm == null){
		%>
		<form name="userEntersCo" method=get onsubmit="" action="reserve.jsp">
		<p>Do you want to confirm these reservations (Y/N):</p>
		<input type=submit name="confirm" value = "Y">
		<input type=submit name="confirm" value = "N">
		</form>
		<%
	}
	
	if (confirm.toUpperCase().equals("Y"))
	{
		for (Triple temp : confirmedList)
		{
			user.reserveCarInsert(login, temp.vin, temp.pid, temp.cost, temp.time, con.stmt);
		}
		out.print("Confirmed!");
	}
}
%>
