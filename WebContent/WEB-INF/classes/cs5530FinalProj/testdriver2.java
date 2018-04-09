package cs5530FinalProj;


import java.lang.*;
import java.sql.*;
import java.util.ArrayList;
import java.io.*;

public class testdriver2 {

	/**
	 * @param args
	 */
	//simple console write lines
	public static void displayMenu()
	{
		System.out.println("        Welcome to UUber System     ");
    	System.out.println("1. Registration:");
    	System.out.println("2. Login:");
    	System.out.println("3. exit:");
    	System.out.println("pleasse enter your choice:");
	}

	public static void displayUserTypeMenu()
	{
		System.out.println("        Welcome to UUber System     ");
		System.out.println("1. Standard User:");
		System.out.println("2. Driver User:");
		System.out.println("3. Go Back:");
    	System.out.println("pleasse enter your choice:");
	}
	
	public static void displayUserMenu()
	{
		System.out.println("        Welcome to UUber System     ");
		System.out.println("1. Reserve a UberCar:");
		System.out.println("2. Favorite UberCar:");
		System.out.println("3. Record a Ride:");
		System.out.println("4. Write Feedback for UberCar:");
		System.out.println("5. View Feedback for UberCar:");
		System.out.println("6. Rate Feedback:");
		System.out.println("7. Set User to Trusted:");
		System.out.println("8. Set User to Not Trusted:");
		System.out.println("9. Browse UC:");
		System.out.println("10. Search UD Feedbacks:");
		System.out.println("11. Two Degrees of Seperation:");
		System.out.println("12. Statistics:");
		System.out.println("13. User Awards (admin only):");
		System.out.println("14. Logout:");
		System.out.println("pleasse enter your choice:");
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
	//end of console write line menus
	
	
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
			displayUserMenu();
			
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
	public static void mainMenu(BufferedReader in, Connector con, Database user) throws IOException
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
			choice = in.readLine();
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
				displayUserTypeMenu();
		    	
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
				displayUserTypeMenu();
		    	
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
				
				System.out.println("Login:");
				login = in.readLine();
				System.out.println("Password:");
				password = in.readLine();
				
				// Check if the login is true or not
				if (c == 1)
					user.verifyLogin(login, password, "user", con.stmt);
				else
					user.verifyLogin(login, password, "driver", con.stmt);
				
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
	
	public static void main(String[] args) {
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
			mainMenu(in, con, data);
			
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
}
