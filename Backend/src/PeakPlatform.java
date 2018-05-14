import Entities.AuthCookie;
import Handler.DBConnectionHandler;
import Handler.GsonSingleton;
import Util.Constants;
import com.google.gson.Gson;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.UnavailableException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.Base64;


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
        Cookie[] cookies = request.getCookies(); //check for cookies
        boolean cookieFound = false;
        if(cookies == null) {
            //redirect to login jsp
            System.out.println("Hi, you have no cookies!");
            this.redirectLogPage(response);
            return;
        } else {
            //we logged yet and depending on which cookies do we have, we redirect to manager or worker home
            for(Cookie cookie : cookies){
                if (cookie.getName() == "cookie-job"){
                    cookieFound = true;
                    byte[] baseValue = Base64.getDecoder().decode(cookie.getValue()); //decode data from cookie
                    String ret = new String(baseValue);
                    if(ret == null){
                        //redirect to login jsp
                        this.redirectLogPage(response);
                        return;
                    } else {
                        Gson gson = GsonSingleton.getInstance().getGson();
                        AuthCookie data = gson.fromJson(ret, AuthCookie.class);
                        String query = Constants.CHECK_COOKIE;
                        ResultSet rs = null;
                        PreparedStatement statement = null;
                        try {
                            statement = connection.prepareCall(query); //connection.prepareStatement(query);
                            statement.setInt(1, data.getUser_id());
                            rs = statement.executeQuery();
                            String user = rs.getString("username");
                            String psw = rs.getString("psw");
                            if(!user.equalsIgnoreCase(data.getUsername()) || !psw.equalsIgnoreCase(data.getPassword())){
                                System.out.println("wrong auth!");
                                this.redirectLogPage(response);
                                return;  //redirect to login
                            }
                            //authenticated
                            String job_des = rs.getString("job");
                            if(job_des.equalsIgnoreCase("worker")){
                                //redirect to worker homepage with credential in request
                                return;
                            } else if (job_des.equalsIgnoreCase("manager")){
                                //redirect to manager homepage with credential in request
                                return;
                            } else {
                                //redirect to login jsp
                                this.redirectLogPage(response);
                                return;
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                            this.redirectLogPage(response);
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
                }
            }
        }
        if(!cookieFound){
            this.redirectLogPage(response);
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

    private void connectDb() throws ClassNotFoundException, SQLException, UnavailableException {
        String dbUrl = context.getInitParameter("dbUrl");
        try {
            Class.forName(context.getInitParameter("dbDrive"));
            connection = DriverManager.getConnection(dbUrl,"root","stefano");
            System.out.println("successful connection!");
        } catch (SQLException e){
            throw new UnavailableException("Couldn't get db connection");
        }
    }

    private void redirectLogPage(HttpServletResponse response) throws  IOException {
        response.sendRedirect( Constants.PATH + "/login");
        return;
    }
}
