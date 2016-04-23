package ucl.team10.anomaly;

import java.io.Serializable;
import ucl.team10.anomaly.libsvm.*;


public class PreparedData implements Serializable {
    private final int l;
    private final double[] y;
    private final svm_node[][] x;
    private ScalingParams params;

    public PreparedData(int l, double[] y, svm_node[][] x, ScalingParams params) {
        this.l = l;
        this.y = y;
        this.x = x;
        this.params = params;
    }

    public int getL() {
        return l;
    }

    public double[] getY() {
        return y;
    }

    public svm_node[][] getX() {
        return x;
    }

    public ScalingParams getParams() {
        return params;
    }
}
