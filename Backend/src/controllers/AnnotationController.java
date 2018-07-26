package controllers;

import Enum.*;
import Entities.AuthCookie;
import Handler.CookieHandler;
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
        if (request.getParameter("validation") == null) {
            RedirectManager.getInstance().redirectToErrorLog(response);
            return;
        }
        int status = Integer.parseInt(request.getParameter("validation"));
        AuthCookie userData = CookieHandler.getInstance().checkCookieUser(request);
        if (status == AnnotationStatus.INVALID.getId()) { //peakInvalid
            System.out.println("--------------invalid---------");
            if (Tools.validPeak(AnnotationStatus.INVALID.getId(), Integer.parseInt(request.getParameter("peakId")),
                    userData.getUser_id(),
                    Integer.parseInt(request.getParameter("campaign")),
                    request.getParameter("peakName"),
                    Double.parseDouble(request.getParameter("latitude")),
                    Double.parseDouble(request.getParameter("longitude")),
                    Double.parseDouble(request.getParameter("elevation")),
                    request.getParameter("localizaedNames")
            )) {
                System.out.println("---- inserted annotation ----");
            } else {
                System.out.println(" %%% error during insertion %%%");
            }

        } else if (status == 1) { //redirect to jsp
            RedirectManager.getInstance().redirectToAnnForm(response,
                    Integer.parseInt(request.getParameter("campaign")),
                    Integer.parseInt(request.getParameter("peakId")),
                    Integer.parseInt(request.getParameter("map")),
                    Double.parseDouble(request.getParameter("elevation")),
                    Double.parseDouble(request.getParameter("latitude")),
                    Double.parseDouble(request.getParameter("longitude")));
            return;

        } else if (status == AnnotationStatus.VALID.getId()) { //request from annotation page
            System.out.println("--------------validation---------");

            int campaign = Integer.parseInt(request.getParameter("campaign"));
            int user = CookieHandler.getInstance().checkCookieUser(request).getUser_id();
            int peakId = Integer.parseInt(request.getParameter("peakId"));
            Double elevation = Double.parseDouble(request.getParameter("elevation"));
            Double latitude = Double.parseDouble(request.getParameter("latitude"));
            Double longitude = Double.parseDouble(request.getParameter("longitude"));

            System.out.println("new validation");

            if (Tools.validPeak(AnnotationStatus.VALID.getId(),
                    peakId,
                    user,
                    campaign,
                    request.getParameter("peakName"),
                    latitude,
                    longitude,
                    elevation,
                    request.getParameter("localizedNames"))) {
                System.out.println("completed validation");
            } else {
                System.out.println("%%% error somewhere %%%");
            }
        } else {
            RedirectManager.getInstance().redirectGeneralError(response);
            return;
        }
        //redirect to respective maps
        if (Integer.parseInt(request.getParameter("map")) == 2) {
            RedirectManager.getInstance().redirectToMap2d(response, Integer.parseInt(request.getParameter("campaign")), Job.WORKER.getId());
            return;
        } else if (Integer.parseInt(request.getParameter("map")) == 3) {
            RedirectManager.getInstance().redirectToMap3d(response, Integer.parseInt(request.getParameter("campaign")), Job.WORKER.getId());
            return;
        } else {
            RedirectManager.getInstance().redirectToErrorLog(response);
            return;
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doPost(request,response);
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