/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package courseschedulerbrendankenneybsk5214;
import java.sql.Connection;
import java.sql.PreparedStatement;
//import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.ResultSet;
/**
 *
 * @author brend
 */
public class StudentQueries {
    private static Connection connection;
    private static PreparedStatement addStudent;
    private static PreparedStatement getAllStudents;
    private static ResultSet resultSet;
    private static PreparedStatement getStudent;
    private static PreparedStatement dropStudent;
    
    public static void addStudent(StudentEntry student){
        connection = DBConnection.getConnection();
        try{
            addStudent = connection.prepareStatement("insert into app.students (studentid, firstname, lastname) values (?,?,?)");
            addStudent.setString(1, student.getStudentID());
            addStudent.setString(2, student.getFirstName());
            addStudent.setString(3, student.getLastName());
            addStudent.executeUpdate();
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
        
    }
    public static ArrayList<StudentEntry> getAllStudents(){
        connection = DBConnection.getConnection();
        ArrayList<StudentEntry> students = new ArrayList<>();
        try{
            getAllStudents = connection.prepareStatement("select studentid, firstname, lastname from app.students");
            resultSet = getAllStudents.executeQuery();
            
            while(resultSet.next()){
                
                String studentID = resultSet.getString(1);
                String firstName = resultSet.getString(2);
                String lastName = resultSet.getString(3);
                StudentEntry temp = new StudentEntry(studentID, firstName, lastName);
                students.add(temp);
                
            }
            
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
        return students;
    }
    public static StudentEntry getStudent(String studentID){
        connection = DBConnection.getConnection();
        StudentEntry temp = new StudentEntry("","","");
        try{
            getStudent = connection.prepareStatement("select firstname, lastname from app.students where studentid = ?");
            getStudent.setString(1, studentID);
            resultSet = getStudent.executeQuery();
            
            while(resultSet.next()){
                String firstName = resultSet.getString(1);
                String lastName = resultSet.getString(2);
                temp = new StudentEntry(studentID, firstName, lastName);
            }
            
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
        return temp;
    }
    public static void dropStudent(String studentID){
        connection = DBConnection.getConnection();
        try{
            dropStudent = connection.prepareStatement("delete from app.students where studentid = ?");
            dropStudent.setString(1, studentID);
            dropStudent.executeUpdate();
            
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
    }
}
