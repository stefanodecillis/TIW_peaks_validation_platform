package Service;

import Entities.Annotation;
import Entities.Peak;
import Handler.DBConnectionHandler;
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
import java.util.HashMap;
import java.util.List;


@WebServlet(name = "StatService")
public class StatService extends HttpServlet {

    Connection connection = null;
    ServletContext context = null;

    @Override
    public void init() throws ServletException {
        context = getServletContext();
        connection = DBConnectionHandler.getInstance().getConnection();
        super.init();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //nothing to do here
    }


    /**
     * @API /stats-api?campaign=?&stat=X&depth=X&peak=?
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int stat = Integer.parseInt(request.getParameter("stat"));
        int campaign = Integer.parseInt(request.getParameter("campaign"));

        System.out.println("stats for campaign= " +campaign);
        System.out.println("type: " + stat);
        Gson gson = Tools.getGson();

        Writer writer = response.getWriter();
        response.setContentType("text/plain");
        if(stat == 1){
            int count = toBeAnnotatedCount(campaign);
            String rs = gson.toJson(count);
            writer.write(rs);
        } else if (stat == 2){
            int count = annotatedCount(campaign);
            String rs = gson.toJson(count);
            writer.write(rs);
        } else if (stat == 3){
            int count = rejecteddAnnotationCount(campaign);
            String rs = gson.toJson(count);
            writer.write(rs);
        } else if (stat == 4){
            int count = conflictCount(campaign);
            String rs = gson.toJson(count);
            writer.write(rs);
        } else if (stat == 5){
            int depth = Integer.parseInt(request.getParameter("depth"));
            if (depth == 1){
                List<Annotation> list = getAnnotationName(campaign);
                String rs = gson.toJson(list);
                writer.write(rs);
            } else if (depth == 2){
                Double peak = Double.parseDouble(request.getParameter("peak"));
                List<Annotation> list = getAnnotationList(campaign,peak);
                String rs = gson.toJson(list.toArray());
                System.out.println(rs);
                writer.write(rs);
            }
        } else if (stat == 6){
            int depth = Integer.parseInt(request.getParameter("depth"));
            if (depth == 1){
                List<Annotation> list = getRejectionList(campaign);
                String rs = gson.toJson(list);
                writer.write(rs);
            } else if (depth == 2){
                Double peak = Double.parseDouble(request.getParameter("peak"));
                List<Annotation> list = getRejectedAnnotationList(campaign,peak);
                String rs = gson.toJson(list);
                System.out.println(rs);
                writer.write(rs);
            }
        } else if (stat == 7){
            List<Peak> list = conflictList(campaign);
            String rs = gson.toJson(list);
            System.out.println(rs);
            writer.write(rs);
        }
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

    private int toBeAnnotatedCount(int campaign) {
        try {
            PreparedStatement statement = connection.prepareStatement(Constants.TOBEANNOTATEDCOUNT);
            statement.setInt(1,campaign);
            ResultSet rs = statement.executeQuery();
            int count = 0;
            while (rs.next()) {
                 count = rs.getInt("num");
            }
            rs.close();
            statement.close();
            return count;
        } catch (SQLException e){
            e.printStackTrace();
            return 0;
        }
    }

    private int annotatedCount(int campaign) {
        try {
            PreparedStatement statement = connection.prepareStatement(Constants.PEAKANNOTATEDCOUNT);
            statement.setInt(1,campaign);
            ResultSet rs = statement.executeQuery();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt("num");
            }
            rs.close();
            statement.close();
            return count;
        } catch (SQLException e){
            e.printStackTrace();
            return 0;
        }
    }

    private int rejecteddAnnotationCount(int campaign) {
        try {
            PreparedStatement statement = connection.prepareStatement(Constants.PEAKINVALIDANNOTATIONCOUNT);
            statement.setInt(1,campaign);
            ResultSet rs = statement.executeQuery();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt("num");
            }
            rs.close();
            statement.close();
            return count;
        } catch (SQLException e){
            e.printStackTrace();
            return 0;
        }
    }

    private int conflictCount(int campaign) {
        try {
            PreparedStatement statement = connection.prepareStatement(Constants.CONFLICTCOUNT);
            statement.setInt(1,campaign);
            statement.setInt(2,campaign);
            ResultSet rs = statement.executeQuery();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt("res");
            }
            rs.close();
            statement.close();
            return count;
        } catch (SQLException e){
            e.printStackTrace();
            return 0;
        }
    }

    private List<Annotation> getAnnotationName(int campaign) {
        try {
            PreparedStatement statement = connection.prepareStatement(Constants.ANNOTATIONPEAKNAME);
            statement.setInt(1,campaign);
            ResultSet rs = statement.executeQuery();
            List<Annotation> list = new ArrayList<>();
            while (rs.next()) {
                Annotation annotation = new Annotation();
                annotation.setPeakName(rs.getString("peak_name"));
                annotation.setPeakId(rs.getDouble("peak_id"));
                list.add(annotation);
            }
            rs.close();
            statement.close();
            return list;
        } catch (SQLException e){
            e.printStackTrace();
            return null;
        }
    }

    private List<Annotation> getAnnotationList(int campaign, Double peak){
        try {
            PreparedStatement statement = connection.prepareStatement(Constants.ANNOTATIONLIST);
            statement.setInt(1,campaign);
            statement.setDouble(2,peak);
            ResultSet rs = statement.executeQuery();
            List<Annotation> list = new ArrayList<>();
            while (rs.next()) {
                list.add(fillAnnotation(rs));
            }
            rs.close();
            statement.close();
            return list;
        } catch (SQLException e){
            e.printStackTrace();
            return null;
        }
    }

    private List<Annotation> getRejectionList(int campaign) {
        try {
            PreparedStatement statement = connection.prepareStatement(Constants.PEAKINVALIDLIST);
            statement.setInt(1,campaign);
            ResultSet rs = statement.executeQuery();
            List<Annotation> list = new ArrayList<>();
            while (rs.next()) {
                Annotation annotation = new Annotation();
                annotation.setPeakId(rs.getDouble("peak_id"));
                annotation.setPeakName(rs.getString("peak_name"));
                list.add(annotation);
            }
            rs.close();
            statement.close();
            return list;
        } catch (SQLException e){
            e.printStackTrace();
            return null;
        }
    }

    private List<Annotation> getRejectedAnnotationList(int campaign, Double peak){
        try {
            PreparedStatement statement = connection.prepareStatement(Constants.INVALIDANNOTATIONLIST);
            statement.setInt(1,campaign);
            statement.setDouble(2,peak);
            ResultSet rs = statement.executeQuery();
            List<Annotation> list = new ArrayList<>();
            while (rs.next()) {
                list.add(fillAnnotation(rs));
            }
            rs.close();
            statement.close();
            return list;
        } catch (SQLException e){
            e.printStackTrace();
            return null;
        }
    }

    private Annotation fillAnnotation(ResultSet rs) throws SQLException{
        Annotation annotation = new Annotation();
        annotation.setPeakId(rs.getDouble("peak_id"));
        annotation.setAnnotationId(rs.getInt("annotation_id"));
        annotation.setElevation(rs.getDouble("elevation"));
        annotation.setValidation(rs.getInt("validation"));
        annotation.setPeakName(rs.getString("peak_name"));
        annotation.setLocalizedName(rs.getString("localized_names"));
        annotation.setCampaignId(rs.getInt("campaign_id"));
        annotation.setUsername(rs.getString("username"));
        annotation.setLongitude(rs.getDouble("longitude"));
        annotation.setLatitude(rs.getDouble("latitude"));
        return annotation;
    }

    private List<Peak> conflictList(int campaign) {
        try {
            PreparedStatement statement = connection.prepareStatement(Constants.CONFLICTLIST);
            statement.setInt(1,campaign);
            statement.setInt(2,campaign);
            ResultSet rs = statement.executeQuery();
            List<Peak> peaks = new ArrayList<>();
            while (rs.next()) {
                Peak peak = new Peak();
                peak.setPeak_id(rs.getInt("peak_id"));
                peak.setName(rs.getString("peak_name"));
                peak.setNum_positive_annotations(rs.getInt("valid"));
                peak.setNum_negative_annotations(rs.getInt("invalid"));
                peaks.add(peak);
            }
            rs.close();
            statement.close();
            return peaks;
        } catch (SQLException e){
            e.printStackTrace();
            return null;
        }
    }
}
