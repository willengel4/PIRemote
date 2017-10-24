<?php
    include 'sql_interface.php';

    $username = $_GET['username'];
    $password = $_GET['password'];
    
    /* Check if the userName exists in the database */

    /* Check if the userName already exists */
    $checkUserNameCommand = "select accessToken from user where username = '$username' and password = '$password'";
    $userNameResult = query_database($checkUserNameCommand);

    if($userNameResult->num_rows > 0)
    {
        if($row = $userNameResult->fetch_assoc())
        {
            $access_token = $row['accessToken'];
            echo "$access_token";
        }
    }
    else
    {
        echo "error";   
    }
?>