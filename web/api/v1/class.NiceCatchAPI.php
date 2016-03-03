<?php
require_once 'class.API.php';

class NiceCatchAPI extends API
{
    public function __construct($request, $origin) {
        parent::__construct($request);

        // Abstracted out for example
        /*
        $APIKey = new Models\APIKey();
        $User = new Models\User();

        if (!array_key_exists('apiKey', $this->request)) {
            throw new Exception('No API Key provided');
        } else if (!$APIKey->verifyKey($this->request['apiKey'], $origin)) {
            throw new Exception('Invalid API Key');
        } else if (array_key_exists('token', $this->request) &&
             !$User->get('token', $this->request['token'])) {

            throw new Exception('Invalid User Token');
        }

        $this->User = $User;*/

        // if(is_array($this->args)){
        //      echo "ARGS ";
        //      print_r($this->args);
        //      echo "\n";
        // } else echo "ARGS " . $this->args . "\n";
    
        // echo "ENDPOINT " . $this->endpoint . "\n";
        
        // echo "REQUEST " . $this->request . "\n";
        //if(is_array($this->request)) print_r($this->request);

        // echo "FILE " . $this->file . "\n";
        
        // echo "VERB " . $this->verb . "\n";
    }

    //------------------------ INVOLVEMENTS ENDPOINT ------------------------
    public function involvements(){
        if($this->method == 'GET'){
            return getDefaultInvolvements();
        } else if($this->method == 'POST'){
            //if the ID is set, editing an existing involvement
            if(isset($this->request['id']) && isset($this->request['involvementKind'])){
                return updateInvolvementKind($this->request['id'],$this->request['involvementKind']);
            } elseif(!isset($this->request['involvementKind'])){
                return "endpoint requires an involvementKind";
            }

            //new involvement (if not in DB)
            return array(
                'id' => getInvolvementKindID($this->request['involvementKind']),
                'involvementKind' => $this->request['involvementKind']
            );
        } else return "endpoint does not recognize " . $this->method . " requests";   
    }

    public function reportKinds(){
        if($this->method == 'GET'){
            return getDefaultReportKinds();
        } else if($this->method == 'POST'){
            //if the ID is set, editing an existing reportKind
            if(isset($this->request['id']) && isset($this->request['reportKind'])){
                return updateReportKind($this->request['id'],$this->request['reportKind']);
            } elseif(!isset($this->request['reportKind'])){
                return "endpoint requires a reportKind";
            }

            //new report kind (if not in DB)
            return array(
                'id' => getReportKindID($this->request['reportKind']),
                'reportKind' => $this->request['reportKind']
            );
        } else return "endpoint does not recognize " . $this->method . " requests";   
        
    }

    public function personKinds(){
        if($this->method == 'GET'){
            return getDefaultPersonKinds();
        } else if($this->method == 'POST'){
            //if the ID is set, editing an existing personKind
            if(isset($this->request['id']) && isset($this->request['personKind'])){
                return updatePersonKind($this->request['id'],$this->request['personKind']);
            } elseif(!isset($this->request['personKind'])){
                return "endpoint requires a personKind";
            }

            //new report kind (if not in DB)
            return array(
                'id' => getPersonKind($this->request['personKind']),
                'personKind' => $this->request['personKind']
            );
        } else return "endpoint does not recognize " . $this->method . " requests";   




    }

    public function buildings(){
        if($this->method == 'GET'){
            return getBuildings();
        } else if ($this->method == 'POST'){
            return "POST -- ADD NEW BUILDING";
        } else return "endpoint does not recognize " . $this->method . " requests";
    }

    public function departments(){
        if($this->method == 'GET'){
            return getDepartments();
        } else if ($this->method == 'POST'){
            return "POST -- ADD NEW DEPARTMENT";
        } else return "endpoint does not recognize " . $this->method . " requests";
    }

    //------------------------ reports ENDPOINT ------------------------
    protected function reports(){
        //URI: /api/v1/reports
        if(!is_array($this->args) || count($this->args) == 0){
            return $this->reportsCollection();
        } else if(count($this->args) == 1){ //URI: /api/v1/reports/<ID>
            return $this->report();
        } else {
            return "IMPROPER API CALL";
        }
    }

    //handler for API call to the reports collection
    private function reportsCollection(){
        if($this->method == 'GET'){
            return "REPORTS COLLECTION (GET)";
        } else if($this->method == 'POST'){
            return "REPORTS COLLECTION (POST)";
        } else if ($this->method == 'DELETE'){
            return "REPORTS COLLECTION (DELETE)";
        } else return "endpoint does not recognize " . $this->method . " requests";
    }

    //------------------------ REPORT endpoint (invisible) ------------------------

    //handler for API call to a single note
    private function report(){
        if($this->method == 'GET'){
            return "SINGLE REPORT (GET)";
        } else if($this->method == 'POST'){
            return "SINGLE REPORT (POST)";
        } else if ($this->method == 'DELETE'){
            return "SINGLE REPORT (DELETE)";
        }
    }

    //parse out args and make a new report
    private function reportPost(){
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

    //------------------------ USER ENDPOINT ------------------------

    
 }
 ?>