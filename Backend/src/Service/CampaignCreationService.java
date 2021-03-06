package Service;

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
                System.out.println("...creating campaign \"" + request.getParameter("name") + "\" from user: " + request.getParameter("owner_id"));
                int owner_id = Integer.parseInt(request.getParameter("owner_id"));

                String query = Constants.INSERT_CAMPAIGN;
                statement = connection.prepareStatement(query);
                statement.setString(1, request.getParameter("name"));
                statement.setInt(2,1); //set create campaign status
                statement.setInt(3, owner_id);
                statement.executeUpdate();
                System.out.println("--> campaign created <--");
                response.sendRedirect(Constants.PATH + "/homeManager");
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
