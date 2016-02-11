<?php
require_once('../models/Path.php');
require_once(Path::models() . 'config.php');

class LocationTest extends PHPUnit_Framework_TestCase {

	private $testLoc;
	private $db;

	public function setUp(){
		$this->db = new Database();

		$this->testLoc = new Location();
		$this->testLoc->setID(99);
		$this->testLoc->setBuildingID(1);
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
		$this->assertEquals(100,$this->testLoc->getRoom());
	}

	/*
	*	@preq: building with ID 1 has a room 100 location in DB
	*/
	public function testLocationExists(){
		$this->assertTrue(Location::locationExists(1,100) == 1); //id of this is 1
		$this->assertTrue(!Location::locationExists(0,0));
	}

	/*
	*	@preq: location with id 1 has building id 1 and room 100
	*/
	public function testFetch(){
		$loc = new Location();
		$loc->fetch(1);

		$this->assertEquals(1, $loc->getID());
		$this->assertEquals(1, $loc->getBuildingID());
		$this->assertEquals(100, $loc->getRoom());
	}

	/*
	*	TODO -- test other cases (already exists)
	*/
	public function testSave(){
		$loc = new Location();
		$loc->setBuildingID(1);
		$loc->setRoom(9999);
		$loc->save();

		$this->assertTrue($loc->getID() != NULL);

		$fetched = new Location();
		$fetched->fetch($loc->getID());

		$this->assertEquals($fetched->getID(), $loc->getID());
		$this->assertEquals($fetched->getBuildingID(), $loc->getBuildingID());
		$this->assertEquals($fetched->getRoom(), $loc->getRoom());

		//delete from DB for cleanup
		//TODO -- replace with proper delete method
		$sql = "DELETE FROM `locations` WHERE id=?";
		$sql = $this->db->prepareQuery($sql, $loc->getID());
		$this->db->query($sql);
	}
}

?>