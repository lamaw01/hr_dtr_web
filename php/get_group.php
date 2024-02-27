<?php
require '../db_connect.php';
header('Content-Type: application/json; charset=utf-8');

// make input json
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

// if not put id die
if($_SERVER['REQUEST_METHOD'] == 'GET'){

    $sql_get_group = "SELECT id, group_name FROM tbl_group;";

    try {
        $get_group = $conn->prepare($sql_get_group);
        $get_group->execute();
        $result_get_group = $get_group->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($result_get_group);
    } catch (PDOException $e) {
        echo json_encode(array('success'=>false,'message'=>$e->getMessage()));
    } finally{
        // Closing the connection.
        $conn = null;
    }
}
else{
    echo json_encode(array('success'=>false,'message'=>'Error input'));
    die();
}
?>