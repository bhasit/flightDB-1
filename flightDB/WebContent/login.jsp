<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/login.css">

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%

		try {
			//Create a connection string
			String url = "jdbc:mysql://127.0.0.1/local_flight_db";
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");

			//Create a connection to your DB
			Connection con = DriverManager.getConnection(url, "root", "admin");
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the combobox from the HelloWorld.jsp
			
			//Get parameters from the HTML form at the login.jsp
		    String newEmail = request.getParameter("email");
		    String newPswd = request.getParameter("password");
		    
		    //if it is an admin
		    if((newEmail.equals("admin"))&&(newPswd.equals("admin"))){
		    	session.setAttribute("user_name", "admin");
		    	%><script>
		    	window.location.href = "admin-syssup/admin.jsp";
		    	</script>
		    	<%
		    	return;
		    }
		    
			if ((newEmail.equals(""))&&(newPswd.equals(""))){
				%>
				<script> 
				    alert("Please enter your email and password");
				    window.location.href = "login.jsp";
				</script>
				<% 
			} else {
				//have to change this sql!!!
				String str = "SELECT * FROM customers e WHERE e.email='" + newEmail + "' and e.password='" + newPswd + "'";
	
				//Run the query against the database.
				ResultSet result = stmt.executeQuery(str);
	
				if (result.next()) {

		
					//check the "locked param in this following statement"
					if( result.getObject("locked") == null ){
						session.setAttribute("user_name", result.getString("user_name"));
						session.setAttribute("user_email", newEmail);
						
						//what should we change this to????
						%>
						
						<script> 
				    		window.location.href = "driverOrPassenger.jsp";
						</script>
					<%
					}
					else if(result.getInt("locked")==0){
						session.setAttribute("user_name", result.getString("user_name"));
						session.setAttribute("user_email", newEmail);
						session.setAttribute("user_type", "end_user");

						%>
						<script> 
				    		window.location.href = "driverOrPassenger.jsp";
						</script>
					<%						
					}
					else if (result.getInt("locked")==1){
						%>
						<script> 
					    	alert("Sorry, the user is locked and cannot log in now");
					    	window.location.href = "index.jsp";
						</script>
						<%						
					}
					//close the connection.
				} else {
					out.print("User not found");
					%>
					<script> 
				    	alert("User not found, or you entered a wrong password.");
				    	window.location.href = "index.jsp";
					</script>
					<%
				}
			}
			con.close();

		} catch (Exception e) {
			out.print("failed");
			%>
			<script> 
		    	alert("Sorry, unexcepted error happens.");
		    	window.location.href = "index.jsp";
			</script>
			<%			
		}
	%>

</body>
</html>