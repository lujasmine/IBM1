package ucl.team10.anomaly;

import java.io.Serializable;

public class Query implements Serializable{
    // private final String userEntityId;
    private final int time;
    private final int day;
    private final double gpsLat;
    private final double gpsLong;

    public Query(int time, int day, float gpsLat, float gpsLong) {
        this.time = time;
        this.day = day;
        this.gpsLat = gpsLat;
        this.gpsLong = gpsLong;
    }

    public Integer getTime() {
        return time;
    }

    public Integer getDay() {
        return day;
    }

    public Double getGpsLat() {
        return gpsLat;
    }

    public Double getGpsLong() {
        return gpsLong;
    }

    @Override
    public String toString() {
        return "Query{" +
                "time='" + time + '\'' +
                ", day=" + day +
                ", gpsLat=" + gpsLat +
                ", gpsLong=" + gpsLong +
                '}';
    }
}
