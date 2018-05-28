package controllers;

import Entities.AuthCookie;
import Handler.DBConnectionHandler;
import Util.Constants;
import com.google.gson.Gson;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;

@WebServlet(name = "RegisterService")
public class RegisterService extends HttpServlet {

    private Connection connection = null;
    private ServletContext context = null;

    @Override
    public void init() throws ServletException {
        context = getServletContext();
        connection = DBConnectionHandler.getInstance().getConnection();
        super.init();
    }

    //TODO check mail structure
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PreparedStatement statement = null;
        ResultSet rs = null;
        String username = request.getParameter("username");
        String mail = request.getParameter("mail");
        String psw = request.getParameter("psw");
        String psw_check = request.getParameter("psw-check");
        if(!checkParam(username,mail,psw,psw_check)){
            this.redirectToError(response);
            return;
        }
        int job_id = getJobId(request.getParameter("job"));
        if(job_id == 0){
            this.redirectToError(response);
            return;
        }
        System.out.println("...saving...");
        String pswBase64 = Base64.getEncoder().encodeToString(psw.getBytes());
        try{
            statement = connection.prepareStatement(Constants.CHECK_USERS);
            rs = statement.executeQuery();
            while (rs.next()){
                if(rs.getString("email").equalsIgnoreCase(mail) || rs.getString("username").equalsIgnoreCase(username)){
                    //similar user found
                    System.out.println("similar user found! \n --> error page");
                    this.redirectToError(response);
                    return;
                }
            }
            PreparedStatement statement2 = null;
            statement2 = connection.prepareStatement(Constants.INSERT_USER);
            statement2.setString(1,username);
            statement2.setString(2,pswBase64);
            statement2.setString(3,mail);
            statement2.setInt(4,job_id);
            statement2.executeUpdate();

            System.out.println("create user with username: " + username +
                                "   psw: " + pswBase64 +
                                "   mail: " + mail +
                                "   job_id: " + job_id);

            //if alg is fine, do this:
            if(!this.completeLogin(response, job_id,mail, pswBase64)){
                System.out.println("! complete login caught an error !");
                this.redirectToError(response);
            }

            return;
        } catch (SQLException e){
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(Constants.PATH+"/register");
    }


    private boolean completeLogin(HttpServletResponse response, Integer job_id, String mail, String psw) throws IOException, SQLException {

        PreparedStatement statement = this.connection.prepareStatement(Constants.CHECK_LOG);
        statement.setString(1, mail);
        statement.setString(2, psw);
        ResultSet rs = statement.executeQuery();
        Integer user_id = null;
        String username = null;

        while (rs.next()) {
            user_id = rs.getInt("user_id");
            username = rs.getString("username");
        }

        if(user_id == null || username == null) {
            return false;
        }

        this.attachCookie(response, user_id,username,psw);

        if(job_id == 1){
            this.redirectToWorker(response);
        } else if (job_id == 2){
            this.redirectToManager(response);
        }

        return true;
    }


    private int getJobId (String job){
        if (job.equalsIgnoreCase("worker")){
            return 1;
        } else if (job.equalsIgnoreCase("manager")){
            return 2;
        }
        return 0;
    }

    private void redirectToError(HttpServletResponse response) throws IOException{
        response.sendRedirect(Constants.PATH+"/errorReg");
    }

    private boolean checkParam(String username, String email, String psw, String psw_check){
        if(username == null || email == null || psw == null || psw_check == null){
            return false;
        }
        if(!psw.equals(psw_check)){
            return false;
        }
        return true;
    }

    //TODO recheck this code --> use unique service to gen cookies
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

    private void redirectToManager(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/homeManager");
        System.out.println("--> manager page");
    }

    private void redirectToWorker(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/homeWorker");
        System.out.println("--> worker page");
    }
}

