<?php
require_once('models/Path.php');
require_once(Path::models() . 'config.php');

//$rep = new Report();
// $rep->setID($id);
// $rep->setDescription("this is a test");
// $rep->setInvolvementKindID(2);
// $rep->setReportKindID(1);
// $rep->setLocationID(1);
// $rep->setPersonID(1);
// $rep->setDepartmentID(2);
// $rep->setDateTime("2016-02-09 00:00:01");

// $rep->save();
//$rep->fetch(1);
//var_dump($rep);

$loc = New Location();
$loc->fetch(1);
var_dump($loc);

?>

<!DOCTYPE html>
<html>
<head>
	<title>test</title>
</head>
<body>

</body>
</html>