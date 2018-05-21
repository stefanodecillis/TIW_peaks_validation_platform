package controllers;

import Handler.DBConnectionHandler;
import Util.Constants;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.Base64;

@WebServlet(name = "UserDetailsService")
public class UserDetailsService extends HttpServlet {

    private Connection connection = null;
    private ServletContext context = null;
    private PreparedStatement statement = null;
    private ResultSet rs = null;


    @Override
    public void init() throws ServletException {
        context = getServletContext();
        connection = DBConnectionHandler.getInstance().getConnection();
        super.init();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            String query = Constants.USER_DETAILS;
            statement = connection.prepareStatement(query);
            statement.setInt(1, Constants.WORKER_TEST_USER_ID);
            rs = statement.executeQuery();
            String insertPsw = request.getParameter("psw");
            String userPsw = null;
            if (rs.next()) {
                userPsw = rs.getString("psswd");
            }
            String insertPswBase96 = Base64.getEncoder().encodeToString(insertPsw.getBytes());
            if (!userPsw.equals(insertPswBase96)) {
                //alert psw sbagliata
                response.sendRedirect(Constants.PATH + "/errorPsw");
            } else {
                String username = request.getParameter("username");
                String mail = request.getParameter("mail");

                if (!username.isEmpty() && !mail.isEmpty()) {
                    //update both
                    query = Constants.UPDATE_USER_DETAILS;
                    statement = connection.prepareStatement(query);
                    statement.setString(1, username);
                    statement.setString(2, mail);
                    statement.setInt(3, Constants.WORKER_TEST_USER_ID);
                    statement.executeUpdate();
                    response.sendRedirect(Constants.PATH + "/userDetails");
                } else if (!username.isEmpty() && mail.isEmpty()) {
                    //update username
                    query = Constants.UPDATE_USER_USERNAME;
                    statement = connection.prepareStatement(query);
                    statement.setString(1, username);
                    statement.setInt(2, Constants.WORKER_TEST_USER_ID);
                    statement.executeUpdate();
                    response.sendRedirect(Constants.PATH + "/userDetails");
                } else if (username.isEmpty() && !mail.isEmpty()) {
                    //update mail
                    query = Constants.UPDATE_USER_EMAIL;
                    statement = connection.prepareStatement(query);
                    statement.setString(1, mail);
                    statement.setInt(2, Constants.WORKER_TEST_USER_ID);
                    statement.executeUpdate();
                    response.sendRedirect(Constants.PATH + "/userDetails");
                } else {
                    //alert form empty
                    response.sendRedirect(Constants.PATH + "/errorEmptyForm");
                }

            }

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (statement != null) {
                try {
                    statement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    public void destroy() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        super.destroy();
    }
}