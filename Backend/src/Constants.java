public class Constants {

    /*static queries and constants*/

    public static final String CHECK_COOKIE = "SELECT ui.user_type_id AS job_id, ua.username AS username, ua.psswd AS psw, ui.user_type_name AS job FROM user_app ua INNER JOIN user_info ui on ua.user_type_id = ui.user_type_id where ua.user_id = ?";
}
