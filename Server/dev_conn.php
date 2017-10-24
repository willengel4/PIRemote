<?php
    include 'sql_interface.php';

    $devName = $_GET['name'];
    $password = $_GET['password'];
    $uat = $_GET['uat'];
    
    /* Check if the userName exists in the database */

    /* Check if the userName already exists */
    $checkUserNameCommand = "select id from device where name = '$devName' and password = '$password'";
    $userNameResult = query_database($checkUserNameCommand);

    if($userNameResult->num_rows > 0)
    {
	$row = $userNameResult->fetch_assoc();

	$id = $row[id];
	


	$q = "insert into authitem values((select id from user where accessToken='$uat'), $id);";
	$rrrr = query_database($q);

	echo "success";
    }
    else
    {
        echo "error";   
    }
?>