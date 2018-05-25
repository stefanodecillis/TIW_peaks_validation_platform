package Handler;

import Util.Constants;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnectionHandler {

    private static DBConnectionHandler instance = null;

    private DBConnectionHandler(){

    }

    public  static DBConnectionHandler getInstance(){
        if(instance == null){
            instance = new DBConnectionHandler();
        }

        return instance;
    }

    public Connection getConnection(){
        Connection connection = null;
        try{
            Class.forName(Constants.DBDRIVER);
            connection = DriverManager.getConnection(Constants.DBURL, Constants.DBUSER, Constants.DBPSW);
        } catch (ClassNotFoundException e){
            e.printStackTrace();
        } catch (SQLException e){
            e.printStackTrace();
        }
        return connection;
    }


}
