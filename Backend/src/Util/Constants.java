package Util;

public class Constants {


    public final static String PATH = "http://localhost:8080";

    /* db credential */
    public final static String DBUSER = "root";
    public final static String DBURL = "jdbc:mysql://localhost:3306/geo_data";
    public final static String DBDRIVE = "com.mysql.cj.jdbc.Driver";


    /*static queries and constants*/

    public static final String CHECK_COOKIE = "SELECT ui.user_type_id AS job_id, ua.username AS username, ua.psswd AS psw, " +
            "ui.user_type_name AS job FROM user_app ua INNER JOIN user_info ui on ua.user_type_id = ui.user_type_id where ua.user_id = ?";
    public final static String CHECK_LOG = "SELECT " +
            "ui.user_type_id AS job_id, " +
            "ua.mail AS mail, " +
            "ua.psswd AS psw, " +
            "ui.user_type_name AS job " +
            "FROM user_app ua " +
            "INNER JOIN user_info ui on ua.user_type_id = ui.user_type_id " +
            "where ua.mail = ? and ua.psswd = ?";
}
