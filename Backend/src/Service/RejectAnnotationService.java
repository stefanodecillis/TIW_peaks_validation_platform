package Service;

import Enum.AnnotationManagerStatus;
import Handler.DBConnectionHandler;
import Util.Constants;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "RejectAnnotationService")
public class RejectAnnotationService extends HttpServlet {

    private Connection connection = null;
    private ServletContext context = null;

    @Override
    public void init() throws ServletException {
        context = getServletContext();
        connection = DBConnectionHandler.getInstance().getConnection();
        super.init();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        PreparedStatement statement = null;

        try {
            String query = Constants.UPDATE_ANNOTATION_VALIDATION_STATUS_ID;
            statement = connection.prepareStatement(query);
            statement.setInt(1, AnnotationManagerStatus.REFUSED.getId());
            statement.setInt(2, Integer.parseInt(request.getParameter("annotation_id")));
            statement.executeUpdate();
            System.out.println("annotation " + request.getParameter("annotation_id") + " refused");

        } catch (SQLException e) {
            e.printStackTrace();

        } finally {
            if (statement != null) {
                try {
                    statement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }


        response.sendRedirect(Constants.PATH + "/annotationsdetails?" +
                "peakId=" + request.getParameter("peakId") +
                "&campaign=" + request.getParameter("campaign") +
                "&peakName=" + request.getParameter("peakName") +
                "&localizedNames=" + request.getParameter("localizedNames") +
                "&elevation=" + request.getParameter("elevation"));


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    public void destroy() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        super.destroy();
    }
}
