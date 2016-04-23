package ucl.team10.anomaly;

import io.prediction.controller.SanityCheck;
import java.util.List;

import java.io.Serializable;

public class TrainingData implements Serializable, SanityCheck {
    private final List<LoginProperties> logins;

    public TrainingData(List<LoginProperties> logins) {
        this.logins = logins;
    }

    public List<LoginProperties> getLogins() {
        return logins;
    }

    public int size() {
        return logins.size();
    }

    @Override
    public void sanityCheck() {
        if (logins.isEmpty()) {
            throw new AssertionError("Login data is empty");
        }
    }
}
