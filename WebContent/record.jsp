<%@ page language="java" import="cs5530FinalProj.*,java.lang.*,java.sql.*,java.util.ArrayList,java.io.*" %>

<html>
<head>
<script LANGUAGE="javascript">

function menu()
{
	window.location = "userMenu.jsp";
}
function record()
{
	window.location = "record.jsp";
}


</script> 
</head>
<body>



<% 
String login = (String)session.getAttribute("login");

String vin = request.getParameter("vin");
String from = request.getParameter("from");
String to = request.getParameter("to");

String choice = request.getParameter("choice");
String confirm = request.getParameter("confirm");

Database user = new Database();
Connector con = new Connector();
ArrayList<String> rideList =  (ArrayList<String>)session.getAttribute("rideList");

if(rideList == null){
	rideList = new ArrayList<String>();	
}

//Loop to add cars

	if(choice == null || choice.equals("Y")){
		
		if(vin == null || from == null || to == null || vin == "" || from == "" || to == ""){
			%>
			<form name="record" method=get onsubmit="" action="record.jsp">
			<p>please enter car vin number:</p>
			<input type=text name="vin">
			<p>please enter your start time:</p>
			<input type=text name="from">
			<p>please enter your end time:</p>
			<input type=text name="to">
			<input type=submit name="gotTime" value = "Enter">
			</form>
			<%
		}else{

			String temp = user.getRide(login, vin, from, to, con.stmt);
			
			//Check if the car was available at that time or not
			if (temp == null){
				out.print("Ride was not avaliable at that time");
				%>
				<form>
				<input type=button onclick="menu()" value = "Return To Main Menu">
				<input type=button onclick="record()" value = "Try again">
				</form>
				<%

			}
			// Car was available
			else{
				rideList.add(temp);
				out.print("A car was avaliable! <br/>");
				session.setAttribute("rideList", rideList);

				
				%>
				<form name="userEntersCo" method=get onsubmit="" action="record.jsp">
				<p>Do you want to add another car (Y/N):</p>
				<input type=submit name="choice" value = "Y">
				<input type=submit name="choice" value = "N">
				</form>
				<%
				
			}
				
		}
	}else if (choice.equals("N")){
		
		if(confirm == null){
			//Print rides to record
			out.print("Record these rides? <br/>");
			for(String s : rideList)
			{
				out.print(s + "<br/>");
			}
			%>
			<form name="userEntersconfirm" method=get onsubmit="" action="record.jsp">
			<p>Do you want to confirm these rides (Y/N):</p>
			<input type=hidden name="choice" value = "N">
			<input type=submit name="confirm" value = "Y">
			<input type=submit name="confirm" value = "N">
			</form>
			<%
			
			
		}
		else if(confirm.equals("Y"))
		{
			out.print("Inserted into DB <br/>");
			//Insert cars into the tables
			for(String s : rideList)
			{
				user.insertRide(s, con.stmt);
			}
			rideList =  new ArrayList<String>();
			session.setAttribute("rideList", rideList);
			%>
			<form>
			<input type=button onclick="menu()" value = "Return To Main Menu">
			</form>
			<%
			
			
		}else if(confirm.equals("N")){
			

			rideList =  new ArrayList<String>();
			session.setAttribute("rideList", rideList);
			
			%>
			<form>
			<input type=button onclick="menu()" value = "Return To Main Menu">
			</form>
			<%

		}


	}
	

%>



