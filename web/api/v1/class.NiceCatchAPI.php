<?php
require_once 'class.API.php';

class NiceCatchAPI extends API
{
    /*
    *   CONSTRUCTOR
    *   ENDPOINTS
    *       1.0 INVOLVEMENTS
    *       1.1 REPORT KINDS
    *       1.2 PERSON KINDS
    *       1.3 BUILDINGS
    *       1.4 DEPARTMENTS
    *       1.5 REPORTS
    *       1.6 REPORT (invisible)
    *   HELPERS
    *       2.0 SET UP PERSON
    *       2.1 SET UP LOCATION
    *       2.2 REQUEST FIELDS SUBMITTED
    *       2.3 VALIDATE PHOTO
    */    

    public function __construct($request, $origin) {
        parent::__construct($request);
    }

    //------------------------ INVOLVEMENTS ENDPOINT <1.0> ------------------------
    public function involvements(){
        if($this->method == 'GET'){
            //get a list of default involvement kinds
            return getDefaultInvolvements();
        } else if($this->method == 'POST'){
            if(isset($this->request['id']) && isset($this->request['involvementKind'])){
                //if the ID is set, editing an existing involvement
                return updateInvolvementKind($this->request['id'],$this->request['involvementKind']);
            } elseif(!isset($this->request['involvementKind'])){
                return "endpoint requires an involvementKind";
            } else {
                //new involvement (if not in DB)
                return array(
                    'id' => getInvolvementKindID($this->request['involvementKind']),
                    'involvementKind' => $this->request['involvementKind']
                );    
            }
        } else return "endpoint does not recognize " . $this->method . " requests";   
    }

    //------------------------ REPORT KINDS ENDPOINT <1.1> ------------------------
    public function reportKinds(){
        if($this->method == 'GET'){
            return getDefaultReportKinds();
        } else if($this->method == 'POST'){
            //if the ID is set, editing an existing reportKind
            if(isset($this->request['id']) && isset($this->request['reportKind'])){
                return updateReportKind($this->request['id'],$this->request['reportKind']);
            } elseif(!isset($this->request['reportKind'])){
                return "endpoint requires a reportKind";
            } else {
                //new report kind (if not in DB)
                return array(
                    'id' => getReportKindID($this->request['reportKind']),
                    'reportKind' => $this->request['reportKind']
                );                
            }
        } else return "endpoint does not recognize " . $this->method . " requests";   
        
    }

    //------------------------ PERSON KINDS ENDPOINT <1.2> ------------------------
    public function personKinds(){
        if($this->method == 'GET'){
            return getDefaultPersonKinds();
        } else if($this->method == 'POST'){
            //if the ID is set, editing an existing personKind
            if(isset($this->request['id']) && isset($this->request['personKind'])){
                return updatePersonKind($this->request['id'],$this->request['personKind']);
            } elseif(!isset($this->request['personKind'])){
                return "endpoint requires a personKind";
            } else {
                //new report kind (if not in DB)
                return array(
                    'id' => getPersonKind($this->request['personKind']),
                    'personKind' => $this->request['personKind']
                );                
            }
        } else return "endpoint does not recognize " . $this->method . " requests";   
    }

    //------------------------ BUILDINGS ENDPOINT <1.3> ------------------------
    public function buildings(){
        if($this->method == 'GET'){
            return getBuildings();
        } else return "endpoint does not recognize " . $this->method . " requests";   
    }

    //------------------------ DEPARTMENTS ENDPOINT <1.4> ------------------------
    public function departments(){
        if($this->method == 'GET'){
            return getDepartments();
        } else return "endpoint does not recognize " . $this->method . " requests";   
    }

    //------------------------ REPORTS ENDPOINT <1.5> ------------------------
    protected function reports(){
        //URI: /api/v1/reports
        if(!is_array($this->args) || count($this->args) == 0){
            return $this->reportsCollection();
        } else if(count($this->args) == 1){ //URI: /api/v1/reports/<ID>
            return $this->report();
        } else if(count($this->args) == 2 && $this->args[1] == 'photo') {
            //an individual photo's report
            return $this->reportPhoto();
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

    //------------------------ REPORT ENDPOINT (invisible) <1.6> ------------------------

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

    //handles uploading or getting a report's photo
    private function reportPhoto(){
        switch($this->method){
            case 'GET':
                return $this->reportPhotoGet();
            case 'POST':
                return $this->reportPhotoPost();
            default:
                return 'error: endpoint does not recognize ' . $this->method . ' requests';
        }

    }

    private function reportPhotoGet(){
        $report = $this->args[0];
    }

    private function reportPhotoPost(){
        if(!$this->validatePhoto()) return 'error: photo upload failed'; 
        $report = new Report();

        //fetch and check for valid report
        $report->fetch($this->args[0]);
        if($report->getID() == null){
            return 'error: failed to load report with id ' . $this->args[0];
        }

        //report id
        $reportID = $this->args[0];

        $photo = $this->files['photo'];
        $upload_dir = Path::uploads() . $reportID . '/';

        //make the directory if it doesn't already exist
        if(!file_exists($upload_dir)){
            mkdir($upload_dir, 0755, true);
        }

        //make sure there wasnt an error with the upload
        if($photo['error'] !== UPLOAD_ERR_OK){
            return 'error: photo upload error';
        }

        //make sure filename is safe
        $name = preg_replace("/[^A-Z0-9._-]/i", "_", $photo['name']);

        //different dir for each report
        $i = 0;
        $parts = pathinfo($name);
        while(file_exists($upload_dir . $name)){
            //myfile-1.png
            $name = $parts['filename'] . '-' . $i . '.' . $parts['extension'];
        }

        //move file from temp directory
        $success = move_uploaded_file($photo['tmp_name'], $upload_dir . $name);
        if(!$success){
            return 'error: unable to save file';
        }

        //set proper file permissions on new file
        chmod($upload_dir . $name, 0644);

        //update the report in DB with file location
        $report->setPhotoPath("" . $upload_dir . $name);
        $report->save();

        return $report->toArray();
    }

    //------------------------ HELPERS ------------------------

    /*  <2.0>
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

    /*  <2.1>
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

    /*  <2.2>
    *   checks if all necessary variables are set
    *   $vars is an array
    */
    private function requestFieldsSubmitted($vars){
        if(is_array($vars)){
            foreach($vars as $var){
                if(!isset($this->request[$var])) return false;
            }
            return true;
        }
        return false;
    }

    /*  <2.3>
    *   validates an image to make sure it is valid
    *   helps prevent incorrect uploads/malicious files
    */
    private function validatePhoto(){
        if(!empty($this->files['photo'])){
            $photo = $this->files['photo'];
            
            //verify file is correct type (gif, jpeg, png)
            $filetype = exif_imagetype($photo['tmp_name']);
            $allowed = array(IMAGETYPE_GIF, IMAGETYPE_JPEG, IMAGETYPE_PNG);
            if(in_array($filetype, $allowed)){
                return true;
            }
        }
        return false;
    }
 }
 ?>