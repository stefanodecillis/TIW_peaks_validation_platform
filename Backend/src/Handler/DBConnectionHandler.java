package Handler;

import Util.Constants;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnectionHandler {

    private Connection connection = null;

    public DBConnectionHandler(){

    }

    public Connection getConnection(){
        if(connection == null){
            try{
                Class.forName(Constants.DBDRIVE);
                connection = DriverManager.getConnection(Constants.DBURL, Constants.DBUSER, "stefano");
            } catch (ClassNotFoundException e){
                e.printStackTrace();
            } catch (SQLException e){
                e.printStackTrace();
            }
        }
        return this.connection;
    }

    public void closeConnection(){
        try {
            this.connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


}
