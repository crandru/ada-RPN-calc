/* 
 * ReportDrv Class to initialize JDBC program
 * Authors: Chris Rand, Michael Lopes, Phill Valoyi
*/
import java.sql.*;
public class ReportDrv{
	
	public static void main (String[] args){
		try{
		DataSource dSource = new DataSource();
		Reports report = new Reports();
		report.classStudent(dSource.getConn());
		report.instructor(dSource.getConn());
		report.student(dSource.getConn());
		dSource.closeConn();
		}
		catch(SQLException e){
			System.out.println("Could not load the database" + e);
		}
	}
}