package ucl.team10.anomaly;

import java.io.Serializable;

public class ScalingParams implements Serializable {

	double range_time, min_time,
		range_gpsLat, min_gpsLat,
		range_gpsLong, min_gpsLong;
	
	public ScalingParams(double range_time, double min_time,
			double range_gpsLat, double min_gpsLat,
			double range_gpsLong, double min_gpsLong) {

		this.range_time = range_time;
		this.min_time = min_time;
		this.range_gpsLat = range_gpsLat;
		this.min_gpsLat = min_gpsLat;
		this.range_gpsLong = range_gpsLong;
		this.min_gpsLong = min_gpsLong;
	}

	public double getMinTime() {
    	return min_time;
    }

    public double getRangeTime() {
        return range_time;
    }

    public double getMinGpsLat() {
        return min_gpsLat;
    }

    public double getRangeGpsLat() {
        return range_gpsLat;
    }

    public double getMinGpsLong() {
        return min_gpsLong;
    }

    public double getRangeGpsLong() {
        return range_gpsLong;
    }
}