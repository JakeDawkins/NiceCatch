<?php
require_once(dirname(dirname(__FILE__)) . "/models/config.php");

class PersonTest extends PHPUnit_Framework_TestCase {

	private $testPerson;
	private $db;

	public function setUp(){
		$this->db = new Database();
		
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

	/*
	*	@preq: user with id 1 has name Tommy, username bob, no phone, and person kind 1
	*/
	public function testFetch(){
		$person = new Person();
		$person->fetch(1);

		$this->assertEquals("bob", $person->getUsername());
		$this->assertEquals("Tommy", $person->getName());
		$this->assertEquals(null, $person->getPhone());
		$this->assertEquals(1, $person->getPersonKindID()); 
	}

	/*
	*	TODO -- test other cases (already exists)
	*/
	public function testSave(){
		$person = new Person();
		$person->setPersonKindID(1);
		$person->setUsername("timmy");
		$person->setName("Timothy");
		$person->setPhone("000-101-1010");
		$person->save();

		$this->assertTrue($person->getID() != NULL);
		
		$fetched = new Person();
		$fetched->fetch($person->getID());

		$this->assertEquals($person->getID(), $fetched->getID());
		$this->assertEquals($person->getPersonKindID(), $fetched->getPersonKindID());
		$this->assertEquals($person->getUsername(), $fetched->getUsername());
		$this->assertEquals($person->getName(), $fetched->getName());
		$this->assertEquals($person->getPhone(), $fetched->getPhone());

		//delete from DB for cleanup
		//TODO -- replace with proper delete method
		$sql = "DELETE FROM `people` WHERE id=?";
		$sql = $this->db->prepareQuery($sql, $person->getID());
		$this->db->query($sql);
	}
}

?>