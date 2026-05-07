<?php
require_once 'baglanti.php';

// Yemekleri veritabanindan cekiyoruz
$sorgu = $pdo->query("SELECT * FROM yemekler ORDER BY id DESC");
$yemekler = $sorgu->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Yemek Tarifleri - Ana Ekran</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4 shadow">
        <div class="container">
            <a class="navbar-brand" href="index.php">🍲 Yemek Tarifleri</a>
            <div class="ms-auto">
                <a class="btn btn-light text-primary fw-bold" href="yeni_tarif.php">Yeni Tarif / Yöntetim Ekranı</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <h2 class="mb-4">Kayıtlı Yemekler</h2>
        <div class="row">
            <?php if (count($yemekler) > 0): ?>
                <?php foreach ($yemekler as $yemek): ?>
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 shadow-sm border-0">
                            <?php $foto = !empty($yemek['fotograf_url']) ? $yemek['fotograf_url'] : 'https://via.placeholder.com/400x250?text=Gorsel+Yok'; ?>
                            <img src="<?= htmlspecialchars($foto) ?>" class="card-img-top" alt="Yemek Resmi" style="height: 250px; object-fit: cover;">
                            
                            <div class="card-body">
                                <h5 class="card-title text-primary"><?= htmlspecialchars($yemek['yemek_adi']) ?></h5>
                                <p class="card-text text-muted">
                                    <?= htmlspecialchars(mb_substr($yemek['tarif_detay'], 0, 100)) ?>...
                                </p>
                            </div>
                            <div class="card-footer bg-white border-top-0 pb-3">
                                <a href="detay.php?id=<?= $yemek['id'] ?>" class="btn btn-outline-primary w-100">Tarifi Oku ve Alışveriş Listesini Gör</a>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <div class="col-12">
                    <div class="alert alert-info text-center shadow-sm p-4" role="alert">
                        <h4>Sistemde henüz hiç yemek tarifi bulunmuyor.</h4>
                        <p>Hemen sağ üstteki butona tıklayarak ilk tarifinizi ekleyin!</p>
                    </div>
                </div>
            <?php endif; ?>
        </div>
    </div>

</body>
</html>