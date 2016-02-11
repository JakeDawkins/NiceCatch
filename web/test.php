<?php
require_once('models/Path.php');
require_once(Path::models() . 'config.php');

//echo getInvolvementID("mynewone");
//echo getReportKindID("newREPORT");

echo json_encode(getDefaultInvolvements()) . "<br /><br />";
echo json_encode(getDefaultReportKinds()) . "<br /><br />";
//echo json_encode(getBuildings()) . "<br /><br />";
//echo json_encode(getDepartments());

?>

<!DOCTYPE html>
<html>
<head>
	<title>test</title>
</head>
<body>

</body>
</html>