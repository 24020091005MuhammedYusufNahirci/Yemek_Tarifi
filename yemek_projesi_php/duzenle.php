<?php
require_once 'baglanti.php';

// URL'de ID yoksa yonetim paneline gonder
if (!isset($_GET['id'])) {
    header("Location: yeni_tarif.php");
    exit;
}
$yemek_id = $_GET['id'];

// --- UPDATE (GUNCELLEME) ISLEMI ---
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['islem']) && $_POST['islem'] == 'guncelle') {
    $yemek_adi = trim($_POST['yemek_adi']);
    $tarif_detay = trim($_POST['tarif_detay']);
    $fotograf_url = trim($_POST['fotograf_url']);

    // 1. Ana yemekler tablosunu guncelle
    $sql = "UPDATE yemekler SET yemek_adi = ?, tarif_detay = ?, fotograf_url = ? WHERE id = ?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$yemek_adi, $tarif_detay, $fotograf_url, $yemek_id]);

    // 2. Yemek_malzeme (Pivot) tablosundaki bu yemege ait eski kayitlari SİL
    $pdo->prepare("DELETE FROM yemek_malzeme WHERE yemek_id = ?")->execute([$yemek_id]);

    // 3. Formdan gelen yepyeni secimleri tekrar EKLE
    if (isset($_POST['secilen_malzemeler']) && is_array($_POST['secilen_malzemeler'])) {
        $sql_malzeme = "INSERT INTO yemek_malzeme (yemek_id, malzeme_id, miktar) VALUES (?, ?, ?)";
        $stmt_malzeme = $pdo->prepare($sql_malzeme);

        foreach ($_POST['secilen_malzemeler'] as $malzeme_id) {
            $miktar = $_POST['miktarlar'][$malzeme_id] ?? '';
            $stmt_malzeme->execute([$yemek_id, $malzeme_id, $miktar]);
        }
    }
    
    // ISLEM BASARILIYSA DIREKT ANA SAYFAYA (index.php) YONLENDIR
    header("Location: index.php");
    exit;
}

// --- FORM ICIN MEVCUT VERILERI CEKME ---
$sorgu = $pdo->prepare("SELECT * FROM yemekler WHERE id = ?");
$sorgu->execute([$yemek_id]);
$yemek = $sorgu->fetch(PDO::FETCH_ASSOC);

if (!$yemek) { die("Yemek bulunamadı."); }

$sorgu_malzemeler = $pdo->query("SELECT * FROM malzemeler ORDER BY malzeme_adi ASC");
$liste_malzemeler = $sorgu_malzemeler->fetchAll(PDO::FETCH_ASSOC);

$sorgu_secili = $pdo->prepare("SELECT malzeme_id, miktar FROM yemek_malzeme WHERE yemek_id = ?");
$sorgu_secili->execute([$yemek_id]);
$secili_db = $sorgu_secili->fetchAll(PDO::FETCH_ASSOC);

$mevcut_malzemeler = [];
foreach($secili_db as $sm) {
    $mevcut_malzemeler[$sm['malzeme_id']] = $sm['miktar'];
}
?>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Tarif Düzenle</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand" href="yeni_tarif.php">⬅ Yönetim Paneline Dön</a>
        </div>
    </nav>

    <div class="container">
        <div class="card shadow border-0 max-w-75 mx-auto" style="max-width: 800px;">
            <div class="card-header bg-warning text-dark fw-bold">
                <h5 class="mb-0">Düzenleniyor: <?= htmlspecialchars($yemek['yemek_adi']) ?></h5>
            </div>
            <div class="card-body">
                <form action="duzenle.php?id=<?= $yemek_id ?>" method="POST">
                    <input type="hidden" name="islem" value="guncelle">
                    
                    <div class="mb-3">
                        <label class="form-label">Yemek Adı</label>
                        <input type="text" name="yemek_adi" class="form-control" value="<?= htmlspecialchars($yemek['yemek_adi']) ?>" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Fotoğraf URL</label>
                        <input type="text" name="fotograf_url" class="form-control" value="<?= htmlspecialchars($yemek['fotograf_url']) ?>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Tarif Detayı</label>
                        <textarea name="tarif_detay" class="form-control" rows="5"><?= htmlspecialchars($yemek['tarif_detay']) ?></textarea>
                    </div>

                    <div class="mb-3 p-3 bg-white border rounded shadow-sm" style="max-height: 300px; overflow-y: auto;">
                        <label class="form-label fw-bold text-danger">Malzemeleri Güncelle</label>
                        
                        <?php foreach($liste_malzemeler as $mlz): ?>
                            <?php 
                                $secili_mi = array_key_exists($mlz['id'], $mevcut_malzemeler);
                                $kayitli_miktar = $secili_mi ? $mevcut_malzemeler[$mlz['id']] : '';
                            ?>
                            <div class="input-group mb-2">
                                <div class="input-group-text bg-light">
                                    <input class="form-check-input mt-0" type="checkbox" name="secilen_malzemeler[]" value="<?= $mlz['id'] ?>" id="mlz_<?= $mlz['id'] ?>" <?= $secili_mi ? 'checked' : '' ?>>
                                </div>
                                <label class="form-control bg-light" for="mlz_<?= $mlz['id'] ?>">
                                    <?= htmlspecialchars($mlz['malzeme_adi']) ?>
                                </label>
                                <input type="text" name="miktarlar[<?= $mlz['id'] ?>]" class="form-control" value="<?= htmlspecialchars($kayitli_miktar) ?>" placeholder="Miktar">
                            </div>
                        <?php endforeach; ?>
                    </div>

                    <button type="submit" class="btn btn-warning w-100 fw-bold">Değişiklikleri Kaydet</button>
                </form>
            </div>
        </div>
    </div>

</body>
</html>