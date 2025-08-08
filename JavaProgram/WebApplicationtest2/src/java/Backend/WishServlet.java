/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Backend;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author helloWorld
 */
public class WishServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet WishServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet WishServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String error = null;
        ResultSet wishes = null;
        String editId = null;
        String editName = null;
        String editWish = null;
        
        // Database configuration (modify as needed)
        String url = "jdbc:mysql://localhost:3306/wishdb";
        String user = "root";
        String password = ""; // No password
        
        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish connection
            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                
                // Handle CRUD operations
                if ("insert".equals(action)) {
                    // Insert new wish
                    String name = request.getParameter("name");
                    String wish = request.getParameter("wish");
                    if (name != null && wish != null) {
                        try (PreparedStatement stmt = conn.prepareStatement(
                                "INSERT INTO wishes (kid_name, wish) VALUES (?, ?)")) {
                            stmt.setString(1, name);
                            stmt.setString(2, wish);
                            stmt.executeUpdate();
                        }
                    }
                } 
                else if ("delete".equals(action)) {
                    // Delete wish
                    String id = request.getParameter("id");
                    if (id != null) {
                        try (PreparedStatement stmt = conn.prepareStatement(
                                "DELETE FROM wishes WHERE id = ?")) {
                            stmt.setInt(1, Integer.parseInt(id));
                            stmt.executeUpdate();
                        }
                    }
                } 
                else if ("edit".equals(action)) {
                    // Get wish for editing
                    String id = request.getParameter("id");
                    if (id != null) {
                        try (PreparedStatement stmt = conn.prepareStatement(
                                "SELECT * FROM wishes WHERE id = ?")) {
                            stmt.setInt(1, Integer.parseInt(id));
                            try (ResultSet rs = stmt.executeQuery()) {
                                if (rs.next()) {
                                    editId = id;
                                    editName = rs.getString("kid_name");
                                    editWish = rs.getString("wish");
                                }
                            }
                        }
                    }
                } 
                else if ("update".equals(action)) {
                    // Update wish
                    String id = request.getParameter("id");
                    String name = request.getParameter("name");
                    String wish = request.getParameter("wish");
                    if (id != null && name != null && wish != null) {
                        try (PreparedStatement stmt = conn.prepareStatement(
                                "UPDATE wishes SET kid_name = ?, wish = ? WHERE id = ?")) {
                            stmt.setString(1, name);
                            stmt.setString(2, wish);
                            stmt.setInt(3, Integer.parseInt(id));
                            stmt.executeUpdate();
                        }
                    }
                }
                
                // Retrieve all wishes to display
                try (Statement stmt = conn.createStatement()) {
                    wishes = stmt.executeQuery("SELECT * FROM wishes");
                }
                
            } catch (SQLException e) {
                error = "Database error: " + e.getMessage();
            }
        } catch (ClassNotFoundException e) {
            error = "JDBC driver not found: " + e.getMessage();
        } catch (NumberFormatException e) {
            error = "Invalid ID format: " + e.getMessage();
        }
        
        // Set attributes for JSP
        request.setAttribute("wishes", wishes);
        request.setAttribute("error", error);
        request.setAttribute("editId", editId);
        request.setAttribute("editName", editName);
        request.setAttribute("editWish", editWish);
        
        // Forward to JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("wishlist.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
