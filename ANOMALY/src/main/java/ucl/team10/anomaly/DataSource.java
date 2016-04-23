package ucl.team10.anomaly;

import ucl.team10.anomaly.libsvm.*;

import io.prediction.controller.EmptyParams;
import io.prediction.controller.java.LJavaDataSource;
import io.prediction.data.store.java.LJavaEventStore;
import io.prediction.data.storage.Event;
import io.prediction.data.store.java.OptionHelper;
import org.apache.spark.SparkContext;
import org.apache.spark.api.java.function.Function;
import org.joda.time.DateTime;
import scala.Option;
import scala.concurrent.duration.Duration;

import java.util.Collections;
import java.util.List;
import java.util.ArrayList;
import java.util.Set;
import java.util.concurrent.TimeUnit;

public class DataSource extends LJavaDataSource<TrainingData, EmptyParams, Query, Set<String>> {

	private final DataSourceParams dsp;

	public DataSource(DataSourceParams dsp) {
        this.dsp = dsp;
    }

    @Override
    public TrainingData readTraining() {
    	List<Event> loginEvents = LJavaEventStore.find(
                dsp.getAppName(),
                OptionHelper.some("user"),
                OptionHelper.<String>none(),
                OptionHelper.<String>none(),
                OptionHelper.some(Collections.singletonList("login")),
                OptionHelper.<Option<String>>none(),
                OptionHelper.<Option<String>>none(),
                OptionHelper.<DateTime>none(),
                OptionHelper.<DateTime>none(),
                OptionHelper.<Integer>none(),
                Duration.apply(10, TimeUnit.SECONDS));

    	List<LoginProperties> logins = new ArrayList<LoginProperties>();
		loginEvents.forEach(event -> logins.add(convert(event)));        

    	return new TrainingData(logins);
    }

    public LoginProperties convert(Event event) {
		return new LoginProperties(event.properties().get("time", Integer.class),
									event.properties().get("day", Integer.class),
                        			event.properties().get("gpsLat", Double.class),
                        			event.properties().get("gpsLong", Double.class));
	}
}