package Enum;

public enum Job {
    WORKER(1),
    MANAGER(2);

    private int id;

    public int getId(){
        return this.id;
    }

    Job(int id){
        this.id = id;
    }
}
