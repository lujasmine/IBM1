<?php
 
 	require_once("vendor/autoload.php");

  use predictionio\EngineClient;

 	$engineClient = new EngineClient('http://134.168.36.17:8000/');
  
  $time = (int)$_GET['time']; 
	$day = (int)$_GET['day'];
	$latitude = (double)$_GET['latitude']; 
	$longitude = (double)$_GET['longitude'];

  $response = $engineClient->sendQuery(array(
                        'event' => 'login',
                        'entityType' => 'user',
                        'entityId' => 'u0',
                        'properties' => array('time' => $time,
                                              'day' => $day,
                                              'gpsLat' => $latitude,
                                              'gpsLong' => $longitude
                                        ),
                       ));

  if (in_array("-1", $response)) {
    echo "-1";
  } else {
    echo "1";
  }

?>