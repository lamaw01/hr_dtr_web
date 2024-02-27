<?php
require '../db_connect.php';
header('Content-Type: application/json; charset=utf-8');

// make input json
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

// if not put id die
if($_SERVER['REQUEST_METHOD'] == 'POST' && array_key_exists('group_id', $input)){
    $group_id = $input['group_id'];

    // $sql_get_group_employee = "SELECT id, group_name FROM tbl_employee_group;";

    $sql_with_group = "SELECT tbl_employee.id, tbl_employee.employee_id, tbl_employee.first_name, tbl_employee.last_name, tbl_employee.middle_name, tbl_employee.week_sched_id, tbl_employee.active
    FROM tbl_employee 
    LEFT JOIN tbl_week_schedule ON tbl_week_schedule.week_sched_id = tbl_employee.week_sched_id 
    LEFT JOIN tbl_employee_group ON tbl_employee.employee_id = tbl_employee_group.employee_id
    WHERE tbl_employee_group.group_id = :group_id AND tbl_employee.active = 1 ORDER BY tbl_employee.last_name ASC;";

    try {
        $get_group_employee = $conn->prepare($sql_with_group);
        $get_group_employee->bindParam(':group_id', $group_id, PDO::PARAM_STR);
        $get_group_employee->execute();
        $result_get_group_employee = $get_group_employee->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($result_get_group_employee);
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