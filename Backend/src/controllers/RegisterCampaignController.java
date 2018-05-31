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

@WebServlet(name = "RegisterCampaignController")
public class RegisterCampaignController extends HttpServlet {

    private Connection connection = null;
    private ServletContext context = null;

    @Override
    public void init() throws ServletException {
        context = getServletContext();
        connection = DBConnectionHandler.getInstance().getConnection();
        super.init();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int campaign_id = Integer.parseInt(request.getParameter("campaign"));
        int worker_id = Integer.parseInt(request.getParameter("user"));
        System.out.println("...request to subscribe from worker: " + worker_id + " to campaign id: " +campaign_id);
        try {
            PreparedStatement statement = connection.prepareStatement(Constants.CHECK_SUBSCRIPTION);
            statement.setInt(1,worker_id);
            statement.setInt(2,campaign_id);
            ResultSet rs = statement.executeQuery();
            System.out.println("...checking...");
            while(rs.next()){
                //there is data. Aborting
                System.out.println("!!there is some data here. Aborting!!");
                //TODO redirect to errorPage. There is a subscription yet
                return;
            }
            //it's ok to continue
            statement.close();
            rs.close();
            System.out.println("inserting the subscribe");
            statement = connection.prepareStatement(Constants.INSERT_SUBSCRIBE);
            statement.setInt(1,worker_id);
            statement.setInt(2,campaign_id);
            statement.executeUpdate();
            System.out.println("---> subscribe with success <---");
            statement.close();
            this.redirectToWorker(response);
            return;
        } catch (SQLException e) {
            e.printStackTrace();

            //TODO Redirect to errorPage (internal error)
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }


    @Override
    public void destroy() {

        if(connection != null){
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        super.destroy();
    }

    private void redirectToWorker(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/homeWorker");
        System.out.println("--> worker page");
    }
}
