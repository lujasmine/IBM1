<?php
 
 	require_once("vendor/autoload.php");

  	use predictionio\EventClient;

  	$baseUrl = "http://134.168.34.68:7000/";

 	$accessKey = 't9FmFxWIERJyaF3XGY8LwFsFSCHsRqbP5Wh0jyeCJzKBs3MjDkzaFRAIX4E7FR5r';
 	$client = new EventClient($accessKey, $baseUrl);
  
  $time = (int)$_GET['time']; 
  $day = (int)$_GET['day'];
  $latitude = (double)$_GET['latitude']; 
  $longitude = (double)$_GET['longitude'];

  	$response = $client->createEvent(array(
                        'event' => 'login',
                        'entityType' => 'user',
                        'entityId' => 'u0',
                        'properties' => array('time' => $time,
                                              'day' => $day,
                                              'gpsLat' => $latitude,
                                              'gpsLong' => $longitude
                                        ),
                       ));
?>