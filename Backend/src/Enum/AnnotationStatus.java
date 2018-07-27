package Enum;


public enum AnnotationStatus {

    VALID(2),
    INVALID(0);

    private int statusId;

    public int getId() {
        return this.statusId;
    }

    AnnotationStatus(int id) {
        this.statusId = id;
    }
}
