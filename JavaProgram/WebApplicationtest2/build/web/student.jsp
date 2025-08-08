<%@ page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // DB config
    String url = "jdbc:mysql://localhost:3306/wishdb";
    String username = "root";  // change as per your config
    String password = "";      // change as per your config

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(url, username, password);

    // Handle Save (Add new student)
    if (request.getParameter("action") != null && request.getParameter("action").equals("save")) {
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String studentClass = request.getParameter("student_class");
        String subject = request.getParameter("subject");
        PreparedStatement ps = con.prepareStatement("INSERT INTO students (name,address,student_class,subject) VALUES (?,?,?,?)");
        ps.setString(1, name);
        ps.setString(2, address);
        ps.setString(3, studentClass);
        ps.setString(4, subject);
        ps.executeUpdate();
        ps.close();
        response.sendRedirect("student.jsp"); // Refresh after post
        return;
    }

    // Handle Delete
    if (request.getParameter("action") != null && request.getParameter("action").equals("delete")) {
        int id = Integer.parseInt(request.getParameter("id"));
        PreparedStatement ps = con.prepareStatement("DELETE FROM students WHERE id=?");
        ps.setInt(1, id);
        ps.executeUpdate();
        ps.close();
        response.sendRedirect("student.jsp"); // Refresh
        return;
    }

    // Handle Update
    if (request.getParameter("action") != null && request.getParameter("action").equals("update")) {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String studentClass = request.getParameter("student_class");
        String subject = request.getParameter("subject");
        PreparedStatement ps = con.prepareStatement("UPDATE students SET name=?, address=?, student_class=?, subject=? WHERE id=?");
        ps.setString(1, name);
        ps.setString(2, address);
        ps.setString(3, studentClass);
        ps.setString(4, subject);
        ps.setInt(5, id);
        ps.executeUpdate();
        ps.close();
        response.sendRedirect("student.jsp");
        return;
    }

    // Fetch all students
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM students");

    // Subjects options for each class (you can extend this map)
    Map<String, String[]> subjectsMap = new HashMap<>();
    subjectsMap.put("Class 1", new String[]{"Math", "Science", "English"});
    subjectsMap.put("Class 2", new String[]{"Biology", "Physics", "Chemistry"});
    subjectsMap.put("Class 3", new String[]{"History", "Geography", "Economics"});

%>

<!DOCTYPE html>
<html>
<head>
    <title>Student Form</title>
    <!-- Bootstrap CSS for styling and modal -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
    <script>
        // JS for dependent dropdown
        const subjectsMap = {
            "Class 1": ["Math", "Science", "English"],
            "Class 2": ["Biology", "Physics", "Chemistry"],
            "Class 3": ["History", "Geography", "Economics"]
        };

        function updateSubjects(dropdownClassId, dropdownSubjectId) {
            const classSelect = document.getElementById(dropdownClassId);
            const subjectSelect = document.getElementById(dropdownSubjectId);
            const selectedClass = classSelect.value;

            // Clear old options
            subjectSelect.innerHTML = "";

            if (subjectsMap[selectedClass]) {
                subjectsMap[selectedClass].forEach(function(sub) {
                    const option = document.createElement("option");
                    option.value = sub;
                    option.text = sub;
                    subjectSelect.appendChild(option);
                });
            }
        }

        // For edit modal populate
        function openEditModal(id, name, address, studentClass, subject) {
            document.getElementById("editId").value = id;
            document.getElementById("editName").value = name;
            document.getElementById("editAddress").value = address;
            document.getElementById("editStudentClass").value = studentClass;
            updateSubjects('editStudentClass', 'editSubject');
            document.getElementById("editSubject").value = subject;

            // Show modal
            $('#editModal').modal('show');
        }

        // Update subjects in edit modal when class changes
        document.addEventListener("DOMContentLoaded", function(){
            document.getElementById('editStudentClass').addEventListener('change', function() {
                updateSubjects('editStudentClass', 'editSubject');
            });
        });
    </script>

</head>
<body class="container mt-5">
    <h2>Student Registration Form</h2>
    <form method="post" action="student.jsp?action=save" onsubmit="return validateForm()">
        <div class="form-group">
            <label>Student Name</label>
            <input name="name" id="name" class="form-control" required>
        </div>
        <div class="form-group">
            <label>Student Address</label>
            <textarea name="address" id="address" class="form-control" required></textarea>
        </div>
        <div class="form-group">
            <label>Student Class</label>
            <select name="student_class" id="studentClass" class="form-control" onchange="updateSubjects('studentClass', 'subject')" required>
                <option value="">--Select Class--</option>
                <option value="Class 1">Class 1</option>
                <option value="Class 2">Class 2</option>
                <option value="Class 3">Class 3</option>
            </select>
        </div>
        <div class="form-group">
            <label>Subjects</label>
            <select name="subject" id="subject" class="form-control" required>
                <option value="">--Select Subject--</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Save</button>
    </form>

    <hr>

    <h3>Students List</h3>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th><th>Name</th><th>Address</th><th>Class</th><th>Subject</th><th>Action</th>
            </tr>
        </thead>
        <tbody>
            <% 
            while (rs.next()) { 
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String address = rs.getString("address");
                String studentClass = rs.getString("student_class");
                String subject = rs.getString("subject");
            %>
            <tr>
                <td><%= id %></td>
                <td><%= name %></td>
                <td><%= address %></td>
                <td><%= studentClass %></td>
                <td><%= subject %></td>
                <td>
                    <button class="btn btn-sm btn-info" 
                        onclick="openEditModal('<%=id%>', '<%=name.replace("'", "\\'")%>', '<%=address.replace("'", "\\'")%>', '<%=studentClass%>', '<%=subject%>')">Edit</button>
                    <a href="student.jsp?action=delete&id=<%=id%>" onclick="return confirm('Delete this record?');" class="btn btn-sm btn-danger">Delete</a>
                </td>
            </tr>
            <% } 
            rs.close();
            stmt.close();
            con.close();
            %>
        </tbody>
    </table>

    <!-- Edit Modal -->
    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <form method="post" action="student.jsp?action=update">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="editModalLabel">Edit Student</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="$('#editModal').modal('hide')">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
              <input type="hidden" name="id" id="editId" />
              <div class="form-group">
                  <label>Name</label>
                  <input name="name" id="editName" class="form-control" required />
              </div>
              <div class="form-group">
                  <label>Address</label>
                  <textarea name="address" id="editAddress" class="form-control" required></textarea>
              </div>
              <div class="form-group">
                  <label>Student Class</label>
                  <select name="student_class" id="editStudentClass" class="form-control" required>
                      <option value="">--Select Class--</option>
                      <option value="Class 1">Class 1</option>
                      <option value="Class 2">Class 2</option>
                      <option value="Class 3">Class 3</option>
                  </select>
              </div>
              <div class="form-group">
                  <label>Subjects</label>
                  <select name="subject" id="editSubject" class="form-control" required>
                      <option value="">--Select Subject--</option>
                  </select>
              </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="$('#editModal').modal('hide')">Close</button>
            <button type="submit" class="btn btn-primary">Update</button>
          </div>
        </div>
        </form>
      </div>
    </div>

    <!-- Bootstrap + jQuery scripts -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
