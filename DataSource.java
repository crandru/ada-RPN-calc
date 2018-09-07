/* 
 * DataSource Class performs all JDBC database functionality
 * Authors: Chris Rand, Michael Lopes, Phill Valoyi
*/

import java.sql.*;
public class DataSource{
	private Connection conn;
	public DataSource()
		throws SQLException {
			
		DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
		
		//login variables
		String user = "REMOVED";
		String pass = "REMOVED";
		
		try {
			conn = DriverManager.getConnection("jdbc:oracle:thin:@Picard2.radford.edu:1521:itec2",user,pass);
		
			
		}
		catch (SQLException e){
			System.out.println("Could not load the database" + e);
		}
	}
	public Connection getConn(){
		return conn;
	}
	public void closeConn() throws SQLException{
		try{
			conn.close();
		}
		catch (SQLException e){
			System.out.println("Could not load the database" + e);
		}
	}
}