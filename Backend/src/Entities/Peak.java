package Entities;

import com.google.gson.annotations.SerializedName;

public class Peak {

    @SerializedName("peak_id")
    private Integer peak_id = null;
    @SerializedName("provenance")
    private String provenance = null;
    @SerializedName("elevation")
    private Double elevation = null;
    @SerializedName("longitude")
    private Double longitude = null;
    @SerializedName("latitude")
    private Double latitude = null;
    @SerializedName("name")
    private String name = null;
    @SerializedName("localized_names")
    private String[][] localized_name = null;
    @SerializedName("validation_status_id")
    private Integer validation_status_id = null;

    public String getProvenance() {
        return provenance;
    }

    public Double getElevation() {
        return elevation;
    }

    public Double getLongitude() {
        return longitude;
    }

    public Double getLatitude() {
        return latitude;
    }

    public String getName() {
        return name;
    }

    public String[][] getLocalized_name() {
        return localized_name;
    }

    public void setProvenance(String provenance) {
        this.provenance = provenance;
    }

    public void setElevation(Double elevation) {
        this.elevation = elevation;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setLocalized_name(String[][] localized_name) {
        this.localized_name = localized_name;
    }

    public Integer getPeak_id() {
        return peak_id;
    }

    public Integer getValidation_status_id() {
        return validation_status_id;
    }

    public void setValidation_status_id(Integer validation_status_id) {
        this.validation_status_id = validation_status_id;
    }

    public void setPeak_id(Integer peak_id) {
        this.peak_id = peak_id;
    }
}
