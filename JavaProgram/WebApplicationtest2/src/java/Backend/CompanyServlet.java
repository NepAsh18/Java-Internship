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
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author helloWorld
 */
public class CompanyServlet extends HttpServlet {

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
            out.println("<title>Servlet CompanyServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CompanyServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
         response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {

            try {
                // Get form data
                String name = request.getParameter("name");
                String startTime = request.getParameter("start_time");
                String endTime = request.getParameter("end_time");

                // JDBC connection info
                String dbURL = "jdbc:mysql://localhost:3306/office";
                String dbUser = "root"; // change to your DB user
                String dbPass = "";     // change to your DB password

                // Load MySQL driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Connect to DB
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                // Insert data
                String sql = "INSERT INTO company (name, start_time, end_time) VALUES (?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, startTime);
                stmt.setString(3, endTime);

                int rows = stmt.executeUpdate();

                if (rows > 0) {
                    out.println("<h3>Company details added successfully!</h3>");
                } else {
                    out.println("<h3>Failed to add company details.</h3>");
                }

                // Close resources
                stmt.close();
                conn.close();

            } catch (Exception e) {
                out.println("<h3>Error: " + e.getMessage() + "</h3>");
                e.printStackTrace(out);
            }

        }
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
