<?php
include "../connect.php";

$id = $_POST['id'];
$old_password = $_POST['old_password'];
$new_password = $_POST['password'];

// Check if the old password is correct for this user
$stmt = $con->prepare("SELECT id FROM `data` WHERE id=? AND pass=?");
$stmt->execute(array($id, $old_password));
if ($stmt->rowCount() == 0) {
    echo json_encode(array("status" => "wrong_old_password"));
    exit;
}

// Check if new password is already used by another user
$stmt = $con->prepare("SELECT id FROM `data` WHERE pass=? AND id!=?");
$stmt->execute(array($new_password, $id));
if ($stmt->rowCount() > 0) {
    echo json_encode(array("status" => "duplicate"));
    exit;
}

// Update the password for the user with the given id
$stmt = $con->prepare("UPDATE `data` SET pass=? WHERE id=?");
$success = $stmt->execute(array($new_password, $id));

if ($success) {
    echo json_encode(array("status" => "success"));
} else {
    echo json_encode(array("status" => "fail"));
}
?>