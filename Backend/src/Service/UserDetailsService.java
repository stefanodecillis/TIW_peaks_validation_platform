package Service;

import Entities.AuthCookie;
import Handler.CookieHandler;
import Handler.DBConnectionHandler;
import Handler.RedirectManager;
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
        AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
        if(!checkParams(request)){
            RedirectManager.getInstance().redirectGeneralError(response);
            return;
        }
        try {
            String query = Constants.USER_DETAILS;
            statement = connection.prepareStatement(query);
            statement.setInt(1, data.getUser_id());
            rs = statement.executeQuery();
            String insertPsw = request.getParameter("psw");
            String userPsw = null;
            while (rs.next()) {
                userPsw = rs.getString("psswd");
            }
            if(userPsw == null){
                RedirectManager.getInstance().redirectGeneralError(response);
                return;
            }
            String insertPswBase96 = Base64.getEncoder().encodeToString(insertPsw.getBytes());
            if (!userPsw.equalsIgnoreCase(insertPswBase96)) {
                //alert psw sbagliata
                response.sendRedirect(Constants.PATH + "/errorPsw");
            } else {
                String username = request.getParameter("username");
                String mail = request.getParameter("mail");

                if (!(request.getParameter("username").equalsIgnoreCase("")|| request.getParameter("username") == null)) {
                    //update username
                    query = Constants.UPDATE_USER_USERNAME;
                    PreparedStatement updateStatement = connection.prepareStatement(query);
                    updateStatement.setString(1, username);
                    updateStatement.setInt(2, data.getUser_id());
                    updateStatement.executeUpdate();
                    response.sendRedirect(Constants.PATH + "/userDetails");
                    System.out.println("<username updated>");
                    updateStatement.close();
                }
                if (!(request.getParameter("mail").equalsIgnoreCase("")|| request.getParameter("mail") == null)) {
                    //update mail
                    query = Constants.UPDATE_USER_EMAIL;
                    PreparedStatement updateStatement = connection.prepareStatement(query);
                    updateStatement.setString(1, mail);
                    updateStatement.setInt(2, data.getUser_id());
                    updateStatement.executeUpdate();
                    response.sendRedirect(Constants.PATH + "/userDetails");
                    System.out.println("<mail updated>");
                    updateStatement.close();
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

    private boolean checkParams(HttpServletRequest request){
        if(((request.getParameter("username").equalsIgnoreCase("")|| request.getParameter("username") == null)
                && (request.getParameter("mail").equalsIgnoreCase("")|| request.getParameter("mail") == null)) ||
                request.getParameter("psw") == null || request.getParameter("psw").equalsIgnoreCase("")){
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
