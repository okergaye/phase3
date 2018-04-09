package cs5530FinalProj;

import java.sql.*;
import java.util.Calendar;
import java.util.GregorianCalendar;

public class Feedback {
	public Feedback()
	{}
	
	// Feedback will use login as a forgien key so we know what user created the feedback fid primary key
	public String getFeedback(String vin, Statement stmt)
	{
		String sql="select text, fid from Feedback where vin = '"+vin+"'";
		String output = "";
		String text, fid;
		ResultSet rs=null;
	 	System.out.println("Getting Feedback For Vin #: "+vin);
	 	try
	 	{
	 		rs=stmt.executeQuery(sql);
	 		while (rs.next())
	 		{
	 			text = rs.getString("text");
	 			fid = rs.getString("fid");
	 		 	output ="\nReview text: " + text + " \nFid: " + fid +"" ;

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
	
	public int createFeedback(String text, String vin, String login, Statement stmt)
	{
		String sql="select login from Feedback where vin = '"+vin+"'";
		String output="";
		ResultSet rs=null;
		
		//Executing SQL
	 	System.out.println("executing "+sql);
	 	try
	 	{
	 		rs=stmt.executeQuery(sql);
	 		while (rs.next())
	 		{
	 			output = rs.getString("login");
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
	 	
	 	if (output.equals(login)) //Check if user is trying to create another feedback
	 	{
	 		System.out.println("Unvaliable to create feedback.  Feedback already exists.");
	 		return 0;
	 	}
		
	 	//Start inserting into table
		Calendar date = new GregorianCalendar();
    	Date test1 = new Date(date.getTimeInMillis());
		
		sql = "insert into Feedback values('" + 0 + "', '" + text + "', '" + test1 + "', '" + vin + "', '" + login + "')";
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
			System.out.println("Feedback Creation Successful");
			return 1;
		}
		else
		{
			System.out.println("Feedback Creation Failed");
			return 0;
		} 	
	}
	
	//User inputs fid in order to rate that feedback if its the users feedback do not rate his own feedback
	public int rateFeedback(String login, String fid, String score, Statement stmt)
	{
		String sql="select login from Feedback where fid = '"+fid+"'";
		String output="";
		ResultSet rs=null;
	 	System.out.println("executing "+sql);
	 	try
	 	{
	 		rs=stmt.executeQuery(sql);
	 		while (rs.next())
	 		{
	 			output = rs.getString("login");
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
	    
	 	if (output.equals(login)) //Check if user is rating their own feedback
	 	{
	 		System.out.println("Unvaliable to rate own feedback");
	 		return 0;
	 	}
	 	else //User rating others feedback
	 	{		
			sql = "insert into Rates values ('" + login + "', '" + fid + "', '" + score + "')";
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
				System.out.println("Feedback Rating Successful");
				return 1;
			}
			else
			{
				System.out.println("Feedback Rating Failed");
				return 0;
			}
	 	}
	}
}
