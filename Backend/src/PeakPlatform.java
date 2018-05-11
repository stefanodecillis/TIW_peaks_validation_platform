import Entities.AuthCookie;
import com.google.gson.Gson;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.UnavailableException;
import javax.servlet.http.Cookie;
import java.io.IOException;
import java.sql.*;

public class PeakPlatform extends javax.servlet.http.HttpServlet {

    private ServletContext context = null;
    private Connection connection = null;

    @Override
    public void init() throws ServletException {
        context = getServletContext();
        try {
            this.connectDb();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        super.init();
    }

    protected void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        //do nothing -> we cannot afford post request from here
    }

    protected void doGet(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        Cookie[] cookies = request.getCookies(); //check for cookies
        if(cookies == null) {
            //redirect to login jsp
        } else {
            //we logged yet and depending on which cookies do we have, we redirect to manager or worker home
            for(Cookie cookie : cookies){
                if (cookie.getName() == "cookie-job"){
                    String ret = cookie.getValue();
                    if(ret == null){
                        //redirect to login jsp
                    } else {
                        Gson gson = GsonSingleton.getInstance().getGson();
                        AuthCookie data = gson.fromJson(ret, AuthCookie.class);
                        if(connection == null){
                            try {
                                this.connectDb();
                            } catch (ClassNotFoundException e) {
                                e.printStackTrace();
                                //shoot an exception
                                System.out.println("connection db found null. ");
                                return;
                            } catch (SQLException e) {
                                e.printStackTrace();
                                //shoot an exception
                                System.out.println("connection db found null. ");
                                return;
                            }
                        }
                        String query = Constants.CHECK_COOKIE;
                        ResultSet rs = null;
                        PreparedStatement statement = null;
                        try {
                            statement = connection.prepareStatement(query);
                            statement.setInt(1, data.getUser_id());
                            rs = statement.executeQuery();
                            String user = rs.getString("username");
                            String psw = rs.getString("psw");
                            if(!user.equalsIgnoreCase(data.getUsername()) || !psw.equalsIgnoreCase(data.getPassword())){
                                System.out.println("wrong auth!");
                                return;  //redirect to login
                            }
                            //authenticated
                            String job_des = rs.getString("job");
                            if(job_des.equalsIgnoreCase("worker")){
                                //redirect to worker homepage with credential in request
                            } else if (job_des.equalsIgnoreCase("manager")){
                                //redirect to manager homepage with credential in request
                            } else {
                                //redirect to login jsp
                            }
                        } catch (SQLException e) {
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
                }
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

    private void connectDb() throws ClassNotFoundException, SQLException, UnavailableException {
        String dbUrl = context.getInitParameter("dbUrl");
        try {
            Class.forName(context.getInitParameter("dbDrive"));
            connection = DriverManager.getConnection(dbUrl,"root","stefano");
        } catch (SQLException e){
            throw new UnavailableException("Couldn't get db connection");
        }
    }
}
