<?php
require_once('../models/Path.php');
require_once(Path::models() . 'config.php');

class LocationTest extends PHPUnit_Framework_TestCase {

	private $testLoc;

	public function setUp(){
		$this->testLoc = new Location();
		$this->testLoc->setID(99);
		$this->testLoc->setBuildingID(1);
		//$this->testLoc->setDepartmentID(2);
		//$this->testLoc->setDateTime("2016-01-31 12:21:32");
		$this->testLoc->setRoom(100);
	}

	public function tearDown(){
		unset($this->testLoc);
	}

	/*
	* 	IF THIS FAILS, CHECK SETTERS
	*/
	public function testGetters(){
		$this->assertEquals(99,$this->testLoc->getID());
		$this->assertEquals(1,$this->testLoc->getBuildingID());
		//$this->assertEquals(2,$this->testLoc->getDepartmentID());
		//$this->assertEquals("2016-01-31 12:21:32",$this->testLoc->getDateTime());
		$this->assertEquals(100,$this->testLoc->getRoom());
	}

	/*
	*	@preq: building with ID 1 has a room 100 location in DB
	*/
	public function testLocationExists(){
		$this->assertTrue(Location::locationExists(1,100) == 1); //id of this is 1
		$this->assertTrue(!Location::locationExists(0,0));
	}
}

?>