<?php
require_once 'baglanti.php';

// Eger URL'de ID yoksa ana sayfaya gonder
if (!isset($_GET['id'])) {
    header("Location: index.php");
    exit;
}

$yemek_id = $_GET['id'];

// 1. Yemeğin kendi bilgilerini çek
$sorgu = $pdo->prepare("SELECT * FROM yemekler WHERE id = ?");
$sorgu->execute([$yemek_id]);
$yemek = $sorgu->fetch(PDO::FETCH_ASSOC);

if (!$yemek) {
    die("Böyle bir yemek bulunamadı!");
}

// 2. Yemeğe ait malzemeleri (Alışveriş Listesini) çek (JOIN işlemi)
$sql_malzeme = "
    SELECT m.malzeme_adi, ym.miktar 
    FROM yemek_malzeme ym
    INNER JOIN malzemeler m ON ym.malzeme_id = m.id
    WHERE ym.yemek_id = ?
";
$sorgu_malzeme = $pdo->prepare($sql_malzeme);
$sorgu_malzeme->execute([$yemek_id]);
$alisveris_listesi = $sorgu_malzeme->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title><?= htmlspecialchars($yemek['yemek_adi']) ?> - Tarif Detayı</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-primary mb-4 shadow">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.php">⬅ Ana Ekrana Dön</a>
        </div>
    </nav>

    <div class="container">
        <div class="row">
            <div class="col-md-8 mb-4">
                <div class="card shadow border-0 h-100">
                    <img src="<?= htmlspecialchars($yemek['fotograf_url']) ?>" class="card-img-top" alt="Yemek Resmi" style="max-height: 450px; object-fit: cover;">
                    <div class="card-body p-4">
                        <h2 class="card-title text-primary fw-bold mb-3"><?= htmlspecialchars($yemek['yemek_adi']) ?></h2>
                        <hr>
                        <h5 class="text-danger fw-bold mt-4 mb-3">🍳 Tarif Detayı ve Yapılışı</h5>
                        <p class="card-text fs-5" style="white-space: pre-wrap; line-height: 1.8;"><?= htmlspecialchars($yemek['tarif_detay']) ?></p>
                    </div>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="card shadow border-0 h-100">
                    <div class="card-header bg-success text-white py-3">
                        <h4 class="mb-0 text-center">🛒 Alışveriş Listesi</h4>
                    </div>
                    <ul class="list-group list-group-flush fs-5">
                        <?php if(count($alisveris_listesi) > 0): ?>
                            <?php foreach($alisveris_listesi as $malzeme): ?>
                                <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                                    <?= htmlspecialchars($malzeme['malzeme_adi']) ?>
                                    <?php if(!empty($malzeme['miktar'])): ?>
                                        <span class="badge bg-secondary rounded-pill px-3 py-2"><?= htmlspecialchars($malzeme['miktar']) ?></span>
                                    <?php endif; ?>
                                </li>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <li class="list-group-item text-muted text-center py-4">Bu tarif için malzeme listesi girilmemiş.</li>
                        <?php endif; ?>
                    </ul>
                </div>
            </div>
        </div>
    </div>

</body>
</html>