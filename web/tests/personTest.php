<?php
require_once('../models/Path.php');
require_once(Path::models() . 'config.php');

class LocationTest extends PHPUnit_Framework_TestCase {

	private $testPerson;

	public function setUp(){
		$this->testPerson = new Person();
		$this->testPerson->setID(99);
		$this->testPerson->setPersonKindID(1);
		$this->testPerson->setPersonKind("Faculty");
		$this->testPerson->setUsername("myusername");
		$this->testPerson->setName("john doe");
		$this->testPerson->setPhone("555-555-5555");
	}

	public function tearDown(){
		unset($this->testPerson);
	}

	/*
	* 	IF THIS FAILS, CHECK SETTERS
	*/
	public function testGetters(){
		$this-> assertEquals(99,$this->testPerson->getID());
		$this-> assertEquals(1,$this->testPerson->getPersonKindID());
		$this-> assertEquals("myusername",$this->testPerson->getUsername());
		$this-> assertEquals("john doe",$this->testPerson->getName());
		$this->assertEquals("Faculty", $this->testPerson->getPersonKind());
		$this-> assertEquals("555-555-5555",$this->testPerson->getPhone());
	}


}

?>