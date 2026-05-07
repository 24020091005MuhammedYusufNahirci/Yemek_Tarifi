<?php
// baglanti.php
$host = 'localhost';
$db   = 'yemek'; // Veri tabanı adını senin oluşturduğun şekliyle güncelledik
$user = 'root';
$pass = '';      // Şifre kısmı tırnak içinde BEMBEYAZ/BOŞ kalmalı, boşluk bile olmamalı!

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Veri tabanı bağlantı hatası: " . $e->getMessage());
}
?>