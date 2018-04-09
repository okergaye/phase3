package cs5530FinalProj;

import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;





public class Database 
{
	public String login;
	String password;
	String name;
	String address;
	String phone;
	boolean driver = false;
	public boolean loggedIn = false;
	
	public Database()
	{}
	
	//for number 10 start
	public void usefullFeedback(String UDLogin, String numToDisplay, Statement s)
	{	
		String sql = "SELECT fid, text, fbdate, Owned.vin, bestFeedback.login, usefullness from (Select UC.vin, UD.login from  UC,UD where "
				+ "UC.login = '" + UDLogin + "' and UC.login = UD.login) as Owned, (Select F.vin, F.fid, F.text, F.fbdate, F.login, R.sumRate as usefullness from "
				+ "(Select avg(rating) as sumRate, fid from Rates GROUP BY fid) as R, Feedback F "
				+ "where F.fid = R.fid) as bestFeedback where Owned.vin = bestFeedback.vin order by usefullness desc LIMIT " + numToDisplay + " ";
		
		ResultSet rs = null;
		String output = "";
		try {
			rs = s.executeQuery(sql);
			while (rs.next()) {
				//this is only for getting stuff back
				output += "|| usefullness: " +rs.getString("usefullness") + "\n";
				output +=  "|| Fid: " + rs.getString("fid") + " ";
				output +=  "|| Feedback text: " + rs.getString("text") + " ";
				output += "|| Date of Feedback: " + rs.getString("fbdate") + " ";
				output += "|| vin: " + rs.getString("vin") + " ";
				output += "|| Feedbackers login: " +rs.getString("login") + " ";

			}
			rs.close();
		} catch (Exception e) {
			System.out.println("cannot execute the query");
		} finally {
			try {
				if (rs != null && !rs.isClosed())
					rs.close();
			} catch (Exception e) {
				System.out.println("cannot close resultset");
			}
		}
		
		System.out.println(output);	
	}
	// number 10 end
	
	public int addHours(String login, String from, String too, Statement s) {

		int start, end;
		
		start = Integer.parseInt(from);
		end = Integer.parseInt(too);
		
		if (end <= start) {
			return 0;
		}
		
		String sql = "INSERT INTO Period " 
			   + "VALUES (0, '" + from + "', '" + too + "')";
		
		insertSQL(s, sql);
		
		sql = "Select max(Pid) as pid from Period";
		String pid = "";		 
		ResultSet rs = null;
		try {
			rs = s.executeQuery(sql);
			while (rs.next()) {
				pid = rs.getString("pid");
			}
			rs.close();
		} catch (Exception e) {
			System.out.println("cannot execute the query for getting pid");
		} finally {
			try {
				if (rs != null && !rs.isClosed())
					rs.close();
			} catch (Exception e) {
				System.out.println("cannot close resultset");
			}
		}
		
		sql = "INSERT INTO Available " 
				   + "VALUES ('" + login + "', '" + pid + "')";
		int output = -1;
		try
		{
			output = s.executeUpdate(sql);
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query for updating avalible table");
			System.out.println(e.getMessage());
		}

		if (output > 0)
		{
			System.out.println("Avaliable Added");
			return 1;
		}
		else
		{
			System.out.println("Avaliable did not add..idk");
			return 0;
		} 

	}


	private int insertSQL(Statement s, String sql) 
	{
		int output = -1;
		try
		{
			output = s.executeUpdate(sql);
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query");
			System.out.println(e.getMessage());
		}

		if (output > 0)
		{
			System.out.println("Period Added");
			return 1;
		}
		else
		{
			System.out.println("Period did not add..idk");
			return 0;
		} 
		
	}

	// problem 9 begin
	public int userBrowseUC(String login, String catagory, String address, String model, String choice, Statement s) 
	{
		//Make things and normalize
		choice.toLowerCase();
		String cat = "", add = "", mod ="", sql = "";

		// if choice is not valid quit life
		if (!choice.equals("a") && !choice.equals("b")) {
			return 0;
		}
		
		//discover which combination is selected
		if (catagory.length() != 0) {
            cat = "and UC.category = '" + catagory + "'";
		}
		if (address.length() != 0) {
			add = "and UD.address = '" + address + "'";

		}
		if (model.length() != 0) {
			mod = "and UC.model = '" + model + "'";

		}
		 if (choice.equals("a")) 
		 {
			 sql = "Select  UC.vin, UC.category, UC.login,  UC.make, UC.model, avg(R.sumRate) as AvgRating from "
			 		+ "UC,UD,Feedback F, (Select sum(rating) as sumRate, fid from Rates GROUP BY fid) as R "
			 		+ "where UC.login = UD.login and F.vin = UC.vin and F.fid = R.fid " + cat + add + mod +" "
			 		+ "group by F.vin order by AvgRating ASC";
				
				
		}
		else 
		{
			sql = "Select  UC.vin, UC.category, UC.login,  UC.make, UC.model, avg(R.sumRate) as AvgRating from "
			 		+ "UC,UD,Feedback F, (Select sum(rating) as sumRate, fid from Rates, Trust T where T.login1 = '" + login + "' and T.login2 = login and T.isTrusted = 1 GROUP BY fid) as R "
			 		+ "where UC.login = UD.login and F.vin = UC.vin and F.fid = R.fid " + cat + add + mod +" "
			 		+ "group by F.vin order by AvgRating ASC";
						
		}
		
		System.out.println(browseSQLHelper(s, sql));

		return 1;
	}

	private String browseSQLHelper(Statement s, String sql) 
	{
		ResultSet rs = null;
		String output = "";
		
		try {
			rs = s.executeQuery(sql);
			while (rs.next()) {
				//this is only for getting stuff back
				output += rs.getString("vin") + " ";
				output += rs.getString("category") + " ";
				output += rs.getString("login") + " ";
				output += rs.getString("make") + " ";
				output += rs.getString("model") + " ";
				output += rs.getString("AvgRating") + "\n";

			}
			rs.close();
		} catch (Exception e) {
			System.out.println("cannot execute the query");
		} finally {
			try {
				if (rs != null && !rs.isClosed())
					rs.close();
			} catch (Exception e) {
				System.out.println("cannot close resultset");
			}
		}
		
		return output;
	}
	// problem 9 end
	
	//problem 4 area
	public String getRide(String login, String vin, String fromHour, String toHour, Statement s)
	{
		Calendar cal = new GregorianCalendar();
    	Date date = new Date(cal.getTimeInMillis());
		int cost = Integer.parseInt(toHour) - Integer.parseInt(fromHour);
		String values = null;
		String count = null;
		
		//check if that string will work
		String sql = "Select count(*) as C from Period P WHERE P.pid = "
				+ "(SELECT A.pid from Available A where login = "
				+ "(SELECT UC.login from UC where UC.vin = '" + vin + "')) "
				+ "and P.fromHour < '" + fromHour + "' and P.toHour > '" + toHour + "'";

		// get maybe available pid, this will catch exceptions
		ResultSet rs=null;
		try
		{
			rs=s.executeQuery(sql);
			while (rs.next())
			{
				count = rs.getString("C");
			}
			rs.close();
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query");
		}
		finally
		{
			try{
				if (rs!=null && !rs.isClosed())
					rs.close();
			}
			catch(Exception e)
			{
				System.out.println("cannot close resultset");
			}
		} 
		
		if(Integer.parseInt(count) != 0) {
			
			values = "VALUES ('" + 0 + "','" + cost + "', '" + date + "', '" + login + "',  '" + vin + "', '" + fromHour + "','" + toHour + "' ) ";
		}
		
		return values;
	}
	
	public int insertRide(String values, Statement s)
	{
		String sql = "INSERT INTO Ride "
					+ values;

		int output = -1;
		try
		{
			output = s.executeUpdate(sql);
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query");
			System.out.println(e.getMessage());
		}

		if (output > 0)
		{
			System.out.println("Ride Added");
			return 1;
		}
		else
		{
			System.out.println("Something went wrong, could be anything?");
			return 0;
		} 
	}
	//problem 4 area end
	//for 3
	public int addCar(String login, String vin, String cat, String make, String model, Statement s ) 
	{
		//Get the user info and make sure there is only 1
		String sql = "INSERT INTO UC "
				+ "VALUES ('" + vin + "', '" + cat + "', '" + login + "',  '" + make + "', '" + model + "' ) ";
		
		int output = -1;
		try
		{
			output = s.executeUpdate(sql);
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query");
			System.out.println(e.getMessage());
		}

		if (output > 0)
		{
			System.out.println("Car Added");
			return 1;
		}
		else
		{
			System.out.println("Something went wrong, are you a legitimate User?");
			return 0;
		} 
	}
	
	//this should ask the user for a vin, and then return t
	public int modCar(String login, String vin, String cat, String make, String model, Statement s ) 
	{
		String sql = "UPDATE UC "
					+ "SET category = '" + cat + "', make = '" + make + "', model = '" + model + "' "
					+ "WHERE vin = '" + vin + "' ";
		
		int output = -1;
		try
		{
			output = s.executeUpdate(sql);
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query");
			System.out.println(e.getMessage());
		}

		if (output > 0)
		{
			System.out.println("Car Updated");
			return 1;
		}
		else
		{
			System.out.println("Something went wrong, did you input the correct vin?");
			return 0;
		} 
	}
	//3 end
	public int createUberDriver(String login, String password, String name, String address, String phone, Statement stmt)
	{
		String sql = "insert into UD values ('" + login + "', '" + password + "', '" + name + "', '" + address + "', '" + phone + "')";
		int output = -1;
		try
		{
			output = stmt.executeUpdate(sql);
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query");
			System.out.println(e.getMessage());
		}

		if (output > 0)
		{
			System.out.println("UberDriver Creation Successful");
			return 1;
		}
		else
		{
			System.out.println("UberDriver Creation Failed");
			return 0;
		} 	
	}
	
	//this is for problem 2
    public ArrayList<Triple> reserveCar(String login, int reserveHours, Statement stmt)
    {	
		ArrayList<Triple> list = new ArrayList<Triple>();
	
		String vin, pid, cost;
		int resHour = reserveHours;
			
		String sql = "select vin, A.pid, toHour - fromHour as Cost from Period P,Available A,UC C where "
				+ "P.pid = A.pid and A.login = C.login and fromHour < '" + resHour + "' and toHour > '" + resHour + "'";

		// get maybe available pid, this will catch exceptions
		ResultSet rs=null;
		try
		{
			rs=stmt.executeQuery(sql);
			while (rs.next())
			{
				vin = rs.getString("vin");
				pid = rs.getString("pid");
				cost = rs.getString("cost");
				list.add(new Triple(vin, pid, cost, resHour));
			}

			rs.close();
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query");
		}
		finally
		{
			try{
				if (rs!=null && !rs.isClosed())
					rs.close();
			}
			catch(Exception e)
			{
				System.out.println("cannot close resultset");
			}
		} 
		
		// now we should have an accepted pid
		return list;
	}
	
    public int reserveCarInsert(String login, String vin, String pid, String cost, int time,  Statement s) 
    {
    	Calendar date = new GregorianCalendar();
    	Date test1 = new Date(date.getTimeInMillis() + time);
		String sql = "insert into Reserve values ('" + login + "', '" + vin + "', '" + pid + "',  '" + cost + "', '" + test1 + "')";
		int output = -1;
		
		try
		{
			output = s.executeUpdate(sql);
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query");
			System.out.println(e.getMessage());
		}

		if (output > 0)
		{
			return 1;
		}
		else
		{
			System.out.println("Something went wrong, please try again");
			return 0;
		} 
    }
    
    public void suggestion(String login, String vin, Statement stmt)
    {
    	String sql = "Select r.vin, Count(*) as A "
    			+ "from Ride r, (select login from Ride where login != '" + login + "' and vin = '" + vin + "' limit 1) as T "
    			+ "where r.login = T.login and r.vin != '" + vin + "' "
    			+ "group by r.vin order by A desc";
    	
    	String output = "";
    	ResultSet rs = null;
    	
		try
		{
			rs=stmt.executeQuery(sql);
			while (rs.next())
			{
				output += "VIN #: " + rs.getString("vin") + "\n";
			}

			rs.close();
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query");
		}
		finally
		{
			try
			{
				if (rs!=null && !rs.isClosed())
					rs.close();
			}
			catch(Exception e)
			{
				System.out.println("cannot close resultset");
			}
		}
		
    	if (output.equals("")) 
    	{
    		System.out.println("No suggestions available.");
		}
    	else 
    	{
			System.out.println("Might we suggest other popular cars users have used: ");
		}
    	
		System.out.println(output);
    }
    
	public int createUberUser(String login, String password, String name, String address, String phone, Statement stmt)
	{
		String sql;
		sql = "insert into UU values ('" + login + "', '" + password + "', '" + name + "', '" + address + "', '" + phone + "')";
		
		int output = -1;
		try
		{
			output = stmt.executeUpdate(sql);
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query");
			System.out.println(e.getMessage());
		}

		if (output > 0)
		{
			System.out.println("UberUser Creation Successful");
			return 1;
		}
		else
		{
			System.out.println("UberUser Creation Failed");
			return 0;
		} 	
	}
	
	public void verifyLogin(String login, String password, String type, Statement stmt)
	{
		String sql;
		
		// Get the user info and make sure there is only 1
		if (type.equals("user"))
		{
			sql = "select *, count(*) as count from UU where login = '" + login + "' and password = '" + password + "'";
		}
		else //The user is a driver
		{
			sql = "select *, count(*) as count from UD where login = '" + login + "' and password = '" + password + "'";
		}
		
		String count = "";
		String localLogin = "";
		String localPassword = "";
		String localName = "";
		String localAddress = "";
		String localPhone = "";
		
		ResultSet rs=null;
		try
		{
			rs=stmt.executeQuery(sql);
			while (rs.next())
			{
				count = rs.getString("count");
				localLogin = rs.getString("login");
				localPassword = rs.getString("password");
				localName = rs.getString("name");
				localAddress = rs.getString("address");
				localPhone = rs.getString("phone");
			}

			rs.close();
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query");
		}
		finally
		{
			try{
				if (rs!=null && !rs.isClosed())
					rs.close();
			}
			catch(Exception e)
			{
				System.out.println("cannot close resultset");
			}
		}
		
		int c = Integer.parseInt(count);
		
		//Setting values to current user until logout so it is easier on menu.
		if (c == 1)
		{
			this.login = localLogin;
			this.password = localPassword;
			this.name = localName;
			this.address = localAddress;
			this.phone = localPhone;
			this.loggedIn = true;
			
			if (type.equals("driver"))
			{
				this.driver = true;
			}
		}
	}
	
	public int userExists(String login, Statement stmt)
	{
		String sql = "select count(*) as count from UU where login = '" + login + "'";
		String output = "";
		ResultSet rs = null;
		try
		{
			rs=stmt.executeQuery(sql);
			while (rs.next())
			{
				output = rs.getString("count");
			}

			rs.close();
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query");
		}
		finally
		{
			try{
				if (rs!=null && !rs.isClosed())
					rs.close();
			}
			catch(Exception e)
			{
				System.out.println("cannot close resultset");
			}
		}
		
		//IF there exists a user with that login it will return 1
		return Integer.parseInt(output);
	}
	
	//Reset values
	public void logout()
	{
		this.login = null;
		this.password = null;
		this.name = null;
		this.address = null;
		this.phone = null;
		this.driver = false;
		this.loggedIn = false;
	}
	
	public int favoriteCar(String vin, String login, Statement stmt)
	{	
		Calendar cal = new GregorianCalendar();
		Date date = new Date(cal.getTimeInMillis());
		
		String sql = "insert into Favorites values ('" + vin + "', '" + login + "', '" + date + "')";
		int output = -1;
		
		try
		{
			output = stmt.executeUpdate(sql);
		}
		catch(Exception e)
		{
			System.out.println("cannot execute the query");
			System.out.println(e.getMessage());
		}

		if (output > 0)
		{
			System.out.println("Car Favorited Successful");
			return 1;
		}
		else
		{
			System.out.println("Car Favorited Failed");
			return 0;
		} 	
	}
	
	public int trustUser(String login1, String login2, int trust, Statement stmt)
	{
		String sql = "select Count(*) as count from Trust where login1 = '" + login1 + "' and login2 = '" + login2 + "'";
		String output = "";
		
		ResultSet rs=null;
	 	try
	 	{
	 		rs=stmt.executeQuery(sql);
	 		while (rs.next())
	 		{
	 			output = rs.getString("count");
	 		}
	     
	 		rs.close();
	 	}
	 	catch(Exception e)
	 	{
	 		System.out.println("cannot execute the query");
	 	}
	 	finally
	 	{
	 		try
	 		{
		 		if (rs!=null && !rs.isClosed())
		 			rs.close();
	 		}
	 		catch(Exception e)
	 		{
	 			System.out.println("cannot close resultset");
	 		}
	 	}
		
		if (output.equals("0")) //If the user did not trust the 2nd user yet insert it into trustUsers
		{
			
			sql = "insert into Trust values ('" + login1 + "', '" + login2 + "', '" + trust + "')";
			int output2 = -1;
			try
			{
				output2 = stmt.executeUpdate(sql);
			}
			catch(Exception e)
			{
				System.out.println("cannot execute the query");
				System.out.println(e.getMessage());
			}

			if (output2 > 0)
			{
				System.out.println("User Trust Set Successfully");
				return 1;
			}
			else
			{
				System.out.println("User Trust Set FAILED!!!!");
				return 0;
			}
		}
		else //If the user already has a trust setting update the trust settings for users trust to 2nd user
		{
			sql = "update Trust set isTrusted = '" + trust + "' where login1 = '" + login1 + "' and login2 = '" + login2 + "'";
			int output2 = -1;
			try
			{
				output2 = stmt.executeUpdate(sql);
			}
			catch(Exception e)
			{
				System.out.println("cannot execute the query");
				System.out.println(e.getMessage());
			}

			if (output2 > 0)
			{
				System.out.println("User Trust Update Successfully");
				return 1;
			}
			else
			{
				System.out.println("User Trust Update FAILED!!!!");
				return 0;
			}
		}
	}
	
	public int degreesOfSeperation(String username1, String username2, Statement stmt)
	{
		//Determine if degree is one
		ArrayList<String> oneDegree = new ArrayList<String>();
		String sql = "select temp.login from Favorites f, Favorites temp where f.vin = temp.vin and f.login != temp.login and f.login = '" + username1 + "'";
		ResultSet rs=null;
	 	try
	 	{
	 		rs=stmt.executeQuery(sql);
	 		while (rs.next())
	 		{
	 			oneDegree.add(rs.getString("login"));
	 		}
	     
	 		rs.close();
	 	}
	 	catch(Exception e)
	 	{
	 		System.out.println("cannot execute the query");
	 	}
	 	finally
	 	{
	 		try
	 		{
		 		if (rs!=null && !rs.isClosed())
		 			rs.close();
	 		}
	 		catch(Exception e)
	 		{
	 			System.out.println("cannot close resultset");
	 		}
	 	}
	 	
	 	// Determine the two users degrees of separation
	 	if (oneDegree.contains(username2))
	 	{
	 		return 1;
	 	}
	 	else //Find if there degree of separation is 2
	 	{
	 		ArrayList<String> twoDegree = new ArrayList<String>();
	 		for (String val : oneDegree)
	 		{
				sql = "select temp.login from Favorites f, Favorites temp where f.vin = temp.vin and f.login != temp.login and f.login = '" + val + "'";
				rs=null;
			 	try
			 	{
			 		rs=stmt.executeQuery(sql);
			 		while (rs.next())
			 		{
			 			twoDegree.add(rs.getString("login"));
			 		}
			     
			 		rs.close();
			 	}
			 	catch(Exception e)
			 	{
			 		System.out.println("cannot execute the query");
			 	}
			 	finally
			 	{
			 		try
			 		{
				 		if (rs!=null && !rs.isClosed())
				 			rs.close();
			 		}
			 		catch(Exception e)
			 		{
			 			System.out.println("cannot close resultset");
			 		}
			 	}
	 		}
	 		
	 		//Check for degree of separation is 2
	 		if (twoDegree.contains(username2))
	 		{
	 			return 2;
	 		}
	 	}
	 	
		return 0;
	}
	
	public void stats(String choice, String limit, Statement stmt)
	{
		String c = choice.toLowerCase();
		
		//Switch to the appropriate method call for what stats the user wants
		switch(c)
		{
			case "a": //Popular UC
				mostPopularUC(limit, stmt);
				break;
				
			case "b": //Expensive UC
				mostExpensiveUC(limit, stmt);
				break;
				
			case "c": //Highest Rating
				highestRatedUC(limit, stmt);
				break;
		}
	}
	
	public void mostPopularUC(String limit, Statement stmt)
	{
		// Array to store the category
		ArrayList<String> cat = new ArrayList<String>();
		String output = "";
		String sql = "Select UC.category, UC.login, R.total as A "
				+ "from UC,UD, (Select Count(*) as total, vin from Ride GROUP BY vin) as R "
				+ "where UC.login = UD.login and R.vin = UC.vin "
				+ "group by R.vin order by A";
		
		ResultSet rs=null;
	 	try
	 	{
	 		rs=stmt.executeQuery(sql);
	 		while (rs.next())
	 		{
	 			//DO NOT ADD MORE THAN 1 OF THE SAME CATEGORY
	 			if (!cat.contains(rs.getString("category")))
 					cat.add(rs.getString("category"));
	 		}
	     
	 		rs.close();
	 	}
	 	catch(Exception e)
	 	{
	 		System.out.println("cannot execute the query");
	 	}
	 	finally
	 	{
	 		try
	 		{
		 		if (rs!=null && !rs.isClosed())
		 			rs.close();
	 		}
	 		catch(Exception e)
	 		{
	 			System.out.println("cannot close resultset");
	 		}
	 	}
	 	
	 	//Name most popular drivers for each category
	 	for (String cate : cat)
	 	{
	 		sql = "Select UC.category, UC.vin, R.total as A "
					+ "from UC,UD, (Select Count(*) as total, vin from Ride GROUP BY vin) as R "
					+ "where UC.login = UD.login and R.vin = UC.vin and UC.category = '" + cate + "' "
					+ "group by R.vin order by A desc limit " + limit + "";

		 	output = "";
			rs=null;
		 	try
		 	{
		 		rs=stmt.executeQuery(sql);
			 	System.out.println("Most Popular Uber Cars in " + cate + "");
		 		while (rs.next())
		 		{
		 			output += "Ride Count: " + rs.getString("A") +" with vin: " + rs.getString("vin") + "\n";
		 		}
		     
		 		rs.close();
		 	}
		 	catch(Exception e)
		 	{
		 		System.out.println("cannot execute the query");
		 	}
		 	finally
		 	{
		 		try
		 		{
			 		if (rs!=null && !rs.isClosed())
			 			rs.close();
		 		}
		 		catch(Exception e)
		 		{
		 			System.out.println("cannot close resultset");
		 		}
		 	}
		 	
		 	//Print the list
		 	System.out.println(output);
	 	}
	}
	
	public void mostExpensiveUC(String limit, Statement stmt)
	{
		// Array to store the category
		ArrayList<String> cat = new ArrayList<String>();
		String output = "";
		String sql = "Select UC.category, UC.login, R.spent as A "
				+ "from UC,UD, (Select avg(cost) as spent, vin from Ride GROUP BY vin) as R "
				+ "where UC.login = UD.login and R.vin = UC.vin "
				+ "group by R.vin order by A";
		
		ResultSet rs=null;
	 	try
	 	{
	 		rs=stmt.executeQuery(sql);
	 		while (rs.next())
	 		{
	 			//DO NOT ADD MORE THAN 1 OF THE SAME CATEGORY
	 			if (!cat.contains(rs.getString("category")))
 					cat.add(rs.getString("category"));
	 		}
	     
	 		rs.close();
	 	}
	 	catch(Exception e)
	 	{
	 		System.out.println("cannot execute the query");
	 	}
	 	finally
	 	{
	 		try
	 		{
		 		if (rs!=null && !rs.isClosed())
		 			rs.close();
	 		}
	 		catch(Exception e)
	 		{
	 			System.out.println("cannot close resultset");
	 		}
	 	}
	 	
	 	//Name most expensive drivers for each category
	 	for (String cate : cat)
	 	{
	 		sql = "Select UC.category, UC.vin, R.spent as A "
					+ "from UC,UD, (Select avg(cost) as spent, vin from Ride GROUP BY vin) as R "
					+ "where UC.login = UD.login and R.vin = UC.vin and UC.category = '" + cate + "' "
					+ "group by R.vin order by A desc limit " + limit + "";

		 	output = "";
			rs=null;
		 	try
		 	{
		 		rs=stmt.executeQuery(sql);
			 	System.out.println("Most Expensive cars in catagory: " + cate + "");
		 		while (rs.next())
		 		{
		 			output += "Average Cost: " + rs.getString("A")+ " for car vin: " + rs.getString("vin") + "\n";
		 		}
		     
		 		rs.close();
		 	}
		 	catch(Exception e)
		 	{
		 		System.out.println("cannot execute the query");
		 	}
		 	finally
		 	{
		 		try
		 		{
			 		if (rs!=null && !rs.isClosed())
			 			rs.close();
		 		}
		 		catch(Exception e)
		 		{
		 			System.out.println("cannot close resultset");
		 		}
		 	}
		 	
		 	//Print the list
		 	System.out.println(output);
	 	}
	}
	
	public void highestRatedUC(String limit, Statement stmt)
	{
		// Array to store the category
		ArrayList<String> cat = new ArrayList<String>();
		String output = "";
		String sql = "Select UC.category, UC.login, avg(R.sumRate) as A "
				+ "from UC,UD,Feedback F, (Select sum(rating) as sumRate, fid from Rates GROUP BY fid) as R "
				+ "where UC.login = UD.login and F.vin = UC.vin and F.fid = R.fid "
				+ "group by F.vin order by A";

		ResultSet rs=null;
	 	try
	 	{
	 		rs=stmt.executeQuery(sql);
	 		while (rs.next())
	 		{
	 			//DO NOT ADD MORE THAN 1 OF THE SAME CATEGORY
	 			if (!cat.contains(rs.getString("category")))
 					cat.add(rs.getString("category"));
	 		}
	     
	 		rs.close();
	 	}
	 	catch(Exception e)
	 	{
	 		System.out.println("cannot execute the query");
	 	}
	 	finally
	 	{
	 		try
	 		{
		 		if (rs!=null && !rs.isClosed())
		 			rs.close();
	 		}
	 		catch(Exception e)
	 		{
	 			System.out.println("cannot close resultset");
	 		}
	 	}
	 	
	 	//Name highest rating drivers for each category
	 	for (String cate : cat)
	 	{
		 	sql = "Select T.login, avg(T.A)as B from (Select UC.category, UC.login, avg(R.sumRate) as A "
					+ "from UC,UD,Feedback F, (Select sum(rating) as sumRate, fid from Rates GROUP BY fid) as R "
					+ "where UC.login = UD.login and F.vin = UC.vin and F.fid = R.fid and UC.category = '" + cate + "' "
					+ "group by F.vin order by A) as T group by T.login order by B desc limit " + limit + "";
		 	output = "";
			rs=null;
		 	try
		 	{
		 		rs=stmt.executeQuery(sql);
			 	System.out.println("Highest Rated Uber User for category: " + cate + "");
		 		while (rs.next())
		 		{
		 			output += "Average Rating: " +rs.getString("B") + " for Uber Driver: " + rs.getString("login") + "\n";
		 		}
		     
		 		rs.close();
		 	}
		 	catch(Exception e)
		 	{
		 		System.out.println("cannot execute the query");
		 	}
		 	finally
		 	{
		 		try
		 		{
			 		if (rs!=null && !rs.isClosed())
			 			rs.close();
		 		}
		 		catch(Exception e)
		 		{
		 			System.out.println("cannot close resultset");
		 		}
		 	}
		 	
		 	//Print the list
		 	System.out.println(output);
	 	}
	}
	
	public String userAward(String choice, String limit, Statement stmt)
	{
		String c = choice.toLowerCase();
		String output = "";
		switch(c)
		{
			case "a": //Trustful Users
				output = trustfulUsers(limit, stmt);
				break;
				
			case "b": //Useful Users
				output = usefulUsers(limit, stmt);
				break;
		}
		return output;
	}
	
	public String trustfulUsers(String limit, Statement stmt)
	{
		String sql = "select login2, sum(isTrusted) as trust from Trust group by login2 order by trust desc limit " + limit + "";
		String output = "";
		ResultSet rs=null;
	 	try
	 	{
	 		rs=stmt.executeQuery(sql);
	 		while (rs.next())
	 		{
	 			output += "Trust total: " + rs.getString("trust") +" for user: " +rs.getString("login2") + "\n";
	 		}
	     
	 		rs.close();
	 	}
	 	catch(Exception e)
	 	{
	 		System.out.println("cannot execute the query");
	 	}
	 	finally
	 	{
	 		try
	 		{
		 		if (rs!=null && !rs.isClosed())
		 			rs.close();
	 		}
	 		catch(Exception e)
	 		{
	 			System.out.println("cannot close resultset");
	 		}
	 	}
	 	
	 	return output;
	}
	
	public String usefulUsers(String limit, Statement stmt)
	{
		String sql = "select f.login, avg(r.rating) as avgRating from Feedback f, Rates r where f.fid = r.fid group by f.login order by avgRating desc limit " + limit + "";
		String output = "";
		ResultSet rs=null;
	 	try
	 	{
	 		rs=stmt.executeQuery(sql);
	 		while (rs.next())
	 		{
	 			output += "Average Feedback Rating: " + rs.getString("avgRating") +" for user: " +rs.getString("login") + "\n";
	 		}
	     
	 		rs.close();
	 	}
	 	catch(Exception e)
	 	{
	 		System.out.println("cannot execute the query");
	 	}
	 	finally
	 	{
	 		try
	 		{
		 		if (rs!=null && !rs.isClosed())
		 			rs.close();
	 		}
	 		catch(Exception e)
	 		{
	 			System.out.println("cannot close resultset");
	 		}
	 	}
	 	
	 	return output;
	}
}
