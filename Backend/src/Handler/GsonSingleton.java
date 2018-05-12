package Handler;

import com.google.gson.Gson;

public class GsonSingleton {

    private static GsonSingleton ourInstance = null;
    public static GsonSingleton getInstance() {
        if(ourInstance == null){
            ourInstance = new GsonSingleton();
        }
        return ourInstance;
    }

    private Gson gson;

    private GsonSingleton() {
        ourInstance.gson = new Gson();
    }

    public Gson getGson(){
        return gson;
    }
}
