<?php
	require_once(dirname(dirname(__FILE__)) . '/models/config.php');
	
	$reports = json_decode(CallAPI("GET","https://people.cs.clemson.edu/~jacksod/api/v1/reports?filter=new"), true)['data'];

	//expand report location and person to show details, not just ID
	if(is_array($reports)){

		for($i = 0; $i < count($reports); $i++){
			$person = new Person();
			$person->fetch($reports[$i]['personID']);

			$reports[$i]['personKind'] = $person->getPersonKindName();
			$reports[$i]['personName'] = $person->getName();
			$reports[$i]['personUsername'] = $person->getUsername(); 
			$reports[$i]['personPhone'] = $person->getPhone();

			$location = new Location();
			$location->fetch($reports[$i]['locationID']);

			$reports[$i]['locationBuilding'] = $location->getBuildingName();
			$reports[$i]['locationRoom'] = $location->getRoom(); 
		}
	}

	//var_dump($reports);
?>


<?php include('header.php'); ?>
<!-- in .container div -->

<div class='row'>
	<div class='col-sm-12'>
		<div class="page-header">
			<h1>All NiceCatch Reports</h1>
		</div>

		<!-- reports table -->
		<table class="table table-striped">
			<thead>
				<tr>
		  		<th>Time</th>
		  		<th>Description</th>
		  		<th>Location</th>
		  		<th>Person</th>
		  	</tr>
			</thead>
			<tbody>
				<?php
				if(is_array($reports)){
					foreach($reports as $report){
						echo '<tr>' .
							'<td>' . $report['dateTime'] . '</td>' .
							'<td>' . $report['description'] . '</td>' .
							'<td>' . 
								$report['locationBuilding'] . '<br />' . 
								$report['locationRoom'] . 
							'</td>' .
							'<td>' . 
								$report['personName'] . '<br />' . 
								$report['personUsername'] . ' (' . $report['personKind'] . ')<br />' . 
								$report['personPhone'] . '</td>' .
							'</tr>';
					}
				}
				?>
			</tbody>  	
		</table>
	</div> <!-- end col -->
</div> <!-- end row -->


<?php include('footer.php'); ?>