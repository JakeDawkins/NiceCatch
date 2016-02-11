<?php
require_once('../models/Path.php');
require_once(Path::models() . 'config.php');

class ReportTest extends PHPUnit_Framework_TestCase {

	private $testReport;
	private $db;

	public function setUp(){
		$this->db = new Database();

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
		$this-> assertEquals("test desc", $this->testReport->getDescription());
		$this-> assertEquals(2, $this->testReport->getInvolvementKindID());
		$this-> assertEquals(1, $this->testReport->getReportKindID());
		$this-> assertEquals(12, $this->testReport->getLocationID());
		$this-> assertEquals(100, $this->testReport->getPersonID());
		$this-> assertEquals(2,$this->testReport->getDepartmentID());
		$this-> assertEquals("2016-01-31 12:21:32",$this->testReport->getDateTime());
		$this-> assertEquals(2, $this->testReport->getStatusID());
		$this-> assertEquals("nothing has been done",$this->testReport->getActionTaken());
	}

	/*
	*	@preq: report with person ID 1 with timedate 2016-02-09 00:00:01 in DB with ID 1 
	*/
	public function testReportExists(){
		$this->assertTrue(Report::reportExists(1, "2016-02-09 00:00:01") == 1);
		$this->assertTrue(!Report::reportExists(0,"2016-02-09 00:00:01"));
	}

	public function testFetch(){
		$rep = new Report();

		//test successful lookup
		$rep->fetch(1);
		$this-> assertEquals(1, $rep->getID());
		$this-> assertEquals("this is a test", $rep->getDescription());
		$this-> assertEquals(2, $rep->getInvolvementKindID());
		$this-> assertEquals(1, $rep->getReportKindID());
		$this-> assertEquals(1, $rep->getLocationID());
		$this-> assertEquals(1, $rep->getPersonID());
		$this-> assertEquals(2, $rep->getDepartmentID());
		$this-> assertEquals("2016-02-09 00:00:01", $rep->getDateTime());
		$this-> assertEquals(null, $rep->getStatusID());
		$this-> assertEquals(null, $rep->getActionTaken());

		//test failed lookup
		$this->assertTrue(!$rep->fetch(0));
	}

	public function testSave(){
		$rep = new Report();
		$now = date("Y-m-d H:i:s");

		$rep->setDescription("test desc");
		$rep->setInvolvementKindID(2);
		$rep->setReportKindID(1);
		$rep->setLocationID(1);
		$rep->setPersonID(1);
		$rep->setDepartmentID(2);
		$rep->setDateTime($now);
		$rep->setStatusID(2);
		$rep->setActionTaken("nothing has been done");
		$rep->save();

		$this->assertTrue($rep->getID() != NULL);
		
		$fetched = new Report();
		$fetched->fetch($rep->getID());

		$this-> assertEquals($rep->getID(), $fetched->getID());
		$this-> assertEquals($rep->getDescription(), $fetched->getDescription());
		$this-> assertEquals($rep->getInvolvementKindID(), $fetched->getInvolvementKindID());
		$this-> assertEquals($rep->getReportKindID(), $fetched->getReportKindID());
		$this-> assertEquals($rep->getLocationID(), $fetched->getLocationID());
		$this-> assertEquals($rep->getPersonID(), $fetched->getPersonID());
		$this-> assertEquals($rep->getDepartmentID(), $fetched->getDepartmentID());
		$this-> assertEquals($rep->getDateTime(), $fetched->getDateTime());
		$this-> assertEquals($rep->getStatusID(), $fetched->getStatusID());
		$this-> assertEquals($rep->getActionTaken(), $fetched->getActionTaken());

		//delete from DB for cleanup
		//TODO -- replace with proper delete method
		$sql = "DELETE FROM `reports` WHERE id=?";
		$sql = $this->db->prepareQuery($sql, $rep->getID());
		$this->db->query($sql);
	}
}

?>