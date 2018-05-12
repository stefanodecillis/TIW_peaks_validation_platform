package controllers;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.Base64;

import Handler.DBConnectionHandler;
import Util.Constants;

@WebServlet(name = "LogService")
public class LogService extends HttpServlet {

    private Connection connection = null;
    private ServletContext context = null;

    @Override
    public void init() throws ServletException {
        context = getServletContext();
        DBConnectionHandler connectionHandler = new DBConnectionHandler();
        connection = connectionHandler.getConnection();
        super.init();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mail = request.getParameter("mail");
        String psw = request.getParameter("psw");
        String pswBase96 = Base64.getEncoder().encodeToString(psw.getBytes()); //encode the psw
        PreparedStatement statement = null;
        ResultSet rs = null;
        try {
            statement = connection.prepareStatement(Constants.CHECK_LOG);
            statement.setString(1, mail);
            statement.setString(2, pswBase96);
            rs = statement.executeQuery();
            //if rs is null/zero, then permission denied
            while(rs.next()){
                //something found
                String job = rs.getString("job");
                if(job.equalsIgnoreCase("worker")){
                    this.redirectToWorker(response);
                    return;
                } else if (job.equalsIgnoreCase("manager")){
                    this.redirectToManager(response);
                    return;
                } else {
                    this.redirectToErrorPage(response);
                    return;
                }
            }
            //nothing found
            this.redirectToErrorPage(response);
        } catch (SQLException e){
            e.printStackTrace();
        } finally {
            if(rs != null){
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if(statement != null){
                try {
                    statement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //nothing to do here -> we don't accept get request
    }

    private void redirectToManager(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/managerHomepage");  //need homepage
    }

    private void redirectToWorker(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/workerHomepage");  //need homepage
    }

    private void redirectToErrorPage(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/errorLog");
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
