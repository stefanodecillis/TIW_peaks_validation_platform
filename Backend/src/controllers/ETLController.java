package controllers;

import Entities.Peak;
import Handler.DBConnectionHandler;
import Handler.RedirectManager;
import Util.Constants;
import Util.Tools;
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

@WebServlet(name = "ETLController")
public class ETLController extends HttpServlet {

    private ServletContext context = null;
    private Connection connection = null;

    @Override
    public void init() throws ServletException {
        context = getServletContext();
        connection = DBConnectionHandler.getInstance().getConnection();
        super.init();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Peak[] peaks = null;
        System.out.println("...running etl...");
        if(request.getParameter("campaign") == null || request.getParameter("campaign").equalsIgnoreCase("")){
            RedirectManager.getInstance().redirectToErrorLog(response); //TODO Redirect to the right page
            return;
        }
        if(request.getAttribute(Constants.OBJECT_PEAKLIST) != null){
            peaks  = (Peak[]) request.getAttribute(Constants.OBJECT_PEAKLIST);
        } else {
            RedirectManager.getInstance().redirectToErrorLog(response); //TODO Redirect to the right page
            return;
        }
        System.out.println("...parsing peaks data...");
        try {
            int index = 1;
            System.out.println("#peaks to process: " + peaks.length);
            PreparedStatement statement = null;
            for (Peak peak : peaks){
                if(Tools.IsDivisble(index,5000)){
                    connection.close();
                    connection = DBConnectionHandler.getInstance().getConnection();
                }
                 statement = connection.prepareStatement(Constants.INSERT_PEAK);
                if(Tools.checkPeakData(peak)){
                    System.out.println("<Peak n°"+index+ " succeed>");
                    statement.setString(1,peak.getProvenance());
                    statement.setDouble(2,peak.getElevation());
                    statement.setDouble(3,peak.getLongitude());
                    statement.setDouble(4,peak.getLatitude());
                    statement.setString(5,peak.getName());
                    if(peak.getLocalized_name() == null) {
                        String localizedNames = Tools.getGson().toJson(peak.getLocalized_name(),String[][].class);
                        statement.setString(6, localizedNames);
                    } else {
                        statement.setNull(6, Types.VARCHAR);
                    }
                    statement.setInt(7, 5); //Integer.parseInt(request.getParameter("campaign"))
                    statement.executeUpdate();
                    System.out.println("Inserted");
                } else {
                    System.out.println("<Peak n°"+index+ " aborted>");
                }
                statement.close();
                index++;
            }
        } catch (SQLException e) {
            e.printStackTrace();
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
}
