package Service;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.Base64;
import Entities.AuthCookie;
import Handler.DBConnectionHandler;
import Util.Constants;
import com.google.gson.Gson;

@WebServlet(name = "LogService")
public class LogService extends HttpServlet {

    private Connection connection = null;
    private ServletContext context = null;

    @Override
    public void init() throws ServletException {
        context = getServletContext();
        connection = DBConnectionHandler.getInstance().getConnection();
        super.init();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mail = request.getParameter("mail");
        String psw = request.getParameter("psw");
        String pswBase96 = Base64.getEncoder().encodeToString(psw.getBytes()); //encode the psw
        PreparedStatement statement = null;
        ResultSet rs = null;
        System.out.println("...checking...");
        try {
            statement = connection.prepareStatement(Constants.CHECK_LOG);
            statement.setString(1, mail);
            statement.setString(2, pswBase96);
            rs = statement.executeQuery();
            //if rs is null/zero, then permission denied
            while(rs.next()){
                //something found
                System.out.println("found result!");
                String job = rs.getString("job");
                Integer user_id = rs.getInt("user_id");
                String username = rs.getString("username");
                if(job.equalsIgnoreCase("worker")){
                    this.attachCookie(response,user_id,username,pswBase96);
                    this.redirectToWorker(response);
                    System.out.println("--> worker page");
                    return;
                } else if (job.equalsIgnoreCase("manager")){
                    this.attachCookie(response,user_id,username,pswBase96);
                    this.redirectToManager(response);
                    System.out.println("--> manager page");
                    return;
                } else {
                    this.redirectToErrorPage(response);
                    return;
                }
            }
            System.out.println("No result \n --> error page");
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
        response.sendRedirect(Constants.PATH +"/homeManager");
    }

    private void redirectToWorker(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/homeWorker");
    }

    private void redirectToErrorPage(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/errorLogPage");
    }
    //TODO Redo the code here  --> cookieHandler
    private void attachCookie(HttpServletResponse response,Integer user_id, String user, String psw){

        System.out.println("...generating cookie...");
        AuthCookie authCookie = new AuthCookie(user_id, user,psw);

        //json data
        Gson gson = new Gson();
        String ret = gson.toJson(authCookie,AuthCookie.class);

        //encode cookie value
        String cryptRet = Base64.getEncoder().encodeToString(ret.getBytes());

        Cookie ck = new Cookie(Constants.COOKIE_USER,cryptRet);//creating cookie object
        ck.setMaxAge(60*60*24); //one day --> age should be expressed in seconds
        response.addCookie(ck);//adding cookie in the response
        System.out.println("cookie attached to response");
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
