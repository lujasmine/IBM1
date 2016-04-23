package ucl.team10.anomaly;

import io.prediction.controller.java.LJavaPreparator;
import org.apache.spark.SparkContext;
import ucl.team10.anomaly.libsvm.svm_node;

public class Preparator extends LJavaPreparator<TrainingData, PreparedData> {

    @Override
    public PreparedData prepare(TrainingData trainingData) {

        int l = trainingData.size();

    	svm_node[][] x = new svm_node[l][10];

        double[] y = new double[l];
        for (int i = 0; i < l; i ++)
            y[i] = 0;

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
    		x[i][1].value = trainingData.getLogins().get(i).getGpsLat();
    		x[i][1].index = 2;
    		min_gpsLat = Math.min(min_gpsLat, x[i][1].value);
    		max_gpsLat = Math.max(max_gpsLat, x[i][1].value);
    		avg_gpsLat += x[i][1].value;

            x[i][2] = new svm_node();
    		x[i][2].value = trainingData.getLogins().get(i).getGpsLong();
    		x[i][2].index = 3;
    		min_gpsLong = Math.min(min_gpsLong, x[i][2].value);
    		max_gpsLong = Math.max(max_gpsLong, x[i][2].value);
    		avg_gpsLong += x[i][2].value;

            for (int j = 1; j <= 7; j++) {

                x[i][2 + j] = new svm_node();
                x[i][2 + j].value = 0;
                x[i][2 + j].index = 3 + j;
            }
            x[i][2 + trainingData.getLogins().get(i).getDay()].value = 1;
    	}

    	avg_time = avg_time / l; range_time = max_time - min_time;
    	avg_gpsLat = avg_gpsLat / l; range_gpsLat = max_gpsLat - min_gpsLat;
    	avg_gpsLong = avg_gpsLong / l; range_gpsLong = max_gpsLong - min_gpsLong;

        for (int i = 0; i < l; i ++) { 
            x[i][0].value = Math.round((-1 + 2 * ((x[i][0].value - min_time) / range_time)) * dg) / dg; 
            x[i][1].value = Math.round((-1 + 2 * ((x[i][1].value - min_gpsLat) / range_gpsLat)) * dg) / dg; 
            x[i][2].value = Math.round((-1 + 2 * ((x[i][2].value - min_gpsLong) / range_gpsLong)) * dg) / dg;  
        }

        ScalingParams params = new ScalingParams(range_time, min_time, 
                                                 range_gpsLat, min_gpsLat, 
                                                 range_gpsLong, min_gpsLong);

        return new PreparedData(l,y,x, params);
    }
}
