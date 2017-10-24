<?php
    include 'sql_interface.php';

    $uat = $_GET["uat"];
    $dat = $_GET["dat"];
    $cid = $_GET["c"];
    $sid = $_GET["sid"]; 

    $checkUserNameCommand = "update device set device.command = '$cid', device.stateID = $sid where accessToken = '$dat';";
    $userNameResult = query_database($checkUserNameCommand);

    if($userNameResult != 0)
    {
	echo "success";
    }
    else
    {
        echo "error";   
    }
?>