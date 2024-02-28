<?php
require '../db_connect.php';
header('Content-Type: application/json; charset=utf-8');

// make input json
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

if($_SERVER['REQUEST_METHOD'] == 'POST' && array_key_exists('id', $input)){
    $id = $input['id']; //int
    $group_id = $input['group_id'];
    $group_name = $input['group_name'];
    $employee_id_new = $input['employee_id_new'];
    $employee_id_remove = $input['employee_id_remove'];
    $update_group_name = $input['update_group_name']; //int 1 or 0

    $sql_insert = 'INSERT INTO tbl_employee_group(employee_id,group_id) VALUES (:employee_id,:group_id)';

    $sql_update = 'UPDATE tbl_group SET group_name=:group_name WHERE id=:id';

    $sql_delete = 'DELETE FROM tbl_employee_group WHERE employee_id=:employee_id AND group_id=:group_id';

    try {
        // update group name
        if($update_group_name == 1){
            $sql2 = $conn->prepare($sql_update);
            $sql2->bindParam(':group_name', $group_name, PDO::PARAM_STR);
            $sql2->bindParam(':id', $id, PDO::PARAM_INT);
            $sql2->execute();
        }

        // add new employee to group
        foreach ($employee_id_new as $id_new) {
            $sql1 = $conn->prepare($sql_insert);
            $sql1->bindParam(':employee_id', $id_new, PDO::PARAM_STR);
            $sql1->bindParam(':group_id', $group_id, PDO::PARAM_STR);
            $sql1->execute();
        }
      
        // add new employee to group
        foreach ($employee_id_remove as $id_remove) {
            $sql3 = $conn->prepare($sql_delete);
            $sql3->bindParam(':employee_id', $id_remove, PDO::PARAM_STR);
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