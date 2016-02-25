<?php
//REPORT CONTROLLER

class ReportController
{
    private $_params;
     
    public function __construct($params){
        $this->_params = $params;
    }
    
    /*
    public function createAction(){
    	$report = new Report();
		$report->setDescription($this->_params['description']);

        //given name. get id
		$report->setInvolvementKindID(getInvolvementKindID($this->_params['involvementKind']));

        //given name. get id
		$report->setReportKindID(getReportKindID($this->_params['reportKind']));
        
        //set up location
        $loc = new Location();
        
            $buildingID = Location::lookupBuildingID($this->_params['buildingName']);
            if($buildingID == false){
                return array('error' => 'invalid building name');
            }

            $loc->setBuildingID($buildingID);
            $loc->setRoom($this->_params['room']);
            $loc->save(); //creates new location if necessary. sets id

		$report->setLocationID($loc->getID());
		$report->setPersonID($this->_params['personID']);

        //given dept name. get id
		$report->setDepartmentID(getDepartmentID($this->_params['department']));
		
        $report->setDateTime($this->_params['dateTime']);
		$report->setStatusID($this->_params['statusID']);
		$report->setActionTaken($this->_params['actionTaken']);
		$report->save();

	    //return the report item in array format
	    return $report->toArray();
    }
     
    public function getAction(){
        $report = new Report();
        $report->fetch($this->_params['id']);

        if($report->getID() == null){
        	return array('error' => 'fetch failed');
        } else return $report->toArray();
    }
     
    public function updateAction(){
        $report = new Report();
        $report->setID($this->_params['id']);
		$report->setDescription($this->_params['description']);
		$report->setInvolvementKindID($this->_params['involvementKindID']);
		$report->setReportKindID($this->_params['reportKindID']);
		$report->setLocationID($this->_params['locationID']);
		$report->setPersonID($this->_params['personID']);
		$report->setDepartmentID($this->_params['departmentID']);
		$report->setDateTime($this->_params['dateTime']);
		$report->setStatusID($this->_params['statusID']);
		$report->setActionTaken($this->_params['actionTaken']);
		$report->save();

	    //return the report item in array format
	    return $report->toArray();

    }
     
    public function deleteAction(){
        $report = new Report();
        $report->fetch($this->_params['id']);
        $report->delete();

        if(Report::reportExists($report->getPersonID(), $report->getDateTime()) != false){ //failed
        	return Array('delete' => 'false');
        } else {
        	return Array('delete' => 'true');	
        }
    }*/


    //post for NEW/UPDATED objects
    public function post(){
        $report = new Report();
        //update if an id exists
        if(isset($this->_params['id'])){
            $report->setID($this->_params['id']);
            echo "ID: " . $this->_params['id'] . "\n";
        }

        $report->setDescription($this->_params['description']);

        //given name. get id
        $report->setInvolvementKindID(getInvolvementKindID($this->_params['involvementKind']));

        //given name. get id
        $report->setReportKindID(getReportKindID($this->_params['reportKind']));
        
        //set up location
        $loc = new Location();
        
            $buildingID = Location::lookupBuildingID($this->_params['buildingName']);
            if($buildingID == false){
                return array('error' => 'invalid building name');
            }

            $loc->setBuildingID($buildingID);
            $loc->setRoom($this->_params['room']);
            $loc->save(); //creates new location if necessary. sets id

        $report->setLocationID($loc->getID());
        $report->setPersonID($this->_params['personID']);

        //given dept name. get id
        $report->setDepartmentID(getDepartmentID($this->_params['department']));
        
        $report->setDateTime($this->_params['dateTime']);
        $report->setStatusID($this->_params['statusID']);
        $report->setActionTaken($this->_params['actionTaken']);
        $report->save();

        //return the report item in array format
        return $report->toArray();
    }
    
    //get for old objects
    public function get(){
        $report = new Report();
        $report->fetch($this->_params['id']);

        if($report->getID() == null){
            return array('error' => 'fetch failed');
        } else return $report->toArray();
    }
     
    //put for updates
    public function put(){
        $report = new Report();
        $report->setID($this->_params['id']);
        $report->setDescription($this->_params['description']);
        $report->setInvolvementKindID($this->_params['involvementKindID']);
        $report->setReportKindID($this->_params['reportKindID']);
        $report->setLocationID($this->_params['locationID']);
        $report->setPersonID($this->_params['personID']);
        $report->setDepartmentID($this->_params['departmentID']);
        $report->setDateTime($this->_params['dateTime']);
        $report->setStatusID($this->_params['statusID']);
        $report->setActionTaken($this->_params['actionTaken']);
        $report->save();

        //return the report item in array format
        return $report->toArray();
    }
     
    //removes with given id
    public function delete(){
        print_r($this->_params);
        echo "ID: " . $this->_params['id'] . "\n";
        $report = new Report();
        $report->fetch($this->_params['id']);
        $report->delete();

        if(Report::reportExists($report->getPersonID(), $report->getDateTime()) != false){ //failed
            return Array('delete' => 'false');
        } else {
            return Array('delete' => 'true');   
        }
    }
}

?>