<?php
    include 'sql_interface.php';

    $dat = $_GET["dat"];

    $checkCommand = "select stateID from device where accessToken = '$dat';";
    $r = query_database($checkCommand);

    if($r->num_rows == 0) 
    {
	echo "error";
    }
    else
    {
        $row = $r->fetch_assoc();
	$sid = $row["stateID"];
	echo "$sid";
    }
?>