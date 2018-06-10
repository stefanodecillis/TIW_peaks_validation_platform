package Entities;

import com.google.gson.annotations.SerializedName;

public class Peak {
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
}
