<?php

require('models/config.php');

$loc = new Location();
$loc->setBuildingID(10);
$loc->save();
echo $loc->getID();

?>