package Util;

public class Constants {


    public final static String PATH = "http://localhost:8080";

    /* constants string*/
    public final static String COOKIE_USER = "cookie-user";

    /* db credential */
    public final static String DBUSER = "root";
    public final static String DBURL = "jdbc:mysql://stefanodecillis.no-ip.org:9000/geo_data?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC"; //mysql needs time date
    public final static String DBDRIVER = "com.mysql.cj.jdbc.Driver";
    public final static String DBPSW = "stefano";


    /*static queries and constants*/

    public static final String CHECK_COOKIE = "SELECT ui.user_type_id AS job_id, ua.username AS username, ua.psswd AS psw, " +
            "ui.user_type_name AS job FROM user_app ua INNER JOIN user_info ui on ua.user_type_id = ui.user_type_id WHERE ua.user_id = ?";
    public final static String CHECK_LOG = "SELECT ua.user_type_id AS job_id, " +
            "ua.mail AS mail, ua.psswd AS psw, ui.user_type_name AS job, ua.user_id as user_id, ua.username as username FROM user_app AS ua INNER JOIN user_info AS ui ON ua.user_type_id = ui.user_type_id WHERE ua.mail = ? and ua.psswd = ?";
    public final static String CHECK_USERS = "SELECT ua.user_type_id AS job_id, " +
            "ua.mail AS email, " +
            "ua.psswd AS psw, " +
            "ua.username AS username " +
            "FROM user_app ua ";
    public final static String INSERT_USER = "INSERT INTO user_app(username,psswd,mail,user_type_id) VALUES(?,?,?,?)";
    public final static String CHECK_CAMPAIGN_BY_OWNER_ID = "SELECT * FROM campaign WHERE owner_id=?";
    public final static String CAMPAIGN_STARTED_JOINED = "select * from campaign as c join subscribe as s on c.campaign_id = s.campaign_id where s.worker_id = ? and c.campaign_status_id = 2";
    public final static String CAMPAIGN_NOT_JOINED = "select * FROM campaign AS C where C.campaign_id not in (select S.campaign_id from subscribe as S where S.worker_id=?)";    //test
    public final static String USER_DETAILS = "SELECT * FROM USER_APP WHERE user_id=?";
    public final static String UPDATE_USER_DETAILS = "UPDATE user_app set username = ? , mail=? where user_id=?";
    public final static String UPDATE_USER_USERNAME = "UPDATE user_app set username = ?  where user_id=?";
    public final static String UPDATE_USER_EMAIL = "UPDATE user_app set mail=? where user_id=?";
    public final static String UPDATE_USER_PASSWORD = "UPDATE user_app set psswd=? where user_id=?";
    public final static String INSERT_CAMPAIGN =  "INSERT INTO campaign(campaign_name, campaign_status_id,owner_id) VALUES(?,?,?)";
    public final static String CHECK_SUBSCRIPTION = "SELECT * FROM subscribe where worker_id = ? and campaign_id = ?";
    public final static String INSERT_SUBSCRIBE = "INSERT INTO subscribe(worker_id, campaign_id) VALUES(?,?)";
    public final static String SELECT_CAMPAIGN_BY_ID_CAMPAIGN_OWNER = "select * from campaign where campaign_id = ? and owner_id = ?";

    public final static int TEST_USER_ID = 3;
    public final static int WORKER_TEST_USER_ID = 4;
}
