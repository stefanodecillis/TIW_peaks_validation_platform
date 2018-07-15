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
        if(request.getParameter("validation") == null){
            RedirectManager.getInstance().redirectToErrorLog(response);
            return;
        }
        int status = Integer.parseInt(request.getParameter("validation"));
        AuthCookie userData = CookieHandler.getInstance().checkCookieUser(request);
        if(status == AnnotationStatus.INVALID.getId()){ //peakInvalid
            System.out.println("--------------invalid---------");
            if(Tools.validPeak(AnnotationStatus.INVALID.getId(),Integer.parseInt(request.getParameter("peakId")),
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
            RedirectManager.getInstance().redirectToMap2d(response,Integer.parseInt(request.getParameter("campaign")), Job.WORKER.getId());
            return;
        } else if (status == AnnotationStatus.VALID.getId()){
            System.out.println("--------------validation---------");
            //redirect to validation page
            request.getRequestDispatcher( "annotation").forward(request,response);
            return;
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //nothing to do here
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
