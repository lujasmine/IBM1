package ucl.team10.anomaly;

import io.prediction.controller.java.LJavaPreparator;
import org.apache.spark.SparkContext;
import ucl.team10.anomaly.libsvm.svm_node;

public class Preparator extends LJavaPreparator<TrainingData, PreparedData> {

    @Override
    public PreparedData prepare(TrainingData trainingData) {

    	int l = trainingData.size();

    	double[] y = new double[l];
    	for (int i = 0; i < l; i ++)
    		y[i] = 0;

    	svm_node[][] x = new svm_node[l][4];
    	double min_time = 1440, max_time = -1, avg_time = 0, range_time = 0,
                min_day = 8, max_day = 0, avg_day = 0, range_day = 0,
                min_gpsLat = 90, max_gpsLat = -90, avg_gpsLat = 0, range_gpsLat = 0,
                min_gpsLong = 180, max_gpsLong = -180, avg_gpsLong = 0, range_gpsLong = 0,
                dg = 1000000;

    	for (int i = 0; i < l; i ++) {

            x[i][0] = new svm_node();
    		x[i][0].value = trainingData.getLogins().get(i).getTime();
    		x[i][0].index = 1;
    		min_time = Math.min(min_time, x[i][0].value);
    		max_time = Math.max(max_time, x[i][0].value);
    		avg_time += x[i][0].value;

            x[i][1] = new svm_node();
    		x[i][1].value = trainingData.getLogins().get(i).getDay();
    		x[i][1].index = 2;
    		min_day = Math.min(min_day, x[i][1].value);
    		max_day = Math.max(max_day, x[i][1].value);
    		avg_day += x[i][1].value;

            x[i][2] = new svm_node();
    		x[i][2].value = trainingData.getLogins().get(i).getGpsLat();
    		x[i][2].index = 3;
    		min_gpsLat = Math.min(min_gpsLat, x[i][2].value);
    		max_gpsLat = Math.max(max_gpsLat, x[i][2].value);
    		avg_gpsLat += x[i][2].value;

            x[i][3] = new svm_node();
    		x[i][3].value = trainingData.getLogins().get(i).getGpsLong();
    		x[i][3].index = 4;
    		min_gpsLong = Math.min(min_gpsLong, x[i][3].value);
    		max_gpsLong = Math.max(max_gpsLong, x[i][3].value);
    		avg_gpsLong += x[i][3].value;
    	}

    	avg_time = avg_time / l; range_time = max_time - min_time;
    	avg_day = avg_day / l; range_day = max_day - min_day;
    	avg_gpsLat = avg_gpsLat / l; range_gpsLat = max_gpsLat - min_gpsLat;
    	avg_gpsLong = avg_gpsLong / l; range_gpsLong = max_gpsLong - min_gpsLong;

        if (range_day == 0)
            range_day = 1;

    	/*for (int i = 0; i < l; i ++) { 
    		x[i][0].value = (x[i][0].value - avg_time) / range_time;
    		x[i][1].value = (x[i][1].value - avg_day) / range_day;
    		x[i][2].value = (x[i][2].value - avg_gpsLat) / range_gpsLat;
    		x[i][3].value = (x[i][3].value - avg_gpsLong) / range_gpsLong;
    	}*/

        for (int i = 0; i < l; i ++) { 
            x[i][0].value = Math.round((-1 + 2 * ((x[i][0].value - min_time) / range_time)) * dg) / dg; 
            x[i][1].value = Math.round((-1 + 2 * ((x[i][1].value - min_day) / range_day)) * dg) / dg;  
            x[i][2].value = Math.round((-1 + 2 * ((x[i][2].value - min_gpsLat) / range_gpsLat)) * dg) / dg; 
            x[i][3].value = Math.round((-1 + 2 * ((x[i][3].value - min_gpsLong) / range_gpsLong)) * dg) / dg;  
        }

        ScalingParams params = new ScalingParams(range_time, min_time, 
                                                 range_day, min_day, 
                                                 range_gpsLat, min_gpsLat, 
                                                 range_gpsLong, min_gpsLong);

        return new PreparedData(l,y,x, params);
    }
}
