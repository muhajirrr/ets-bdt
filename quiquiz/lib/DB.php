<?php
namespace lib;
use mysqli;
class DB {
    private static $conn;
    public static function connect() {
        if (!isset(self::$conn)) {
            self::$conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME, 6033);
        }
        if (self::$conn->connect_error) {
            die('Connection failed: ' . self::$conn->connect_error);
        }
    }
    public static function disconnect() {
        if (isset(self::$conn)) {
            self::$conn->close();
            self::$conn = null;
        }
    }
    public static function query($query) {
        self::connect();
        $res = self::$conn->query($query);
        $data = array();
        if ($res) {
            while ($obj = mysqli_fetch_object($res)) {
                $data[] = $obj;
            }
        }
        self::disconnect();
        return $data;
    }
}