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
        } else return "endpoint does not recognize " . $this->method . " requests";   
    }

    public function departments(){
        if($this->method == 'GET'){
            return getDepartments();
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
        if($this->method == 'POST'){
            return $this->reportPost();
        } else return "endpoint does not recognize " . $this->method . " requests";
    }

    //------------------------ REPORT endpoint (invisible) ------------------------

    //handler for API call to a single note
    private function report(){
        if($this->method == 'GET'){
            return "SINGLE REPORT (GET)";
        } else if($this->method == 'POST'){
            return "UPDATE REPORT (POST)";
        } else if ($this->method == 'DELETE'){
            return "SINGLE REPORT (DELETE)";
        }
    }

    //parse out args and make a new report
    private function reportPost(){
        $report = new Report();

        //update if an id exists
        if(isset($this->request['id'])){
            $report->setID($this->request['id']);
        }

        $report->setDescription($this->request['description']);

        //given name. get id
        $report->setInvolvementKindID(getInvolvementKindID($this->request['involvementKind']));

        //given name. get id
        $report->setReportKindID(getReportKindID($this->request['reportKind']));
        
        //set up location
        if(!$this->requestFieldsSubmitted(["buildingName","room"]))
            return "error: missing location information";
        $locID = $this->setUpLocation();
        if($locID != -1) $report->setLocationID($locID);
        else return "error: invalid location information";

        //set up person
        if(!$this->requestFieldsSubmitted(["personKind","username","name","phone"]))
            return "error: missing person information";
        $personID = $this->setUpPerson();
        if($personID != -1) $report->setPersonID($personID);
        else return "error: invalid person data";

        //given dept name. get id
        $report->setDepartmentID(getDepartmentID($this->request['department']));
        
        $report->setDateTime($this->request['dateTime']);
        $report->setStatusID($this->request['statusID']);
        $report->setActionTaken($this->request['actionTaken']);
        $report->save();

        //return the report item in array format
        return $report->toArray();
    }

    //------------------------ HELPERS ------------------------

    /*
    *   creates a person using request data
    *   @preq personKind, username, name, and phone are set
    *   @ret int | person id if valid request data, -1 otherwise
    */
    private function setUpPerson(){
        $person = new Person();
        
        $person->setPersonKindID(getPersonKindID($this->request['personKind']));
        $person->setUsername($this->request['username']);
        $person->setName($this->request['name']);
        $person->setPhone($this->request['phone']);
        $person->save();

        return $person->getID();
    }

    /*
    *   creates a location using request data
    *   @ret int | location id if valid request data, -1 otherwise
    */
    private function setUpLocation(){
        $location = new Location();

        $buildingID = Location::lookupBuildingID($this->request['buildingName']);
        if($buildingID == false){ 
            //building not found
            return -1;
        }

        $location->setBuildingID($buildingID);
        $location->setRoom($this->request['room']);
        $location->save(); //creates new location if necessary. sets id

        return $location->getID();
    }

    //checks if all necessary variables are set
    //$vars is an array
    private function requestFieldsSubmitted($vars){
        if(is_array($vars)){
            foreach($vars as $var){
                if(!isset($this->request[$var])) return false;
            }
            return true;
        }
        return false;
    }
 }
 ?>