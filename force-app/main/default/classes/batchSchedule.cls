public class batchSchedule implements Schedulable {
    public static void execute(SchedulableContext sc){
        batchAccount b = new batchAccount();
        database.executeBatch(b);
    }
}