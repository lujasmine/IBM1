package ucl.team10.anomaly;

import ucl.team10.anomaly.libsvm.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import io.prediction.controller.java.LJavaAlgorithm;

import java.io.*;

public class Algorithm extends LJavaAlgorithm<PreparedData, Model, Query, PredictedResult> {

	private static final Logger logger = LoggerFactory.getLogger(Algorithm.class);
    private final AlgorithmParams ap;

    public Algorithm(AlgorithmParams ap) {
        this.ap = ap;
    }

    @Override
    public Model train(PreparedData preparedData) {

    	svm_problem problem = new svm_problem();
    	problem.l = preparedData.getL();
        problem.x = preparedData.getX();
    	problem.y = preparedData.getY();

        System.out.println("In algorithm");
        for (int i=0; i<problem.l; i++) {
            System.out.print(problem.y[i] + " ");
            for (int j=0; j<4; j++) {
                System.out.print(problem.x[i][j].index + ":");
                System.out.print(problem.x[i][j].value + " ");
            }
            System.out.println();
        } 

    	svm_parameter params = new svm_parameter();
    	params.svm_type = 2;
    	params.kernel_type = 2;
        params.degree = ap.getDegree();
        params.gamma = ap.getGamma();
        params.coef0 = ap.getCoef0();
        params.nu = ap.getNu();
        params.cache_size = ap.getCache();
        params.C = ap.getC();
        params.eps = 1e-3;
        params.p = ap.getP();
        params.shrinking = ap.getShrinking();
        params.probability = ap.getProbability();
        params.nr_weight = ap.getNrWeight();
        params.weight_label = new int[0];
        params.weight = new double[0];

    	svm_model lib_model = svm.svm_train(problem, params);
        try {
            svm.svm_save_model("output", lib_model);
        } catch (IOException e) {
            System.err.println("Invalid output file name: " + e.getMessage());
        }
    	
        Model model = new Model(lib_model, preparedData.getParams());

    	if (problem.l < 2)
    		model.early = 1;

    	return model;
    }

    @Override
    public PredictedResult predict(Model model, final Query query) {

        ScalingParams params = model.getScalingParams();
        double dg = 1000000;

    	if (model.early == 1) {
    		return new PredictedResult(-1);
    	}
    	else {
    		svm_node[] svm_query = new svm_node[10];

            svm_query[0] = new svm_node();
            svm_query[0].index = 1;
            svm_query[0].value = Math.round((-1 + 2 * (query.getTime() - params.getMinTime()) / params.getRangeTime()) * dg) / dg;
            //svm_query[0].value = -1 + 2 * (query.getTime() - params.getMinTime()) / params.getRangeTime();
            System.out.println(svm_query[0].value);

            svm_query[1] = new svm_node();
            svm_query[1].index = 2;
            svm_query[1].value = Math.round((-1 + 2 * (query.getGpsLat() - params.getMinGpsLat()) / params.getRangeGpsLat()) * dg) / dg;
            //svm_query[2].value = -1 + 2 * (query.getGpsLat() - params.getMinGpsLat()) / params.getRangeGpsLat();
            System.out.println(svm_query[1].value);

            svm_query[2] = new svm_node();
            svm_query[2].index = 3;
            svm_query[2].value = Math.round((-1 + 2 * (query.getGpsLong() - params.getMinGpsLong()) / params.getRangeGpsLong()) * dg) / dg;
            //svm_query[3].value = -1 + 2 * (query.getGpsLong() - params.getMinGpsLong()) / params.getRangeGpsLong();
            System.out.println(svm_query[2].value);

            for (int i = 1; i <= 7; i++) {

                svm_query[2 + i] = new svm_node();
                svm_query[2 + i].index = 3 + i;
                svm_query[2 + i].value = 0;
            }
            svm_query[2 + query.getDay()].value = 1;
            for (int i = 3; i <= 9; i++) {

                System.out.print(svm_query[i].value + " ");
            }
            System.out.println();


	    	double allowed = svm.svm_predict(model.getModel(), svm_query);

	    	return new PredictedResult(allowed);
    	}
    }
}   


