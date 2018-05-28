package Entities;

import com.google.gson.annotations.SerializedName;

public class AuthCookie {

    @SerializedName("user_id")
    private Integer user_id;

    @SerializedName("username")
    private String username;

    @SerializedName("password")
    private String password; //base94



    public AuthCookie (Integer user_id, String username, String password){
        this.password = password;
        this.user_id = user_id;
        this.username = username;
    }

    public Integer getUser_id() {
        return user_id;
    }
    public String getUsername() {
        return username;
    }
    public String getPassword() {
        return password;
    }
}
