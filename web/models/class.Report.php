<?php
require_once('Path.php');
require_once(Path::models() . 'config.php');

class Report {
	private $id;
	private $description;
	private $involvementKindID;
	private $reportKindID;
	private $locationID;
	private $personID;
	private $departmentID;
	private $dateTime;
	private $statusID;
	private $actionTaken;

	//------------------------ GETTERS ------------------------
	public function getID(){
		return $this->id;
	}

	public function getDescription(){
		return $this->description;
	}

	public function getInvolvementKindID(){
		return $this->involvementKindID;
	}

	public function getReportKindID(){
		return $this->reportKindID;
	}

	public function getLocationID(){
		return $this->locationID;
	}

	public function getPersonID(){
		return $this->personID;
	}

	public function getDepartmentID(){
		return $this->departmentID;
	}

	public function getDateTime(){
		return $this->dateTime;
	}

	public function getStatusID(){
		return $this->statusID;
	}

	public function getActionTaken(){
		return $this->actionTaken;
	}

	//------------------------ SETTERS ------------------------

	public function setID($id){
		$this->id = $id;
	}

	public function setDescription($description){
		$this->description = $description;
	}

	public function setInvolvementKindID($involvementKindID){
		$this->involvementKindID = $involvementKindID;
	}

	public function setReportKindID($reportKindID){
		$this->reportKindID = $reportKindID;
	}

	public function setLocationID($locationID){
		$this->locationID = $locationID;
	}

	public function setPersonID($personID){
		$this->personID = $personID;
	}

	public function setDepartmentID($departmentID){
		$this->departmentID = $departmentID;
	}

	public function setDateTime($dateTime){
		$this->dateTime = $dateTime;
	}

	public function setStatusID($statusID){
		$this->statusID = $statusID;
	}

	public function setActionTaken($actionTaken){
		$this->actionTaken = $actionTaken;
	}

	//------------------------ DB METHODS ------------------------

	/*
	*	takes the report object and saves to DB.

	*	@case1 new report | add new record to DB
	*	@case2 old report with ID | update record in DB
	*	@case3 old report with no ID | look up id from person/time, set local, update record in DB
	*	
	*	@return boolean | false on fail to get id from DB in case 3
	*/
	public function save(){
		$db = new Database();
		$sql = "SELECT * FROM `reports` WHERE `personID`=? AND `dateTime`=?";
		$sql = $db->prepareQuery($sql, $this->personID, $this->dateTime);
		$results = $db->select($sql);

		if(count($results) == 0){ //new report
			$sql = "INSERT INTO `reports`(`description`, `involvementKindID`, `reportKindID`, `locationID`, `personID`, `departmentID`, `dateTime`,`statusID`,`actionTaken`) VALUES(?,?,?,?,?,?,?,?,?)";
			$sql = $db->prepareQuery($sql, $this->description, $this->involvementKindID, $this->reportKindID, $this->locationID, $this->personID, $this->departmentID, $this->dateTime, $this->statusID, $this->actionTaken);
			$db->query($sql);

			//get id from new report
			$sql = "SELECT * FROM `reports` WHERE `personID`=? AND `dateTime`=?";
			$sql = $db->prepareQuery($sql, $this->personID, $this->dateTime);
			$results = $db->select($sql);
			if(isset($results[0]['id'])){
				$this->id = $results[0]['id'];	
			} else return false;
		} else { //old report
			if(is_null($this->id)){ //old report, new object. no local id yet
				//get id from DB
				if(isset($results[0]['id'])){
					$this->id = $results[0]['id'];	
				} else return false;
			}

			$sql = "UPDATE reports SET `description`=?, `involvementKindID`=?, `reportKindID`=?, `locationID`=?, `personID`=?, `departmentID`=?, `dateTime`=?, `statusID`=?, `actionTaken`=? WHERE id=?";
			$sql = $db->prepareQuery($sql, $this->description, $this->involvementKindID, $this->reportKindID, $this->locationID, $this->personID, $this->departmentID, $this->dateTime, $this->statusID, $this->actionTaken, $this->id);
			$db->query($sql);
		}
	}

	/*
	*	given a report's id, looks up and sets the report's local vars
	* 	@param $id | int report ID in DB
	*	@return bool | only if lookup fails (not in DB)
	*/
	public function fetch($id){
		$db = new Database();
		$sql = "SELECT * FROM reports WHERE id=?";
		$sql = $db->prepareQuery($sql, $id);

		$results = $db->select($sql);

		if(count($results) != 0){
			$this->setID($id);
			$this->setDescription($results[0]['description']);
			$this->setInvolvementKindID($results[0]['involvementKindID']);
			$this->setReportKindID($results[0]['reportKindID']);
			$this->setLocationID($results[0]['locationID']);
			$this->setPersonID($results[0]['personID']);
			$this->setDepartmentID($results[0]['departmentID']);
			$this->setDateTime($results[0]['dateTime']);
			$this->setStatusID($results[0]['statusID']);
			$this->setActionTaken($results[0]['actionTaken']);
		} else return false;
	}

	/*
	*	check to see if a report exists on the DB (prevents accidental duplicates)
	*	
	*	@param $personID | int id of person submitting 
	*		$dateTime | datetime of report submission
	*
	*	@return bool | false if report doesn't exist,
	*		int | report id if does exist
	*/
	public static function reportExists($personID, $dateTime){
		$db = new Database();
		$sql = "SELECT * FROM `reports` WHERE `personID`=? AND `dateTime`=?";
		$sql = $db->prepareQuery($sql, $personID, $dateTime);
		$results = $db->select($sql);
		if(isset($results[0]['id'])){
			return $results[0]['id'];	
		} else return false;
	}

}

?>