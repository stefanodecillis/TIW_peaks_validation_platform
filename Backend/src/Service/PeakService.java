package Service;

import Entities.AuthCookie;
import Entities.Peak;
import Enum.Job;
import Handler.CookieHandler;
import Handler.DBConnectionHandler;
import Handler.RedirectManager;
import Util.Constants;
import Util.Tools;
import com.google.gson.Gson;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Writer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


@WebServlet(name = "PeakService")
public class PeakService extends HttpServlet {

    private ServletContext context = null;
    private Connection connection = null;


    @Override
    public void init() throws ServletException {
        context = getServletContext();
        connection = DBConnectionHandler.getInstance().getConnection();
        super.init();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //
    }

    /**
     * @path=/campaign/getpeaks?campaign=?&job=?
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
        if (request.getParameter("campaign") == null || request.getParameter("campaign").equalsIgnoreCase("")) {
            RedirectManager.getInstance().redirectToErrorLog(response); //TODO create the right page
        }
        int campaign_id = Integer.parseInt(request.getParameter("campaign"));
        String res = null;
        if (Integer.parseInt(request.getParameter("job")) == Job.WORKER.getId()) {

            try {
                System.out.println("...retrieving peaks data...");

                String query = Constants.WORKER_PEAK_STILL_VALIDABLE;
                PreparedStatement statement = connection.prepareStatement(query);
                statement.setInt(1, campaign_id);
                statement.setInt(2, data.getUser_id());
                statement.setInt(3, campaign_id);
                ResultSet rs = statement.executeQuery();

                List<Peak> peaks = new ArrayList<>();

                while (rs.next()) {
                    Peak peak = new Peak();
                    peak.setPeak_id(rs.getInt("peak_id"));
                    peak.setName(rs.getString("peak_name"));
                    peak.setElevation(rs.getDouble("elevation"));
                    peak.setLongitude(rs.getDouble("longitude"));
                    peak.setLatitude(rs.getDouble("latitude"));
                    peak.setProvenance(rs.getString("provenance"));
                    peak.setValidation_status_id(rs.getInt("validation_status_id"));

                    //TODO need to do this prob --> peak.setLocalized_name(rs.getString("localized_names"));
                    peaks.add(peak);
                }

                if (peaks.isEmpty()) {
                    res = "error. No peaks";
                } else {
                    Gson gson = Tools.getGson();
                    res = gson.toJson(peaks);
                    Writer out = response.getWriter();
                    //response.setContentType("application/json");
                    //response.setCharacterEncoding("UTF-8");
                    response.setContentType("text/plain");
                    response.setCharacterEncoding("UTF-8");
                    System.out.println(res);
                    out.write(res);
                }

            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else if (Integer.parseInt(request.getParameter("job")) == Job.MANAGER.getId()) {
            try {
                System.out.println("...retrieving peaks data...");

                String query = Constants.CHECK_PEAKS_BY_CAMPAIGN;
                PreparedStatement statement = connection.prepareStatement(query);
                statement.setInt(1, campaign_id);
                ResultSet rs = statement.executeQuery();

                List<Peak> peaks = new ArrayList<>();

                while (rs.next()) {
                    Peak peak = new Peak();
                    peak.setPeak_id(rs.getInt("peak_id"));
                    peak.setName(rs.getString("peak_name"));
                    peak.setElevation(rs.getDouble("elevation"));
                    peak.setLongitude(rs.getDouble("longitude"));
                    peak.setLatitude(rs.getDouble("latitude"));
                    peak.setProvenance(rs.getString("provenance"));
                    peak.setValidation_status_id(rs.getInt("validation_status_id"));
                    peak.setNum_negative_annotations(rs.getInt("neg_annotations"));
                    peak.setNum_positive_annotations(rs.getInt("pos_annotations"));

                    //TODO need to do this prob --> peak.setLocalized_name(rs.getString("localized_names"));
                    peaks.add(peak);
                }

                if (peaks.isEmpty()) {
                    res = "error. No peaks";
                } else {
                    Gson gson = Tools.getGson();
                    res = gson.toJson(peaks);
                    Writer out = response.getWriter();
                    //response.setContentType("application/json");
                    //response.setCharacterEncoding("UTF-8");
                    response.setContentType("text/plain");
                    response.setCharacterEncoding("UTF-8");
                    System.out.println(res);
                    out.write(res);
                }

            } catch (SQLException e) {
                e.printStackTrace();
            }

        } else {
            RedirectManager.getInstance().redirectToErrorLog(response); //TODO create the right page
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }


    }
}