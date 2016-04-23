package ucl.team10.anomaly;

import java.io.Serializable;

public class LoginProperties implements Serializable{
    // private final String userEntityId;
    private final Integer time;
    private final Integer day;
    private final Double gpsLat;
    private final Double gpsLong;

    public LoginProperties(Integer time, Integer day, Double gpsLat, Double gpsLong) {
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
        return "LoginProperties{" +
                "time='" + time + '\'' +
                ", day=" + day +
                ", gpsLat=" + gpsLat +
                ", gpsLong=" + gpsLong +
                '}';
    }
}
