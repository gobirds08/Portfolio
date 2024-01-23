/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package courseschedulerbrendankenneybsk5214;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
//import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author brend
 */
public class CourseQueries {
    private static Connection connection;
    private static PreparedStatement addCourse;
    private static PreparedStatement getCourseList;
    private static ResultSet resultSet;
    private static PreparedStatement getAllCourseCodes;
    private static PreparedStatement getCourseSeats;
    private static PreparedStatement dropCourse;
    
    public static void addCourse(CourseEntry course){
        connection = DBConnection.getConnection();
        try{
            addCourse = connection.prepareStatement("insert into app.courses (semester, coursecode, description, seats) values (?,?,?,?)");
            addCourse.setString(1, course.getSemester());
            addCourse.setString(2, course.getCourseID());
            addCourse.setString(3, course.getDescription());
            addCourse.setInt(4, course.getSeats());
            addCourse.executeUpdate();
            
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
    }
    public static ArrayList<CourseEntry> getAllCourses(String semester){
        
        connection = DBConnection.getConnection();
        ArrayList<CourseEntry> courses = new ArrayList<>();
        try{
            
            getCourseList = connection.prepareStatement("select coursecode, description, seats from app.courses where semester = ? order by coursecode");
            getCourseList.setString(1, semester);
            resultSet = getCourseList.executeQuery();
            
            while(resultSet.next())
            {
                String courseCode = resultSet.getString(1);
                String description = resultSet.getString(2);
                int seats = resultSet.getInt(3);
                CourseEntry temp = new CourseEntry(semester, courseCode, description, seats);
                courses.add(temp);
                
            }
            
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
        return courses;
    }
    public static ArrayList<String> getAllCourseCodes(String semester){
        connection = DBConnection.getConnection();
        ArrayList<String> courseCodes = new ArrayList<>();
        try{
            getAllCourseCodes = connection.prepareStatement("select coursecode from app.courses where semester = ? order by coursecode");
            getAllCourseCodes.setString(1, semester);
            resultSet = getAllCourseCodes.executeQuery();
            
            while(resultSet.next()){
                courseCodes.add(resultSet.getString(1));
            }
            
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
        return courseCodes;
    }
    public static int getCourseSeats(String semester, String courseCode){
        connection = DBConnection.getConnection();
        int seats = -1;
        try{
            getCourseSeats = connection.prepareStatement("select seats from app.courses where semester = ? and coursecode = ?");
            getCourseSeats.setString(1, semester);
            getCourseSeats.setString(2, courseCode);
            resultSet = getCourseSeats.executeQuery();
            resultSet.next();
            seats = resultSet.getInt(1);
            
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
        return seats;
    }
    public static void dropCourse(String semester, String courseCode){
        connection = DBConnection.getConnection();
        try{
            dropCourse = connection.prepareStatement("delete from app.courses where semester = ? and coursecode = ?");
            dropCourse.setString(1, semester);
            dropCourse.setString(2, courseCode);
            dropCourse.executeUpdate();
            
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
    }
    
}
