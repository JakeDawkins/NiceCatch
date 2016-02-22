<?php
//LOADER CONTROLLER -- used for loading data for app displays

class LoaderController
{
    private $_params;
     
    public function __construct($params){
        $this->_params = $params;
    }
     
    public function getDefaultInvolvementsAction(){
        return getDefaultInvolvements();
    }

    public function getDefaultReportKindsAction(){
        return getDefaultReportKinds();
    }

    public function getDefaultPersonKindsAction(){
        return getDefaultPersonKinds();
    }

    public function getBuildingsAction(){
        return getBuildings();
    }

    public function getDepartmentsAction(){
        return getDepartments();
    }
}

?>