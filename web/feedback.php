<?php 
header('Location: http://goo.gl/forms/6XmDVnV34U');

//names -- description, device
/*
require_once(dirname(__FILE__) . '/models/config.php');

if($_SERVER["REQUEST_METHOD"] == "POST"){
	$description = '';
	if(isset($_POST['description']) && $_POST['description'] != ''){
		$description = test_input($_POST['description']);
	} else {
		$errors[] = 'Please enter a bug description.';
	}

	$device = '';
	if(isset($_POST['device'])){
		$device = test_input($_POST['device']);
	} else {
		$errors[] = 'device not selected';
	}

	//process
	if(!empty($description) && !empty($device)){
		$db = new Database();
		$sql = 'INSERT INTO `feedback`(`description`,`device`) VALUES(?,?)';
		$sql = $db->prepareQuery($sql, $description, $device);
		$db->query($sql);

		$successes[] = 'Thank you for your feedback.';
		$description = ''; //reset
	}
}
*/
?>

<!--
<!DOCTYPE html>
<html>
<head>
	<title>Nice Catch Feedback</title>
	<style>
		body {
			background-color: #FFE0B2;
			font-family: sans-serif;
		}

		.container {
			width: 700px;
			margin: 25px auto 0 auto;
			padding: 10px 0;
			background-color: white;
			text-align: center;
		}

		.bold {
			font-weight: bold;
		}

		.left {
			text-align: left;
		}

		.errors {
			background-color: #FFCCBC;
			margin: 0 10px;
		}

		.successes {
			background-color: #C8E6C9;
			margin: 0 10px;
		}
	</style>
</head>
<body>
	<div class='container'>
		<div class='errors'>

			<?php 
			/*
			if(isset($errors) && is_array($errors)){
				foreach($errors as $error){
					echo '- ' . $error . '<br />';
				}
			}
			*/
			?>
		</div>
		<div class='successes'>
			<?php 
			/*
			if(isset($successes) && is_array($successes)){
				foreach($successes as $success){
					echo '- ' . $success . '<br />';
				} 
			}
			*/
			?>
		</div>

		<h1>Report a Bug</h1>
		<?php //echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>
		<form action='<?php //echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>' method='POST'>
			<label class='bold' for='description'>
				Please descibe the issue. <br />If you can reproduce the issue, explain how (max 1000 characters).
			</label>
			<br />
			<textarea name='description' rows='7' cols='75' maxlength="1000"><?php //if(isset($description)) echo $description; ?></textarea>
			<br /><br />

			<label class='bold' for='device'>
				What device is this NiceCatch having the problem on?
			</label>
			<br />

			<label for='device'>iPhone 4/4s</label>
			<input name='device' type='radio' value='4' />
			<br />

			<label for='device'>iPhone 5/5s/5c</label>
			<input name='device' type='radio' value='5' />
			<br />

			<label for='device'>iPhone 6/6s</label>
			<input name='device' type='radio' value='6' />
			<br />

			<label for='device'>iPhone 6 Plus/6s Plus</label>
			<input name='device' type='radio' value='p' />
			<br />

			<br />
			<input type='submit' />
		</form>				
	</div>
</body>
</html>
-->