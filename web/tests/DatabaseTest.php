<?php
require_once(dirname(dirname(__FILE__)) . "/models/config.php");

class DatabaseTest extends PHPUnit_Framework_TestCase {

	//database object to be used by all tests
	private $db;

	public function setUp(){
		$this->db = new Database();
	}
	public function tearDown(){
		unset($this->db);
	}

	//------------------------ TESTS ------------------------

	public function testConnectSuccess(){
		$mysqli = $this->db->connect();
		$this->assertTrue($mysqli != false);
	}

	public function testPrepareQuery(){
		$sql = $this->db->prepareQuery("SELECT * FROM `table` WHERE `field1` = ? AND `field2` = ? AND ? AND `field3` = ?","lol 'WUT'", 13, true, null);
		$this->assertEquals($sql, "SELECT * FROM `table` WHERE `field1` = 'lol \'WUT\'' AND `field2` = 13 AND TRUE AND `field3` = NULL");

		$sql = $this->db->prepareQuery('UPDATE `some_table` SET `some_column` = ?, `some_other_column` = ?, `some_id` = ? WHERE `item` = ?', '20', 21, 69, 'this_val');
		$this->assertEquals($sql, "UPDATE `some_table` SET `some_column` = '20', `some_other_column` = 21, `some_id` = 69 WHERE `item` = 'this_val'");
	}

	/*
	*	@prereq: must be records in buildings
	*/
	public function testQuery(){
		$sql = "SELECT * FROM `buildings`";
		$result = $this->db->query($sql)->num_rows;
		$this->assertTrue($result > 0); 
	}

	/*
	*	@preq: must be records in buildings where record with id=1 has buildingName of "Bracket Hall"
	*		first record in locations has room of 100
	*/
	public function testSelect(){
		$sql = "SELECT buildingName FROM buildings WHERE id=1";
		$result = $this->db->select($sql);
		$this->assertEquals("Brackett Hall",$result[0]['buildingName']);

		$sql = "SELECT * FROM locations";
		$result = $this->db->select($sql);
		$this->assertTrue(count($result) > 0);
		$this->assertEquals(100, $result[0]['room']);
	}
}
?>