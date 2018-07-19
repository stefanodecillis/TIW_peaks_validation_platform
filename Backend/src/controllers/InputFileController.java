package controllers;

import Entities.Peak;
import Handler.DBConnectionHandler;
import Util.Constants;
import Util.Tools;
import com.google.gson.Gson;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.*;
import java.sql.Connection;
import java.sql.SQLException;

@MultipartConfig
@WebServlet(name = "InputFileController")
public class InputFileController extends HttpServlet {

    private ServletContext context = null;
    private Connection connection = null;

    @Override
    public void init() throws ServletException {
        context = getServletContext();
        connection = DBConnectionHandler.getInstance().getConnection();
        super.init();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("<loader file called>");
        System.out.println(request.getParameter("campaign"));
        System.out.println(request.getParameter("fileStatus"));
        if(request.getParameter("campaign") == null || request.getParameter("campaign").equalsIgnoreCase("")
                || request.getParameter("fileStatus") == null
                ||request.getParameter("fileStatus").equalsIgnoreCase("") ){
            //TODO REDIRECT  error page
        }
        Part filePart = request.getPart("file"); // Retrieves <input type="file" name="file">
        String fileName = getSubmittedFileName(filePart);
        InputStream fileContent = filePart.getInputStream();
        System.out.println("--> input file: " + fileName + "<--");
        // ... (do your job here)
        Reader reader = new InputStreamReader(fileContent,"UTF-8");
        Gson gson = Tools.getGson();
        Peak[] peakList = gson.fromJson(reader, Peak[].class);
        String data = gson.toJson(peakList[1]); //print an example
        System.out.println("example");
        System.out.println(data);

        int statusFile = Integer.parseInt(request.getParameter("fileStatus"));
        int campaign_id = Integer.parseInt(request.getParameter("campaign"));

        request.setAttribute(Constants.OBJECT_PEAKLIST, peakList);
        request.setAttribute(Constants.STATUS_FILE, statusFile);
        request.setAttribute(Constants.CAMPAIGN_REQUEST, campaign_id);

        //forward the request to Servlet2
        RequestDispatcher reqDispatcher = request.getRequestDispatcher("etlprocess");
        reqDispatcher.forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }


    private static String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1); // MSIE fix.
            }
        }
        return null;
    }

    @Override
    public void destroy() {
        if(connection != null){
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        super.destroy();
    }
}
