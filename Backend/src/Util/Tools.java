package Util;

import Entities.Peak;
import Handler.DBConnectionHandler;
import com.google.gson.Gson;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
import java.util.concurrent.Executors;


public  class Tools {

    public static Gson getGson(){
        return new Gson();
    }

    public static boolean checkPeakData (Peak peak){
        if      (peak.getProvenance().equalsIgnoreCase("")|| peak.getProvenance() == null || peak.getLatitude() == null || peak.getLongitude() == null){
            return false;
        }
        return true;
    }

    public static boolean IsDivisble(int x, int n)
    {
        return (x % n) == 0;
    }

    /**
     *
     * @param status 0 -> invalid  || 1 -> valid
     * @param peakId
     * @param userId
     * @param campaignId
     * @param peakName
     * @param latitude
     * @param longitude
     * @param elevation
     * @param localizedNames
     * @return
     */
    public static boolean validPeak(int status,int peakId, int userId, int campaignId,String peakName, Double latitude,Double longitude, Double elevation, String localizedNames) {
        Executors.newSingleThreadExecutor().execute((Runnable) () -> {
            Connection connection = DBConnectionHandler.getInstance().getConnection();
            checkData(peakId,userId,campaignId);
            try {
                PreparedStatement statement = connection.prepareStatement(Constants.INSERT_ANNOTATION);
                statement.setInt(1, status);
                statement.setInt(2,peakId);
                statement.setInt(5,campaignId);
                if(peakName == null){
                    statement.setNull(3, Types.VARCHAR);
                } else {
                    statement.setString(3,peakName);
                }
                statement.setInt(4,userId);
                if(latitude == null){
                    statement.setNull(6, Types.DOUBLE);
                } else {
                    statement.setDouble(6,latitude);
                }
                if(longitude == null){
                    statement.setNull(7, Types.DOUBLE);
                } else {
                    statement.setDouble(7,longitude);
                }
                if(elevation == null){
                    statement.setNull(8, Types.DOUBLE);
                } else {
                    statement.setDouble(8,elevation);
                }
                if(localizedNames == null){
                    statement.setNull(9, Types.VARCHAR);
                } else {
                    statement.setString(9,localizedNames);
                }
                statement.execute();
                statement.close();
                connection.close();
                System.out.println("----------- inserted validation ----------");
            } catch (SQLException e){
                e.printStackTrace();
            }
        });
        return true;
    }

    private static boolean checkData(Integer peakId, Integer userId, Integer campaignId){
        if (peakId == null || userId == null || campaignId == null){
            return false;
        }
        return true;
    }

}
