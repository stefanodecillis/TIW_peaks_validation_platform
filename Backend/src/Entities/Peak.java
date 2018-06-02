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
}
