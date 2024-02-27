<?php
require '../db_connect.php';
header('Content-Type: application/json; charset=utf-8');

// make input json
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

if($_SERVER['REQUEST_METHOD'] == 'POST' && array_key_exists('group_name', $input)){
    $group_name = $input['group_name'];
    $employee_id = $input['employee_id'];

    $sql_create_group = 'INSERT INTO tbl_group(group_name) VALUES (:group_name)';

    $sql_get_last_id = 'SELECT id FROM tbl_group ORDER BY id DESC LIMIT 1;';

    $sql = 'INSERT INTO tbl_employee_group(employee_id,group_id) VALUES (:employee_id,:group_id)';

    try {
        // create
        $sql1 = $conn->prepare($sql_create_group);
        $sql1->bindParam(':group_name', $group_name, PDO::PARAM_STR);
        $sql1->execute();

        // get last id
        $sql2 = $conn->prepare($sql_get_last_id);
        $sql2->execute();
        $result_sql2 = $sql2->fetch(PDO::FETCH_ASSOC);
        $group_id = $result_sql2["id"];
        
        // loop insert
        foreach ($employee_id as $id) {
            $sql3 = $conn->prepare($sql);
            $sql3->bindParam(':employee_id', $id, PDO::PARAM_STR);
            $sql3->bindParam(':group_id', $group_id, PDO::PARAM_STR);
            $sql3->execute();
        }
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