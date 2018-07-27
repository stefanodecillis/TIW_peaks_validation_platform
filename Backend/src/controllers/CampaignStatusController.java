package controllers;

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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "CampaignStatusController")
public class CampaignStatusController extends HttpServlet {

    private Connection connection = null;
    private ServletContext context = null;
    private AuthCookie data = null;

    @Override
    public void init() throws ServletException {
        context = getServletContext();
        connection = DBConnectionHandler.getInstance().getConnection();
        super.init();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if(request.getParameter("status") == null || request.getParameter("status").equalsIgnoreCase("")
                || request.getParameter("campaign") == null || request.getParameter("campaign").equalsIgnoreCase("")){
            RedirectManager.getInstance().redirectGeneralError(response);
            return;
        }
        data = CookieHandler.getInstance().checkCookieUser(request);
        int nextStatus = Integer.parseInt(request.getParameter("status"));
        int campaign_id = Integer.parseInt(request.getParameter("campaign"));
        System.out.println("...user is changing status campaign in " + nextStatus + "...");
       if(nextStatus == 2){
           //check if there is data
           this.startCampaign(response,campaign_id);
           return;
       } else if (nextStatus == 3){
           //check if current status is 2
           this.closeCampaign(response,campaign_id);
           return;
       } else {
           this.redirectToErrorPage(response);
           return;
       }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //nothing to do here
    }

    private void startCampaign(HttpServletResponse response,int campaign_id) throws IOException {
        PreparedStatement statement = null;
        ResultSet rs = null;
        System.out.println("...starting campaign...");
        try {
            statement = connection.prepareStatement(Constants.CHECK_PEAKS_BY_CAMPAIGN);
            statement.setInt(1,campaign_id);
            rs = statement.executeQuery();
            boolean dataFound = false;
            //checking data
            while(rs.next()){
                dataFound = true; //found data
            }
            if(!dataFound){
                this.redirectToErrorPage(response);
                return;
            }
            System.out.println("..passed data criteria..");
            statement.close();
            rs.close();
            statement = connection.prepareStatement(Constants.UPDATE_STATUS_CAMPAIGN);
            statement.setInt(1, 2);
            statement.setInt(2,campaign_id);
            statement.executeUpdate();
            updateDate(campaign_id);
            System.out.println(">>CAMPAIGN STARTED SUCCESSFULLY<<");
            this.redirectToDetails(response,campaign_id);
        } catch (SQLException e) {
            e.printStackTrace();
            this.redirectToErrorPage(response);
        }
    }

    private void closeCampaign(HttpServletResponse response,int campaign_id) throws IOException {
        PreparedStatement statement = null;
        ResultSet rs = null;
        System.out.println("...closing campaign...");
        try {
            statement = connection.prepareStatement(Constants.CHECK_STATUS_CAMPAIGN);
            statement.setInt(1,campaign_id);
            rs = statement.executeQuery();
            int status = 0;
            while (rs.next()){
                status = rs.getInt("campaign_status_id");
            }
            if(status == 0){
                this.redirectToErrorPage(response);
                System.out.println(".. no campaign found ..");
                return;
            } else if (status != 2){
                this.redirectToErrorPage(response);
                System.out.println(" !! this campaign is not started !!");
                return;
            }
            statement.close();
            rs.close();
            statement = connection.prepareStatement(Constants.UPDATE_STATUS_CAMPAIGN);
            statement.setInt(1,3);
            statement.setInt(2,campaign_id);
            statement.executeUpdate();
            updateDate(campaign_id);
            System.out.println(">>CAMPAIGN CLOSED SUCCESSFULLY<<");
            this.redirectToDetails(response,campaign_id);
        } catch (SQLException e) {
            e.printStackTrace();
            this.redirectToErrorPage(response);
        }
    }


    private void redirectToDetails(HttpServletResponse response,int campaign_id) throws IOException {
        response.sendRedirect(Constants.PATH +"/campaigndetails?campaign="+campaign_id+"&user="+data.getUser_id());
        System.out.println("---> Campaign Details");
    }

    private void redirectToErrorPage(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/errorEmptyForm");
        System.out.println("---> ErrorPage");
    }

    private void updateDate(int campaign) {
        try {
            Connection connection = DBConnectionHandler.getInstance().getConnection();
            PreparedStatement statement = connection.prepareStatement(Constants.UPDATE_DATE_CAMPAIGN);
            statement.setInt(1,campaign);
            //update
            statement.execute();

            statement.close();
            connection.close();
        } catch (SQLException e){
            e.printStackTrace();
        }
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

}
