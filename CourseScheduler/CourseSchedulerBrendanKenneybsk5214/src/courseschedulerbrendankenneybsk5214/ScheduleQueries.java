/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package courseschedulerbrendankenneybsk5214;

import java.sql.Timestamp;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.SQLException;

/**
 *
 * @author brend
 */
public class ScheduleQueries {
    private static Connection connection;
    private static PreparedStatement addScheduleEntry;
    private static PreparedStatement getScheduleByStudent;
    private static PreparedStatement getScheduledStudentCount;
    private static ResultSet resultSet;
    private static PreparedStatement getScheduledStudentsByCourse;
    private static PreparedStatement getWaitlistedStudentsByCourse;
    private static PreparedStatement dropStudentScheduleByCourse;
    private static PreparedStatement dropScheduleByCourse;
    private static PreparedStatement updateScheduleEntry;
    
    public static void addScheduleEntry(ScheduleEntry schedule){
        connection = DBConnection.getConnection();
        try{
            addScheduleEntry = connection.prepareStatement("insert into app.schedules (semester, coursecode, studentid, status, timestamp) values (?,?,?,?,?)");
            addScheduleEntry.setString(1, schedule.getSemester());
            addScheduleEntry.setString(2, schedule.getCourseID());
            addScheduleEntry.setString(3, schedule.getStudentID());
            addScheduleEntry.setString(4, schedule.getStatus());
            addScheduleEntry.setObject(5, schedule.getTimestamp());
            addScheduleEntry.executeUpdate();
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
        
    }
    public static ArrayList<ScheduleEntry> getScheduleByStudent(String semester, String studentID){
        connection = DBConnection.getConnection();
        ArrayList<ScheduleEntry> scheduled = new ArrayList<>();
        try{
            getScheduleByStudent = connection.prepareStatement("select coursecode, status, timestamp from app.schedules where semester = ? and studentid = ?");
            getScheduleByStudent.setString(1, semester);
            getScheduleByStudent.setString(2, studentID);
            resultSet = getScheduleByStudent.executeQuery();
            
            while(resultSet.next()){
                String courseID = resultSet.getString(1);
                String status = resultSet.getString(2);
                Timestamp timestamp = (Timestamp)(resultSet.getObject(3));
                ScheduleEntry schedule = new ScheduleEntry(semester, courseID, studentID, status, timestamp);
                scheduled.add(schedule);
            }
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
        return scheduled;
    }
    public static int getScheduledStudentCount(String semester, String courseCode){
        connection = DBConnection.getConnection();
        int numStudents = 0;
        try{
            getScheduledStudentCount = connection.prepareStatement("select studentID from app.schedules where semester = ? and coursecode = ? and status = ?");
            getScheduledStudentCount.setString(1, semester);
            getScheduledStudentCount.setString(2, courseCode);
            getScheduledStudentCount.setString(3, "S");
            resultSet = getScheduledStudentCount.executeQuery();
            
            while(resultSet.next()){
                numStudents++;
            }
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
        return numStudents;
    }
    public static ArrayList<ScheduleEntry> getScheduledStudentsByCourse(String semester, String courseCode){
        connection = DBConnection.getConnection();
        ArrayList<ScheduleEntry> scheduledStudents = new ArrayList<>();
        try{
            getScheduledStudentsByCourse = connection.prepareStatement("select studentid, timestamp from app.schedules where semester = ? and courseCode = ? and status = ?");
            getScheduledStudentsByCourse.setString(1, semester);
            getScheduledStudentsByCourse.setString(2, courseCode);
            getScheduledStudentsByCourse.setString(3, "S");
            resultSet = getScheduledStudentsByCourse.executeQuery();
            
            while(resultSet.next()){
                String studentID = resultSet.getString(1);
                Timestamp timestamp = resultSet.getTimestamp(2);
                ScheduleEntry schedule = new ScheduleEntry(semester, courseCode, studentID, "S", timestamp);
                scheduledStudents.add(schedule);
            }
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
        return scheduledStudents;
    }
    public static ArrayList<ScheduleEntry> getWaitlistedStudentsByCourse(String semester, String courseCode){
        connection = DBConnection.getConnection();
        ArrayList<ScheduleEntry> scheduledStudents = new ArrayList<>();
        try{
            getScheduledStudentsByCourse = connection.prepareStatement("select studentid, timestamp from app.schedules where semester = ? and courseCode = ? and status = ? order by timestamp");
            getScheduledStudentsByCourse.setString(1, semester);
            getScheduledStudentsByCourse.setString(2, courseCode);
            getScheduledStudentsByCourse.setString(3, "W");
            resultSet = getScheduledStudentsByCourse.executeQuery();
            
            while(resultSet.next()){
                String studentID = resultSet.getString(1);
                Timestamp timestamp = resultSet.getTimestamp(2);
                ScheduleEntry schedule = new ScheduleEntry(semester, courseCode, studentID, "W", timestamp);
                scheduledStudents.add(schedule);
            }
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
        return scheduledStudents;
    }
    public static void dropStudentScheduleByCourse(String semester, String studentID, String courseCode){
        connection = DBConnection.getConnection();
        try{
            dropStudentScheduleByCourse = connection.prepareStatement("delete from app.schedules where semester = ? and studentid = ? and courseCode = ?");
            dropStudentScheduleByCourse.setString(1, semester);
            dropStudentScheduleByCourse.setString(2, studentID);
            dropStudentScheduleByCourse.setString(3, courseCode);
            dropStudentScheduleByCourse.executeUpdate();
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
    }
    public static void dropScheduleByCourse(String semester, String courseCode){
        connection = DBConnection.getConnection();
        try{
            dropScheduleByCourse = connection.prepareStatement("delete from app.schedules where semester = ? and courseCode = ?");
            dropScheduleByCourse.setString(1, semester);
            dropScheduleByCourse.setString(2, courseCode);
            dropScheduleByCourse.executeUpdate();
            
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
    }
    public static void updateScheduleEntry(String semester, ScheduleEntry entry){
        connection = DBConnection.getConnection();
        try{
            updateScheduleEntry = connection.prepareStatement("update app.schedules set status = ? where studentid = ? and coursecode = ? and semester = ?");
            String studentID = entry.getStudentID();
            String courseCode = entry.getCourseID();
            updateScheduleEntry.setString(1, "S");
            updateScheduleEntry.setString(2, studentID);
            updateScheduleEntry.setString(3, courseCode);
            updateScheduleEntry.setString(4, semester);
            updateScheduleEntry.executeUpdate();
            
        }catch(SQLException sqlException){
            sqlException.printStackTrace();
        }
    }
    
}
