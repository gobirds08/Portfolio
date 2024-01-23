/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package courseschedulerbrendankenneybsk5214;

import java.sql.Timestamp;

/**
 *
 * @author brend
 */
public class ScheduleEntry {
    private final String semester;
    private final String courseID;
    private final String studentID;
    private final String status;
    private final Timestamp timestamp;

    public ScheduleEntry(String semester, String courseID, String studentID, String status, Timestamp timestamp) {
        this.semester = semester;
        this.courseID = courseID;
        this.studentID = studentID;
        this.status = status;
        this.timestamp = timestamp;
    }

    public String getSemester() {
        return semester;
    }

    public String getCourseID() {
        return courseID;
    }

    public String getStudentID() {
        return studentID;
    }

    public String getStatus() {
        return status;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }
   
    
}
