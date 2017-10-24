<?php
	include 'sql_interface.php';
	$uat = $_GET["accessToken"];

	$get_devices_query = "select device.id, device.name, device.type, device.stateID, device.icon, device.accessToken from user join authitem join device on user.id = authitem.userid and device.id = authitem.deviceid where user.accessToken='$uat';";

	$r = query_database($get_devices_query);

	$ids = array();

	while($row = $r->fetch_assoc())
	{
		$id = $row["id"];
	
		array_push($ids, $id);
	
		$name = $row["name"];
		$type = $row["type"];
		$sID = $row["stateID"];
		$icon = $row["icon"];
		$at = $row["accessToken"];
		echo "$id*$name*$type*$sID*$icon**$at\n";
	}
	echo "!@#$";
	for ($i=0; $i < count($ids); $i++)
	{
		$currID = $ids[$i];
		$qq = "select * from state where deviceID = $currID";
		$rr = query_database($qq);

		while($row1 = $rr->fetch_assoc())
		{
			$stateID = $row1["id"];
			$state = $row1["state"];
			$color = $row1["color"];

			echo "$currID*$stateID*$state*$color\n";
		}
	}
	echo "!@#$";
	for ($i=0; $i < count($ids); $i++)
	{
		$currID = $ids[$i];
		$qqq = "select * from command where deviceID = $currID";
		$rrr = query_database($qqq);
		
		while($row2 = $rrr->fetch_assoc())
		{
			$c = $row2["command"];
			$n = $row2["nextStateID"];

			echo "$currID*$c*$n\n";
		}	
		
	}
?>