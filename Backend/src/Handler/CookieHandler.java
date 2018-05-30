package Handler;

import Entities.AuthCookie;
import Util.Constants;
import com.google.gson.Gson;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
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
                        return data;
                    }
                }
            }
        }
        return null;
    }

    public boolean closeUserCookie(HttpServletRequest request){
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
                    return true;
                }
            }
        }

        return false;
    }

}
