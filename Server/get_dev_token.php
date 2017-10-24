<?php
    include 'sql_interface.php';

    $name = $_GET['name'];
    $pass = $_GET['pass'];

    $checkCommand = "select accessToken from device where name = '$name' and password = '$pass';";
    $r = query_database($checkCommand);

    if($r->num_rows == 0) 
    {
	echo "error";
    }
    else
    {
        $row = $r->fetch_assoc();
	$a = $row["accessToken"];
	echo "$a";
    }
?>