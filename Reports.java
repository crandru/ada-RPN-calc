/* 
 * Reports Class generates reports (Class/Student,Instructor,Student)
 * Authors: Chris Rand, Michael Lopes, Phill Valoyi
*/
import java.sql.*;
public class Reports{
	public static void classStudent(Connection conn) throws SQLException{
		/* Class/Student Report query */
		try{
		String query = "SELECT * from Enroll INNER JOIN Student on Enroll.SID = Student.SID ORDER BY Class_name, Last";
			Statement stmt = conn.createStatement();
			ResultSet rset = stmt.executeQuery(query);
		System.out.println("Class_Name|First|Last\n---------------------------");
			while(rset.next()){
				System.out.print(rset.getString("Class_name") + "|" + rset.getString("First") + "|" + rset.getString("Last"));
				System.out.println();
			}
			System.out.println("\n---------------------------");
		}
		catch(SQLException e){
			System.out.println("Could not load the database" + e);
		}
			
	}
	public static void instructor(Connection conn){
		/* Instructor Report query */
		try{
			String query = "SELECT Fname, Lname, Class_Name, Count(*) from Instructor INNER JOIN Enroll on Instructor.TID = Enroll.TID GROUP BY Fname, Lname, Class_Name";
			Statement stmt = conn.createStatement();
			ResultSet rset = stmt.executeQuery(query);
			System.out.println("---------------------------\nFirst|Last|Class_Name|Count\n---------------------------");
			while(rset.next()){
				System.out.print(rset.getString("Fname") + "|" + rset.getString("Lname") + "|" + rset.getString("Class_name") + "|" + rset.getString("Count(*)"));
				System.out.println("");
			}
			System.out.println("\n---------------------------");
		}
		catch(SQLException e){
			System.out.println("Could not load the database" + e);
		}
	}
	public static void student(Connection conn){
		try{
			/* Student Report Query */
			String query = "SELECT Class_Name, First, Last, Exp_Level from Student INNER JOIN Enroll on Student.SID = Enroll.SID";
			Statement stmt = conn.createStatement();
			ResultSet rset = stmt.executeQuery(query);
			System.out.println("Class_Name|First|Last|Exp_Level\n---------------------------");
			while(rset.next()){
				System.out.print(rset.getString("Class_name") + "|" + rset.getString("First") + "|" + rset.getString("Last") + "|" + rset.getString("Exp_Level"));
				System.out.println();
			}
			System.out.println("\n---------------------------");
		}
		catch(SQLException e){
			System.out.println("Could not load the database" + e);
		}
	}
}