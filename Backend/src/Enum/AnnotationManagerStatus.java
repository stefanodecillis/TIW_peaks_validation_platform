package Enum;

public enum AnnotationManagerStatus {
    REFUSED(0),
    NOTREFUSED(1);

    private int statusId;

    public int getId() {
        return this.statusId;
    }

    AnnotationManagerStatus(int id) {
        this.statusId = id;
    }
}
