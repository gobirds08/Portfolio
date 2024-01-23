/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package courseschedulerbrendankenneybsk5214;

/**
 *
 * @author brend
 */
public class StudentEntry {
    private final String studentID;
    private final String firstName;
    private final String lastName;

    public StudentEntry(String studentID, String firstName, String lastName) {
        this.studentID = studentID;
        this.firstName = firstName;
        this.lastName = lastName;
    }

    public String getStudentID() {
        return studentID;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }
    @Override
    public String toString(){
        return String.format("%s %s", getFirstName(),getLastName());
    }
    
    
}
