package Handler;

import Util.Constants;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RedirectManager {
    private static RedirectManager ourInstance = null;

    public static RedirectManager getInstance() {
        if(ourInstance == null){
            ourInstance = new RedirectManager();
        }
        return ourInstance;
    }


    /**
     * class used to redirect all the connections across the platform
     */
    private RedirectManager() {
    }

    /* all redirect */

    public void redirectLogPage(HttpServletResponse response) throws IOException {
        response.sendRedirect( Constants.PATH + "/login");
        System.out.println("--> log page");
        return;
    }

    public void redirectToManager(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/homeManager");
        System.out.println("--> manager page");
    }

    public void redirectToWorker(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/homeWorker");
        System.out.println("--> worker page");
    }

    public void redirectToErrorLog(HttpServletResponse response) throws IOException {
        response.sendRedirect(Constants.PATH +"/errorLogPage");
        System.out.println("--> error log page !!");
    }

    private void redirectToErrorReg(HttpServletResponse response) throws IOException{
        response.sendRedirect(Constants.PATH+"/errorReg");
        System.out.println("--> error reg page !!");
    }
}
