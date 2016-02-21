<?php

require_once("models/config.php");

//echo getInvolvementID("mynewone");
//echo getReportKindID("newREPORT");

//echo json_encode(getDefaultInvolvements()) . "<br /><br />";
//echo json_encode(getDefaultReportKinds()) . "<br /><br />";
//echo json_encode(getBuildings()) . "<br /><br />";
//echo json_encode(getDepartments());

$depts = [/*"Agricultural & Environmental Sciences", "Animal & Veterinary Sciences", "Architecture", "Art", */"Automotive Engineering", "Bioengineering", "Biological Sciences", "Chemical & Biomolecular Engineering", "Chemistry", "Civil Engineering", "Construction Science & Management", "Electrical & Computer Engineering", "Environmental Engineering", "Food, Nutrition & Packaging Science", "Forestry & Environmetnal Conservaton", "Genetics & Biochemistry", "Materials Science & Engineering", "Mechanical Engineering", "Nursing", "Physics & Astronomy", "Public Health Sciences"];

$buildings = [/*"Brackett Hall", "BRC", "Brooks Center", "Cook Lab", "Earle Hall", "Fluor Daniel", "Freeman Hall", "Godfrey", */"Godley Snell", "Harris A. Smith", "Hunter Hall", "Jordan", "Kinard Lab", "Lee Hall", "Lehotsky Hall", "Life Science", "Long Hall", "Lowry", "McAdams Hall", "Newman Hall", "Olin Hall", "Poole", "Ravenel", "Rhodes Annex", "Rhodes Hall", "Riggs", "Sirrine Hall"];

$db = new Database();

foreach($depts as $dept){
	$sql = "INSERT INTO departments(departmentName) VALUES(?)";
	$sql = $db->prepareQuery($sql, $dept); 
	$db->query($sql);
}

foreach($buildings as $bldg){
	$sql = "INSERT INTO buildings(buildingName) VALUES(?)";
	$sql = $db->prepareQuery($sql, $bldg); 
	$db->query($sql);
}

?>

<!DOCTYPE html>
<html>
<head>
	<title>test</title>
</head>
<body>

</body>
</html>