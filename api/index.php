<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");


// Connection to MySQL Database
$connection = mysqli_connect("localhost", "root", "", "flutter_db");

// insert to Database
if ($_GET["myApi"] == "insert") {
    $userInput = json_decode(file_get_contents('php://input'), true);
    $name = $userInput['name'];
    $family = $userInput['family'];
    $age = $userInput['age'];

    $query = "INSERT INTO `users`(`name`, `family`, `age`) VALUES ('$name','$family','$age')";

    mysqli_query($connection, $query);
}

// select from database
if ($_GET["myApi"] == "get") {
    $query = "SELECT * FROM `users`";

    $result = mysqli_query($connection, $query);
    $data = mysqli_fetch_all($result, MYSQLI_ASSOC);

    echo json_encode($data);
}

// delete from database
if ($_GET["myApi"] == "delete") {
    $userInput = json_decode(file_get_contents('php://input'), true);
    $id = $userInput['id'];
    $query = "DELETE FROM `users` WHERE `id`=$id ";

    mysqli_query($connection, $query);
}

// update to Database
if ($_GET["myApi"] == "update") {
    $userInput = json_decode(file_get_contents('php://input'), true);
    $id = $userInput['id'];
    $name = $userInput['name'];
    $family = $userInput['family'];
    $age = $userInput['age'];

    $query = "UPDATE `users` SET `name`='$name',`family`='$family',`age`='$age' WHERE `id`=$id ";

    mysqli_query($connection, $query);
}
