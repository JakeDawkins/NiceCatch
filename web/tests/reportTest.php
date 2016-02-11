<?php
require_once('../models/Path.php');
require_once(Path::models() . 'config.php');

class ReportTest extends PHPUnit_Framework_TestCase {

	private $testReport;

	public function setUp(){
		$this->testReport = new Report();
		$this->testReport->setID(99);
		$this->testReport->setDescription("test desc");
		$this->testReport->setInvolvementKindID(2);
		$this->testReport->setReportKindID(1);
		$this->testReport->setLocationID(12);
		$this->testReport->setPersonID(100);
		$this->testReport->setDepartmentID(2);
		$this->testReport->setDateTime("2016-01-31 12:21:32");
		$this->testReport->setStatusID(2);
		$this->testReport->setActionTaken("nothing has been done");
	}

	public function tearDown(){
		unset($this->testReport);
	}

	/*
	* 	IF THIS FAILS, CHECK SETTERS
	*/
	public function testGetters(){
		$this-> assertEquals(99, $this->testReport->getID());
		$this-> assertEquals("test desc", $this->testReport->getDescription("test desc"));
		$this-> assertEquals(2, $this->testReport->getInvolvementKindID());
		$this-> assertEquals(1, $this->testReport->getReportKindID());
		$this-> assertEquals(12, $this->testReport->getLocationID());
		$this-> assertEquals(100, $this->testReport->getPersonID());
		$this-> assertEquals(2,$this->testReport->getDepartmentID());
		$this-> assertEquals("2016-01-31 12:21:32",$this->testReport->getDateTime());
		$this-> assertEquals(2, $this->testReport->getStatusID());
		$this-> assertEquals("nothing has been done",$this->testReport->getActionTaken());
	}
}

?>