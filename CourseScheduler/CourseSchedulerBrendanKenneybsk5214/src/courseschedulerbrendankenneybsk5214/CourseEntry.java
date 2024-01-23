/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package courseschedulerbrendankenneybsk5214;

/**
 *
 * @author brend
 */
public class CourseEntry {
    private final String semester;
    private final String courseID;
    private final String description;
    private final int seats;

    public CourseEntry(String semester, String courseID, String description, int seats) {
        this.semester = semester;
        this.courseID = courseID;
        this.description = description;
        this.seats = seats;
    }

    public String getSemester() {
        return semester;
    }

    public String getCourseID() {
        return courseID;
    }

    public String getDescription() {
        return description;
    }

    public int getSeats() {
        return seats;
    } 
    
}
