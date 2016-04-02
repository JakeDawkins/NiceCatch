<?php
	//$response = json_decode(file_get_contents('https://people.cs.clemson.edu/~jacksod/api/v1/involvements'));
	//print_r($response);

	$response = CallAPI("GET","https://people.cs.clemson.edu/~jacksod/api/v1/buildings");
	var_dump($response);

// Method: POST, PUT, GET etc
// Data: array("param" => "value") ==> index.php?param=value
function CallAPI($method, $url, $data = false){
    $curl = curl_init();

    switch ($method)
    {
        case "POST":
            curl_setopt($curl, CURLOPT_POST, 1);

            if ($data)
                curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
            break;
        case "PUT":
            curl_setopt($curl, CURLOPT_PUT, 1);
            break;
        default:
            if ($data)
                $url = sprintf("%s?%s", $url, http_build_query($data));
    }

    // Optional Authentication:
    curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
    curl_setopt($curl, CURLOPT_USERPWD, "username:password");

    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

    $result = curl_exec($curl);

    curl_close($curl);

    return $result;
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	<title>NiceCatch Admin</title>

	<!-- Bootstrap -->
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

	<!-- Optional theme -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->

	<style>
		html {
			position: relative;
			min-height: 100%;
		}

		body {
			margin-bottom: 60px;
			padding-top: 60px; /* for fixed nav */
		}

		footer {
			height: 60px;
			position: absolute;
			bottom: 0;
		}


	</style>
</head>
<body>
    <!-- Fixed navbar -->
    <nav class="navbar navbar-default navbar-fixed-top">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
				    <span class="sr-only">Toggle navigation</span>
				    <span class="icon-bar"></span>
				    <span class="icon-bar"></span>
				    <span class="icon-bar"></span>
				</button>
			  	<a class="navbar-brand" href="#">Nice Catch</a>
			</div>
			<div id="navbar" class="collapse navbar-collapse">
			  	<ul class="nav navbar-nav">
			    	<li class="active"><a href="#">All</a></li>
			    	<li><a href="#about">New</a></li>
			    	<li><a href="#contact">Closed</a></li>
			  	</ul>
			</div><!--/.nav-collapse -->
		</div>
    </nav>

    <!-- Begin page content -->
    <div class="container">
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