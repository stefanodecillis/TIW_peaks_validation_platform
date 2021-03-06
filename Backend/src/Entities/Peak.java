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
    @SerializedName("num_positive_annotations")
    private Integer num_positive_annotations = null;
    @SerializedName("num_negative_annotations")
    private Integer num_negative_annotations = null;
    @SerializedName("has_ref_ann")
    private Boolean has_ref_ann = false;

    public Boolean getHas_ref_ann() {
        return has_ref_ann;
    }

    public void setHas_ref_ann(Boolean has_ref_ann) {
        this.has_ref_ann = has_ref_ann;
    }

    private String localizedNames = null;

    public Integer getNum_positive_annotations(){return num_positive_annotations;}

    public Integer getNum_negative_annotations(){return num_negative_annotations;}

    public void setNum_positive_annotations(Integer num){this.num_positive_annotations=num;}

    public void setNum_negative_annotations(Integer num){this.num_negative_annotations=num;}

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

    public String getLocalizedNames() {
        return localizedNames;
    }

    public void setLocalizedNames(String localizedNames) {
        this.localizedNames = localizedNames;
    }
}
