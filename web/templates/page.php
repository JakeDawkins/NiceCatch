<?php
	require_once(dirname(dirname(__FILE__)) . '/models/config.php');
	
	$response = json_decode(CallAPI("GET","https://people.cs.clemson.edu/~jacksod/api/v1/buildings"));
	print_r($response);


?>


<?php include('header.php'); ?>
<!-- in .container div -->

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
	  	<tr>
	  		<td>2016-04-01 10:00:01</td>
	  		<td>this is a test of the report description</td>
	  		<td>McAdams Hall<br />Room 100</td>
	  		<td>Jake Dawkins<br />jacksod<br />555-555-5555</td>
	  	</tr>
	  	<tr>
	  		<td>2016-04-01 10:00:01</td>
	  		<td>this is a test of the report description</td>
	  		<td>McAdams Hall<br />Room 100</td>
	  		<td>Jake Dawkins<br />jacksod<br />555-555-5555</td>
	  	</tr>
	</tbody>  	
</table>

<?php include('footer.php'); ?>