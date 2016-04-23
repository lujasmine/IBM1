package ucl.team10.anomaly;

import ucl.team10.anomaly.libsvm.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.Serializable;


public class Model implements Serializable {

	private static final Logger logger = LoggerFactory.getLogger(Model.class);
	public int early;
	private svm_model model;
	private ScalingParams params;

	public Model(svm_model model, ScalingParams params) {
		this.model = model;
		this.params = params;
	}

	public svm_model getModel() {
		return model;
	}

	public ScalingParams getScalingParams() {
		return params;
	}
}