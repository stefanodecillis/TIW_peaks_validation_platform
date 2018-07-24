package controllers;

import Enum.*;
import Handler.CookieHandler;
import Handler.RedirectManager;
import Util.Tools;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ValidationController")
public class ValidationController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int campaign = Integer.parseInt(request.getParameter("campaign"));
        int user = CookieHandler.getInstance().checkCookieUser(request).getUser_id();
        int peakId = Integer.parseInt(request.getParameter("peakId"));
        Double elevation = Double.parseDouble(request.getParameter("elevation"));
        Double latitude = Double.parseDouble(request.getParameter("latitude"));
        Double longitude = Double.parseDouble(request.getParameter("longitude"));

        System.out.println("new validation");

        if(Tools.validPeak(AnnotationStatus.VALID.getId(),
                peakId,
                user,
                campaign,
                request.getParameter("peakName"),
                latitude,
                longitude,
                elevation,
                request.getParameter("localizedNames"))){
            System.out.println("completed validation");
        } else {
            System.out.println("%%% error somewhere %%%");
        }

        if(Integer.parseInt(request.getParameter("map"))==2 ){
            RedirectManager.getInstance().redirectToMap2d(response, campaign, Job.WORKER.getId());
            return;
        }else if (Integer.parseInt(request.getParameter("map"))==3 ) {
            RedirectManager.getInstance().redirectToMap3d(response, campaign, Job.WORKER.getId());
            return;
        } else {
            RedirectManager.getInstance().redirectToErrorLog(response);
            return;
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //nothing to do here
    }
}
