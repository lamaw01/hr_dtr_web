<?php
require '../db_connect.php';
header('Content-Type: application/json; charset=utf-8');

// make input json
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);

// if not put id die
if($_SERVER['REQUEST_METHOD'] == 'POST' && array_key_exists('employee_id', $input)){
    $employee_id = $input['employee_id'];
    $department_id = $input['department_id'];

    $concat_employee_id = "%$employee_id%";

    // $sql_search_employee= "SELECT tbl_employee.id,tbl_employee.employee_id, tbl_employee.first_name, tbl_employee.last_name, tbl_employee.middle_name FROM tbl_employee 
    // LEFT JOIN tbl_employee_department ON tbl_employee.employee_id = tbl_employee_department.employee_id 
    // WHERE (tbl_employee.employee_id LIKE :employee_id OR tbl_employee.first_name LIKE :employee_id OR tbl_employee.last_name LIKE :employee_id)
    // AND tbl_employee.active = 1 GROUP BY tbl_employee.employee_id ORDER BY tbl_employee.last_name;";

    $sql_search_employee = "SELECT tbl_employee.id, tbl_employee.employee_id, tbl_employee.first_name, tbl_employee.last_name, tbl_employee.middle_name, tbl_employee.week_sched_id, tbl_employee.active
    FROM tbl_employee 
    LEFT JOIN tbl_week_schedule ON tbl_week_schedule.week_sched_id = tbl_employee.week_sched_id
    WHERE (tbl_employee.employee_id LIKE :employee_id OR tbl_employee.first_name LIKE :employee_id OR tbl_employee.last_name LIKE :employee_id) AND tbl_employee.active = 1
    ORDER BY tbl_employee.last_name ASC;";

    $sql_search_employee_with_department = "SELECT tbl_employee.id, tbl_employee.employee_id, tbl_employee.first_name, tbl_employee.last_name, tbl_employee.middle_name, tbl_employee.week_sched_id, tbl_employee.active
    FROM tbl_employee 
    LEFT JOIN tbl_week_schedule ON tbl_week_schedule.week_sched_id = tbl_employee.week_sched_id
    LEFT JOIN tbl_employee_department ON tbl_employee.employee_id = tbl_employee_department.employee_id
    WHERE (tbl_employee.employee_id LIKE :employee_id OR tbl_employee.first_name LIKE :employee_id OR tbl_employee.last_name LIKE :employee_id)
    AND tbl_employee_department.department_id = :department_id AND tbl_employee.active = 1
    ORDER BY tbl_employee.last_name ASC;";

    try {
        // $set=$conn->prepare("SET SQL_MODE=''");
        // $set->execute();
        if($department_id != '000'){
            $get_search_employee=$conn->prepare($sql_search_employee_with_department);
        }else{
            $get_search_employee=$conn->prepare($sql_search_employee);
        }
        // $get_search_employee= $conn->prepare($sql_search_employee);
        $get_search_employee->bindParam(':employee_id', $concat_employee_id, PDO::PARAM_STR);
        if($department_id != '000'){
            $get_search_employee->bindParam(':department_id', $department_id, PDO::PARAM_STR);
        }
        $get_search_employee->execute();
        $result_get_search_employee = $get_search_employee->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($result_get_search_employee);
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