package Handler;

import Util.Constants;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.io.IOException;

public class RedirectManager {
    private static RedirectManager ourInstance = null;

    public static RedirectManager getInstance() {
        if (ourInstance == null) {
            ourInstance = new RedirectManager();
        }
        return ourInstance;
    }


    /**
     * class used to redirect all the connections across the platform
     */
    private RedirectManager() {
    }

    /* all redirect */

    public void redirectLogPage(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH + "/login");
        System.out.println("--> log page");
        return;
    }

    public void redirectToManager(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH + "/homeManager");
        System.out.println("--> manager page");
    }

    public void redirectToAnnForm(HttpServletResponse response, int campaign, int peakId, int map, Double elevation, Double latitude, Double longitude) throws IOException {
        response.sendRedirect(Constants.PATH + "/annotation?campaign=" + campaign + "&peakId=" + peakId + "&map=" + map + "&elevation=" + elevation + "&latitude=" + latitude + "&longitude=" + longitude);
        System.out.println("--> annotation form");
    }

    public void redirectToWorker(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH + "/homeWorker");
        System.out.println("--> worker page");
    }

    public void redirectToErrorLog(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH + "/errorLogPage");
        System.out.println("--> error log page !!");
    }

    public void redirectToErrorReg(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH + "/errorReg");
        System.out.println("--> error reg page !!");
    }

    public void redirectToMap2d(HttpServletResponse response, int campaign, int job) throws IOException {
        response.sendRedirect(Constants.PATH + "/map2d?campaign=" + campaign + "&job=" + job);
        System.out.println("---> map2d page");
    }

    public void redirectToMap3d(HttpServletResponse response, int campaign, int job) throws IOException {
        response.sendRedirect(Constants.PATH + "/map3d?campaign=" + campaign + "&job=" + job);
        System.out.println("---> map3d page");
    }

    public void redirectHome(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH);
        System.out.println("-----> Home");
    }

    public void redirectGeneralError(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH+ "/generalerror");
        System.out.println("----> General ErrorPage");
    }

}
