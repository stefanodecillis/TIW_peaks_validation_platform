package Handler;

import Entities.AuthCookie;
import Util.Constants;
import com.google.gson.Gson;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Base64;

public class CookieHandler {

    private static CookieHandler ourInstance = null;

    public static CookieHandler getInstance() {
        if(ourInstance == null){
            ourInstance = new CookieHandler();
        }

        return ourInstance;
    }

    private CookieHandler() {
    }

    public AuthCookie checkCookieUser(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies(); //check for cookies
        boolean cookieFound = false;
        if (cookies == null) {
            return null;
        } else {
            //we logged yet and depending on which cookies do we have, we redirect to manager or worker home
            System.out.println("...checking cookies...[" + cookies.length + "]");
            for (Cookie cookie : cookies) {
                if (cookie.getName().equalsIgnoreCase(Constants.COOKIE_USER)) {
                    cookieFound = true;
                    System.out.println("-->cookie found <--");
                    byte[] baseValue = Base64.getDecoder().decode(cookie.getValue()); //decode data from cookie
                    String ret = new String(baseValue);
                    if (ret == null) {
                        return null;
                    } else {
                        System.out.println("...checking integrity...");
                        Gson gson = new Gson();
                        AuthCookie data = gson.fromJson(ret, AuthCookie.class);
                        System.out.println("data passed with success");
                        return data;
                    }
                }
            }
        }
        return null;
    }

    public boolean closeUserCookie(HttpServletRequest request, HttpServletResponse response){
        Cookie[] cookies = request.getCookies(); //check for cookies
        boolean cookieFound = false;
        if (cookies == null) {
            return false;
        } else {
            for(Cookie cookie : cookies){
                if (cookie.getName().equalsIgnoreCase(Constants.COOKIE_USER)){
                    System.out.println("->Cookie Found<-");
                    cookie.setMaxAge(0);
                    cookie.setValue("");
                    cookie.setPath("/");
                    response.addCookie(cookie);
                    System.out.println("->Cookie Deleted<-");
                    return true;
                }
            }
        }

        return false;
    }

    public boolean createCookie(HttpServletResponse response, String cookieName,String cookieValue){
        try{
            String encodedValue = Base64.getEncoder().encodeToString(cookieValue.getBytes());
            Cookie cookie = new Cookie(cookieName, encodedValue);
            cookie.setMaxAge(60*60*24*2); //two days
            System.out.println("..cookie created...");
            response.addCookie(cookie);
            System.out.println("<cookie attached>");
            return true;
        } catch (Exception e){
            e.printStackTrace();
            return false;
        }
    }

    public void attachCookieUser(HttpServletResponse response,Integer user_id, String user, String psw){
        System.out.println("...generating cookie...");
        AuthCookie authCookie = new AuthCookie(user_id, user,psw);

        //json data
        Gson gson = new Gson();
        String ret = gson.toJson(authCookie,AuthCookie.class);

        //encode cookie value
        String cryptRet = Base64.getEncoder().encodeToString(ret.getBytes());

        Cookie ck = new Cookie(Constants.COOKIE_USER,cryptRet);//creating cookie object
        ck.setMaxAge(60*60*24); //one day --> age should be expressed in seconds
        response.addCookie(ck);//adding cookie in the response
        System.out.println("cookie attached to response");
    }


    /**
     * scattered around --> Denied unauthorized clients
     *
     * @param request
     * @param response
     * @return
     * @throws IOException
     */
    public boolean isSafe(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if(checkCookieUser(request) == null){
            RedirectManager.getInstance().redirectHome(response);
            return false;
        } else {
            return true;
        }
    }

}
