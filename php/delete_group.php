<?php
require '../db_connect.php';
header('Content-Type: application/json; charset=utf-8');

// make input json
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);


if($_SERVER['REQUEST_METHOD'] == 'POST' && array_key_exists('group_id', $input)){
    $id = $input['id'];
    $group_id = $input['group_id'];

    $sql_delete_group = 'DELETE FROM tbl_group WHERE id=:id';

    $sql_delete_employee_group = 'DELETE FROM tbl_employee_group WHERE group_id=:group_id';

    try {
        // delete group
        $sql1 = $conn->prepare($sql_delete_group);
        $sql1->bindParam(':id', $id, PDO::PARAM_STR);
        $sql1->execute();

        // delete employee group
        $sql2 = $conn->prepare($sql_delete_employee_group);
        $sql2->bindParam(':group_id', $group_id, PDO::PARAM_STR);
        $sql2->execute();
        echo json_encode(array('success'=>true,'message'=>'ok'));
    } catch (PDOException $e) {
        echo json_encode(array('success'=>false,'message'=>$e->getMessage()));
    } finally{
        // Closing the connection.
        $conn = null;
    }
}else{
    echo json_encode(array('success'=>false,'message'=>'error input'));
    die();
}
?>