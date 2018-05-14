package Util;

public class Constants {


    public final static String PATH = "http://localhost:8080";

    /* db credential */
    public final static String DBUSER = "root";
    public final static String DBURL = "jdbc:mysql://localhost:3306/geo_data?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC"; //mysql needs time date
    public final static String DBDRIVER = "com.mysql.cj.jdbc.Driver";


    /*static queries and constants*/

    public static final String CHECK_COOKIE = "SELECT ui.user_type_id AS job_id, ua.username AS username, ua.psswd AS psw, " +
            "ui.user_type_name AS job FROM user_app ua INNER JOIN user_info ui on ua.user_type_id = ui.user_type_id WHERE ua.user_id = ?";
    public final static String CHECK_LOG = "SELECT ua.user_type_id AS job_id, " +
            "ua.mail AS mail, ua.psswd AS psw, ui.user_type_name AS job FROM user_app AS ua INNER JOIN user_info AS ui ON ua.user_type_id = ui.user_type_id WHERE ua.mail = ? and ua.psswd = ?";
    public final static String CHECK_USERS = "SELECT ua.user_type_id AS job_id, " +
            "ua.mail AS email, " +
            "ua.psswd AS psw, "  +
            "ua.username AS username " +
            "FROM user_app ua ";
    public final static String INSERT_USER = "INSERT INTO user_app(username,psswd,mail,user_type_id) VALUES(?,?,?,?)";
    public final static String CHECK_CAMPAIGN_BY_OWNER_ID = "SELECT * FROM CAMPAIGN WHERE owner_id=?";

    //test
    public final static int TEST_USER_ID = 3;

}
