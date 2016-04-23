package ucl.team10.anomaly;

import io.prediction.controller.Params;

import java.util.List;

public class AlgorithmParams implements Params {
    private final int degree;
    private final double gamma;
    private final double coef0;
    private final double nu;
    private final double cache_size;
    private final double eps;
    private final double C;
    private final double p;
    private final int shrinking;
    private final int probability;
    private final int nr_weight;


    public AlgorithmParams(int degree, double gamma, double coef0, double nu,
                            double cache_size, double C, double p, double eps,
                            int shrinking, int probability, int nr_weight) {
        this.degree = degree;
        this.gamma = gamma;
        this.coef0 = coef0;
        this.nu = nu;
        this.cache_size = cache_size;
        this.eps = eps;
        this.C = C;
        this.p = p;
        this.shrinking = shrinking;
        this.probability = probability;
        this.nr_weight = nr_weight;
    }

     public int getDegree() {
        return degree;
    }

    public double getGamma() {
        return gamma;
    }

    public double getCoef0() {
        return coef0;
    }

    public double getNu() {
        return nu;
    }

    public double getCache() {
        return cache_size;
    }

    public double getEps() {
        return eps;
    }

    public double getC() {
        return C;
    }

    public double getP() {
        return p;
    }

    public int getShrinking() {
        return shrinking;
    }

    public int getProbability() {
        return probability;
    }

    public int getNrWeight() {
        return nr_weight;
    }

    @Override
    public String toString() {
        return "AlgorithmParams {" +
                "degree=" + degree +
                ", gamma=" + gamma +
                ", coef0=" + coef0 +
                ", nu=" + nu +
                ", cache_size=" + cache_size +
                ", eps=" + eps +
                ", C=" + C +
                ", p=" + p +
                ", shrinking=" + shrinking +
                ", probability=" + probability +
                ", nr_weight=" + nr_weight +
                '}';
    }
}
