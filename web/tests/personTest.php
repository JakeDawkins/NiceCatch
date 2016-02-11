<?php
require_once('../models/Path.php');
require_once(Path::models() . 'config.php');

class LocationTest extends PHPUnit_Framework_TestCase {

	private $testPerson;

	public function setUp(){
		$this->testPerson = new Person();
		$this->testPerson->setID(99);
		$this->testPerson->setPersonKindID(1);
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
		$this-> assertEquals("555-555-5555",$this->testPerson->getPhone());
	}

	/*
	*	@preq: user with username "bob" has ID 1 in DB.
	*/
	public function testPersonExists(){
		$this->assertTrue(Person::personExists("bob") == 1);
		$this->assertTrue(!Person::personExists("12345"));
	}
}

?>