package Entities;


import com.google.gson.annotations.SerializedName;

public class Annotation {

    @SerializedName("annotation_id")
    private int annotationId;
    @SerializedName("elevation")
    private Double elevation;
    @SerializedName("validation")
    private int validation;
    @SerializedName("peak_name")
    private String peakName;
    @SerializedName("localized_names")
    private String localizedName;
    @SerializedName("campaign_id")
    private int campaignId;
    @SerializedName("user_id")
    private int userId;
    @SerializedName("peak_id")
    private Double peakId;
    @SerializedName("latitude")
    private Double longitude;
    @SerializedName("longitude")
    private Double latitude;

    private String username;

    public int getAnnotationId() {
        return annotationId;
    }

    public void setAnnotationId(int annotationId) {
        this.annotationId = annotationId;
    }

    public Double getElevation() {
        return elevation;
    }

    public void setElevation(Double elevation) {
        this.elevation = elevation;
    }

    public int getValidation() {
        return validation;
    }

    public void setValidation(int validation) {
        this.validation = validation;
    }

    public String getPeakName() {
        return peakName;
    }

    public void setPeakName(String peakName) {
        this.peakName = peakName;
    }

    public String getLocalizedName() {
        return localizedName;
    }

    public void setLocalizedName(String localizedName) {
        this.localizedName = localizedName;
    }

    public int getCampaignId() {
        return campaignId;
    }

    public void setCampaignId(int campaignId) {
        this.campaignId = campaignId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Double getPeakId() {
        return peakId;
    }

    public void setPeakId(Double peakId) {
        this.peakId = peakId;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
