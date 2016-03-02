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
        //     echo "ARGS ";
        //     print_r($this->args);
        //     echo "\n";
        // } else echo "ARGS " . $this->args . "\n";
    
        // echo "ENDPOINT " . $this->endpoint . "\n";
        
        // echo "REQUEST " . $this->request . "\n";
        // if(is_array($this->request)) print_r($this->request);

        // echo "FILE " . $this->file . "\n";
        
        //echo "VERB " . $this->verb . "\n";
    }

    //------------------------ INFO LOADERS ENDPOINTS ------------------------
    public function involvements(){
        if($this->method == 'GET'){
            return getDefaultInvolvements();
        } else if($this->method == 'PUT'){
            return "PUT -- ADD NEW INVOLVEMENT";
        } else return "endpoint does not recognize " . $this->method . " requests";   
    }

    public function reportKinds(){
        if($this->method == 'GET'){
            return getDefaultReportKinds();
        } else if ($this->method == 'PUT'){
            return "PUT -- ADD NEW REPORT KIND";
        } else return "endpoint does not recognize " . $this->method . " requests";
        
    }

    public function personKinds(){
        if($this->method == 'GET'){
            return getDefaultPersonKinds();
        } else if ($this->method == 'PUT'){
            return "PUT -- ADD NEW PERSON KIND";
        } else return "endpoint does not recognize " . $this->method . " requests";
    }

    public function buildings(){
        if($this->method == 'GET'){
            return getBuildings();
        } else if ($this->method == 'PUT'){
            return "PUT -- ADD NEW BUILDING";
        } else return "endpoint does not recognize " . $this->method . " requests";
    }

    public function departments(){
        if($this->method == 'GET'){
            return getDepartments();
        } else if ($this->method == 'PUT'){
            return "PUT -- ADD NEW DEPARTMENT";
        } else return "endpoint does not recognize " . $this->method . " requests";
    }

    //------------------------ reports ENDPOINT ------------------------
    protected function reports(){
        //URI: /api/v1/reports
        if(!is_array($this->args) || count($this->args) == 0){
            return $this->reportsCollection();
        } else if(count($this->args) == 1){ //URI: /api/v1/reports/<ID>
            return $this->reportsElement();
        } else {
            return "IMPROPER API CALL";
        }
    }

    //handler for API call to the reports collection
    private function reportsCollection(){
        if($this->method == 'GET'){
            return "REPORTS COLLECTION (GET)";
        } else if($this->method == 'PUT'){
            return "REPORTS COLLECTION (PUT)";
        } else if ($this->method == 'DELETE'){
            return "REPORTS COLLECTION (DELETE)";
        } else return "endpoint does not recognize " . $this->method . " requests";
    }

    //handler for API call to a single note
    private function reportsElement(){
        if($this->method == 'GET'){
            return "SINGLE REPORT (GET)";
        } else if($this->method == 'PUT'){
            return "SINGLE REPORT (PUT)";
        } else if ($this->method == 'DELETE'){
            return "SINGLE REPORT (DELETE)";
        }
    }

    //------------------------ USER ENDPOINT ------------------------

    
 }
 ?>