package controllers;

import Handler.DBConnectionHandler;
import Util.Constants;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
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
        String pswBase64 = Base64.getEncoder().encodeToString(psw.getBytes());
        try{
            statement = connection.prepareStatement(Constants.CHECK_USERS);
            rs = statement.executeQuery();
            while (rs.next()){
                if(rs.getString("email").equalsIgnoreCase(mail) || rs.getString("username").equalsIgnoreCase(username)){
                    //similar user found
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

        } catch (SQLException e){
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(Constants.PATH+"/register");
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
