import Entities.AuthCookie;
import Handler.CookieHandler;
import Handler.DBConnectionHandler;
import Util.Constants;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;


public class PeakPlatform extends javax.servlet.http.HttpServlet {

    private ServletContext context = null;
    private Connection connection = null;

    @Override
    public void init() throws ServletException {
        context = getServletContext();
        connection = DBConnectionHandler.getInstance().getConnection();
        super.init();
    }

    protected void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        //do nothing -> we cannot afford post request from here
    }

    protected void doGet(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
        if(data == null){
            this.redirectLogPage(response);
            return;
        }
        String query = Constants.CHECK_COOKIE;
        ResultSet rs = null;
        PreparedStatement statement = null;
        try {
            statement = connection.prepareStatement(query);
            statement.setInt(1, data.getUser_id());
            System.out.println("user_id: " + data.getUser_id() +" trying to log in..");
            rs = statement.executeQuery();
            String user = null;
            String psw = null;
            String job_des = null;
            int userId = -1;
            while(rs.next()){
                user = rs.getString("username");
                psw = rs.getString("psw");
                job_des = rs.getString("job");
                userId = rs.getInt("userId");
            }
            if(userId != data.getUser_id()){
                System.out.println("wrong auth!");
                this.redirectLogPage(response);
                return;  //redirect to login
            }
            //authenticated
            System.out.println("<Authenticated>");
            if(job_des.equalsIgnoreCase("worker")){
                this.redirectToWorker(response);
                return;
            } else if (job_des.equalsIgnoreCase("manager")){
                //redirect to manager homepage with credential in request
                this.redirectToManager(response);
                return;
            } else {
                //redirect to login jsp
                this.redirectLogPage(response);
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("caught error \n --> log page");
            this.redirectLogPage(response);
        } finally {
            try {
                rs.close();
                statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }


    @Override
    public void destroy() {
        try {
            if (connection != null){
                connection.close();
            }
        } catch (Exception e){
            System.out.println(e.getMessage());
        }
        super.destroy();
    }


    private void redirectLogPage(HttpServletResponse response) throws  IOException {
        response.sendRedirect( Constants.PATH + "/login");
        System.out.println("--> log page");
        return;
    }

    private void redirectToManager(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/homeManager");
        System.out.println("--> manager page");
    }

    private void redirectToWorker(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/homeWorker");
        System.out.println("--> worker page");
    }
}
