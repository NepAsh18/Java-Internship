<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
    <title>Kids Wishlist</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 80%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        form { margin: 10px 0; padding: 15px; background: #f9f9f9; border: 1px solid #ddd; }
        .actions a { margin-right: 10px; }
        .edit-form { background: #eef; padding: 15px; margin-top: 20px; }
        .error { color: red; }
    </style>
</head>
<body>
    <h1>Kids Wishlist Manager</h1>
    
    <%-- Display error message if any --%>
    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <!-- Add New Wish Form -->
    <form action="WishServlet" method="GET">
        <input type="hidden" name="action" value="insert">
        <label>Kid's Name: <input type="text" name="name" required></label>
        <label>Wish: <input type="text" name="wish" required></label>
        <input type="submit" value="Add Wish">
    </form>

    <!-- Display Wishes Table -->
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Wish</th>
            <th>Actions</th>
        </tr>
        <%
        ResultSet rs = (ResultSet) request.getAttribute("wishes");
        if (rs != null) {
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("kid_name");
                String wish = rs.getString("wish");
        %>
        <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= wish %></td>
            <td class="actions">
                <a href="WishServlet?action=edit&id=<%= id %>">Edit</a>
                <a href="WishServlet?action=delete&id=<%= id %>" 
                   onclick="return confirm('Are you sure?')">Delete</a>
            </td>
        </tr>
        <%
            }
        }
        %>
    </table>

    <!-- Edit Form (Displayed when editing) -->
    <%
    String editId = (String) request.getAttribute("editId");
    String editName = (String) request.getAttribute("editName");
    String editWish = (String) request.getAttribute("editWish");
    if (editId != null) {
    %>
    <div class="edit-form">
        <h2>Edit Wish</h2>
        <form action="WishServlet" method="GET">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= editId %>">
            <label>Kid's Name: <input type="text" name="name" value="<%= editName %>" required></label>
            <label>Wish: <input type="text" name="wish" value="<%= editWish %>" required></label>
            <input type="submit" value="Update">
            <a href="WishServlet">Cancel</a>
        </form>
    </div>
    <% } %>
</body>
</html>