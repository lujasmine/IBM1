package ucl.team10.anomaly;

import java.io.Serializable;

public class PredictedResult implements Serializable{
    private final double allowed;

    public PredictedResult(double allowed) {
        this.allowed = allowed;
    }

    public double getAllowed() {
        return allowed;
    }

    @Override
    public String toString() {
        return "PredictedResult{" +
                "allowed=" + allowed +
                '}';
    }
}
