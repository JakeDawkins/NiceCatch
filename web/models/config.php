<?php
require_once(dirname(__FILE__) . "/Path.php");
require_once(Path::models() . "class.Database.php");
require_once(Path::models() . "class.Location.php");
require_once(Path::models() . "class.Report.php");
require_once(Path::models() . "class.Person.php");
require_once(Path::models() . "Funcs.php");

date_default_timezone_set('America/New_York');

GLOBAL $errors;
GLOBAL $successes;

$errors = array();
$successes = array();

?>