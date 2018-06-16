package controllers;

import Entities.AuthCookie;
import Handler.CookieHandler;
import Handler.DBConnectionHandler;
import Handler.RedirectManager;
import Util.Constants;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.Base64;

@WebServlet(name = "UserDetailsPasswordService")
public class UserDetailsPasswordService extends HttpServlet {

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
        AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
        if(!checkParams(request)){
            RedirectManager.getInstance().redirectToErrorLog(response);  //todo redirect to the right page
            return;
        }
        //todo need to review all the code
        try {
            System.out.println("...changing password...");
            String query = Constants.USER_DETAILS;
            statement = connection.prepareStatement(query);
            statement.setInt(1, data.getUser_id());
            rs = statement.executeQuery();
            String oldPsw = request.getParameter("oldPsw");
            String userPsw = null;
            while (rs.next()) {
                userPsw = rs.getString("psswd");
            }
            if(userPsw == null){
                RedirectManager.getInstance().redirectToErrorLog(response);  //todo redirect to the right page
                return;
            }
            String insertPswBase64 = Base64.getEncoder().encodeToString(oldPsw.getBytes());
            if (!userPsw.equalsIgnoreCase(insertPswBase64)) {
                //alert psw sbagliata
                response.sendRedirect(Constants.PATH + "/errorPsw");
            } else {
                String newPsw = request.getParameter("newPsw");

                query = Constants.UPDATE_USER_PASSWORD;
                statement = connection.prepareStatement(query);
                String newPswBase64 = Base64.getEncoder().encodeToString(newPsw.getBytes());
                statement.setString(1, newPswBase64);
                statement.setInt(2, data.getUser_id());
                statement.executeUpdate();
                System.out.println("<password changed>");
                response.sendRedirect(Constants.PATH + "/userDetails");
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

    private boolean checkParams(HttpServletRequest request){
        if(request.getParameter("oldPsw") == null || request.getParameter("oldPsw").equalsIgnoreCase("")
                || request.getParameter("newPsw") == null || request.getParameter("newPsw").equalsIgnoreCase("")
                ||request.getParameter("newPswConfirm") == null || request.getParameter("newPswConfirm").equalsIgnoreCase("")
                ||!(request.getParameter("newPsw").equalsIgnoreCase(request.getParameter("newPswConfirm")))){
            return false;
        }

        return true;
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
