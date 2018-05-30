package controllers;

import Handler.CookieHandler;
import Util.Constants;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "LogoutController")
public class LogoutController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("..logging out..");
        if(!CookieHandler.getInstance().closeUserCookie(request, response)){
            System.out.println("  !!! ERROR LOG OUT  !!!  ");
            this.redirectToErrorPage(response);
            return;
        }
        this.redirectLogPage(response);
        return;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //do nothing
    }

    private void redirectLogPage(HttpServletResponse response) throws  IOException {
        response.sendRedirect( Constants.PATH + "/login");
        System.out.println("--> log page");
        return;
    }

    private void redirectToErrorPage(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/errorLogPage");
    }
}
