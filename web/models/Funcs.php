<?php
require_once('config.php');

//for cleaning and validating form inputs.
function test_input($data) {
	$data = trim($data);
	$data = stripslashes($data);
	$data = htmlspecialchars($data);
	return $data;
}

//------------------------ LOOKUP METHODS (FOR Loader Controller) ------------------------

function getDefaultPersonKinds(){
	$db = new Database();
	$sql = "SELECT * FROM personKinds WHERE `default`=1";
	$results = $db->select($sql);
	$personKinds = array();

	if(is_array($results)){
		foreach($results as $result){
			$personKinds[] = array('id' => $result['id'], 'personKind' => $result['personKind'], 'default' => $result['default']);
		}
	}
	return $personKinds;	
}


function getDefaultInvolvements(){
	$db = new Database();
	$sql = "SELECT * FROM involvementKinds WHERE `default`=1";
	$results = $db->select($sql);
	$involvements = array();

	if(is_array($results)){
		foreach($results as $result){
			$involvements[] = array('id' => $result['id'], 'involvementKind' => $result['involvementKind'], 'default' => $result['default']);
		}
	}
	return $involvements;
}

function getDefaultReportKinds(){
	$db = new Database();
	$sql = "SELECT * FROM reportKinds WHERE `default`=1";
	$results = $db->select($sql);
	$reportKinds = array();

	if(is_array($results)){
		foreach($results as $result){
			$reportKinds[] = array('id' => $result['id'], 'reportKind' => $result['reportKind'], 'default' => $result['default']);
		}
	}
	return $reportKinds;
}

function getBuildings(){
	$db = new Database();
	$sql = "SELECT * FROM buildings";
	$results = $db->select($sql);
	$buildings = array();

	if(is_array($results)){
		foreach($results as $result){
			$buildings[] = array('id' => $result['id'], 'buildingName' => $result['buildingName']);
		}
	}
	return $buildings;
}

function getDepartments(){
	$db = new Database();
	$sql = "SELECT * FROM departments";
	$results = $db->select($sql);
	$departments = array();

	if(is_array($results)){
		foreach($results as $result){
			$departments[] = array('id' => $result['id'], 'departmentName' => $result['departmentName']);
		}
	}
	return $departments;
}

//------------------------ add new involvements/report kinds ------------------------

/*
*	adds a new involvement if necessary. returns the id
*/
function getInvolvementKindID($involvement){
	$db = new Database();
	$sql = "SELECT * FROM involvementKinds WHERE involvementKind=?";
	$sql = $db->prepareQuery($sql, $involvement);

	$results = $db->select($sql);
	if(isset($results[0]['id'])){
		return $results[0]['id'];	
	} else { //add new involvement
		$sql = "INSERT INTO involvementKinds(`involvementKind`,`default`) VALUES(?,0)";
		$sql = $db->prepareQuery($sql, $involvement);
		$db->query($sql);
	}

	$sql = "SELECT * FROM involvementKinds WHERE involvementKind=?";
	$sql = $db->prepareQuery($sql, $involvement);

	$results = $db->select($sql);
	if(isset($results[0]['id'])){
		return $results[0]['id'];	
	} else return false;
}

/*
*	given an existing involvement kind id, update the kind to the given name
*/
function updateInvolvementKind($id, $involvementKind){
	$db = new Database();
	$sql = "UPDATE involvementKinds SET involvementKind=? WHERE id=?";
	$sql = $db->prepareQuery($sql, $involvementKind, $id);

	$db->query($sql);
	return array(
		'id' => $id,
		'involvementKind' => $involvementKind
		);
}

/*
*	adds a new report kind if necessary. returns the id
*/
function getReportKindID($reportKind){
	$db = new Database();
	$sql = "SELECT * FROM reportKinds WHERE reportKind=?";
	$sql = $db->prepareQuery($sql, $reportKind);

	$results = $db->select($sql);
	if(isset($results[0]['id'])){
		return $results[0]['id'];	
	} else { //add new involvement
		$sql = "INSERT INTO reportKinds(`reportKind`,`default`) VALUES(?,0)";
		$sql = $db->prepareQuery($sql, $reportKind);
		$db->query($sql);
	}

	$sql = "SELECT * FROM reportKinds WHERE reportKind=?";
	$sql = $db->prepareQuery($sql, $reportKind);

	$results = $db->select($sql);
	if(isset($results[0]['id'])){
		return $results[0]['id'];	
	} else return false;
}

function getDepartmentID($departmentName){
	$db = new Database();
	$sql = "SELECT id FROM departments WHERE departmentName=?";
	$sql = $db->prepareQuery($sql, $departmentName);

	$results = $db->select($sql);
	if(isset($results[0]['id'])){
		return $results[0]['id'];
	} else return -1;
}


?>