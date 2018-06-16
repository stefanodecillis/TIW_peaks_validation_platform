package Util;

import Entities.Peak;
import com.google.gson.Gson;


public  class Tools {

    public static Gson getGson(){
        return new Gson();
    }

    public static boolean checkPeakData (Peak peak){
        if      (peak.getProvenance().equalsIgnoreCase("")|| peak.getProvenance() == null||
                 peak.getElevation() == null || peak.getLatitude() == null || peak.getLongitude() == null || peak.getName() == null || peak.getName().equalsIgnoreCase("")){
            return false;
        }
        return true;
    }

    public static boolean IsDivisble(int x, int n)
    {
        return (x % n) == 0;
    }

}

//TODO remove name