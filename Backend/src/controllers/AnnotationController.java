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
import java.sql.SQLException;
import java.sql.Types;

@WebServlet(name = "AnnotationController")
public class AnnotationController extends HttpServlet {

    private ServletContext context = null;
    private Connection connection = null;

    @Override
    public void init() throws ServletException {
        context = getServletContext();
        connection = DBConnectionHandler.getInstance().getConnection();
        super.init();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if(request.getParameter("validation") == null){
            RedirectManager.getInstance().redirectToErrorLog(response);
            return;
        }
        int status = Integer.parseInt(request.getParameter("validation"));
        AuthCookie userData = CookieHandler.getInstance().checkCookieUser(request);
        if(status == 0){ //peakInvalid
            System.out.println("--------------invalid---------");
            if(invalidPeak(Integer.parseInt(request.getParameter("peakId")),
                    userData.getUser_id(),
                    Integer.parseInt(request.getParameter("campaign")),
                    request.getParameter("peakName"),
                    Double.parseDouble(request.getParameter("latitude")),
                    Double.parseDouble(request.getParameter("longitude")),
                    Double.parseDouble(request.getParameter("elevation")),
                    request.getParameter("localizaedNames")
                    )){
                System.out.println("---- inserted annotation ----");
            } else {
                System.out.println(" %%% error during insertion %%%");
            }
            RedirectManager.getInstance().redirectToMap2d(response,Integer.parseInt(request.getParameter("campaign")), 1);
            return;
        } else if (status == 1){
            System.out.println("--------------validation---------");
            //redirect to validation page
            request.getRequestDispatcher( "annotation").forward(request,response);
            return;
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //nothing to do here
    }

    private boolean invalidPeak(int peakId, int userId, int campaignId,String peakName, Double latitude,Double longitude, Double elevation, String localizedNames) {
            checkData(peakId,userId,campaignId);
        try {
            PreparedStatement statement = connection.prepareStatement(Constants.INSERT_ANNOTATION);
            statement.setInt(1, 0);
            statement.setInt(2,peakId);
            statement.setInt(5,campaignId);
            if(peakName == null){
                statement.setNull(3, Types.VARCHAR);
            } else {
                statement.setString(3,peakName);
            }
            statement.setInt(4,userId);
            if(latitude == null){
                statement.setNull(6, Types.DOUBLE);
            } else {
                statement.setDouble(6,latitude);
            }
            if(longitude == null){
                statement.setNull(7, Types.DOUBLE);
            } else {
                statement.setDouble(7,longitude);
            }
            if(elevation == null){
                statement.setNull(8, Types.DOUBLE);
            } else {
                statement.setDouble(8,elevation);
            }
            if(localizedNames == null){
                statement.setNull(9, Types.VARCHAR);
            } else {
                statement.setString(9,localizedNames);
            }

            statement.execute();
            statement.close();

            return true;
        } catch (SQLException e){
            e.printStackTrace();
            return false;
        }
    }

    private boolean checkData(Integer peakId, Integer userId, Integer campaignId){
        if (peakId == null || userId == null || campaignId == null){
            return false;
        }
        return true;
    }

    @Override
    public void destroy() {
        try {
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        super.destroy();
    }
}
