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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

@WebServlet(name = "campaignCreationService")
public class CampaignCreationService extends HttpServlet {

    private Connection connection = null;
    private ServletContext context = null;
    private PreparedStatement statement = null;

    @Override
    public void init() throws ServletException {
        context = getServletContext();
        connection = DBConnectionHandler.getInstance().getConnection();
        super.init();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {

            if (request.getParameter("name").isEmpty()) {
                response.sendRedirect(Constants.PATH + "/errorEmptyForm");
            } else {

                int owner_id = Integer.parseInt(request.getParameter("owner_id"));

                String query = Constants.INSERT_CAMPAIGN;
                statement = connection.prepareStatement(query);
                statement.setString(1, request.getParameter("name"));
                statement.setInt(2, 1);
                Timestamp timestamp = new Timestamp(System.currentTimeMillis());
                statement.setTimestamp(3, timestamp);
                statement.setTimestamp(4, null); // sistemare database
                statement.setTimestamp(5, null); //  sistemare database
                statement.setInt(6, owner_id);
                statement.executeUpdate();

                response.sendRedirect(Constants.PATH + "/campaignDetails?name=" + request.getParameter("name")); //redirect campaignDetails

            }

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {

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
