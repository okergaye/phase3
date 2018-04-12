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
function login()
{
	window.location = "login.jsp";
}
function orders()
{
	window.location = "orders.jsp";
}
function register()
{
	window.location = "register.jsp";
}
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
function browse()
{
	window.location = "browse.jsp";	
}
function trust()
{
	window.location = "trust.jsp";	
}
function write()
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
function search()
{
	window.location = "search.jsp";	
}
</script> 
</head>
<body>

<form name="user_search" method=get onclick="login()" action="login.jsp">
		<input type=button name="nil" value="backtologin">
	</form>

<%
String menu = request.getParameter("menuChoice");


if (menu != null) {
	//main(menu);
	switch(menu)
	{
	case "1":
		%>
  		<script type="text/javascript"> register(); </script>
		<%
		break;	
	case "2"://this is for login
		
		break;
	}

}

System.out.println(menu);
%>


<%!
public static void displayMenu()
{
	%>
	Welcome to UUBER System
	<p>1. Registration</p>
	<p>2. Login</p>
	<p>Please enter 1 or 2</p>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="orders.jsp">
	<input type=hidden name="searchAttribute" value="login">
	<input type=submit name="menuChoice" value = "1">
	<input type=submit name="menuChoice" value = "2">
    </form>
	<%! 
	
	
}



public static void displayDriverMenu()
{
	System.out.println("        Welcome to UUber System     ");
	System.out.println("1. Add a UberCar:");
	System.out.println("2. Update a UberCar:");
	System.out.println("3. Set Hours of Op:");
	System.out.println("4. Logout:");
	System.out.println("pleasse enter your choice:");
}
//end of console write line menuss


//this is main menu option 2
public static void startUser(BufferedReader in, Connector con, Database user) throws IOException
{
	String choice, username, username2, vin, feedback, fid, score, from, to, model, address, catagory, number, output;
	boolean loggedIn = true;
	boolean choiceTrue = false;
	Feedback fb = new Feedback();
	int c=0;
	
	// Start loop
	while(loggedIn)
	{
	//	displayUserMenu();
		
		//Find which option to go to
		choice = in.readLine();
		try
		{
			c = Integer.parseInt(choice);
		}
		catch (Exception e)
		{	 
			continue;
		}
		
		//Check if in bounds
		if (c<1 | c>14)
			continue;
		
		//Switch case for all the options
		switch (c)
		{
		case 1: //Reserve
			reserve(in, con, user);

			break;
			
		case 2: // Favorite
			System.out.println("please enter car vin number:");
			vin = in.readLine();
			
			user.favoriteCar(vin, user.login, con.stmt);
			
			break;
			
		case 3: // Record a Ride
			ArrayList<String> rideList = new ArrayList<String>();
			String temp;
			boolean goOn = true;
			
			//Loop to add cars
			while (goOn)
			{
				System.out.println("please enter car vin number:");
				vin = in.readLine();
				System.out.println("please enter your start time:");
				from = in.readLine();
				System.out.println("please enter your end time:");
				to = in.readLine();
				
				temp = user.getRide(user.login, vin, from, to, con.stmt);
				
				//Check if the car was available at that time or not
				if (temp == null)
					System.out.println("Ride was not avaliable at that time");
				else // Car was available
					rideList.add(temp);
				
				System.out.println("Do you want to add another car (Y/N):");
				choice = in.readLine();
				
				//Check to end loop
				if (choice.toUpperCase().equals("N"))
				{
					goOn = false;
				}
			}
			
			//Print rides to record
			for(String s : rideList)
			{
				System.out.println(s);
			}
			
			System.out.println("Do you want to confirm these rides (Y/N):");
			choice = in.readLine();
			
			//If they confirm the rides insert into table
			if(choice.toUpperCase().equals("Y"))
			{
				//Insert cars into the tables
				for(String s : rideList)
				{
					user.insertRide(s, con.stmt);
				}
			}
			
			break;
			
		case 4: // Write Feedback
			System.out.println("please enter car vin number:");
			vin = in.readLine();
			System.out.println("please enter your feedback:");
			feedback = in.readLine();
			
			//Feedback creation here
			fb.createFeedback(feedback, vin, user.login, con.stmt);
			break;
			
		case 5: // View Feedback
			System.out.println("please enter car vin number:");
			vin = in.readLine();
			
		    String result =	fb.getFeedback(vin, con.stmt);
			
			System.out.println("Here are your results: \n" + result);

			break;
			
		case 6: // Rate Feedback
			System.out.println("please enter fid number to rate feedback:");
			fid = in.readLine();
			System.out.println("please enter 0 (useless), 1 (useful), or 2 (very useful):");
			score = in.readLine();
			
			fb.rateFeedback(user.login, fid, score, con.stmt);
			break;
			
		case 7: //Trust a user
			System.out.println("please enter other username:");
			username = in.readLine();
			
			if (user.userExists(username, con.stmt) == 1)
			{
				user.trustUser(user.login, username, 1, con.stmt);
			}
			else
			{
				System.out.println("User does not exists.");
			}
			
			break;
			
		case 8: //Do not trust a user
			System.out.println("please enter other username:");
			username = in.readLine();
			
			if (user.userExists(username, con.stmt) == 1)
			{
				user.trustUser(user.login, username, -1, con.stmt);
			}
			else
			{
				System.out.println("User does not exists.");
			}
			
			break;
			
		case 9: //Browsing UC
			System.out.println("If blank it will not be considered.");
			System.out.println("please enter a catagory:");
			catagory = in.readLine();
			System.out.println("If blank it will not be considered.");
			System.out.println("please enter an address (City, State):");
			address = in.readLine();
			System.out.println("If blank it will not be considered.");
			System.out.println("please enter car model:");
			model = in.readLine();
			System.out.println("Sorting order:");
			System.out.println("(a) average numerical score of feedbacks:");
			System.out.println("(b) average numerical score of trusted users feedbacks:");
			System.out.println("please enter your choice:");
			choice = in.readLine();
			
			user.userBrowseUC(user.login, catagory, address, model, choice, con.stmt);
			
			break;
			
		case 10: //Search UD feedbacks
			System.out.println("please enter a UD login:");
			username = in.readLine();
			System.out.println("please enter the number of feedbacks to display:");
			number = in.readLine();
			user.usefullFeedback(username, number, con.stmt);
			
			break;
			
		case 11: //2DoS
			System.out.println("please enter first username:");
			username = in.readLine();
			System.out.println("please enter second username:");
			username2 = in.readLine();
			
			int degree;
			
			degree = user.degreesOfSeperation(username, username2, con.stmt);
			System.out.println("Users: " +username+ " and " +username2+ " are " + degree+ " degree apart" );

			break;
			
		case 12: //Stats
			System.out.println("Statistics:");
			System.out.println("please enter how many users to limit the list to:");
			number = in.readLine();
			
			choiceTrue = false;
			
			//Start loop to prevent user from choosing a different option
			while (!choiceTrue)
			{
				System.out.println("Statistics:");
				System.out.println("(a) Most popular UC for each catagory:");
				System.out.println("(b) Most expensive UC for each catagory:");
				System.out.println("(c) Highest Rating UC for each catagory:");
				System.out.println("please enter your choice:");
				choice = in.readLine();
				
				if (!choice.toLowerCase().equals("a") && !choice.toLowerCase().equals("b") && !choice.toLowerCase().equals("c"))
				{
					System.out.println("Choose one of the three options.");
				}
				else
				{
					choiceTrue = true;
				}
			}
			
			user.stats(choice, number, con.stmt);
			
			break;
			
		case 13: //User Awards
			System.out.println("User Award:");
			System.out.println("please enter how many users to limit the list to:");
			number = in.readLine();
			
			choiceTrue = false;
			
			//Start loop to prevent user from choosing a different option
			while (!choiceTrue)
			{
				System.out.println("(a) Most trusted user:");
				System.out.println("(b) Most useful user:");
				System.out.println("please enter your choice:");
				choice = in.readLine();
				
				if (!choice.toLowerCase().equals("a") && !choice.toLowerCase().equals("b"))
				{
					System.out.println("Choose one of the two options.");
				}
				else
				{
					choiceTrue = true;
				}
			}
			
			output = user.userAward(choice, number, con.stmt);
			
			switch(choice.toLowerCase())
			{
			case "a":
				System.out.println("Heres the list of most trusted users: \n" + output);
				break;
			case "b":
				System.out.println("Heres the list of most useful users: \n" + output);
				break;
			}
			
			break;
			
		case 14: //Logging out
			user.logout();
			loggedIn = false;
			System.out.println("Logging out.");
			break;
		}
	}
	//End of loop
}

private static void reserve(BufferedReader in, Connector con, Database user) throws IOException 
{
	String choice, vin, from;
	int time;
	boolean confirm;
	ArrayList<Triple> list = new ArrayList<Triple>();
	ArrayList<Triple> confirmedList = new ArrayList<Triple>();
	confirm = false;
	while(!confirm)
	{
		System.out.println("please enter a time to reserve a car:");
		from = in.readLine();
		
		time = Integer.parseInt(from);
		
		list = user.reserveCar(user.login, time, con.stmt);
		
		// Print out list of cars to reserve available 
		System.out.println("Here are all available Uber Cars:");
		for (Triple temp : list)
		{
			System.out.println("VIN #: "+temp.vin+", Cost: $" + temp.cost);
		}
		
		System.out.println("Please enter the VIN # of the car you would like to reserve:");
		vin = in.readLine();
		
		//Stores to confirm later
		for (Triple temp : list)
		{
			if (temp.vin.equals(vin))
			{
				confirmedList.add(new Triple(vin, temp.pid, temp.cost, temp.time));
				System.out.println("Added VIN #: "+ vin + "");
				user.suggestion(user.login, vin, con.stmt);
			}
		}
		
		//Check if user wants to reserve car or not
		System.out.println("Do you want to reserve another car (Y/N):");
		choice = in.readLine();
		
		if (choice.toUpperCase().equals("N")) {
			confirm = true;
			break;
		}
	}
	
	//User Confirmation
	System.out.println("Do you want to confirm these reservations (Y/N):");
	for (Triple temp : confirmedList)
	{
		System.out.println("VIN #: "+ temp.vin + " with cost: $" + temp.cost);
	}
	
	choice = in.readLine();
	
	if (choice.toUpperCase().equals("Y"))
	{
		for (Triple temp : confirmedList)
		{
			user.reserveCarInsert(user.login, temp.vin, temp.pid, temp.cost, temp.time, con.stmt);
		}
		System.out.println("Confirmed!");
	}
}

public static void startDriver(BufferedReader in, Connector con, Database user) throws IOException
{
	String choice, vin, from, to, catagory, make, model;
	boolean loggedIn = true;
	int c=0;
	
	//Start of loop
	while(loggedIn)
	{
		displayDriverMenu();
		
		//get choice
		choice = in.readLine();
		try
		{
			c = Integer.parseInt(choice);
		}
		catch (Exception e)
		{	 
			continue;
		}
		
		// is in bounds
		if (c<1 | c>8)
			continue;
		
		//Switch case for all the options
		switch (c)
		{
		case 1: //Add a car
			System.out.println("please enter car vin number:");
			vin = in.readLine();
			System.out.println("please enter car catagory:");
			catagory = in.readLine();
			System.out.println("please enter car make:");
			make = in.readLine();
			System.out.println("please enter car model:");
			model = in.readLine();
			
			user.addCar(user.login, vin, catagory, make, model, con.stmt);
			break;
			
		case 2: //Update a car
			System.out.println("please enter car vin number:");
			vin = in.readLine();
			System.out.println("please enter car catagory:");
			catagory = in.readLine();
			System.out.println("please enter car make:");
			make = in.readLine();
			System.out.println("please enter car model:");
			model = in.readLine();
			
			user.modCar(user.login, vin, catagory, make, model, con.stmt);
			break;
			
		case 3: //Set hours of operation
			System.out.println("please enter your starting time:");
			from = in.readLine();
			System.out.println("please enter your ending time:");
			to = in.readLine();
			
			//Set the hours of operation for the ud from this information
			user.addHours(user.login, from, to, con.stmt);
			
			break;
			
		case 4:
			user.logout();
			loggedIn = false;
			System.out.println("Logging out.");
			break;
		}
	}
	// End of loop
}






// this is actually the reg menu!!! aka main menu option 1
public static void mainMenu(BufferedReader in, Connector con, Database user, String menu) throws IOException
{
	
	String choice;
    int c=0;
    String name;
    String address;
    String phone;
    String login;
    String password;
    boolean active = true;
    
	while(active)
	{
		displayMenu();

		//choice = in.readLine();
		choice = menu;
		try
		{
			c = Integer.parseInt(choice);
		}
		catch (Exception e)
		{	 
			continue;
		}
		if (c<1 | c>3)
			continue;
		
		// Switch Case
		switch(c)
		{
		case 1: //Registration
		//	displayUserTypeMenu();
	    	
			// Check if user registration for standard or driver
			//choice = in.readLine();
					choice = menu;
			try
			{
				c = Integer.parseInt(choice);
			}
			catch (Exception e)
			{	 
				continue;
			}
			
			// Return to menu
			if (c > 3 || c < 1)
				continue;
			
			//get out
			if (c == 3)
			{
				break;
			}
			
			System.out.println("please enter your name:");
			name = in.readLine();
			System.out.println("please enter your address:");
			address = in.readLine();
			System.out.println("please enter your phone:");
			phone = in.readLine();
			System.out.println("Login:");
			login = in.readLine();
			//Verify unique login here
			System.out.println("Password:");
			password = in.readLine();
			
			if (c == 1) //Register to standard user
			{
				user.createUberUser(login, password, name, address, phone, con.stmt);
			}
			else
			{
				user.createUberDriver(login, password, name, address, phone, con.stmt);
			}
			break;
			
		case 2: //Login
		//	displayUserTypeMenu();
	    	
			// Check if user registration for standard or driver
			choice = in.readLine();
			try
			{
				c = Integer.parseInt(choice);
			}
			catch (Exception e)
			{	 
				continue;
			}
			
			// Return to menu
			if (c > 3 || c < 1)
				continue;
			
			if (c==3)
			{
				break;
			}
			
			%> 
			
			<% 
			Database user = new Database();
			Connector con = new Connector();
			String login = request.getParameter("login");
			String password = request.getParameter("password");
			user.verifyLogin(login, password, request.getParameter("person"), con.stmt);
		//	user.verifyLogin(login, password, "user", con.stmt);

			%>
			<%!
			
			// Check if the login is true or not
		//	if (c == 1)
			//	user.verifyLogin(login, password, "user", con.stmt);
		//	else
				//user.verifyLogin(login, password, "driver", con.stmt);
			
			// If the user is logged in switch to their menu
			if (user.loggedIn == true)
			{
				if (c == 1)
					startUser(in, con, user);
				else
					startDriver(in, con, user);
				break;
			}
			else
			{
				System.out.println("Login Failed.");
				break;
			}
			
		case 3: //Exit
			active = false;
			break;
		}
	}
}

public static void main(String m) {
	System.out.println("Example for cs5530");
	Connector con=null;
	Database data = new Database();
    try
	{
		//remember to replace the password
		con= new Connector();
		System.out.println ("Database connection established");
		BufferedReader in = new BufferedReader(new InputStreamReader(System.in));

		//Show the user the main menu
		mainMenu(in, con, data, m);
		
		System.out.println("EoM");
		con.stmt.close();
	}
	catch (Exception e)
	{
		e.printStackTrace();
		System.err.println ("Either connection error or query execution error!");
	}
	finally
	{
		if (con != null)
		{
			try
			{
			con.closeConnection();
			System.out.println ("Database connection terminated");
			}
			catch (Exception e) { /* ignore close errors */ }
		}	 
	}
}



%>






<%
String searchAttribute = request.getParameter("searchAttribute");
if( searchAttribute == null ){
%>









	Form1: Search orders on user name YOU SONVABddddddddddddddddddddddECH:
	<form name="user_search" method=get onsubmit="return check_all_fields(this)" action="orders.jsp">
		<input type=hidden name="searchAttribute" value="login">
		<input type=text name="attributeValue" length=10>
		<input type=submit>
	</form>
	<BR><BR>
	Form2: Search orders on director name:
	<form name="director_search" method=get onsubmit="return check_all_fields(this)" action="orders.jsp">
		<input type=hidden name="searchAttribute" value="director">
		<input type=text name="attributeValue" length=10>
		<input type=submit>
	</form>

<%

} else {

	String attributeValue = request.getParameter("attributeValue");
	Connector connector = new Connector();
	//Order order = new Order();
	
%>  

  <p><b>Listing orders in JSP: </b><BR><BR>

  The orders for query: <b><%=searchAttribute%>='<%=attributeValue%>'</b> are  as follows:<BR><BR>
  
  <b>Alternate way (servlet method):</b> <BR><BR>
  <%
		out.println("The orders for query: <b>"+searchAttribute+"='"+attributeValue+
					"'</b> are as follows:<BR><BR>");
		//out.println(order.getOrders(searchAttribute, attributeValue, connector.stmt));
  %>

<%
 connector.closeConnection();
}  // We are ending the braces for else here
%>

<BR><a href="orders.jsp"> New query </a></p>

<p>Schema for Order table: <font face="Geneva, Arial, Helvetica, sans-serif">( 
  title varchar(100), quantity integer, login varchar(8), director varchar(10) 
  )</font></p>

</body>
