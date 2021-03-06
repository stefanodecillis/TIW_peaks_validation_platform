package Util;

public class Constants {


    public final static String PATH = "http://localhost:8080";

    /* constants string*/
    public final static String COOKIE_USER = "cookie-user";

    /* db credential */
    public final static String DBUSER = "root";
    public final static String DBURL = "jdbc:mysql://stefanodecillis.no-ip.org:9000/geo_data?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC&autoReconnect=true&interactiveClient=true"; //mysql needs time date
    public final static String DBDRIVER = "com.mysql.cj.jdbc.Driver";
    public final static String DBPSW = "stefano";
    //public final static String DBURL = "jdbc:mysql://localhost:3306/geo_data?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC"; //mysql needs time date



    /*static queries*/

    public static final String CHECK_COOKIE = "SELECT ui.user_type_id AS job_id, ua.username AS username, ua.psswd AS psw, " +
            "ui.user_type_name AS job, ua.user_id as userId FROM user_app ua INNER JOIN user_info ui on ua.user_type_id = ui.user_type_id WHERE ua.user_id = ?";
    public final static String CHECK_LOG = "SELECT ua.user_type_id AS job_id, " +
            "ua.mail AS mail, ua.psswd AS psw, ui.user_type_name AS job, ua.user_id as user_id, ua.username as username FROM user_app AS ua INNER JOIN user_info AS ui ON ua.user_type_id = ui.user_type_id WHERE ua.mail = ? and ua.psswd = ?";
    public final static String CHECK_USERS = "SELECT ua.user_type_id AS job_id, " +
            "ua.mail AS email, " +
            "ua.psswd AS psw, " +
            "ua.username AS username " +
            "FROM user_app ua ";
    public final static String INSERT_USER = "INSERT INTO user_app(username,psswd,mail,user_type_id) VALUES(?,?,?,?)";
    public final static String CHECK_CAMPAIGN_BY_OWNER_ID = "SELECT * FROM campaign WHERE owner_id=? order by campaign_status_id";
    public final static String CAMPAIGN_STARTED_JOINED = "select * from campaign as c join subscribe as s on c.campaign_id = s.campaign_id where s.worker_id = ? and c.campaign_status_id = 2";
    public final static String CAMPAIGN_NOT_JOINED = "select * FROM campaign AS C where C.campaign_id not in (select S.campaign_id from subscribe as S where S.worker_id=?)";    //test
    public final static String USER_DETAILS = "SELECT * FROM user_app WHERE user_id=?";
    public final static String UPDATE_USER_DETAILS = "UPDATE user_app set username = ? , mail=? where user_id=?";
    public final static String UPDATE_USER_USERNAME = "UPDATE user_app set username = ?  where user_id=?";
    public final static String UPDATE_USER_EMAIL = "UPDATE user_app set mail=? where user_id=?";
    public final static String UPDATE_USER_PASSWORD = "UPDATE user_app set psswd=? where user_id=?";
    public final static String INSERT_CAMPAIGN = "INSERT INTO campaign(campaign_name, campaign_status_id,owner_id) VALUES(?,?,?)";
    public final static String CHECK_SUBSCRIPTION = "SELECT * FROM subscribe where worker_id = ? and campaign_id = ?";
    public final static String INSERT_SUBSCRIBE = "INSERT INTO subscribe(worker_id, campaign_id) VALUES(?,?)";
    public final static String SELECT_CAMPAIGN_BY_ID_CAMPAIGN_OWNER = "select * from campaign where campaign_id = ? and owner_id = ? ";
    public final static String UPDATE_DATE_CAMPAIGN = "update campaign set ts_date = CURRENT_DATE where campaign_id = ?";
    public final static String UPDATE_DATE_CAMPAIGN_CLOSE = "update campaign set ts_end = CURRENT_DATE where campaign_id = ?";
    public final static String CHECK_PEAKS_BY_CAMPAIGN = "select * from peak p left join (select  peak_id, count(*) as pos_annotations from annotation a where a.validation=2 group by peak_id )  as t on p.peak_id = t.peak_id\n" +
            "left join (select peak_id, count(*) as neg_annotations from annotation a where a.validation = 0 group by peak_id) as s on s.peak_id = p.peak_id where campaign_id=?";
    public final static String CHECK_ANN_STATUS = "select validation_status_id from annotation where peak_id=? and campaign_id=?";
    public final static String UPDATE_STATUS_CAMPAIGN = "update campaign set campaign_status_id = ?, ts_date = CURRENT_TIMESTAMP where campaign_id = ?";
    public final static String UPDATE_ANNOTATION_VALIDATION_STATUS_ID = "update annotation set validation_status_id=? where annotation_id=?";
    public final static String CHECK_STATUS_CAMPAIGN = "select campaign_status_id from campaign where campaign_id = ?";
    public final static String INSERT_PEAK = "insert into peak(provenance,elevation,longitude,latitude,peak_name,localized_names,campaign_id,validation_status_id) values(?,?,?,?,?,?,?,?)";
    public final static String INSERT_ANNOTATION = "insert into annotation(validation, peak_id, peak_name,user_id, campaign_id,latitude,longitude,elevation,localized_names,validation_status_id) values(?,?,?,?,?,?,?,?,?,1)";
    public final static String COUNT_PEAK_ANNOTATIONS = "select count(*) as num from annotation where campaign_id=? and validation=? and peak_id=?";
    public final static String WORKER_PEAK_STILL_VALIDABLE = "select * from peak where campaign_id =? and peak_id NOT IN(select DISTINCT p.peak_id from peak p inner join annotation a on p.peak_id = a.peak_id where a.user_id =? and a.campaign_id =?)";

    /*statistic queries*/
    public final static String TOBEANNOTATEDCOUNT = "select count(*) as num from peak p left join annotation a on a.peak_id = p.peak_id where p.campaign_id = ? and a.peak_id is null";
    public final static String PEAKANNOTATEDCOUNT = "select count(DISTINCT p.peak_id) as num from peak p left join annotation a on a.peak_id = p.peak_id where p.campaign_id = ? and a.peak_id is not null";
    public final static String PEAKINVALIDANNOTATIONCOUNT = "select count(DISTINCT p.peak_id) as num from peak p left join annotation a on a.peak_id = p.peak_id where p.campaign_id = ? and a.peak_id is not null and a.validation_status_id = 0";
    public final static String CONFLICTCOUNT = "select sum(case when t1.num>t2.num then t2.num else t1.num end) as res from (select peak_id, count(*) as num from annotation where validation = 2 and campaign_id = ? group by peak_id) as t1 inner join (select peak_id, count(*) as num from annotation where validation = 0 and campaign_id = ? group by peak_id) as t2 on t1.peak_id = t2.peak_id";
    public final static String ANNOTATIONLIST = "select * from annotation a inner join user_app ua on ua.user_id = a.user_id where campaign_id = ? and peak_id = ?";
    public final static String ANNOTATIONPEAKNAME = "select peak_id, peak_name from annotation where campaign_id = ? group by peak_id";
    public final static String PEAKINVALIDLIST = "select distinct peak_name, peak_id from annotation where campaign_id = ? and validation_status_id = 0";
    public final static String INVALIDANNOTATIONLIST = "select * from annotation a inner join user_app ua on ua.user_id = a.user_id where campaign_id = ? and peak_id = ? and validation_status_id = 0";
    public final static String CONFLICTLIST = "select t1.peak_id, t1.peak_name, t1.num as valid, t2.num as invalid from (select peak_id, peak_name,count(*) as num from annotation where validation = 2 and campaign_id = ? group by peak_id) as t1 inner join (select peak_id, count(*) as num from annotation where validation = 0 and campaign_id = ? group by peak_id) as t2 on t1.peak_id = t2.peak_id group by t1.peak_id";


    /* test */
    public final static int TEST_USER_ID = 3;
    public final static int WORKER_TEST_USER_ID = 4;

    /* constants */
    public final static String OBJECT_PEAKLIST = "peak_list_data";
    public final static String STATUS_FILE = "status_file";
    public final static String CAMPAIGN_REQUEST = "campaign_request";
}
