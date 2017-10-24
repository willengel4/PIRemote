<?php
    /* This script will sign up a user if given a unique userName and 
     * a valid password, firstName, and lastName 
     * returns error code 1 if the given username already exists 
     * returns error code 0 if a query error occurs */

    include 'sql_interface.php';   
    
    $name = $_GET["deviceName"];
    $password = $_GET["password"];
    $type = $_GET["type"];
    $currState = $_GET["state"];
    $icon = $_GET["icon"];
    $state = $_GET["sstr"];
    $color = $_GET["cstr"];
    $cmds = $_GET["cmds"];
    $nsds = $_GET["nsds"];
    $uat = $_GET["uat"];
    
    $states = explode("*", $state);
    $colors = explode("*", $color);
    $commands = explode("*", $cmds);
    $nexts = explode("*", $nsds);

    print_r($commands);
    echo "fdsjafksdlf\n";
    print_r($nexts);

    /* Check if the userName already exists */
    $checkUserNameCommand = "select id from device where devicename = '$name'";
    $userNameResult = query_database($checkUserNameCommand);

    /* Username is unique */
    if($userNameResult->num_rows == 0)
    {
        /* Give the user an new access token */
        $access_token = "";
        for($i = 0; $i < 50; $i++) 
        {
            do
            {
                $random_ascii = rand(48, 122);
            } while(!(($random_ascii >= 48 && $random_ascii <= 57) || ($random_ascii >= 65 && $random_ascii <= 90) || ($random_ascii >= 97 && $random_ascii <= 122)));

            $access_token .= chr($random_ascii);   
        }

        $insertCommand = "insert into device values(0, '$name', '$password', '$type', 0, 'x', '$icon', '$access_token');";
        $addUserResult = query_database($insertCommand);

	for ($i = 0; $i < count($states); $i++)
	{
	     $s = $states[$i];
   	     $c = $colors[$i];

	     $query = "insert into state values (0, (select max(id) from device), '$s', '$c');";
	     $result = query_database($query);
	}

	$q1 = "select id from state where state.deviceID = (select max(id) from device) and state.state = '$currState'";
	$r1 = query_database($q1);
        $row = $r1->fetch_assoc();
	$sID = $row['id'];

	$q2 = "select max(id) from device;";
	$r2 = query_database($q2);
        $row2 = $r2->fetch_assoc();
	$dID = $row2['max(id)'];

	$qqqq = "update device set stateID = $sID where id = $dID;";
	$rrr = query_database($qqqq);

	for ($t = 0; $t < count($commands); $t++)
	{
	     $g = $commands[$t];
	     $h = $nexts[$t];

	     $qu = "insert into command values ($dID, '$g', (select id from state where state.state='$h' and state.deviceID=$dID));";
	     $re = query_database($qu);
	}

	$q3 = "select id from user where first='Will';";
	$r3 = query_database($q3);
        $row3 = $r3->fetch_assoc();
	$uID = $row3['id'];

	$quuu = "insert into authitem values($uID, $dID);";   
        $r10 = query_database($quuu);

        echo "success?";
    }

    /* Not unique */
    else 
    {
        echo "error,1";
    }
?>  